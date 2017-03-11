load 'Server/DataAccess/data_reading'

#require 'securerandom'

class Reading
#fields
  attr_accessor :client_id, sensor_type, value, location, timestamp

  #Constructor
  def initialize(client_id = 0, sensor_type = "default", value = 0.0, location = 1111111, timestamp = DateTime.now)

    @clientId= clientId
    @isConnected = isConnected
    @sensorType = sensorType
    @valeu = value
    @location = location
    @timestamp = timestamp

  end

  #insert new client reading
  def insertReading()

    #@reading_id = SecureRandom.uuid

    DataReading.insertReading(@client_id, @sensor_type, @value, @location, @timestamp)

  end

  #select client readings
  def getReadings(client_id)

    readings = Array.new(Reading)
    i = 0

    result = DataReading.selectAllClientReadings(client_id)

    result.each do |doc|

      reading = Reading.new

      #serialise object
      reading.client_id = client_id
      reading.sensor_type = doc[:sensor_type]
      reading.value = doc[:value]
      reading.location = doc[:location]
      reading.timestamp = doc[:timestamp]

      readings[i] = reading

    end

    return readings

  end


end