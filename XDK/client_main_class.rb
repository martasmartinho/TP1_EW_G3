require '../XDK/client'
require 'socket'
require 'json'

class ClientMainClass

  def self.main()

    host = 'localhost'
    port = 2000

    s = TCPSocket.open(host, port)

    request = { 'main' => 'dsfghjkl' }.to_json
    s.print(request)

    s.close


  end

end

ClientMainClass.main()