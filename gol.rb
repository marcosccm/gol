require 'rubygems'
require 'rspec'

class Cell
  def transition neighbour_count
    die
  end

  def die
  end
end

describe "A Game of Life cell" do
  it "dies when it has less then 2 neighbours" do
    cell = Cell.new
    expect(cell).to receive :die
    cell.transition 0
  end
end
