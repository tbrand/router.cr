require "../src/route"

# This sample shows how to mix with other default middlewares.
# We use ErrorHandler, LogHandler and StaticFileHandler in this sample (Of course RouteHandler as well).
#
# Here is a list of default HTTP::Handler(s)
# - HTTP::CompressHandler           https://crystal-lang.org/api/HTTP/CompressHandler.html
# - HTTP::ComputedContentTypeHeader https://crystal-lang.org/api/HTTP/ComputedContentTypeHeader.html
# - HTTP::ErrorHandler              https://crystal-lang.org/api/HTTP/ErrorHandler.html
# - HTTP::LogHandler                https://crystal-lang.org/api/HTTP/LogHandler.html
# - HTTP::StaticFileHandler         https://crystal-lang.org/api/HTTP/StaticFileHandler.html
# - HTTP::WebSocketHandler          https://crystal-lang.org/api/HTTP/WebSocketHandler.html

class WebServer
  include Route

  # HTTP::Handler(s)
  @log_handler = HTTP::LogHandler.new
  @error_handler = HTTP::ErrorHandler.new
  @static_file_handler = HTTP::StaticFileHandler.new(File.expand_path("../public", __FILE__))
  @route_handler = RouteHandler.new

  @index = API.new do |context|
    context.response.print "OK"
    context
  end

  def initialize
    draw(@route_handler) do
      get "/ok", @index
    end
  end

  def run
    # Please note about the order of the handlers.
    # For example, LogHandler should be the first of the array since it should get all accesses.
    # ErrorHandler should be the next of the LogHandler to handle all errors.
    # StatifFileHandler should be the next of the ErrorHandler since it should serve static files
    # before the access coming to RouteHandler.
    # StaticFileHandler will pass the access to the RouteHandler if the file does not exist.
    # So RouteHandler should be last.
    # The array of the handlers should be like this.
    handlers = [
      @log_handler,
      @error_handler,
      @static_file_handler,
      @route_handler,
    ]

    server = HTTP::Server.new(3000, handlers)
    server.listen

    # Try
    # `curl localhost:3000/ok`         <- Handle route
    # `curl localhost:3000/hello.html` <- Serve static file
    # `curl localhost:3000/invalid`    <- Internal Error(500)
  end
end

web_server = WebServer.new
web_server.run
