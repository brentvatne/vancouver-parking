module Api
  class Car2Go

    # Endpoint to the Car2Go Api. You'll need your own OAuth Consumer Key, which
    # you can get from: http://code.google.com/p/car2go/wiki/parkingspots_v2_1
    def self.endpoint
      @endpoint ||= "http://www.car2go.com/api/v2.1/parkingspots?loc=Vancouver" +
                    "&oauth_consumer_key=#{ApiKeys::Car2Go}" +
                    "&format=json"
    end

    # Returns an Array of ParkingSpot instances
    def self.fetch_parking_spots(&block)
      BubbleWrap::HTTP.get(endpoint) do |response|
        if response.ok?
          response_data = BubbleWrap::JSON.parse(response.body)['placemarks']

          parking_spots = response_data.map { |parking_spot_data|
            ParkingSpot.from_json(parking_spot_data)
          }

          block.call(true, parking_spots)
        else
          block.call(false, nil)
        end
      end
    end
  end
end
