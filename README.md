# rails-explicit_override

[![Build Status](https://github.com/kddnewton/rails-explicit_override/workflows/Main/badge.svg)](https://github.com/kddnewton/rails-explicit_override/actions)
[![Gem](https://img.shields.io/gem/v/rails-explicit_override.svg)](https://rubygems.org/gems/rails-explicit_override)

Rails has many built-in methods that can be overridden by user code to change behavior. For example if you override `ActionController::action_methods`, you can change which methods are considered routing actions. However, overriding built-in methods can be accidental if you do not realize it exists in the first place. This gem solves that problem by requiring you to explicitly declare which methods you are overriding. If you forget to declare an override, or if you declare an override for a method that does not exist, an error will be raised.

Take the example of the `ActionController::action_methods` method. If you want to override it, you would do the following:

```ruby
class HomeController < ApplicationController
  explicit_overrides!(Rails.env.development?)

  def index
    # ...
  end

  private

  explicit_override
  def action_methods
    # ...
  end
end
```

If you forgot to declare the explicit override, you would get the following error:

```
HomeController is marked as requiring explicit overrides, and already has a
method named 'action_methods' defined. To override this method, you must call
'explicit_override' on the line before the method definition.
```

## API

There are two main methods you interact with in this gem. The first is:

```ruby
Rails::ExplicitOverride::ClassMethods#explicit_overrides!(development = false)
```

This method is used to enable tracking explicit overrides for a class. This module is automatically extended into `ActiveRecord::Base` and `ActionController::Base`, so you can call it in any subclass of those classes. Otherwise you must explicitly extend it into your class. The `development` parameter controls whether or not it will raise, and for best-practice it is expected to only be enabled in development environments to avoid raising errors in production. Once this method is called, any method that is defined that overrides a superclass method must be marked with:

```ruby
Rails::ExplicitOverride#explicit_override
```

which must be placed on the line immediately before the method definition. If a method is overridden without being marked, or if a method is marked but does not override a superclass method, an error will be raised.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rails-explicit_override"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-explicit_override

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kddnewton/rails-explicit_override.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
