require 'socket'

class ReadingsClient

    def initialize

    end



end

c = ReadingsClient.new()



def every_so_many_seconds(seconds)
  last_tick = Time.now
  loop do
    sleep 0.1
    if Time.now - last_tick >= seconds
      last_tick += seconds
      yield
    end
  end
end

every_so_many_seconds(1) do
  p Time.now
end