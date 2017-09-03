<img src="https://cloud.githubusercontent.com/assets/3483230/25668495/c3c28574-3061-11e7-9dbd-969d95eb4bf8.png" width="200" />

[![Build Status](https://travis-ci.org/tbrand/router.cr.svg?branch=master)](https://travis-ci.org/tbrand/router.cr)
[![GitHub release](https://img.shields.io/github/release/tbrand/router.cr.svg)](https://github.com/tbrand/router.cr/releases)

---

The default web server of the Crystal is quite good :smile: but it weak at routing :cry:.  
Kemal is an awesome defacto standard web framework for Crystal :smile:, but it's too fat for some purpose :cry:.

**router.cr** is a **minimum** but **High Performance** middleware for Crystal web server.  
See the amazing performance of **router.cr** [here](https://github.com/tbrand/which_is_the_fastest).:rocket:

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  router:
    github: tbrand/router.cr
```

## Usage

### Basic usage

```crystal
require "router"
```

Include `Router` to utilize **router.cr**.
```crystal
class WebServer
  include Router
end
```

In the following sample codes, `class WebServer ... end` will be omitted.
To initialize RouteHandler
```crystal
@route_handler = RouteHandler.new
```

To define API, call API.new with `context` and `params`(optional) where context is HTTP::Server::Context and params is Hash(String, String). All APIs have to return the context at end of the method. In this example, params is omitted. (The usage of params is later)
```crystal
@index = API.new do |context|
  context.response.print "Hello router.cr"
  context # returning context
end
```

Define your routes in a `draw` block.
```crystal
draw(@route_handler) do # Draw routes
  get "/", @index
end
```

To activate the routes
```crystal
def run
  server = HTTP::Server.new(3000, @route_handler) # Set RouteHandler to your server
  server.listen
end
```

Finally, run your server.
```crystal
web_server = WebServer.new
web_server.run
```

See [sample](https://github.com/tbrand/router.cr/blob/master/sample/sample.cr) and [tips]([sample](https://github.com/tbrand/router.cr/blob/master/sample/tips.cr)) for details.

### Path parameters

`params` is a Hash(String, String) that is used when you define a path parameters such as `/user/:id` (`:id` is a parameters). Here is an example.
```crystal
class WebServer
  @route_handler = RouteHandler.new

  @user = API.new do |context, params|
    context.response.print params["id"] # get :id in url from params
    context
  end

  def initialize
    draw(@route_handler) do
      get "/user/:id", @user
    end
  end
end
```

`params` also includes query params such as `/user?id=3`. Here is an example.
```crystal
class WebServer
  @route_handler = RouteHandler.new

  @user = API.new do |context, params|
    response_body = "user: "
    # Get a query param like /user?id=3
    response_body += params["id"] if params.has_key?("id")
    context.response.print response_body
    context
  end

  def initialize
    draw(@route_handler) do
      get "/user", @user
    end
  end
end
```

See [sample](https://github.com/tbrand/router.cr/blob/master/sample/sample.cr) and [tips]([sample](https://github.com/tbrand/router.cr/blob/master/sample/tips.cr)) for details.

## Contributing

1. Fork it ( https://github.com/tbrand/router.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [tbrand](https://github.com/tbrand) Taichiro Suzuki - creator, maintainer
