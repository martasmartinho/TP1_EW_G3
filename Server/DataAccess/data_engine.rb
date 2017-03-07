
class DataEngine

  #Fields
  attr_accessor :dataClient, :dataReading, :connectionString

  #Constructor
  def initialize(connectionString = "")

      @connectionString = connectionString

  end

  #Get class properties
  def getDataClient()

    if (@dataClient == nill)
      @dataClient = new.DataClient(this)
    end

    return @dataClient
  end

  def getDataReading

    if (@dataClient == nill)
      @dataClient = new.DataClient(this)

    end

    return dataClient
  end

end