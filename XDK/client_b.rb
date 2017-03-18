require 'socket'
require 'json'
load 'xdk.rb'

class ClientB < Xdk

  def run(host, port)

    #open connection
    socket = TCPSocket.new(host, port)
    str = format('%d,%d', @id, @location)
    #send id to server
    socket.puts(str)
counter = -2
    sleep(0.3)
    #send temperature to server
    thread_a = Thread.new do
      chronometer(30) do
        socket.puts(JSON.generate(updateTemperature))
        counter = counter + 1
        str = socket.gets
        if str != nil
          printf("%d - ", counter)
          puts str.chomp
        end
      end

    end
    sleep(0.1)
    #send temperature to server
    thread_b = Thread.new do
      chronometer(1) do
        socket.puts(JSON.generate(updateAcoustic))
        counter = counter + 1
        str = socket.gets
        if str != nil
          printf("%d - ", counter)
          puts str.chomp
        end
      end

    end

    thread_a.join
    thread_b.join

    socket.close

  end


end

b = ClientB.new(2, 30, 1, 222222)
b.run('127.0.0.1', 2020)
