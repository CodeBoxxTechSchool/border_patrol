require 'spec_helper'

describe BorderPatrol do
  describe ".parse_kml" do
    it "returns a BorderPatrol::Region containing a BorderPatrol::Polygon for each polygon in the KML file and its placemark name,id,description" do
      kml_data = File.read("#{File.dirname(__FILE__)}/../support/multi-polygon-test.kml")
      regions = BorderPatrol.parse_kml(kml_data)
      regions.length.should == 3
      regions.each do |placemark|
          placemark[:polygons].should be_a Array
          placemark[:name].should be_a String
          placemark[:description].should be_a String
          placemark[:id].should be_a String
      end
    end

    context "when there is only one polygon" do
      it "returns a region containing a single polygon" do
        kml_data = File.read("#{File.dirname(__FILE__)}/../support/colorado-test.kml")
        regions = BorderPatrol.parse_kml(kml_data)
        regions.length.should == 1
        regions.each do |placemark|
            placemark[:polygons].should be_a Array
            placemark[:polygons].size.should == 1
            placemark[:name].should be_a String
            placemark[:description].should be_a String
            placemark[:id].should be_a String
        end

      end
    end
    context "when there is multigeometry form and many polygons" do
      it "returns a region containing a multiple polygons" do
        kml_data = File.read("#{File.dirname(__FILE__)}/../support/multi-geometry-test.kml")
        regions = BorderPatrol.parse_kml(kml_data)
        regions.length.should == 1
        regions.each do |placemark|
            placemark[:polygons].should be_a Array
            placemark[:polygons].size.should == 2
            placemark[:name].should be_a String
            placemark[:description].should be_a String
            placemark[:id].should be_a String
        end

      end
    end
  end

  describe ".parse_kml_polygon_data" do
    it "returns a BorderPatrol::Polygon with the points from the kml data in the correct order" do
      kml = <<-EOM
        <Polygon>
          <outerBoundaryIs>
           <LinearRing>
             <tessellate>1</tessellate>
             <coordinates>
               -10,25,0.000000
               -1,30,0.000000
               10,1,0.000000
               0, -5,000000
               -10,25,0.000000
              </coordinates>
            </LinearRing>
          </outerBoundaryIs>
        </Polygon>
      EOM
      polygon = BorderPatrol.parse_kml_polygon_data(kml)
      polygon.should == BorderPatrol::Polygon.new(BorderPatrol::Point.new(-10, 25), BorderPatrol::Point.new(-1, 30), BorderPatrol::Point.new(10, 1), BorderPatrol::Point.new(0, -5))
    end
  end

  describe BorderPatrol::Point do
    describe "==" do
      it "is true if both points contain the same values" do
        BorderPatrol::Point.new(1, 2).should == BorderPatrol::Point.new(1, 2)
      end

      it "is true if one point contains floats and one contains integers" do
        BorderPatrol::Point.new(1, 2.0).should == BorderPatrol::Point.new(1.0, 2)
      end

      it "is false if the points contain different values" do
        BorderPatrol::Point.new(1, 3).should_not == BorderPatrol::Point.new(1.0, 2)
      end
    end
  end
end
