# Just curl localhost where mock server is listening

def curl(method : String, path : String, port : Int32) : HTTP::Client::Response?
  
  client = HTTP::Client.new "localhost", port

  response = nil
  
  case method
  when "GET"
    response = client.get path
  when "POST"
    response = client.post path
  end

  client.close

  response
end
