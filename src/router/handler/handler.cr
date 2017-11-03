module Router
  class RouteHandler
    include HTTP::Handler

    def initialize
      @tree = Radix::Tree(Action).new
    end

    def search_route(context : HTTP::Server::Context) : RouteContext?
      method = context.request.method
      route = @tree.find(method.upcase + context.request.path)

      return { action: route.payload, params: route.params } if route.found?

      nil
    end

    def call(context : HTTP::Server::Context)
      if route_context = search_route(context)
        route_context[:action].call(context, route_context[:params])
      else
        call_next(context)
      end
    end

    def add_route(key : String, action : Action)
      @tree.add(key, action)
    end
  end
end
