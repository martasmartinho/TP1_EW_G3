require 'socket'
require 'json'
load '../Logic/client.rb'
load '../Logic/reading.rb'

class Server

  attr_accessor :clients, :server_socket

  def initialize(port)

    @port = port
    @clients = Array::new

  end

  #start server
  def run

    @server_socket = TCPServer.open(@port)
    puts 'socket created'
    printReadings

    while true
      puts 'waiting o client connection'
      Thread.new(server_socket.accept) do |connection|
        puts "Accepting connection from: #{connection.peeraddr[1]}"
        #Carregar client
        client = Client.new
        @clients.push(client)

        begin
          while connection

            #connection.puts('Connected to server')
            doc = connection.gets

            if doc != nil && doc != 'DISCONNECT'
              doc = doc.chomp
              if client.client_id == 0
                client.client_id = doc.to_s.split(',').first
                client.location = doc.to_s.split(',').last
                client.is_connected = true
                puts "ID: #{client.client_id}"
                puts "Location: #{client.location}"
                puts "Connected: #{client.is_connected}"
                client.connectClient
                connection.puts('Connected to server')
                doc = ''
                connection.flush

              else
                if doc != 'DISCONNECT'
                  array = Array.new
                  array = doc.to_s.split('}{')

                  if array.count > 1
                    array[0] = array[0] + '}'
                    array[1] = '{' + array[1]
                    array.each { |d|
                      j = JSON.parse(d)
                      client.addReading(j['sensor_type'], j['value'], j['location'], j['timestamp'])
                    }
                  else
                    j = JSON.parse(doc)
                    client.addReading(j['sensor_type'], j['value'], j['location'], j['timestamp'])
                  end




                end

              end
            end

            if doc == 'DISCONNECT'
              puts 'Received: DISCONNECT, closed connection'
              connection.puts('Disconnected')
              connection.close
              break
            else
              #puts doc
              connection.puts doc
              connection.flush
              information

            end
          end
        rescue Exception => e
          # Displays Error Message
          puts "#{ e } (#{ e.class } (#{ doc })"
          @aerver_socket.close
        ensure
          connection.close
          client.is_connected = false
          client.disconnectClient
          @clients.delete(client)
          if client.readings.count > 0
            client.addReading()
          end
          puts ''
          puts "Temperature readings counter: #{client.temperature_counter}"
          puts ''
          puts "Acoustic readings counter: #{client.acoustic_counter}"
          puts ''
          puts "Closing client: #{ client.client_id }"
        end
      end
    end

  end


  #print readings
  # @param [Reading] readings
  def printReadings

    puts ''
    printf('See client readings y|n: ')
    option = readline.chomp
    if option == 'y'

      printf('Type client id: ')
      sleep(0.1)
      client = Client.new
      client.client_id =  Integer(readline.chomp)
      printf('Type sensor: ')
      sensor_type = Integer(readline.chomp)
      client = client.getClient(client.client_id, )

      if client == nil
        puts 'Client does not exist'
      else
        client.getReadings(sensor_type)
        puts "Client: #{client.client_id}"
        puts "Location: #{client.location}"

        if (sensor_type == 1) then
          puts 'Sensor: Temperature'
        else
          puts 'Sensor: Acoustic'
        end

        client.readings.each { |r|
          reading = Reading.new
          reading = r
          puts reading.timestamp
          puts "   value: #{reading.value}"

        }
      end

    end

    puts ''

  end

  #clear terminal
  def clearRubyConsole
    puts ("\n" * 40)
    time = Time.new
    puts time.strftime('%Y-%m-%d %H:%M:%S')
    puts ('-' * 40)
  end

  #show information to user
  def information
    clearRubyConsole

    if @clients.count > 0
      puts ' ============ Connected clients ============'
      @clients.each { |c|
        cl = Client.new
        cl = c

        puts '||'
        puts "|| client  #{cl.client_id}"
        puts "||    *location: #{cl.location}"
        puts "||    *Temperature: #{cl.temperature_counter}"
        puts "||    *Acoustic: #{cl.acoustic_counter}"
        puts '||___________________________________________'

      }
    else
      puts ' ============ Connected clients ============'
      puts '||                                         ||'
      puts '||  Empty data                             ||'
      puts '||                                         ||'
      puts '||                                         ||'
      puts '||                                         ||'
      puts ' ==========================================='
    end



  end


end

s = Server.new(2020)

s.run
s.close
