require "../src/route"

class MockServer

  @server : HTTP::Server?

  def initialize(@port : Int32)
    # Disable all logs
    route_log_level(Production)
    
    get "/", index
    get "/params/:id", param

    post "/post_test", post_test
  end

  def index(context : Context, uriParams : UriParams) : Context
    context.response.print "index"
    context
  end

  def param(context : Context, uriParams : UriParams) : Context
    context.response.print "params:#{uriParams["id"]}"
    context
  end

  def post_test(context : Context, uriParams : UriParams) : Context
    context.response.print "ok"
    context
  end
  
  def run
    @server = HTTP::Server.new(@port){ |context| routing(context) }.listen
  end

  def close
    if server = @server
      server.close
    end
  end

  include Route
end
