class ParkingSpot
  attr_accessor :coordinates,
                :name,
                :totalCapacity,
                :usedCapacity

  def self.fromJSON(parsedJSONHash)
    newParkingSpot = new

    parsedJSONHash.each_pair do |key, value|
      if ['coordinates', 'name', 'totalCapacity', 'usedCapacity'].include?(key)
        newParkingSpot.send("#{key}=", value)
      end
    end

    newParkingSpot
  end

  # Predicate methods
  def remainingFreeSpaces
    totalCapacity - usedCapacity
  end

  def hasFreeSpace?
    remainingFreeSpaces > 0
  end

  # Returns a CCLocation object built from the coordinate.
  def location
    @location ||=
      CLLocation.alloc.initWithLatitude(coordinate.latitude,
                                        longitude: coordinate.longitude)
  end

  # Uses the `location` to determine the distance from another location.
  def metersFromLocation(otherLocation)
    location.distanceFromLocation(otherLocation) / 1000
  end


  # Map kit hooks
  # Used by MapKit as the title text when you click on the pin
  def title; name; end

  # Used by MapKit to place it on the map
  def coordinate
    CLLocationCoordinate2D.new.tap do |coord|
      coord.longitude = coordinates[0]
      coord.latitude  = coordinates[1]
    end
  end
end
