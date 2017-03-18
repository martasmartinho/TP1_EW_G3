require 'json'

class Xdk

  def initialize(id, start_temperature, start_acoustic, location)

    @id = id
    @last_temperature = start_temperature
    @last_acoustic = start_acoustic
    @location = location

  end

  #upadate random temperatire
  def updateTemperature

    low = @last_temperature - 1.0
    hight = @last_temperature + 1.0
    value = Random.new.rand(low..hight).round(2)

    @last_temperature = value

    #build jason
    doc = toJson(1, value)
    return doc

  end


  #update random acoustic
  def updateAcoustic

    low = @last_acoustic - 1.0
    hight = @last_acoustic + 1.0

    value = Random.new.rand(low..hight).round(2)

    @last_acoustic = value

    #build json
    doc = toJson(2, value)
    return doc

  end

  #Build json
  def toJson(sensor_type, value)

    my_hash = {:id => @id, :sensor_type => sensor_type, :value => value, :location => @location, :timestamp => Time.now}
    return my_hash

  end

  #sendinding data time to time with stop
  def chronometerWithTemporizer(seconds, to)

    last_tick = Time.now
    stop = Time.now + to
    yield
    while Time.now < stop
      sleep 0.1
      if Time.now - last_tick >= seconds
        last_tick += seconds
        yield
      end
    end
  end

  #sending data every x seconds
  def chronometer(seconds)
    last_tick = Time.now
    yield
    loop do
      sleep 0.1
      if Time.now - last_tick >= seconds
        last_tick += seconds
        yield
      end
    end
  end


end
