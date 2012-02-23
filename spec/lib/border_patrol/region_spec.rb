require 'spec_helper'

describe BorderPatrol::Region do
  it "is a Set" do
    BorderPatrol::Region.new.should be_a Set
  end

  it "stores the polygons provided at initialization" do
    region = BorderPatrol::Region.new([create_polygon, create_polygon(1), create_polygon(2)])
    region.length.should == 3
  end

  describe "#contains_point?" do
    subject { BorderPatrol::Region.new.add(:name => "Colorado", :description => "Colorado description", :id => "COL", :polygons => @polygons) }

    it "raises an argument error if contains_point? takes more than 3 arguments" do
      expect { subject.contains_point? }.to raise_exception ArgumentError
      expect { subject.contains_point?(1,2,3) }.to raise_exception ArgumentError
    end

    it "returns true if any polygon contains the point" do
      point = BorderPatrol::Point.new(1,2)
      @polygons = [create_polygon, create_polygon(30)]

      a = subject.contains_point?(point)

      subject.contains_point?(point).should be_true
    end

    it "returns false if no polygons contain the point" do
      point = BorderPatrol::Point.new(-1,-2)
      @polygons = [create_polygon, create_polygon(30)]

      a = subject.contains_point?(point)

      subject.contains_point?(point).should be_false
    end

    it "transforms (x,y) coordinates passed in into a point" do
      @polygons = [create_polygon, create_polygon(30)]

      subject.contains_point?(1,2).should be_true
    end

  end

  describe "#placemark" do
    subject { BorderPatrol::Region.new.add(:polygons => @polygons) }

    it "return the placemark from the polygon that contains the point" do
      @polygons = [create_polygon, create_polygon(30)]
      subject.contains_point?(1,2).should be_true
    end

  end

  def create_polygon(start=0)
    BorderPatrol::Polygon.new(
      BorderPatrol::Point.new(start,start),
      BorderPatrol::Point.new(start + 10, start),
      BorderPatrol::Point.new(start + 10, start + 10),
      BorderPatrol::Point.new(start, start + 10))
  end

end
