# frozen_string_literal: true

class String
  def red
    "\e[31m#{self}\e[0m"
  end
end

class Board
  attr_accessor :board
  def initialize
    @board = Array.new(8) { Array.new 8 }
    @board.each do |row|
      8.times do |num|
        row[num] = num
      end
    end
  end

  def show(moves)
    8.times do |row|
      str = ''
      8.times do |col|
        if !moves.include?([row,col])
          str += @board[row][col].to_s + ' '
        else
          str += @board[row][row].to_s.red + ' '
        end
      end
      puts str
    end
  end
end

class Knight
  attr_accessor :row_col , :moves, :parent
  def initialize(row_col)
    @row_col = row_col
    @moves = possible_moves(@row_col)
    @parent = nil
  end

  def self.bredth_first_search(target,root)
    root = Knight.new(root)
    que = [root]
    used = []
    road = []
    until que.empty?
      current_knight = que.shift
      used.push(current_knight.row_col)
      if current_knight.row_col == target
        until current_knight.parent.nil?
          road.push(current_knight.row_col)
          current_knight = current_knight.parent
        end
        road.push(current_knight.row_col)
        return road
      else
        current_knight.moves.each do |move|
          if !(used.include? move)
            new_knight = Knight.new(move)
            new_knight.parent = current_knight
            que.push(new_knight)
          end
        end
      end
    end
    nil
  end

  def possible_moves(row_col)
    moves = []
    all_moves = [[2, 1], [1, 2], [-2, 1], [-1, 2], 
    [2, -1], [1, -2], [-2, -1], [-1, -2]]
    all_moves.each do |combination|
      pos_row = combination[0] + row_col[0]
      pos_col = combination[1] + row_col[1]
      if pos_row < 8 && pos_row >= 0 && pos_col < 8 && pos_col >= 0
        moves.push([pos_row, pos_col])
      end
    end
    moves
  end
end

board = Board.new
moves = Knight.bredth_first_search([2,3],[3,3])
p moves
p board.show(moves)