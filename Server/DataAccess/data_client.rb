require 'rubygems'
require 'mongo'

class DataClient

  #fields
  attr_accessor :db
  @db = 'tp1_ew_mongodb'

  #create new client
  def self.insertClient(client_id, is_connected)

      Mongo::Logger.logger.level = ::Logger::FATAL

      begin

        connection = Mongo::Client.new([ '127.0.0.1:27017' ], :database => @db,
                                    :server_selection_timeout => 5)

        document = { :client_id => cliente_id,
                :creation_date =>  DateTime.now,
                :update_date =>  DateTime.now, :readings => [] }

        connection[:client_readings].insert_one document
        connection.close

        rescue Mongo::Error::NoServerAvailable => e

        puts 'Cannot connect to the server'
        puts e

      end

  end


  #select a client
  def self.selectClient(clientId)

    Mongo::Logger.logger.level = ::Logger::FATAL

    begin

      client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'tp1_ew_mongodb',
                                 :server_selection_timeout => 5)


      client[:client_readings].find.each { |doc| puts doc }




      doc = { :client_id => 9, :is_connected => true,
              :creation_date =>  DateTime.now,
              :update_date =>  DateTime.now, :readings => []}

      docs = client[:clients].find({}, { :projection => {:client_id => 0}})


      #client[:clients].insert_one doc
      client.close

    rescue Mongo::Error::NoServerAvailable => e

      p 'Cannot connect to the server'
      p e

    end


    puts "There are #{docs.count} documents"

  end


  #update a client
  def self.updateClient(client_id, is_connected)

    Mongo::Logger.logger.level = ::Logger::DEBUG

    begin

      connection = Mongo::Client.new([ '127.0.0.1:27017' ], :database => @db,
                                     :server_selection_timeout => 5)

      p 'connection open'

      connection[:client_readings].update_one({:client_id => client_id}, '$push' =>
          {:is_connected => is_connected,
           :value => readings::value,
           :update_date =>  DateTime.now} )

      connection.close
      p 'connection close'
    rescue Mongo::Error::NoServerAvailable => e

      puts 'Cannot connect to the server'
      puts e

    end

  end

end