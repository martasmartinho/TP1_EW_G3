require 'rubygems'
require 'mongo'


class DataReading

  #fields
  attr_accessor :db
  @db = 'tp1_ew_mongodb'

  #insert new client reding
  def self.insertReading(client_id, sensor_type, value, location, timestamp)


    Mongo::Logger.logger.level = ::Logger::FATAL

    begin
      #open connection
      connection = Mongo::Client.new([ '127.0.0.1:27017' ], :database => @db,
                                     :server_selection_timeout => 5)

      #update document collection
      connection[:client_readings].update_one({:client_id => Integer(client_id)}, '$push' =>
          {:sensor_type => sendor_type,
           :value => value,
           :location => location,
           :timestamp => timestamp} )

      #close connection
      connection.close

    rescue Mongo::Error::NoServerAvailable => e

      puts 'Cannot connect to the server'
      puts e

    end

  end


  #insert new client redings
  def self.insertReadings(client_id, readings)



    Mongo::Logger.logger.level = ::Logger::FATAL

    begin
      #open connection
      connection = Mongo::Client.new([ '127.0.0.1:27017' ], :database => @db,
                                     :server_selection_timeout => 5)



      #update document collection
      readings.each do |r|
        reading = Reading.new
        reading = r
        connection[:client_readings].update_one({:client_id => Integer(client_id)}, '$push' =>
            {:readings => {:sensor_type => Integer(r.sensor_type),
             :value => Float(r.value),
             :location => Integer(r.location),
             :timestamp => r.timestamp}})
      end



      #close connection
      connection.close

    rescue Mongo::Error::NoServerAvailable => e

      puts 'Cannot connect to the server'
      puts e

    end

  end


  #select new client reding
  def self.selectAllClientReadings(client_id, sensor_type)


    readings = Array.new

    Mongo::Logger.logger.level = ::Logger::FATAL

    begin

      #open connection
      connection = Mongo::Client.new([ '127.0.0.1:27017' ], :database => @db,
                                     :server_selection_timeout => 5)

      #get document
      connection[:client_readings].find(:client_id => Integer(client_id)).each do |doc|


        #populate array with readings
        (doc['readings']).each do |r|

          if r['sensor_type'] == sensor_type
            reading = Reading.new
            reading.sensor_type = r['sensor_type']
            reading.value = r['value']
            reading.location = r['location']
            reading.timestamp = r['timestamp']
            readings.push(reading)
          end
        end
      end

      #close connection
      connection.close

      return readings

      rescue Mongo::Error::NoServerAvailable => e

      puts 'Cannot connect to the server'
      puts e

    end
  end

end



