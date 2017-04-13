module Route
  class ProfileHandler
    include HTTP::Handler

    class Access
      property method : String
      property path : String
      property time : Time::Span
      property n : Int32

      def initialize(@method, @path, @time, @n); end

      def access(time : Time::Span)
        @time += time
        @n += 1
      end
    end

    @data = {} of String => Access

    def format_data : String
      String.build do |res|
        @data.each do |key, access|
          res << "[ #{access.method} #{access.path} ] ".ljust(20, ' ')
          res << "Access: #{access.n} ".ljust(20, ' ')
          res << "Total: #{format_time(access.time)} ".ljust(20, ' ')
          res << "Ave: #{format_time(access.time/access.n)} ".ljust(20, ' ')
          res << "\n"
        end
      end
    end

    def call(context)
      method = context.request.method
      path = context.request.resource

      if method == "GET" && path == "/profile"
        context.response.content_type = "text/plain"
        context.response.print format_data
        return context
      end

      time = Time.now

      call_next(context)
      elapsed_time = Time.now - time

      method = context.request.method
      path = context.request.resource
      key = method + path

      if @data.has_key?(key)
        @data[key].access(elapsed_time)
      else
        @data[key] = Access.new(method, path, elapsed_time, 1)
      end
    end

    def format_time(time)
      minutes = time.total_minutes
      return "#{minutes.round(2)}m" if minutes >= 1

      seconds = time.total_seconds
      return "#{seconds.round(2)}s" if seconds >= 1

      millis = time.total_milliseconds
      return "#{millis.round(2)}ms" if millis >= 1

      "#{(millis * 1000).round(2)}µs"
    end
  end
end
