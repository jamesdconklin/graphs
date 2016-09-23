require 'vertex'
require 'rspec'

describe Vertex do
  before(:each) do
    Vertex.reset_count
    @zero = Vertex.new
    @one = Vertex.new
    @two = Vertex.new
    @three = Vertex.new
    @four = Vertex.new
    @five = Vertex.new
    @six = Vertex.new
    @seven = Vertex.new(value: "Seven")
  end

  describe '#initialize' do
    it 'defaults value to id' do
      expect(@six.value).to eq(@six.id)
    end

    it 'sets and increments an id' do
      expect(@zero.id).to eq(0)
      expect(@seven.id).to eq(7)
    end

    it 'sets value according to options hash if given' do
      expect(@seven.value).to eq("Seven")
    end

    it 'sets neighbors to be an empty set' do
      expect(@six.neighbors).to be_a(Hash)
      expect(@six.neighbors).to be_empty
    end

    it 'sets distance and prev to nil' do
      expect(@four.prev).to be_nil
      expect(@three.distance).to be_nil
    end
  end

  describe '#directed_connect' do
    before(:each) { @two.directed_connect(@three) }

    it 'only connects in one direction.' do
      expect(@two.neighbors).to include(@three)
      expect(@three.neighbors).not_to include(@two)
    end

    it 'assigns a default weight of 1' do
      expect(@two.neighbors[@three]).to eq(1)
    end

    it 'assigns a given weight when specified' do
      @three.directed_connect(@two, 7)
      expect(@three.neighbors[@two]).to eq(7)
    end
  end

  describe '#connect' do
    before(:each) { @five.connect(@six) }

    it 'connects both nodes to the other.' do
      expect(@five.neighbors).to include(@six)
      expect(@six.neighbors).to include(@five)
    end

    it 'assigns a default weight of 1.' do
      expect(@five.neighbors[@six]).to eq(1)
      expect(@six.neighbors[@five]).to eq(1)
    end

    it 'assigns given weight when specified.' do
      @zero.connect(@five, 6)
      expect(@zero.neighbors[@five]).to eq(6)
      expect(@five.neighbors[@zero]).to eq(6)
    end
  end

  describe '#traverse' do
    before(:each)
  end

end