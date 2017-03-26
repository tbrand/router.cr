# Just curl localhost where mock server is listening

def curl(method : String, path : String) : HTTP::Client::Response?
  client = HTTP::Client.new "localhost", 3000

  response = nil
  case method
  when "GET"
    response = client.get path
  when "POST"
    response = client.post path
  when "PUT"
    response = client.put path
  end

  client.close

  response
end
