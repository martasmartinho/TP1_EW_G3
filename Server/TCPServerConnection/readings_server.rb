require 'socket'


class ReadingsServer

  #initialize the server
  def initialize(port)

    #connected clients list
    @clients = Array::new
    #create a new TCP server
    @server_socket = TCPServer.new('', port)

    #define socket
    @server_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
    printf('Server start on port %d\n', port)
    @clients.push(@server_socket)

  end

  #connection body
  def run

    while 1
      res = select(@clients, nil, nil, nil)
      if res != nill then
        for socket in res[0]
          #if client is trying to connect
          if socket == @server_socket then
            acceptNewConnection
          else
            #if client is trying to disconnect
            if socket.eof? then
              str = sprintf('Client disconnected %s: %s\n', socket.peeraddr[2], socket.peeraddr[1])
              receiveReading(str, socket)
              socket.close
              @clients.delete(socket)

              #if client is trying to send message
            else
              str = sprintf('[%s|%s]: %s', socket.peeraddr[2], socket.peeraddr[1]. socket.gets())
              resceiveReading(str, socket)
            end
          end
        end
      end
    end
  end

  #private methods

  private

  def receiveReading(reading, omit_socket)

    #reencaminhar a mensagem para outros clientes
    @clients.each do |client_socket|
      if client_socket != @server_socket && client_socket != omit_socket
        client_socket.write(reading)
      end
    end
  end

  def acceptNewConnection

    new_socket = @server_socket.accept
    @clients.puch(new_socket)
    new_socket.write ('You can now begin sending readings')
    str = sprintf("Client joined %s: %s\n", new_socket.peeraddr[2], new_socket.peeraddr[1])
    receiveReading(str, new_socket)

  end

end


server = ReadingsServer.new(2626)
server.run