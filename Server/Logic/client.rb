class Client

  #fields
  attr_accessor :clientId, :isConnected

  #Constructor
  def initialize(clientId = 0, isConnected = false)

    @clientId= clientId
    @isConnected = isConnected

  end

end



