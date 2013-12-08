require 'rubygems'
require 'rspec'

class Alive
  def transition(cell, neighbour_count)
    transitions = {
      2 => :live,
      3 => :live
    }

    cell.send(transitions.fetch(neighbour_count, :die))
  end

  def live_count(counter)
    counter.inc
  end
end

class Dead
  def transition(cell, neighbour_count)
    transitions = {
      3 => :live
    }

    cell.send(transitions.fetch(neighbour_count, :die))
  end

  def live_count(counter)
  end
end

class Position < Struct.new(:x, :y)
end

class Cell
  def initialize state, position
    @state = state
    @position = position
  end

  def transition neighbour_count
    @state.transition(self, neighbour_count)
  end

  def live
  end

  def die
  end

  def live_count(counter)
    @state.live_count counter
  end

  def is_adjacent_to(another, adjacents)
    adjacents.push self if @position.is_adjacent_to another.position
  end
end

describe "A Game of Life cell" do
  it "knows if it's adjacent to another cell" do
    position = double
    allow(position).to receive(:is_adjacent_to).and_return true

    cell = Cell.new(Alive.new, position)

    adjacent = double(position: nil)
    adjacents = double

    expect(adjacents).to receive(:push).with(cell)

    cell.is_adjacent_to adjacent, adjacents
  end

  context "a live cell" do
    let(:cell) { Cell.new(Alive.new, Position.new(0, 0)) }

    it "dies when it has less then 2 neighbours" do
      expect(cell).to receive(:die)
      cell.transition 0
    end

    it "lives when it has 2 or 3 neighbours" do
      expect(cell).to receive(:live)
      cell.transition 2
    end

    it "lives when it has 3 neighbours" do
      expect(cell).to receive(:live)
      cell.transition 3
    end

    it "dies when it has more than 3 neighbours" do
      expect(cell).to receive(:die)
      cell.transition 4
    end

    it "counts itself as alive" do
      counter = double :inc
      expect(counter).to receive :inc
      cell.live_count counter
    end
  end

  context 'a dead cell' do
    let(:cell) { Cell.new(Dead.new, Position.new(0, 0)) }

    it "remains dead when it has 0 neighbours" do
      expect(cell).to receive(:die)
      cell.transition 0
    end

    it "remains dead when it has 1 neighbours" do
      expect(cell).to receive(:die)
      cell.transition 1
    end

    it "becomes alive when it has exactly 3 neighbours" do
      expect(cell).to receive(:live)
      cell.transition 3
    end

    it "remains dead with more than 3 neighbours" do
      expect(cell).to receive(:die)
      cell.transition 4
    end

    it "doesn't count itself as alive" do
      counter = double :inc
      expect(counter).to_not receive :inc
      cell.live_count counter
    end
  end
end
