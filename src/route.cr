require "./route/*"
require "yaml"

module Route
  alias Context = HTTP::Server::Context
  alias UriParams = Hash(String, String?)

  record Route, proc : Proc(Context, UriParams, Context), params : Hash(String, String?)

  def routing(context : Context) : Context?
    i "#{context.request.method} #{context.request.resource}"

    if route = search_route(context)
      route.proc.call(context, route.params)
    end

    nil
  end

  macro spawn_server(t, &block)
    
    channel = Channel(Nil).new

    {% for i in 0..t %}
      spawn do
        {{yield}}
      end
    {% end %}

      channel.receive
  end  

  include HttpMethods
  include Logger
end
