load 'Server/DataAccess/data_client'
load 'Server/Logic/reading'

class Client

  #fields
  attr_accessor :client_id, :is_connected, :readings

  #Constructor
  def initialize(client_id = 0, is_connected = false)

    @client_id= client_id
    @is_connected = is_connected

  end


  #connect new client
  def connectNewClient()

    if DataClient.existClient(@client_id)

      DataClient.insertClient(@client_id, @is_connected)
      return true

    end

    return false

  end


  #reconnect a client
  def reconectClient()

    DataClient.updateClient(@clientId, true)
    @is_connected = true;

  end


  #disconect a client
  def disconnectClient()

    DataClient.updateClient(@clientId, false)
    @is_connected = false;

  end


  #get a client
  def getClient(client_id)

    res = DataClient.selectClient(@client_id)

    @client_id = client_id
    @is_connected = res[:is_connected]

    return client

  end


  #get a client
  def existClient()

    exist = DataClient.existClient(@client_id)

    return exist

  end


  #get a client readings
  def getReadings()

    @readings = Array.new
    reading = Reading.new

    readings = reading.DataReading.selectAllClientReadings(client_id)

    return @readings

  end

  #get add new reading
  def addReading(sensor_type, value, location)

    if @readings == null

      @readings = Array.new

    end

    reading = Reading.new

    #serialise object
    reading.client_id = @client_id
    reading.sensor_type = sensor_type
    reading.value = value
    reading.location = location
    readings.timestamp = DateTime.now


    reading.insertReading()

    @readings[readings.count()] = reading

  end

end



