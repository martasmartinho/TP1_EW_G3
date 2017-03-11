require 'drb/drb'



class Client < XDK

  attr_accessor :remote_object
  @remote_object = DRbObject.new_with_uri('druby://localhost:9090')

  def initialize()

    DRb.start_service
    @remote_object = DRbObject.new_with_uri('druby://localhost:9090')

  end

  def test

    @remote_object.receiveReading('Hello, world!') #=> 'Hello, world!'

  end

  def sendReading(client_id, sensor_type, value, location)
    #@remote_object.sendReadings   #=> 'Hello, world!'
  end

end
