#!/usr/bin/ruby
require 'curses'
include Curses

class Puzzle
  attr_accessor :window, :moves, :is_won

  def initialize
    self.window = Window.new(100, 100, 2, 5)
    self.moves  = 0 # Moves counter
    self.is_won = false # Property to prevent any actions after win

    @puzzle = (1..15).to_a # Numbers to sort
    @ef     = { x: 3, y: 3 } # Empty field

    shuffle!
  end

  # Reshape game filed after move
  def draw
    window.clear
    y = 0
    @puzzle.each do |xval|
      y += 1
      x = 0
      xval.each_with_index do |yval|
        x += 5
        window.setpos(y, x)
        window.addstr(yval.to_s)
      end
    end

    window.setpos(8, 5)
    window.addstr('Moves: ' + @moves.to_s)

    render_menu
  end

  # Move numbers in specified direction
  def move!(direction)
    case direction
    when 'w'
      @ef[:x] != 3 && swap!(@ef[:x] + 1, @ef[:y], @ef[:x], 'h')
    when 's'
      @ef[:x] != 0 && swap!(@ef[:x] - 1, @ef[:y], @ef[:x], 'h')
    when 'a'
      @ef[:y] != 3 && swap!(@ef[:x], @ef[:y] + 1, @ef[:y], 'v')
    when 'd'
      @ef[:y] != 0 && swap!(@ef[:x], @ef[:y] - 1, @ef[:y], 'v')
    when 'q'
      exit
    when 'r'
      reset!
    end
  end

  # Check if numbers combination is winning
  def won?
    @won_combination = (1..15).to_a.each_slice(4).to_a
    @won_combination[3].push(nil)

    if @puzzle == @won_combination
      # Set won property true to prevent actions after winning
      self.is_won = true

      true
    else
      false
    end
  end

  # Return winning message
  def won
    window.clear
    window.setpos(3, 12)
    window.addstr('You won!')
    window.setpos(4, 7)
    window.addstr('You made ' + moves.to_s + ' moves.')

    render_menu
  end

  # Reset all data and prepare to start new game
  def reset!
    self.moves  = 0
    self.is_won = false

    @puzzle  = (1..15).to_a
    @ef      = { x: 3, y: 3 }

    shuffle!
  end

  private

  # Swap empty filed with number in specified direction
  def swap!(x, y, z, direction)
    if direction == 'v'
      @puzzle[x][y], @puzzle[x][z] = @puzzle[x][z], @puzzle[x][y]
    elsif direction == 'h'
      @puzzle[x][y], @puzzle[z][y] = @puzzle[z][y], @puzzle[x][y]
    end

    @ef = { x: x, y: y }
    self.moves += 1 # Count moves
  end

  # Shuffle numbers before game
  def shuffle!
    @puzzle.shuffle!
    @puzzle = @puzzle.each_slice(4).to_a
    @puzzle[3].push(nil) # Add empty field to game numbers array
  end

  # Add main menu
  def render_menu
    window.setpos(10, 5)
    window.addstr('To restart game press "r"')
    window.setpos(11, 5)
    window.addstr('To quit game press "q"')
    window.setpos(0, 0)
  end
end

init_screen
noecho

puzzle = Puzzle.new
puzzle.draw

while (ch = puzzle.window.getch)
  if puzzle.is_won
    if ch == 'r'
      puzzle.reset!
      puzzle.draw
    elsif ch == 'q'
      exit
    end
  else
    puzzle.move!(ch)
    if puzzle.won?
      puzzle.won
    else
      puzzle.draw
    end
  end
end
