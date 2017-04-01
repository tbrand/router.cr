require "./spec_helper"
require "./mock_server"
require "./curl"

describe Route do
  mock_server = MockServer.new(3000)

  spawn do
    mock_server.run
  end

  sleep 0.5

  it "#index" do
    result = curl("GET", "/")
    result.not_nil!.body.should eq("index")
  end

  it "#params" do
    result = curl("GET", "/params/1")
    result.not_nil!.body.should eq("params:1")
    result = curl("GET", "/params/2")
    result.not_nil!.body.should eq("params:2")
  end

  it "#test_param" do
    result = curl("GET", "/params/1/test/3")
    result.not_nil!.body.should eq("params:1, 3")
    result = curl("GET", "/params/2/test/4")
    result.not_nil!.body.should eq("params:2, 4")
  end

  it "#post_test" do
    result = curl("POST", "/post_test")
    result.not_nil!.body.should eq("ok")
  end

  it "#put_test" do
    result = curl("PUT", "/put_test")
    result.not_nil!.body.should eq("ok")
  end

  it "#view" do
    result = curl("GET", "/view")
    result.not_nil!.body.should eq("<p>OK</p>\n")
  end

  mock_server.close
end
