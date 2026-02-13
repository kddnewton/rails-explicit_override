# frozen_string_literal: true

require "active_record"
require "action_controller"
require "rails/explicit_override/version"

module Rails
  class ExplicitOverride < Module
    class Error < StandardError
    end

    class MissingExplicitOverrideError < Error
      def initialize(cls, name)
        super(<<~MSG)
          #{cls.name || cls.inspect} is marked as requiring explicit overrides,
          and already has a method named '#{name}' defined. To override this
          method, you must call 'explicit_override' on the line before the
          method definition.
        MSG
      end
    end

    class UnexpectedExplicitOverrideError < Error
      def initialize(cls, name)
        super(<<~MSG)
          #{cls.name || cls.inspect} is marked as requiring explicit overrides,
          but '#{name}' is not defined in the superclass, so this call to
          'explicit_override' is unexpected.
        MSG
      end
    end

    def initialize(method_names)
      explicit_override_lineno = nil

      define_method(:explicit_override) do
        explicit_override_lineno = caller_locations(1, 1).first.lineno
      end

      define_method(:method_added) do |name|
        explicit_override = false
        if explicit_override_lineno
          explicit_override = (caller_locations(1, 1).first.lineno - explicit_override_lineno) <= 1
          explicit_override_lineno = nil
        end

        if explicit_override != (method_defined = method_names.include?(name))
          error = method_defined ? MissingExplicitOverrideError : UnexpectedExplicitOverrideError
          raise error.new(self, name)
        end

        super(name)
      end
    end

    module ClassMethods
      # Provides the same interface as Rails::ExplicitOverride, but does
      # nothing. This is meant to be used in non-development environments to
      # avoid both the overhead of tracking method definitions and the risk of
      # raising errors.
      module Noop
        def explicit_override
        end
      end

      private_constant :Noop

      # Track method definitions to see if they override methods defined in any
      # superclass. If they do, require that they be marked with
      # `explicit_override`. If they are not marked or are marked incorrectly,
      # raise an error.
      def explicit_overrides!(development = false)
        extend(development ? ExplicitOverride.new(instance_methods) : Noop)
      end

      ActiveRecord::Base.extend(self)
      ActionController::Base.extend(self)
    end
  end
end
