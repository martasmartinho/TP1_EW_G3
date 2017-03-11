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
      connection[:client_readings].update_one({:client_id => cliente_id}, '$push' =>
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


  #select new client reding
  def self.selectAllClientReadings(client_id)


    readings = Array.new

    Mongo::Logger.logger.level = ::Logger::FATAL

    begin

      array = new.Array
      counter = 0

      #open connection
      connection = Mongo::Client.new([ '127.0.0.1:27017' ], :database => @db,
                                     :server_selection_timeout => 5)

      #get document
      doc = connection[:client_readings].find(:client_id => client_id )

      #populate array with readings
      (doc[:readings]).each do |reading|
        array[counter] = reading
        counter = counter + 1
      end

      #close connection
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



