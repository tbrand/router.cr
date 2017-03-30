require "./route/*"

module Route
  # Alias of API
  alias API = Proc(HTTP::Server::Context, Hash(String, String), HTTP::Server::Context)

  # This includes API and url parametes
  record RouteContext, api : API, params : Hash(String, String)

  # RouteHandler to be drawn
  @tmp_route_handler : RouteHandler?

  def draw(route_handler, &block)
    @tmp_route_handler = route_handler
    yield
    @tmp_route_handler = nil
  end

  # Supported http methods
  HTTP_METHODS = %w(get post put patch delete options)
  
  {% for http_method in HTTP_METHODS %}
    def {{http_method.id}}(path : String, api : API)
      abort "Please call `{{http_method.id}}` in `draw`" if @tmp_route_handler.nil?
      @tmp_route_handler.not_nil!.add_route("{{http_method.id}}".upcase + path, api)
    end
  {% end %}
end
