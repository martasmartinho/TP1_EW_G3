require 'rubygems'
require 'mongo'

class DataReading

  #fields
  attr_accessor :db
  @db = 'tp1_ew_mongodb'

  #insert new client reding
  def self.insertReading(client_id, sensor_type, value, location)

    Mongo::Logger.logger.level = ::Logger::FATAL

    begin

      connection = Mongo::Client.new([ '127.0.0.1:27017' ], :database => @db,
                                     :server_selection_timeout => 5)

      connection[:client_readings].update_one({:client_id => cliente_id}, '$push' =>
                                    {:sensor_type => sendor_type,
                                     :value => value,
                                     :location => location,
                                     :timestamp => DateTime.now} )

      connection.close

    rescue Mongo::Error::NoServerAvailable => e

      puts 'Cannot connect to the server'
      puts e

    end

  end


  #select new client reding
  def self.selectAllClientReadings(clientId)


    readings = Array.new

    Mongo::Logger.logger.level = ::Logger::FATAL

    begin
      array = new.Array
      counter = 0

      connection = Mongo::Client.new([ '127.0.0.1:27017' ], :database => @db,
                                     :server_selection_timeout => 5)

      connection[:client_readings].find(:client_id => clientId ).each do |doc|
        (doc[:readings]).each do |item|
          array[counter] = readings. item[:value]
          counter = counter + 1
        end
      end

      connection.close

      return array

      rescue Mongo::Error::NoServerAvailable => e

      puts 'Cannot connect to the server'
      puts e

    end

    #readings = document[readings]


    return 1

  end

end

