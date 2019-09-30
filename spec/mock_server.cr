require "../src/router"

class MockServer
  include Router

  @server : HTTP::Server
  @route_handler = RouteHandler.new

  def draw_routes
    get "/" do |context, params|
      context.response.print "index"
      context
    end

    get "/params/:id" do |context, params|
      context.response.print "params:#{params["id"]}"
      context
    end

    get "/params/:id/test/:test_id" do |context, params|
      context.response.print "params:#{params["id"]}, #{params["test_id"]}"
      context
    end

    post "/post_test" do |context, params|
      context.response.print "ok"
      context
    end

    put "/put_test" do |context, params|
      context.response.print "ok"
      context
    end

    head "/head_test" do |context, params|
      context.response.status_code = 204
      context
    end
  end

  def initialize(@port : Int32)
    draw_routes

    @server = HTTP::Server.new([route_handler])
    @server.bind_tcp("127.0.0.1", @port)
  end

  def run
    @server.listen
  end

  def close
    if server = @server
      server.close
    end
  end
end
