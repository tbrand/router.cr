require "../src/route"

class WebServer
  # --- NOTE ---
  # All api method should be the format
  # def some_api(context : Context, uriParams : Uriparams) : Context
  #   some logics...
  # end
  #
  # Here is how to define apis
  # GET /
  def index(context : Context, uriParams : UriParams) : Context
    context.response.print "Hello Route.cr!"
    context
  end

  # GET /user/:id
  def user(context : Context, uriParams : UriParams) : Context
    # You can receive uri params from uriParams
    context.response.print "User(#{uriParams["id"]})"
    context
  end

  # POST /user
  def user_register(context : Context, uriParams : UriParams) : Context
    context.response.print "Register User!"
    context
  end

  def initialize
    # Define your routing
    # The DSL format is
    # 'http_method' 'path', 'method_name'
    # get, post, put, patch, delete and options are supported
    # For example,
    get "/", index
    get "/user/:id", user
    post "/user", user_register
  end

  def run

    # Running server in 4 threads concurrently
    spawn_server(4) do

      # Using default Crystal server
      server = HTTP::Server.new(3000) do |context|
        # Just call 'routing' method with the server context
        # 'routing' returns nil if the route not found
        routing(context)
      end

      # You have to reuse the port
      # when you run multiple servers at same port
      server.listen(true)
    end
  end

  # Include Route.cr library
  include Route
end

web_server = WebServer.new
web_server.run
