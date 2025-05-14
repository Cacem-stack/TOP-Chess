require_relative "lib/board.rb"

game_one = Board.new
last_player = nil

def continue_query
  puts "Continue previous game? y/n: "
  answer = gets.chomp.downcase
  until answer == "y" || answer == "n"
    puts "Try again: 'y' or 'n'"
    answer = gets.chomp.downcase
  end
  if answer == "y"
    serialized = File.read('save.rb')
    game_one = Marshal::load(serialized)
    game_one.choose_type
  end
end

continue_query
game_one.choose_type
