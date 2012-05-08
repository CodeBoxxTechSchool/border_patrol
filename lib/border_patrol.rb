module BorderPatrol
  class InsufficientPointsToActuallyFormAPolygonError < ArgumentError;
  end
  class Point < Struct.new(:x, :y);
  end

  def self.parse_kml(string)
    doc = Nokogiri::XML(string)
    region = BorderPatrol::Region.new
    doc.xpath('//kml:Placemark', 'kml' => 'http://earth.google.com/kml/2.2').map do |placemark_kml|
      polygons = placemark_kml.xpath('./kml:Polygon | ./kml:MultiGeometry/kml:Polygon', 'kml' => 'http://earth.google.com/kml/2.2').map do |polygon_kml|
        parse_kml_polygon_data(polygon_kml.to_s)
      end
      name = placemark_kml.xpath("./kml:name", 'kml' => 'http://earth.google.com/kml/2.2').text.strip
      description = placemark_kml.xpath("./kml:description", 'kml' => 'http://earth.google.com/kml/2.2').text.strip
      id = placemark_kml.xpath("./kml:id", 'kml' => 'http://earth.google.com/kml/2.2').text.strip
      region.add(:name => name, :description => description, :id => id, :polygons => polygons)
    end
    region
  end

  private
  def self.parse_kml_polygon_data(string)
    doc = Nokogiri::XML(string)
    coordinates = doc.xpath("//coordinates").text.strip.split("\n")
    points = coordinates.map do |coord|
      x, y, z = coord.strip.split(',')
      BorderPatrol::Point.new(x.to_f, y.to_f)
    end
    BorderPatrol::Polygon.new(points)
  end
end

require 'set'
require 'nokogiri'
require 'border_patrol/version'
require 'border_patrol/polygon'
require 'border_patrol/region'
