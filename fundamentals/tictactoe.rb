#!/usr/bin/env ruby

class TicTacToe
  WINNING_COMBINATIONS = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], # rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], # columns
    [0, 4, 8], [2, 4, 6]             # diagonals
  ].freeze

  def initialize
    @board = Array.new(9, " ")
    @current_player = "X"
  end

  def play
    loop do
      clear_terminal
      display_board
      make_move

      if winner?
        clear_terminal
        display_board
        puts "Player #{@current_player} wins!"
        break
      end

      if board_full?
        clear_terminal
        display_board
        puts "It's a draw!"
        break
      end

      switch_player
    end
  end

  private

  def clear_terminal
    system("clear") || system("cls")
  end

  def display_board
    puts "Welcome to Tic Tac Toe!"
    puts "Players take turns entering positions 1-9"
    puts
    puts " #{cell(0)} | #{cell(1)} | #{cell(2)} "
    puts "---+---+---"
    puts " #{cell(3)} | #{cell(4)} | #{cell(5)} "
    puts "---+---+---"
    puts " #{cell(6)} | #{cell(7)} | #{cell(8)} "
    puts
  end

  def cell(index)
    @board[index] == " " ? (index + 1).to_s : @board[index]
  end

  def make_move
    loop do
      print "Player #{@current_player}, enter position (1-9): "
      input = gets.chomp

      unless input.match?(/^[1-9]$/)
        puts "Invalid input. Please enter a number 1-9."
        next
      end

      position = input.to_i - 1

      if @board[position] != " "
        puts "That position is already taken. Try again."
        next
      end

      @board[position] = @current_player
      break
    end
  end

  def switch_player
    @current_player = @current_player == "X" ? "O" : "X"
  end

  def winner?
    WINNING_COMBINATIONS.any? do |combo|
      combo.all? { |i| @board[i] == @current_player }
    end
  end

  def board_full?
    @board.none? { |cell| cell == " " }
  end
end

if __FILE__ == $0
  TicTacToe.new.play
end