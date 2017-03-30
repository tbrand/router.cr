require "../src/route"

class MinimumSample
  include Route
  
  def run
    route_handler = RouteHandler.new

    draw(route_handler) do get "/", API.new { |context|
                             context.response.print "OK!"; context
                           }
    end

    HTTP::Server.new(3000, route_handler).listen
  end
end

MinimumSample.new.run
