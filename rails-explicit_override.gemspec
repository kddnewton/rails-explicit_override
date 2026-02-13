# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rails/explicit_override/version"

Gem::Specification.new do |spec|
  spec.name = "rails-explicit_override"
  spec.version = Rails::ExplicitOverride::VERSION
  spec.authors = ["Kevin Newton"]
  spec.email = ["kddnewton@gmail.com"]

  spec.summary = "Explicitly mark Rails methods as overridden"
  spec.homepage = "https://github.com/kddnewton/rails-explicit_override"
  spec.license = "MIT"

  spec.files = %w[
    LICENSE
    README.md
    lib/rails/explicit_override.rb
    lib/rails/explicit_override/version.rb
    rails-explicit_override.gemspec
  ]

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.metadata = { "rubygems_mfa_required" => "true" }

  spec.add_dependency "activerecord"
  spec.add_dependency "actionpack"
end
