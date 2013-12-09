require "rspec"

require_relative "../lib/gol"

describe "The World" do
  let(:cells) do
    [
      alive(0,0), alive(0,1),
      dead(0,0), dead(1,1)
    ]
  end

  subject(:world) { World.new(cells) }

  it "can move to the next state of an initial cell group" do
    expect(world.cells.map(&:print)).to eq ["*", "*", " ", " "]
    world.next_turn
    expect(world.cells.map(&:print)).to eq [" ", " ", " ", " "]
  end
end

describe "A Position" do
  [
    { a: Position.new(0, 0), b: Position.new(0,1) },
    { a: Position.new(0, 0), b: Position.new(1,0) },
    { a: Position.new(0, 0), b: Position.new(-1,1) },
    { a: Position.new(0, 0), b: Position.new(-1,0) },
    { a: Position.new(0, 0), b: Position.new(1,1) },
    { a: Position.new(0, 0), b: Position.new(-1,-1) }
  ].each do |args|
    it "#{args[:a]} is adjacent to #{args[:b]}" do
      expect(args[:a]).to be_adjacent_to args[:b]
    end
  end

  [
    { a: Position.new(0, 0), b: Position.new(2,2) },
    { a: Position.new(0, 0), b: Position.new(2,0) }
  ].each do |args|
    it "#{args[:a]} is not adjacent to #{args[:b]}" do
      expect(args[:a]).to_not be_adjacent_to args[:b]
    end
  end

  it "it's not adjacent to itself" do
    a = Position.new(2, 2)
    expect(a).to_not be_adjacent_to a
  end
end

describe "A Game of Life cell" do
  let(:position) { double }

  it "knows if it's adjacent to another cell" do
    position = double(adjacent_to?: true)

    cell = Cell.new(Alive, position)

    adjacent = double(position: nil)
    adjacents = double

    expect(adjacents).to receive(:add_adjacency).with(cell, adjacent)

    cell.is_adjacent_to adjacent, adjacents
  end

  context "a live cell" do
    let(:cell) { Cell.new(Alive, position) }

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
      counter = double :next
      expect(counter).to receive :next
      cell.live_count counter
    end
  end

  context 'a dead cell' do
    let(:cell) { Cell.new(Dead, position) }

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

def alive(x,y)
  Cell.new(Alive, Position.new(x,y))
end

def dead(x,y)
  Cell.new(Dead, Position.new(x,y))
end
