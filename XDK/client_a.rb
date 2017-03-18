require 'socket'
require 'json'
require 'thread'
load 'xdk.rb'

class ClientA < Xdk

  def run(host, port)

    #open connection
    socket = TCPSocket.new(host, port)
    str = format('%d,%d', @id, @location)
    #send id to server
    socket.puts(str)
    #start time
    start = Time.now

    sleep(0.3)
    #send temperature to server
    thread_a = Thread.new do
        chronometerWithTemporizer(15, 14) do
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
      chronometerWithTemporizer(1, 16) do
          socket.puts(JSON.generate(updateAcoustic))
          str = socket.gets
          if str != nil
            puts str.chomp
          end
      end


    end
    thread_a.join
    thread_b.join

    socket.puts("DISCONNECTED")

  end
end

a = ClientA.new(1, 30, 1, 11111)
a.run('127.0.0.1', 2020)
