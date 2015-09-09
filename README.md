# Strut

[![Build Status](https://travis-ci.org/dcutting/strut.svg?branch=master)](https://travis-ci.org/dcutting/strut.svg?branch=master)

Acceptance testing with [Swagger](http://swagger.io).

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

Add this line to your application's Gemfile:

```ruby
gem 'strut'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strut

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dcutting/strut. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
