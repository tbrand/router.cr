require "./router/handler"
require "./router/version"

module Router
  alias Action = HTTP::Server::Context, Hash(String, String) -> HTTP::Server::Context
  alias RouteContext = NamedTuple(action: Action, params: Hash(String, String))

  getter route_handler : RouteHandler = RouteHandler.new
  @server : HTTP::Server?

  HTTP_METHODS = %w(get post put patch delete options)

  # Define each method for supported http methods
  {% for http_method in HTTP_METHODS %}
    def {{http_method.id}}(path : String, &block : Action)
      @route_handler.add_route("/{{http_method.id.upcase}}" + path, block)
    end
  {% end %}

  def run(port : Int32 = 3000)
    draw_routes
    @server = HTTP::Server.new(port, [@route_handler]).listen
  end

  def run(host : String = "127.0.0.1", port : Int32 = 3000)
    draw_routes
    @server = HTTP::Server.new(host, port, [@route_handler]).listen
  end

  def run(host : String = "127.0.0.1", port : Int32 = 3000, handlers : Array(HTTP::Handler) = Array(HTTP::Handler))
    draw_routes
    @server = HTTP::Server.new(host, port, handlers + [@route_handler]).listen
  end

  def close
    if server = @server
      server.close
    end
  end
end
