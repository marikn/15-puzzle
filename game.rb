#!/usr/bin/ruby
require 'curses'
include Curses

class Puzzle
  attr_accessor :window
  attr_accessor :moves

  @puzzle
  @ef

  def initialize
    self.window = Window.new(100,100,2,5)
    self.moves  = 0

    @puzzle = (1..15).to_a
    @ef 	  = [3,3]

    shuffle!
  end

  def draw
    self.window.clear
    @y = 0
    @puzzle.each { |xval|
      @y+=5
      xval.each_with_index { |yval, yindex|
        self.window.setpos(yindex + 2, @y)
        self.window.addstr(yval.to_s)
      }
    }

    self.window.setpos(10, 5)
    self.window.addstr('Moves: ' + @moves.to_s)
  end

  def shuffle!
    @puzzle.shuffle!
    @puzzle = @puzzle.each_slice(4).to_a
    @puzzle[3].push(nil)
  end

  def move!(direction)
    case direction
      when 'w'
        if @ef[1] != 3
	        swap!(@ef[0], @ef[1]+1, @ef[1], 'v')
        end
      when 's'
        if @ef[1] != 0
	        swap!(@ef[0], @ef[1]-1, @ef[1], 'v')
        end
      when 'a'
        if @ef[0] != 3
	        swap!(@ef[0]+1, @ef[1], @ef[0], 'h')
        end
      when 'd'
        if @ef[0] != 0
	        swap!(@ef[0]-1, @ef[1], @ef[0], 'h')
        end
    end
  end

  def swap!(x, y, z, direction)
    case direction
      when 'v'
        @puzzle[x][y], @puzzle[x][z] = @puzzle[x][z], @puzzle[x][y]
      when 'h'
        @puzzle[x][y], @puzzle[z][y] = @puzzle[z][y], @puzzle[x][y]
    end 

    @ef = [x, y]
    self.moves+=1
  end
end

init_screen
noecho

puzzle = Puzzle.new
puzzle.draw

while ch = puzzle.window.getch
  puzzle.move!(ch)
  puzzle.draw
end