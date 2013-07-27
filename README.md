# Newrelic::Rake

NewRelic instrument for rake task.

## Installation

Add this line to your application's Gemfile:

    gem 'newrelic-rake'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install newrelic-rake

## Usage

There is usually nothing to do for rake tasks in rails that depend on `:environment`,
monitoring of these should just work.

Rake files need to require `newrelic-rake` and start the newrelic agent
before executing tasks to monitor:

```
require 'newrelic-rake'
NewRelic::Agent.manual_start
```

These steps happen automatically in Rails' `:environment` task if you use `Bundler.require` in your `application.rb`.

## Authors and Contributors

* [Richard Huang](https://github.com/flyerhzm) - Creator of the project
* [Yury Velikanau](yury.velikanau@gmail.com) - Main contributor

Please fork and contribute, any help in making this project better is appreciated!

This project is a member of the [OSS Manifesto](http://ossmanifesto.org/).

## Copyright

Copyright @ 2012 - 2013 Richard Huang. See
[MIT-LICENSE](https://github.com/flyerhzm/newrelic-rake/blob/master/MIT-LICENSE) for details
