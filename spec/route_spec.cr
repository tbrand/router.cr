require "./spec_helper"
require "./mock_server"
require "./curl"

class RouteSpec

  def initialize(port)
    @mock_server = MockServer.new(port)
  end

  def spec(&block)

    spawn do
      @mock_server.run
    end

    sleep 0.5

    yield # Spec here

    @mock_server.close
  end
end

describe Route do

  it "#index" do

    port = 3000

    RouteSpec.new(port).spec do
      result = curl("GET", "/", port)
      result.not_nil!.body.should eq("index")
    end
  end

  it "#params" do

    port = 3001

    RouteSpec.new(port).spec do
      result = curl("GET", "/params/1", port)
      result.not_nil!.body.should eq("params:1")
      result = curl("GET", "/params/2", port)
      result.not_nil!.body.should eq("params:2")
    end
  end

  it "#post_test" do

    port = 3002

    RouteSpec.new(port).spec do
      result = curl("POST", "/post_test", port)
      result.not_nil!.body.should eq("ok")
    end
  end
end
