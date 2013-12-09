require_relative 'lib/gol'

def alive(x,y)
  Cell.new(Alive, Position.new(x,y))
end

def dead(x,y)
  Cell.new(Dead, Position.new(x,y))
end

cells = [
  dead(0,0), dead(0,1), dead(0,2), dead(0,3), dead(0,4),
  dead(1,0), dead(1,1), alive(1,2), dead(1,3), dead(1,4),
  dead(2,0), dead(2,1), alive(2,2), dead(2,3), dead(2,4),
  dead(3,0), dead(3,1), alive(3,2), dead(3,3), dead(3,4),
  dead(4,0), dead(4,1), dead(4,2), dead(4,3), dead(4,4)
]

small = [
  dead(0,0), alive(0,1),
  alive(1,0), alive(1,1) 
]

require "pp"
w = World.new(cells)
p = Printer.new

loop do
  p.print(w.next_turn)
  sleep 1
end
