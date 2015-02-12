require 'pp'
require 'json'

game = JSON.parse(File.read('./input.json'))

tiles_raw = game["tiles"]
dictionary_raw = game["dictionary"]
board_raw = game["board"]

# Clean the board data
board = board_raw.map{|row| row.split(' ').map(&:to_i) }

# Clean the tile data
tiles = {}
tiles_raw.each do |tile|
  letter = tile[0]
  value = tile[1..(-1)]
  tiles[letter] = value
end



# Clean the dictionary and associate with tile values
dictionary_value = {}

letters = tiles.keys.join('')

# dictionary = []
#
# dictionary_raw.each do |word|
#   ok = true
#   word.chars.each do |letter|
#     unless letters.include?(letter)
#       ok = false
#     end
#   end
#   dictionary << word if ok
# end
#
# dictionary_raw = dictionary

dictionary_raw.each do |word|
  dictionary_value[word] = word.chars.map do |char|
    tiles[char].to_i
  end
end

col_length = board[0].length
row_length = board.length

pp board
puts board_raw

results = {}


winner ={
  max_score: 0,
  max_word: nil,
  max_col: nil,
  max_row: nil
}

dictionary_value.each do |word, values|

  (0...row_length).each do |row|
    (0...col_length).each do |col|
      row_position_value = 0
      col_position_value = 0

      if word.length <= col_length-col
        values.each_with_index do |value, idx|
          row_position_value = row_position_value +  board[row][col+idx] * value
        end
      end

      if word.length <= row_length-row
        values.each_with_index do |value, idx|
          col_position_value = col_position_value +  board[row+idx][col] * value
        end
      end

      if winner[:max_score] <= col_position_value
        winner[:max_score] = col_position_value
        winner[:max_word] = word
        winner[:max_col] = col
        winner[:max_row] = row
        winner[:values] = values
        puts winner
      end

      if winner[:max_score] <= row_position_value
        winner[:max_score] = row_position_value
        winner[:max_word] = word
        winner[:max_col] = col
        winner[:max_row] = row
        winner[:values] = values
        puts winner
      end


      # puts 'word:  ' + word.to_s + ' row: ' + row.to_s + '  col: ' + col.to_s + ' row value: ' + row_position_value.to_s + '  values: ' + values.join('-')+ ' col value: ' + col_position_value.to_s + '  values: ' + values.join('-')

    end
  end
end


puts winner






#

# [8, 12, 4, 3, 3, 4, 6].zip([2, 3, 1, 1, 1, 1, 1]).map{|i, j| i*j}.inject(:+)
