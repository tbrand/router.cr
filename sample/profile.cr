require "../src/router"

# router.cr serves ProfileHandler
# You can easily get a profile by accessing "/profile"
# ```
# [ GET /one ]        Access: 10          Total: 704.0µs      Ave: 70.4µs
# [ GET /two ]        Access: 9           Total: 309.0µs      Ave: 34.3µs
# [ GET /three ]      Access: 9           Total: 262.0µs      Ave: 29.1µs
# ```
class ProfiledServer
  include Router

  def run
    # Initialize profile handler
    profile_handler = ProfileHandler.new

    route_handler = RouteHandler.new

    draw(route_handler) do
      get "/one", API.new { |context|
        context.response.content_type = "text/plain"
        context.response.print "one"
        context
      }
      get "/two", API.new { |context|
        context.response.content_type = "text/plain"
        context.response.print "two"
        context
      }
      get "/three", API.new { |context|
        context.response.content_type = "text/plain"
        context.response.print "three"
        context
      }
    end

    # Set profile_handler before route_handler
    # Now you can get profile by accessing 'localhost:3000/profile'
    server = HTTP::Server.new(3000, [profile_handler, route_handler])
    server.listen

    # Try
    # `curl localhost:3000/one`
    # `curl localhost:3000/two`
    # `curl localhost:3000/three`
    # `curl localhost:3000/profile` <- get profile
  end
end

profiled_server = ProfiledServer.new
profiled_server.run
