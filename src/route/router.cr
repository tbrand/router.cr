require "radix"
require "http/server"

module Route
  class RouteHandler
    include HTTP::Handler

    def initialize
      @tree = Radix::Tree(API).new
    end

    def search_route(context : HTTP::Server::Context) : RouteContext?
      method = context.request.method
      path = context.request.resource

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
end
