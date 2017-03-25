module Route
  module Logger

    module Level
      Develop = 0
      Production = 1
    end

    @level = Develop

    def route_log_level(@level : Int32)
    end

    def i(msg : String)
      puts "\e[36m[Route.cr]\e[m #{msg}" if @level == Develop
    end

    def w(msg : String)
      puts "\e[33m[Route.cr]\e[m #{msg}" if @level == Develop
    end

    def e(msg : String)
      puts "\e[31m[Route.cr]\e[m #{msg}"
    end

    include Level
  end
end
