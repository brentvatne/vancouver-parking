class ParkingSpot
  attr_accessor :coordinates,
                :name,
                :totalCapacity,
                :usedCapacity

  def to_s
    "(#{remainingFreeSpaces}) - #{name}"
  end

  def remainingFreeSpaces
    totalCapacity - usedCapacity
  end

  def hasFreeSpace?
    remainingFreeSpaces > 0
  end

  def self.fromJSON(parsedJSONHash)
    newParkingSpot = new

    parsedJSONHash.each_pair do |key, value|
      if ['coordinates', 'name', 'totalCapacity', 'usedCapacity'].include?(key)
        newParkingSpot.send("#{key}=", value)
      end
    end

    newParkingSpot
  end

  # Map kit hooks
  def title
    name
  end

  def coordinate
    c = CLLocationCoordinate2D.new
    c.longitude = coordinates[0]
    c.latitude  = coordinates[1]
    c
  end

  def location
    CLLocation.alloc.initWithLatitude(coordinate.latitude, longitude: coordinate.longitude)
  end

  def metersFromLocation(otherLocation)
    location.distanceFromLocation(otherLocation) / 1000
  end
end
