module Route
  class RouteNotFoundException < Exception
    def initialize(method, path)
      super "Route not found: #{method} #{path}"
    end
  end
end
