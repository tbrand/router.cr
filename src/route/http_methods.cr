require "http/server"

module Route

  module HttpMethods

    HTTP_METHODS = %w(get post put patch delete options)

    @routes_methods = {} of String => Hash(String, Route)
    @routes_methods_regex = {} of String => Hash(Regex, Route)

    def search_route(context : Context) : Route?
      method = context.request.method
      path   = context.request.resource

      return @routes_methods[method][path] if @routes_methods[method].has_key?(path)

      @routes_methods_regex[method.upcase].each_key do |r|

        if params = r.match(path)

          ok = true
          
          rr = @routes_methods_regex[method][r]
          rr.params.each_key do |key|
            
            if params[key].includes?("/")
              ok = false
              break
            end
            
            rr.params[key] = params[key]
          end

          return rr if ok
        end
      end

      w "No method found for this route"

      nil
    end

    macro http_methods

      {% for http_method in HTTP_METHODS %}

        def route_{{http_method.id}}(path : String, proc : Proc(Context, UriParams, Context))

          unless @routes_methods.has_key?("{{http_method.id}}".upcase)
            @routes_methods["{{http_method.id}}".upcase] = {} of String => Route
          end
          
          @routes_methods["{{http_method.id}}".upcase][path] = Route.new(proc, {} of String => String?)
          
          if path.includes?(":")

            route_regex = Route.new(proc, {} of String => String?)
            
            path.split("/").each do |part|
              
              if part.starts_with?(":")
                path = path.gsub(part, "(?<#{part[1..-1]}>.*)")
                route_regex.params[part[1..-1]] = nil
              end
              
              unless @routes_methods_regex.has_key?("{{http_method.id}}".upcase)
                @routes_methods_regex["{{http_method.id}}".upcase] = {} of Regex => Route
              end
            end

            @routes_methods_regex["{{http_method.id}}".upcase][Regex.new(path)] = route_regex
          end
        end
      {% end %}
    end

    macro get(path, proc)
      route_get "{{path.id}}", -> {{proc.id}}(Context, UriParams)
    end

    macro post(path, proc)
      route_post "{{path.id}}", -> {{proc.id}}(Context, UriParams)
    end

    macro put(path, proc)
      route_put "{{path.id}}", -> {{proc.id}}(Context, UriParams)
    end

    macro patch(path, proc)
      route_patch "{{path.id}}", -> {{proc.id}}(Context, UriParams)
    end

    macro delete(path, proc)
      route_delete "{{path.id}}", -> {{proc.id}}(Context, UriParams)
    end

    macro options(path, proc)
      route_options "{{path.id}}", -> {{proc.id}}(Context, UriParams)
    end

    http_methods
  end
end
