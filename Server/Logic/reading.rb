load 'Server/DataAccess/data_engine'

class Reading
#fields
  attr_accessor :readingId, clientId, sensorType, value, location, timestamp

  #Constructor
  def initialize(clientId = 0 , isConnected = false, sensorType = "default", value = 0.0, location = 1111111, timestamp = DateTime.now)

    @clientId= clientId
    @isConnected = isConnected
    @sensorType = sensorType
    @valeu = value
    @location = location
    @timestamp = timestamp

  end

end