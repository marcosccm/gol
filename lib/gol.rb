class Counter
  attr_reader :value
  def initialize(value)
    @value = 0
  end
  def next
    @value += 1
  end
end

class Alive
  def self.transition(cell, neighbour_count)
    transitions = {
      2 => :live,
      3 => :live
    }

    cell.send(transitions.fetch(neighbour_count, :die))
  end

  def self.live_count(counter)
    counter.next
  end

  def self.print
    "*"
  end
end

class Dead
  def self.transition(cell, neighbour_count)
    transitions = {
      3 => :live
    }

    cell.send(transitions.fetch(neighbour_count, :die))
  end

  def self.live_count(counter)
  end

  def self.print
    "_"
  end
end

class World
  attr_reader :cells, :adjacencies
  def initialize(cells)
    @cells = cells
    @adjacencies = Hash.new { |adj, cell| adj[cell] = [] } 
    calculate_adjacencies
  end

  def calculate_adjacencies
    @cells.each do |cell|
      @cells.each { |another|  cell.is_adjacent_to(another, self) }
    end
  end

  def next_turn
    counts = @adjacencies.map do |cell, adjacents| 
      counter = Counter.new(0)
      adjacents.each { |adj| adj.live_count(counter) }
      [cell, counter]
    end

    Hash[counts].each do |cell, count|
      cell.transition(count.value)
    end

    @cells
  end

  def add_adjacency(cell, adjacent)
    @adjacencies[cell] << adjacent
  end
end

class Position < Struct.new(:x, :y)
  def adjacent_to? b
    dx = self.x - b.x
    dy = self.y - b.y

    return false if [dx, dy] == [0,0]
    dx.between?(-1,1) && dy.between?(-1,1)
  end

  def to_s
    "(#{x}, #{y})"
  end
end

class Printer
  def print(cells)
    groups = cells.group_by { |cell| cell.position.y }
    groups.map do |y, group|
      puts group.map { |c| c.print }.join
    end
  end
end

class Cell
  attr_reader :position

  def initialize state, position
    @state = state
    @position = position
  end

  def transition neighbour_count
    @state.transition(self, neighbour_count)
  end

  def live
    @state = Alive
  end

  def die
    @state = Dead
  end

  def live_count(counter)
    @state.live_count counter
  end

  def is_adjacent_to(another, adjacents)
    adjacents.add_adjacency(self, another) if @position.adjacent_to? another.position
  end

  def print
    @state.print
  end
end
