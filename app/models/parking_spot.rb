class ParkingSpot
  attr_accessor :coordinates,
                :name,
                :totalCapacity,
                :usedCapacity

  def to_s
    "(#{remainingFreeSpaces}) - #{name} at #{coordinates}"
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
end
