require_relative 'lib/gol'

def a(x,y)
  Cell.new(Alive, Position.new(x,y))
end

def d(x,y)
  Cell.new(Dead, Position.new(x,y))
end

oscillator = [
  d(0,0), d(0,1), d(0,2), d(0,3), d(0,4),
  d(1,0), d(1,1), a(1,2), d(1,3), d(1,4),
  d(2,0), d(2,1), a(2,2), d(2,3), d(2,4),
  d(3,0), d(3,1), a(3,2), d(3,3), d(3,4),
  d(4,0), d(4,1), d(4,2), d(4,3), d(4,4)
]

small = [
  d(0,0), a(0,1),
  a(1,0), a(1,1) 
]

crazy = [
  d(1 , 1) , d(2  , 1) , d(3  , 1) , a(4 , 1) , d(5 , 1) , d(6 , 1) , d(7  , 1) , d(8  , 1) , d(9  , 1), d(10, 1),
  d(1 , 2) , d(2  , 2) , d(3  , 2) , d(4 , 2) , d(5 , 2) , d(6 , 2) , d(7  , 2) , a(8  , 2) , d(9  , 2), d(10, 2),
  d(1 , 3) , a(2  , 3) , a(3  , 3) , d(4 , 3) , a(5 , 3) , d(6 , 3) , d(7  , 3) , d(8  , 3) , d(9  , 3), d(10, 3),
  d(1 , 4) , d(2  , 4) , a(3  , 4) , d(4 , 4) , d(5 , 4) , d(6 , 4) , a(7  , 4) , a(8  , 4) , a(9  , 4), d(10, 4),
  d(1 , 5) , d(2  , 5) , d(3  , 5) , d(4 , 5) , d(5 , 5) , d(6 , 5) , d(7  , 5) , d(8  , 5) , d(9  , 5), d(10, 5),
]

require "pp"
w = World.new(crazy)
p = Printer.new

loop do
  p.print(w.next_turn)
  sleep 1
  puts "\n"
end
