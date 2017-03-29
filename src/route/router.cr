require "radix"
require "http/server"

module Route
  def routeHandler : Router
    Router::INSTANCE
  end

  class Router
    include HTTP::Handler

    INSTANCE = new

    @tree = Radix::Tree(API).new

    def routeHandler : Router
      INSTANCE
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
      if route_context = Router::INSTANCE.search_route(context)
        route_context.api.call(context, route_context.params)
      end
    end

    HTTP_METHODS = %w(get post put patch delete options)

    {% for http_method in HTTP_METHODS %}
      def route_{{http_method.id}}(path : String, api : API)
        @tree.add("{{http_method.id}}".upcase + path, api)
      end
    {% end %}
  end

  macro get(path, api)
    Router::INSTANCE.route_get("{{path.id}}", {{api.id}})
  end

  macro post(path, api)
    Router::INSTANCE.route_post("{{path.id}}", {{api.id}})
  end

  macro put(path, api)
    Router::INSTANCE.route_put("{{path.id}}", {{api.id}})
  end

  macro patch(path, api)
    Router::INSTANCE.route_patch("{{path.id}}", {{api.id}})
  end

  macro delete(path, api)
    Router::INSTANCE.route_delete("{{path.id}}", {{api.id}})
  end

  macro options(path, api)
    Router::INSTANCE.route_options("{{path.id}}", {{api.id}})
  end
end
