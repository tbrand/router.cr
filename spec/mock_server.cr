require "../src/router"

struct MockServer
  include Router

  def draw
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
  end
end
