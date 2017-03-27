require "../src/route"

class MockServer
  @server  : HTTP::Server?
  @servers = [] of HTTP::Server

  def initialize(@port : Int32)
    # Disable all logs
    route_log_level(Production)
    
    get "/", index
    get "/params/:id", param
    get "/params/:id/test/:test_id", test_param
    
    post "/post_test", post_test

    put "/put_test", put_test
  end

  def index(context : Context, uriParams : UriParams) : Context
    context.response.print "index"
    context
  end

  def param(context : Context, uriParams : UriParams) : Context
    context.response.print "params:#{uriParams["id"]}"
    context
  end

  def test_param(context : Context, uriParams : UriParams) : Context
    context.response.print "params:#{uriParams["id"]}, #{uriParams["test_id"]}"
    context
  end

  def post_test(context : Context, uriParams : UriParams) : Context
    context.response.print "ok"
    context
  end

  def put_test(context : Context, uriParams : UriParams) : Context
    context.response.print "ok"
    context
  end

  def run
    @server = HTTP::Server.new(@port) { |context| routing(context) }.listen
  end

  def spawn_run

    spawn_server(4) do

      server = HTTP::Server.new(@port) { |context| routing(context) }
      server.listen(true)

      @servers.push(server)
    end
  end

  def close
    if server = @server
      server.close
    end

    @servers.each do |s|
      s.close
    end
  end

  include Route
end
