# Thirtysix

A Rack middleware for instrumentation object creation in your rails app

## Setup

Include this in your Gemfile

`gem 'thirtysix', :require => 'thirtysix/rack/middleware'`

Set The following in your ENV

```
THIRTYSIX_URL
THIRTYSIX_API_KEY
```

`THIRTYSIX_URL` should point to an instance of the Thirtysix App which is collecting the instrumentation requests. Set this to the running instance at `http://www.thirtysix.tech`

`THIRTYSIX_API_KEY` can be set to any of the values at `http://www.thirtysix.tech/api_keys`