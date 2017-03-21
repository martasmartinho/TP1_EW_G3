load '../Server/DataAccess/data_client.rb'
load '../Server/DataAccess/data_reading.rb'


class Client

  #fields
  attr_accessor :client_id, :is_connected, :location, :readings, :temperature_counter, :acoustic_counter

  #Constructor
  def initialize(client_id = 0, is_connected = false, location = 000000)

    @client_id= client_id
    @is_connected = is_connected
    @location = location
    @temperature_counter = 0
    @acoustic_counter = 0

  end

  def connectClient

    if DataClient.existClient(@client_id)
      DataClient.updateClient(@client_id, @is_connected, @location)
    else
      DataClient.insertClient(@client_id, @is_connected, @location)
    end


  end


  #reconnect a client
  def disconnectClient

    DataClient.updateClient(@client_id, @is_connected, @location)

  end

  #get a client
  def getClient(client_id)

    if existClient()
      return DataClient.selectClient(client_id)
    end

    return nil


  end


  #get a client
  def existClient

    exist = DataClient.existClient(@client_id)

    return exist

  end


  #get a client readings
  def getReadings(sensor_type)

    @readings = Array.new

    @readings = DataReading.selectAllClientReadings(@client_id, sensor_type)



  end

  #get add new reading
  def addReading(sensor_type = nil, value = nil, location = nil, timestamp = nil)

    if @readings == nil

      @readings = Array::new

    end

    if @is_connected
      reading = Reading::new

      #serialise object
      reading.client_id = @client_id
      reading.sensor_type = sensor_type
      reading.value = value
      reading.location = location
      reading.timestamp = timestamp

      if sensor_type == 1
        @temperature_counter = @temperature_counter + 1
      else
        @acoustic_counter = @acoustic_counter + 1
      end

      @readings.push(reading)

    end

    if ((@readings.count == 10 || !@is_connected) && @readings.count > 0)
      DataReading.insertReadings(@client_id, @readings)
      readings.clear
    end

  end


  def saveReadings

    docs = '['
    @readings.each do |r|
      docs += format('{:sensor_type=> %d, :value=> %f, :location=> %d, :sensor_type=> %s},',
                     r.sensor_type,
                     r.value,
                     r.location,
                     r.timestamp.to_s)
    end
    n = docs.length - 2
    docs = docs[0..n]
    docs = ']'

    DataReading.insertReadings(@client_id, docs)

  end

end



