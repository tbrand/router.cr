require "../src/route"

class WebServer
  # Add Route functions to WebServer.class
  include Route

  # Initialize RouteHandler
  @route_handler = RouteHandler.new

  # To define API, call API.new with context and params(optional) where
  # context : HTTP::Server::Context
  # params  : Hash(String, String)
  #
  # HTTP::Server::Context is a default context of the http request/response
  # This includes body, header, response and so on
  # See https://crystal-lang.org/api/HTTP/Server/Context.html
  # All API have to return HTTP::Server::Context
  # For this, Basically, you just put the context on the last line of each API

  # GET "/"
  @index = API.new do |context|
    context.response.print "Hello route.cr"
    context
  end

  # params is used when you define parameters in your url such as '/user/:id' (path parameters)
  # In this case, you can get the 'id' by params["id"]
  # GET "/user/:id"
  @user = API.new do |context, params|
    context.response.print params["id"] # get :id in url from params
    context
  end

  # POST "/user"
  @register_user = API.new do |context|
    context
  end

  # When you register the routes with pathes, just call `[HTTP_METHOD] "[PATH]", [API]`
  # In the below example, do it in a constructor
  def initialize

    # Draw routes like this
    draw(@route_handler) do
      get  "/",         @index
      get  "/user/:id", @user
      post "/user",     @register_user
    end
  end

  def run
    # set RouteHandler to your server
    server = HTTP::Server.new(3000, @route_handler)
    server.listen
  end
end

# Initialize WebServer.class
web_server = WebServer.new

# Start running
web_server.run