require "radix"

module Router
  # Alias of Action
  alias Action = Proc(HTTP::Server::Context, Hash(String, String), HTTP::Server::Context)

  # This includes Action and url parametes
  record RouteContext, api : Action, params : Hash(String, String)

  class RouteHandler
    include HTTP::Handler

    def initialize
      @tree = Radix::Tree(Action).new
    end

    def search_route(context : HTTP::Server::Context) : RouteContext?
      method = context.request.method
      route = @tree.find(method.upcase + context.request.path)

      # Merge query params into path params
      context.request.query_params.each do |k, v|
        route.params[k] = v unless route.params.has_key?(k)
      end

      if route.found?
        return RouteContext.new(route.payload, route.params)
      end

      nil
    end

    def call(context)
      if route_context = search_route(context)
        route_context.api.call(context, route_context.params)
      else
        call_next(context)
      end
    end

    def add_route(key : String, api : Action)
      @tree.add(key, api)
    end
  end

  # RouteHandler to be drawn
  @tmp_route_handler : RouteHandler?

  def draw(route_handler, &block)
    @tmp_route_handler = route_handler
    yield
    @tmp_route_handler = nil
  end

  # Supported http methods
  HTTP_METHODS = %w(get post put patch delete options)
  {% for http_method in HTTP_METHODS %}
    def {{http_method.id}}(path : String, api : Action)
      abort "Please call `{{http_method.id}}` in `draw`" if @tmp_route_handler.nil?
      @tmp_route_handler.not_nil!.add_route("{{http_method.id.upcase}}" + path, api)
    end
  {% end %}
end
