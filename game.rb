#!/usr/bin/ruby
require 'curses'
include Curses

class Puzzle
  attr_accessor :window
  attr_accessor :moves

  @puzzle
  @empty_field

  def initialize
    self.window = Window.new(100,100,2,5)
    self.moves  = 0

    @puzzle      = (1..15).to_a
    @empty_field = [3,3]

    shuffle!
  end

  def draw
    self.window.clear
    @y = 0
    @puzzle.each { |xval|
      @y +=5
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
        if @empty_field[1] != 3
          tmp = @puzzle[@empty_field[0]][@empty_field[1]+1]
          @puzzle[@empty_field[0]][@empty_field[1]] = tmp
          @puzzle[@empty_field[0]][@empty_field[1]+1] = nil
          @empty_field[1] = @empty_field[1]+1
          self.moves+=1
        end
      when 's'
        if @empty_field[1] != 0
          tmp = @puzzle[@empty_field[0]][@empty_field[1]-1]
          @puzzle[@empty_field[0]][@empty_field[1]] = tmp
          @puzzle[@empty_field[0]][@empty_field[1]-1] = nil
          @empty_field[1] = @empty_field[1]-1
          self.moves+=1
        end
      when 'a'
        if @empty_field[0] != 3
          tmp = @puzzle[@empty_field[0]+1][@empty_field[1]]
          @puzzle[@empty_field[0]][@empty_field[1]] = tmp
          @puzzle[@empty_field[0]+1][@empty_field[1]] = nil
          @empty_field[0] = @empty_field[0]+1
          self.moves+=1
        end
      when 'd'
        if @empty_field[0] != 0
          tmp = @puzzle[@empty_field[0]-1][@empty_field[1]]
          @puzzle[@empty_field[0]][@empty_field[1]] = tmp
          @puzzle[@empty_field[0]-1][@empty_field[1]] = nil
          @empty_field[0] = @empty_field[0]-1
          self.moves+=1
        end
    end
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