class ParkingSpot
  attr_accessor :coordinates,
                :name,
                :total_capacity,
                :used_capacity

  def to_s
    "#{used_capacity} / #{total_capacity} - #{name} at #{coordinates}"
  end

  def self.from_json(parsed_json_object)
    new_spot = new

    parsed_json_object.each_pair do |key, value|
      if ['coordinates', 'name', 'totalCapacity', 'usedCapacity'].include?(key)
        new_spot.send("#{key}=", value)
      end
    end

    new_spot
  end

  def totalCapacity=(val)
    self.total_capacity = val
  end

  def usedCapacity=(val)
    self.used_capacity = val
  end
end
