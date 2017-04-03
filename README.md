<img src="https://cloud.githubusercontent.com/assets/3483230/24613845/84909cd8-18c4-11e7-8c04-d3f0d30bc9c4.png" width="200" />

---

[![Build Status](https://travis-ci.org/tbrand/route.cr.svg?branch=master)](https://travis-ci.org/tbrand/route.cr)
[![Dependency Status](https://shards.rocks/badge/github/tbrand/route.cr/status.svg)](https://shards.rocks/github/tbrand/route.cr)
[![devDependency Status](https://shards.rocks/badge/github/tbrand/route.cr/dev_status.svg)](https://shards.rocks/github/tbrand/route.cr)
[![GitHub release](https://img.shields.io/github/release/tbrand/route.cr.svg)](https://github.com/tbrand/route.cr/releases)

The default web server of the Crystal is quite good but it weak at routing.
Kemal is an awesome defacto standard web framework for Crystal, but it's too fat for some purpose.

**route.cr** is a **minimum** but powerful **High Performance** middleware for Crystal web server.
See the amazing performance of **route.cr** [here](https://github.com/tbrand/which_is_the_fastest) **route.cr** includes convenient rendering tool and profiler.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  route:
    github: tbrand/route.cr
```

## Usage

### Basic usage

```crystal
require "route"
```

Include `Route` to utilize **route.cr**.
```crystal
class WebServer
  include Route
end
```

In the following sample codes, `class WebServer ... end` will be omitted.
To initialize RouteHandler
```crystal
@route_handler = RouteHandler.new
```

To define API, call API.new with `context` and `params`(optional) where context is HTTP::Server::Context and params is Hash(String, String). All APIs have to return the context. In this example, params is omitted. (The usage of params is later)
```crystal
@index = API.new do |context|
  context.response.print "Hello route.cr"
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

See [sample](https://github.com/tbrand/route.cr/blob/master/sample/sample.cr) for details.

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

See [sample](https://github.com/tbrand/route.cr/blob/master/sample/sample.cr) for details.

### Rendering views(.ecr)

route.cr also support **simple rendering function** to render `.ecr` file with parameters.
First, define your view like
```crystal
def_view :view_sample, "sample/public/hello.ecr", name: String, num: Int32
```
where "sample/public/hello.ecr" is
```
My name is <%= @name %>. The number is <%= @num %>.
```
`:view_sample` is an identifier of the view. "sample/public/hello.ecr" is a relative path to the file. `name` and `num` are parameters used in "sample/public/hello.ecr". Note that these parameters have to be class variables in the file. See [here](https://github.com/tbrand/route.cr/blob/master/sample/public/hello.ecr). When you render them, just call `render_view` like
```crystal
context.response.print render_view(:view_sample, "tbrand", 10)
```

See [sample](https://github.com/tbrand/route.cr/blob/master/sample/sample.cr) for details.

### Get profiles

route.cr also serves **ProfileHandler**. By using this, you can easily get the access data like
```
[ GET /one ]        Access: 10          Total: 704.0µs      Ave: 70.4µs
[ GET /two ]        Access: 9           Total: 309.0µs      Ave: 34.3µs
[ GET /three ]      Access: 9           Total: 262.0µs      Ave: 29.1µs
```
For this, just set `ProfileHandler` to your server like
```
server = HTTP::Server.new(3000, [ProfileHandler.new, @route_handler])
```
After running your server, try accessing "/profile".

See [sample](https://github.com/tbrand/route.cr/blob/master/sample/profile.cr) for details.

## Contributing

1. Fork it ( https://github.com/tbrand/route.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [tbrand](https://github.com/tbrand) Taichiro Suzuki - creator, maintainer
