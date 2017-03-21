load '../Server/TCPServerConnection/server.rb'

class MainClass

  def initialize(server)
    @server = server
  end

  def menu
    sleep(10)
    option = 0

    loop do
      #sleep(2)
      @server.clearRubyConsole
      puts ' ============== MENU =============== '
      puts '||                                 ||'
      puts '|| 0 - Stop                        ||'
      puts '|| 1 - Connected clients           ||'
      puts '|| 2 - Readings                    ||'
      puts '||_________________________________||'

      puts 'Choose an option: '
      option = Integer(readline.chomp)

      case option
        when 0
          puts 'buy...'
        when 1
          @server.information
        when 2
          @server.printReadings
        when 3

        when 4

        when 5

        else
          print('Error')
      end

      break if (option == 0)
    end
  end


end

s = Server.new(2020)

m = MainClass.new(s)

Thread.start { m.menu }
s.run

s.close
