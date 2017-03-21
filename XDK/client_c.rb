require 'socket'
load '../XDK/xdk.rb'

class ClientC < Xdk

  def run(host, port)

    #open connection
    socket = TCPSocket.new(host, port)


    str = format('%d,%d', @id, @location)
    #send id to server
    socket.puts(str)

    sleep(0.3)
    #send temperature to server
    thread_a = Thread.new do
      chronometer(30) do
        socket.puts(JSON.generate(updateTemperature))
        str = socket.gets
        if str != nil
          puts str.chomp
        end

      end

    end
    sleep(0.1)
    #send temperature to server
    thread_b = Thread.new do
      chronometer(1) do
        socket.puts(JSON.generate(updateAcoustic))
        str = socket.gets
        if str != nil
          puts str.chomp
        end
      end

    end

    thread_a.join
    thread_b.join

    socket.close

  end


end

c = ClientC.new(3, 30, 1, 333333)
c.run('127.0.0.1', 2020)
