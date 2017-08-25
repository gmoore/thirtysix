# Thirtysix

A Rack middleware for instrumentation object creation in your rails app

## Setup

### Gemfile

Include this in the Gemfile of the app you want to instrument

`gem 'thirtysix', :require => 'thirtysix/rack/middleware'`

### Environment

Set the following environment variables

`THIRTYSIX_URL` set this to `http://www.thirtysix.tech`

`THIRTYSIX_API_KEY`: An API key. Grab one from the [Valid API keys](http://www.thirtysix.tech/api_keys)

See also [Thirtysix App](https://github.com/gmoore/thirtysixapp)