#!/usr/bin/ruby
require 'curses'
include Curses

class Puzzle
  attr_accessor :window, :moves, :is_won

  def initialize
    self.window = Window.new(100,100,2,5)
    self.moves  = 0                 # Moves counter
    self.is_won = false             # Property to prevent any actions after win

    @puzzle = (1..15).to_a         # Numbers to sort
    @ef     = { :x => 3, :y => 3 } # Empty field

    shuffle!
  end

  # Reshape game filed after move
  def draw
    self.window.clear
    y = 0
    @puzzle.each { |xval|
      y+=1; x = 0
      xval.each_with_index { |yval|
        x+=5
        self.window.setpos(y, x)
        self.window.addstr(yval.to_s)
      }
    }

    self.window.setpos(8, 5)
    self.window.addstr('Moves: ' + @moves.to_s)

    render_menu
  end

  # Move numbers in specified direction
  def move!(direction)
    case direction
      when 'w'
        if @ef[:x] != 3
          swap!(@ef[:x]+1, @ef[:y], @ef[:x], 'h')
        end
      when 's'
        if @ef[:x] != 0
          swap!(@ef[:x]-1, @ef[:y], @ef[:x], 'h')
        end
      when 'a'
        if @ef[:y] != 3
          swap!(@ef[:x], @ef[:y]+1, @ef[:y], 'v')
        end
      when 'd'
        if @ef[:y] != 0
          swap!(@ef[:x], @ef[:y]-1, @ef[:y], 'v')
        end
      when 'q'
        exit;
      when 'r'
        self.reset!
      else;
    end
  end

  # Check if numbers combination is winning
  def won?
    @won_combination = (1..15).to_a.each_slice(4).to_a
    @won_combination[3].push(nil)

    if @puzzle == @won_combination
      self.is_won = true            # Set won property true to prevent actions after winning

      true
    else
      false
    end
  end

  # Return winning message
  def won
    self.window.clear
    self.window.setpos(3, 12)
    self.window.addstr('You won!')
    self.window.setpos(4, 7)
    self.window.addstr('You made ' + self.moves.to_s + ' moves.')

    render_menu
  end

  # Reset all data and prepare to start new game
  def reset!
    self.moves  = 0
    self.is_won = false

    @puzzle  = (1..15).to_a
    @ef      = { :x => 3, :y => 3 }

    shuffle!
  end

  private

  # Swap empty filed with number in specified direction
  def swap!(x, y, z, direction)
    case direction
      when 'v'
        @puzzle[x][y], @puzzle[x][z] = @puzzle[x][z], @puzzle[x][y]
      when 'h'
        @puzzle[x][y], @puzzle[z][y] = @puzzle[z][y], @puzzle[x][y]
      else
    end

    @ef = { :x => x, :y => y }
    self.moves+=1                   # Count moves
  end

  # Shuffle numbers before game
  def shuffle!
    @puzzle.shuffle!
    @puzzle = @puzzle.each_slice(4).to_a
    @puzzle[3].push(nil)            # Add empty field to game numbers array
  end

  # Add main menu
  def render_menu
    self.window.setpos(10, 5)
    self.window.addstr('To restart game press "r"')
    self.window.setpos(11, 5)
    self.window.addstr('To quit game press "q"')
    self.window.setpos(0, 0)
  end

end

init_screen
noecho

puzzle = Puzzle.new
puzzle.draw

while true
  ch = puzzle.window.getch
  if puzzle.is_won
    case ch
      when 'q'
        exit
      when 'r'
        puzzle.reset!
        puzzle.draw
      else
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
