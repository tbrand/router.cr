require "../src/router"

class MockServer
  include Router

  @server : HTTP::Server?
  @route_handler = RouteHandler.new

  @index = API.new do |context|
    context.response.print "index"
    context
  end

  @param = API.new do |context, params|
    result_body = "params:#{params["id"]}"
    result_body += ", query_params:#{params["q"]}" if params.has_key?("q")
    context.response.print result_body
    context
  end

  @test_param = API.new do |context, params|
    context.response.print "params:#{params["id"]}, #{params["test_id"]}"
    context
  end

  @post_test = API.new do |context, params|
    context.response.print "ok"
    context
  end

  @put_test = API.new do |context, params|
    context.response.print "ok"
    context
  end

  def_view :view, "spec/view/test.ecr", text: String

  @view = API.new do |context|
    context.response.print render_view(:view, "OK")
    context
  end

  def initialize(@port : Int32)
    draw(@route_handler) do
      get "/", @index
      get "/params/:id", @param
      get "/params/:id/test/:test_id", @test_param
      get "/view", @view
      put "/put_test", @put_test
      post "/post_test", @post_test
    end
  end

  def run
    @server = HTTP::Server.new(@port, [ProfileHandler.new, @route_handler]).listen
  end

  def close
    if server = @server
      server.close
    end
  end
end
