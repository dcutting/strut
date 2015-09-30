# Strut

[![Build Status](https://travis-ci.org/dcutting/strut.svg?branch=master)](https://travis-ci.org/dcutting/strut)
[![Coverage Status](https://coveralls.io/repos/dcutting/strut/badge.svg?branch=master&service=github)](https://coveralls.io/github/dcutting/strut?branch=master)
[![Code Climate](https://codeclimate.com/github/dcutting/strut/badges/gpa.svg)](https://codeclimate.com/github/dcutting/strut)

Acceptance testing with [Swagger](http://swagger.io).

Rather than testing your web service through the API (and therefore requiring your whole stack to be up and running with sample data), Strut uses [Slim](http://www.fitnesse.org/FitNesse.UserGuide.WritingAcceptanceTests.SliM.SlimProtocol) and fixture code. This lets you mock out databases and other external systems, while still covering the major parts of your web service API.

## Why?

* Want to specify our web service APIs in Swagger
    - Because it’s pretty
    - Because it’s concise
    - Because it has tools that help you transform it into docs, etc.
* Want to write automated acceptance tests for our web service APIs
    - Because we don’t want to manually test it for releases
    - Because we want to be confident we don’t break it accidentally
* Don’t want to duplicate the API in the Swagger spec and the test suite
    - Because the Swagger spec will drift out of sync
    - Because we’ll need to maintain two different ways of saying similar things
* Therefore, Strut!

## Installation

Strut is a command-line tool installed via [RubyGems](https://rubygems.org):

    $ gem install strut

Then run it from any directory containing a .strut.yml configuration file:

    $ strut

## .strut.yml configuration file

You need a .strut.yml configuration file in the directory where you run strut (or you can specify a path to one as the only argument to strut). That file should look like this:

    swagger:
      my_service.yaml
    runner:
      Runner.exe -a "..\MyService.Specs\bin\Debug\MyService.Specs.dll.config" -r fitSharp.Slim.Service.Runner,Slim/fitsharp.dll MyService.Specs/bin/Debug/MyService.Specs.dll 9011
    host:
      localhost
    port:
      9011
    max_attempts:
      3
    namespace:
      Specs
    output:
      pretty

The `runner` property is a command that runs the Slim server and attaches to your system under test. Strut will automatically run this for you, and kill it when the tests complete. This is an optional parameter. If omitted, Strut will still attempt to connect to the provided host and port, but you will need to manually ensure the Slim server is running.

You can have "pretty" output (similar to default Cucumber output), or "junit" XML output.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Windows

* Install Ruby using [RubyInstaller](http://rubyinstaller.org)
* Install [gitbash](https://git-scm.com/download/win)
* gem install bundler
* git clone git@github.com:dcutting/strut.git
* cd strut
* bin/setup
* bundle exec ruby exe/strut .strut.yml

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dcutting/strut. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
