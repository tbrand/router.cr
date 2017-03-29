require "./route/*"
require "yaml"

module Route
  # Alias of API
  alias API = Proc(HTTP::Server::Context, Hash(String, String), HTTP::Server::Context)

  # This includes API and url parametes
  record RouteContext, api : API, params : Hash(String, String)
  include Logger
end
