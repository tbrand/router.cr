require "./router/handler"
require "./router/version"

module Router
  alias Action = HTTP::Server::Context, Hash(String, String) -> HTTP::Server::Context
  alias RouteContext = NamedTuple(action: Action, params: Hash(String, String))

  getter route_handler : RouteHandler = RouteHandler.new

  HTTP_METHODS = %w(get post put patch delete options head)

  # Define each method for supported http methods
  {% for http_method in HTTP_METHODS %}
    def {{http_method.id}}(path : String, &block : Action)
      @route_handler.add_route("/{{http_method.id.upcase}}" + path, block)
    end
  {% end %}
end
