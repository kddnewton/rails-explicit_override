# frozen_string_literal: true

require "test_helper"

class ExplicitOverrideTest < Test::Unit::TestCase
  test "ActiveRecord::Base explicit_override success" do
    Class.new(ActiveRecord::Base) do
      explicit_overrides!(true)

      explicit_override
      def save(*args)
      end
    end
  end

  test "ActiveRecord::Base explicit_override MissingExplicitOverrideError" do
    error =
      assert_raise(Rails::ExplicitOverride::MissingExplicitOverrideError) do
        Class.new(ActiveRecord::Base) do
          explicit_overrides!(true)

          def save(*args)
          end
        end
      end

    assert_include(error.message, "'save'")
  end

  test "ActiveRecord::Base explicit_override UnexpectedExplicitOverrideError" do
    assert_raise(Rails::ExplicitOverride::UnexpectedExplicitOverrideError) do
      Class.new(ActiveRecord::Base) do
        explicit_overrides!(true)

        explicit_override
        def foo(*args)
        end
      end
    end
  end

  test "ActiveRecord::Base explicit_override production" do
    Class.new(ActiveRecord::Base) do
      explicit_overrides!(false)

      def save(*args)
      end
    end
  end

  test "ActionController::Base explicit_override success" do
    Class.new(ActionController::Base) do
      explicit_overrides!(true)

      explicit_override
      def action_name
      end
    end
  end

  test "ActionController::Base explicit_override MissingExplicitOverrideError" do
    assert_raise(Rails::ExplicitOverride::MissingExplicitOverrideError) do
      Class.new(ActionController::Base) do
        explicit_overrides!(true)

        def action_name
        end
      end
    end
  end

  test "ActionController::Base explicit_override UnexpectedExplicitOverrideError" do
    assert_raise(Rails::ExplicitOverride::UnexpectedExplicitOverrideError) do
      Class.new(ActionController::Base) do
        explicit_overrides!(true)

        explicit_override
        def foo(*args)
        end
      end
    end
  end

  test "ActionController::Base explicit_override production" do
    Class.new(ActionController::Base) do
      explicit_overrides!(false)

      def action_name
      end
    end
  end

  test "other explicit_override success" do
    parent =
      Class.new do
        def foo
          "bar"
        end
      end

    Class.new(parent) do
      extend Rails::ExplicitOverride::ClassMethods
      explicit_overrides!(true)

      explicit_override
      def foo
        "baz"
      end
    end
  end

  test "other explicit_override MissingExplicitOverrideError" do
    parent =
      Class.new do
        def foo
          "bar"
        end
      end

    assert_raise(Rails::ExplicitOverride::MissingExplicitOverrideError) do
      Class.new(parent) do
        extend Rails::ExplicitOverride::ClassMethods
        explicit_overrides!(true)

        def foo
          "baz"
        end
      end
    end
  end

  test "other explicit_override UnexpectedExplicitOverrideError" do
    parent =
      Class.new do
        def foo
          "bar"
        end
      end

    assert_raise(Rails::ExplicitOverride::UnexpectedExplicitOverrideError) do
      Class.new(parent) do
        extend Rails::ExplicitOverride::ClassMethods
        explicit_overrides!(true)

        explicit_override
        def baz
          "qux"
        end
      end
    end
  end

  test "other explicit_override production" do
    parent =
      Class.new do
        def foo
          "bar"
        end
      end

    Class.new(parent) do
      extend Rails::ExplicitOverride::ClassMethods
      explicit_overrides!(false)

      def foo
        "baz"
      end
    end
  end

  test "explicit_overrides! in base" do
    parent =
      Class.new do
        extend Rails::ExplicitOverride::ClassMethods
        explicit_overrides!(true)

        def foo
          "bar"
        end
      end

    assert_raise(Rails::ExplicitOverride::MissingExplicitOverrideError) do
      Class.new(parent) do
        def foo
          "baz"
        end
      end
    end
  end
end
