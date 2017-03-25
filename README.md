# route.cr

The default web server of the Crystal is quite good but it weak at routing.
Kemal is an awesome defacto standard web framework for Crystal, but it's too fat for some purpose.

**route.cr** is a minimum but powerful path router for Crystal web server.

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

Define your API. All API have to take Context and UriParams arguments and return Context. Context is an alias of HTTP::Server::Context. The explain of UriParams is later. Here is an example.
```crystal
class WebServer
  def index(context : Context, uriParams : UriParams) : Context
    # ...Write your logic here...
	return context
  end
end
```

Define your route at somewhere. In this example, define it in a contructor.
```crystal
class WebServer
  def initialize
    get "/", index
  end
end
```

To activate the routes, pass a context from `HTTP::Server` to routing like
```
class WebServer
  def run
    server = HTTP::Server.new(3000) do |context|
	  routing(context) # Pass context to `routing`
	end

	server.listen
  end
end
```

Finally, run your server.
```
web_server = WebServer.new
web_server.run
```

UriParams is a Hash(String, String) that is used when you define a path including parameters such as `"/user/:id"`(`:id` is a parameters). Here is an example.
```
class WebServer
  def initialize
    get "/user/:id"
  end
  
  def user_id(context : Context, uriParams : UriParams) : Context
    id = uriParams["id"] # You can refer the :id like this.
	... Your logics here
	return context
  end
end
```

See `sample/` for details.

## Contributing

1. Fork it ( https://github.com/tbrand/route.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [tbrand](https://github.com/tbrand) Taichiro Suzuki - creator, maintainer
