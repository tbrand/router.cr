require "radix"

module Route
  # Alias of API
  alias API = Proc(HTTP::Server::Context, Hash(String, String), HTTP::Server::Context)

  # This includes API and url parametes
  record RouteContext, api : API, params : Hash(String, String)

  class RouteHandler
    include HTTP::Handler

    def initialize
      @tree = Radix::Tree(API).new
    end

    def search_route(context : HTTP::Server::Context) : RouteContext?
      method = context.request.method
      path = case md = %r(^[^?]+).match(context.request.resource)
             when Regex::MatchData
               md[0]
             else
               context.request.resource
             end

      route = @tree.find(method.upcase + path)

      if route.found?
        return RouteContext.new(route.payload, route.params)
      end

      nil
    end

    def call(context)
      if route_context = search_route(context)
        route_context.api.call(context, route_context.params)
      else
        raise RouteNotFoundException.new(context.request.method, context.request.resource)
      end

      call_next(context) if @next
    end

    def add_route(key : String, api : API)
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
    def {{http_method.id}}(path : String, api : API)
      abort "Please call `{{http_method.id}}` in `draw`" if @tmp_route_handler.nil?
      @tmp_route_handler.not_nil!.add_route("{{http_method.id.upcase}}" + path, api)
    end
  {% end %}
end
