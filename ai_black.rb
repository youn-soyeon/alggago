require "xmlrpc/server"
require "socket"

s = XMLRPC::Server.new(ARGV[0])
MAX_NUMBER = 16000

class MyAlggago

  def calculate(positions)
    #Codes here
    my_position = positions[0]
    your_position = positions[1]

    current_stone_number = 0
    index = 0
    min_length = MAX_NUMBER
    x_length = MAX_NUMBER
    y_length = MAX_NUMBER

    my_position.each do |my|
      your_position.each do |your|

        x_distance = (my[0] - your[0]).abs
        y_distance = (my[1] - your[1]).abs

        current_distance = Math.sqrt(x_distance * x_distance + y_distance * y_distance)
        # 네구역으로 나뉘어 상대방돌을 맞추고 좀더 안쪽으로 움직이게끔치는코드
        if min_length > current_distance
          current_stone_number = index
          min_length = current_distance

          if your[0] > 350
            if your[1] > 350
              x_length = your[0]-10 - my[0]
              y_length = your[1]-10 - my[1]
            else
              x_length = your[0]-10 - my[0]
              y_length = your[1]+10 - my[1]
            end
          else
            if your[1] > 350
              x_length = your[0]+10 - my[0]
              y_length = your[1]-10 - my[1]
            else
              min_length = current_distance
              x_length = your[0]+10 - my[0]
              y_length = your[1]+10 - my[1]
            end
          end
        end
      end
      index = index + 1
    end

    #Return values
    message = positions.size #돌의 갯수
    stone_number = current_stone_number #움직일 돌
    stone_x_strength = x_length * 5
    stone_y_strength = y_length * 5
    return [stone_number, stone_x_strength, stone_y_strength, message]

    #Codes end
  end

  def get_name
    "Team Incoder"
  end
end

s.add_handler("alggago", MyAlggago.new)
s.serve
