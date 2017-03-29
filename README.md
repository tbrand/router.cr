# route.cr

[![Build Status](https://travis-ci.org/tbrand/route.cr.svg?branch=master)](https://travis-ci.org/tbrand/route.cr)
[![Dependency Status](https://shards.rocks/badge/github/tbrand/route.cr/status.svg)](https://shards.rocks/github/tbrand/route.cr)
[![devDependency Status](https://shards.rocks/badge/github/tbrand/route.cr/dev_status.svg)](https://shards.rocks/github/tbrand/route.cr)

The default web server of the Crystal is quite good but it weak at routing.
Kemal is an awesome defacto standard web framework for Crystal, but it's too fat for some purpose.

**route.cr** is a **minimum** but powerful **High Performance** web framework for Crystal web server.
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

To define API, call API.new with context and params(optional) where context is HTTP::Server::Context and params is Hash(String, String). All APIs have to return the context.
```crystal
class WebServer
  @index = API.new do |context|
    context.response.print "Hello route.cr"
    context
  end
end
```

Define your route at somewhere. In this example, define it in a contructor.
```crystal
class WebServer
  def initialize
    get "/", @index
  end
end
```

To activate the routes, use `routeHandler`.
```crystal
class WebServer
  def run
    server = HTTP::Server.new(3000, routeHandler)
    server.listen
  end
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

  @user = API.new do |context, params|
    context.response.print params["id"] # get :id in url from params
    context
  end

  def initialize
    get "/user/:id", @user
  end
end
```

See [sample](https://github.com/tbrand/route.cr/blob/master/example/sample.cr) for details.

## Contributing

1. Fork it ( https://github.com/tbrand/route.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [tbrand](https://github.com/tbrand) Taichiro Suzuki - creator, maintainer
