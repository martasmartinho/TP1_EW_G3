#require 'rubygems'
#"{require 'mongo'
#require 'bson'}"

class DataClient

  #fields
  attr_accessor :db
  @db = 'tp1_ew_mongodb'

  #create new client
  def self.insertClient(client_id, is_connected, location)

    Mongo::Logger.logger.level = ::Logger::FATAL

    begin

      #open connection
      connection = Mongo::Client.new(['127.0.0.1:27017'], :database => @db,
                                     :server_selection_timeout => 5)

      #create new document
      document = {:client_id => Integer(client_id),
                  :is_connected => is_connected,
                  :location => Integer(location),
                  :creation_date => DateTime.now,
                  :update_date => DateTime.now, :readings => []}

      #insert document
      connection[:client_readings].insert_one document

      #close connection
      connection.close

    rescue Mongo::Error::NoServerAvailable => e

      puts 'Cannot connect to the server'
      puts e

    end

  end


  #select a client
  def self.existClient(client_id)

    exist = false

    Mongo::Logger.logger.level = ::Logger::FATAL

    begin

      #open connection
      client = Mongo::Client.new(['127.0.0.1:27017'], :database => @db,
                                 :server_selection_timeout => 5)

      #count documents
      docs = client[:client_readings].find(:client_id => Integer(client_id))

      #close connection
      client.close

      if docs.count > 0

        exist = true

      end

      return exist

    rescue Mongo::Error::NoServerAvailable => e

      p 'Cannot connect to the server'
      p e

    end

  end


  #select a client
  def self.selectClient(client_id)

    c = Client.new

    Mongo::Logger.logger.level = ::Logger::FATAL

    begin

      #open connection
      client = Mongo::Client.new(['127.0.0.1:27017'], :database => @db,
                                 :server_selection_timeout => 5)

      #select document
      client[:client_readings].find(:client_id => Integer(client_id)).each do |doc|

        c.client_id = Integer(doc['client_id'])
        c.is_connected = doc['is_connected']
        c.location = doc['location']

      end

      #close connection
      client.close

      return c

    rescue Mongo::Error::NoServerAvailable => e

      p 'Cannot connect to the server'
      p e

    end


    #puts "There are #{docs.count} documents"

  end

  #select connected clients
  def self.selectConnectedClients()


    connectedClients = Array.new

    Mongo::Logger.logger.level = ::Logger::FATAL

    begin

      #open connection
      client = Mongo::Client.new(['127.0.0.1:27017'], :database => @db,
                                 :server_selection_timeout => 5)

      #select document
      client[:client_readings].find(:is_connected => true).each do |doc|
        c = Client.new

        c.client_id = Integer(doc['client_id'])
        c.is_connected = doc['is_connected']
        c.location = doc['location']

        connectedClients.push(c)

      end

      #close connection
      client.close

      return connectedClients

    rescue Mongo::Error::NoServerAvailable => e

      p 'Cannot connect to the server'
      p e

    end




  end

  #update a client
  def self.updateClient(client_id, is_connected, location)

    Mongo::Logger.logger.level = ::Logger::DEBUG

    begin

      #open connection
      connection = Mongo::Client.new(['127.0.0.1:27017'], :database => @db,
                                     :server_selection_timeout => 5)

      #update document
      connection[:client_readings].update_one({:client_id => Integer(client_id)}, '$set' =>
          {:is_connected => is_connected,
           :location => Integer(location),
           :update_date => DateTime.now})

      #close connection
      connection.close

    rescue Mongo::Error::NoServerAvailable => e

      puts 'Cannot connect to the server'
      puts e

    end

  end

end