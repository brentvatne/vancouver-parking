class ParkingSpots
  include Enumerable

  def initialize(parkingSpots)
    @_parkingSpots = parkingSpots
    self
  end

  def each
    @_parkingSpots.each do |parkingSpot|
      yield(parkingSpot)
    end
  end

  def count
    @_parkingSpots.count
  end

  def [](key)
    @_parkingSpots[key]
  end

  # Converts a properly formatted JSON string to an Array of Parking Spot objects
  def self.fromJSON(data)
    ParkingSpots.new(data.map { |parkingSpotData|
      ParkingSpot.fromJSON(parkingSpotData)
    })
  end

  # Should be chainable with sortByDistanceFrom
  def hasFreeSpace
    ParkingSpots.new(@_parkingSpots.select(&:hasFreeSpace?))
  end

  # location - a CLLocation instance
  def sortByDistanceFrom(otherLocation)
    ParkingSpots.new(@_parkingSpots.sort { |a, b|
      a.metersFromLocation(otherLocation) <=> b.metersFromLocation(otherLocation)
    })
  end
end
