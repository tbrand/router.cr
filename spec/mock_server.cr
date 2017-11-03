require "../src/router"

class MockServer
  include Router

  @server : HTTP::Server?
  @route_handler = RouteHandler.new

  def draw_routes
    get "/" do |context, params|
      context.response.print "index"
      context
    end

    get "/params/:id" do |context, params|
      result_body = "params:#{params["id"]}"
      result_body += ", query_params:#{params["q"]}" if params.has_key?("q")
      context.response.print result_body
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
  end

  def initialize(@port : Int32)
  end

  def run
    draw_routes

    @server = HTTP::Server.new(@port, [route_handler]).listen
  end

  def close
    if server = @server
      server.close
    end
  end
end
