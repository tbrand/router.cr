require "spec"
require "../src/router"
require "./mock_server"

mock_server = MockServer.new(3000)

Spec.before_suite do
  spawn do
    mock_server.run
  end

  sleep 0.1
end

Spec.after_suite do
  mock_server.close
end
