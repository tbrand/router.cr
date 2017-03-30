# route.cr

[![Build Status](https://travis-ci.org/tbrand/route.cr.svg?branch=master)](https://travis-ci.org/tbrand/route.cr)
[![Dependency Status](https://shards.rocks/badge/github/tbrand/route.cr/status.svg)](https://shards.rocks/github/tbrand/route.cr)
[![devDependency Status](https://shards.rocks/badge/github/tbrand/route.cr/dev_status.svg)](https://shards.rocks/github/tbrand/route.cr)

The default web server of the Crystal is quite good but it weak at routing.
Kemal is an awesome defacto standard web framework for Crystal, but it's too fat for some purpose.

**route.cr** is a **minimum** but powerful **High Performance** middleware for Crystal web server.
See the amazing performance of **route.cr** [here](https://github.com/tbrand/which_is_the_fastest)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  route:
    github: tbrand/route.cr
```

## Usage

```crystal
require "route"
```

Include `Route` to utilize this.
```crystal
class WebServer
  include Route
end
```

In the following example codes, `class WebServer ... end` will be omitted.
Initialize RouteHandler
```crystal
@route_handler = RouteHandler.new
```

To define API, call API.new with context and params(optional) where context is HTTP::Server::Context and params is Hash(String, String). All APIs have to return the context. In this example, params is omitted. (The usage of params is later)
```crystal
@index = API.new do |context|
  context.response.print "Hello route.cr"
  context
end
```

Define your routes in a `draw` block.
```crystal
draw(@route_handler) do
  get "/", @index
end
```

To activate the routes
```crystal
def run
  server = HTTP::Server.new(3000, routeHandler)
  server.listen
end
```

Finally, run your server.
```crystal
web_server = WebServer.new
web_server.run
```

`params` is a Hash(String, String) that is used when you define a path including parameters such as `"/user/:id"` (`:id` is a parameters). Here is an example.
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

See [sample](https://github.com/tbrand/route.cr/blob/master/sample) for details.

## Contributing

1. Fork it ( https://github.com/tbrand/route.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [tbrand](https://github.com/tbrand) Taichiro Suzuki - creator, maintainer
