<img src="https://cloud.githubusercontent.com/assets/3483230/25668495/c3c28574-3061-11e7-9dbd-969d95eb4bf8.png" width="200" />

[![Build Status](https://travis-ci.org/tbrand/router.cr.svg?branch=master)](https://travis-ci.org/tbrand/router.cr)
[![GitHub release](https://img.shields.io/github/release/tbrand/router.cr.svg)](https://github.com/tbrand/router.cr/releases)

---

The default web server of the Crystal is quite good :smile: but it weak at routing :cry:.  
Kemal or other web frameworks written in Crystal are awesome :smile:, but it's too fat for some purpose :cry:.

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

Define a method to draw all routes for your web server.
```crystal
class WebServer
  include Router
  
  def draw_routes
    # Drawing routes HERE!
  end
end
```

In that method, call HTTP method name (downcase) like `get` or `post` with PATH and BLOCK where
 - PATH  : String
 - BLOCK : block of HTTP::Server::Context, Hash(String, String) -> HTTP::Server::Context
```
class WebServer
  include Router

  def draw_routes
    get "/" do |context, params|
      context.response.print "Hello router.cr!"
	  context
	end
  end
end
```

Here we've defined a GET route at root path (/) that just print out "Hello router.cr" when we get access.
To activate (run) the route, just define run methods for your server with route_handler
```
class WebServer
  include Router
  
  def draw_routes
    get "/" do |context, params|
      context.response.print "Hello router.cr!"
	  context
	end
  end
  
  def run
    server = HTTP::Server.new(3000, route_handler)
    server.listen
  end
end
```
Here route_handler is getter defined in Router. So you can call `route_handler` at anywhere in WebServer instance.

Finally, run your server.
```crystal
web_server = WebServer.new
web_server.draw_routes
web_server.run
```

See [sample](https://github.com/tbrand/router.cr/blob/master/sample/sample.cr) and [tips]([sample](https://github.com/tbrand/router.cr/blob/master/sample/tips.cr)) for details.

### Path parameters

`params` is a Hash(String, String) that is used when you define a path parameters such as `/user/:id` (`:id` is a parameters). Here is an example.
```crystal
class WebServer
  include Router

  def draw_routes
    get "/user/:id" do |context, params|
      context.response.print params["id"] # get :id in url from params
      context
    end
  end
end
```
Note that `params` also includes query params such as `/user?id=3`.

See [sample](https://github.com/tbrand/router.cr/blob/master/sample/sample.cr) and [tips]([sample](https://github.com/tbrand/router.cr/blob/master/sample/tips.cr)) for details.

## Contributing

1. Fork it ( https://github.com/tbrand/router.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [tbrand](https://github.com/tbrand) Taichiro Suzuki - creator, maintainer
