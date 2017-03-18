#load 'Server/DataAccess/data_reading'

#require 'securerandom'

class Reading
#fields
  attr_accessor :client_id, :sensor_type, :value, :location, :timestamp

  #Constructor
  def initialize(client_id = 0, sensor_type = 'default', value = 0.0, location = 1111111, timestamp = Time.now)

    @client_id = client_id
    @sensor_type = sensor_type
    @valeu = value
    @location = location
    @timestamp = timestamp

  end

  #insert new client reading
  def insertReading()

    #@reading_id = SecureRandom.uuid

    DataReading.insertReading(@client_id, @sensor_type, @value, @location, @timestamp)

  end

  #insert new client readings
  def insertReadings(client_id, readings)

    DataReading.insertReadings(client_id, readings)

  end

  #select client readings
  def getReadings(sensor_type)

    readings = Array.new(Reading)
    i = 0

    result = DataReading.selectAllClientReadings(@client_id, sensor_type)

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