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
end

class Dead
  def transition(cell, neighbour_count)
    transitions = {
      3 => :live
    }

    cell.send(transitions.fetch(neighbour_count, :die))
  end
end

class Cell
  def initialize state
    @state = state
  end

  def transition neighbour_count
    @state.transition(self, neighbour_count)
  end

  def live
  end

  def die
  end
end

describe "A Game of Life cell" do
  it "dies when it has less then 2 neighbours" do
    cell = Cell.new Alive.new
    expect(cell).to receive(:die)
    cell.transition 0
  end

  it "lives when it has 2 or 3 neighbours" do
    cell = Cell.new Alive.new
    expect(cell).to receive(:live)
    cell.transition 2
  end

  it "lives when it has 3 neighbours" do
    cell = Cell.new Alive.new
    expect(cell).to receive(:live)
    cell.transition 3
  end

  it "dies when it has more than 3 neighbours" do
    cell = Cell.new Alive.new
    expect(cell).to receive(:die)
    cell.transition 4
  end

  context 'a dead cell' do
    it "remains dead when it has 0 neighbours" do
      cell = Cell.new Dead.new
      expect(cell).to receive(:die)
      cell.transition 0
    end

    it "becomes alive when it has exactly 3 neighbours" do
      cell = Cell.new Dead.new
      expect(cell).to receive(:live)
      cell.transition 3
    end
  end
end
