module Api
  class Car2Go
    class << self
      # Endpoint to the Car2Go Api. You'll need your own OAuth Consumer Key, which
      # you can get from: http://code.google.com/p/car2go/wiki/parkingspots_v2_1
      def endpoint
        @endpoint ||= "http://www.car2go.com/api/v2.1/parkingspots?loc=Vancouver" +
                      "&oauth_consumer_key=#{ApiKeys::Car2Go}" +
                      "&format=json"
      end

      # Fake implementation for testing
      # Does not make an api call, just uses data from this source file
      def fetchParkingSpots(&block)
        block.call(true, parkingSpotsFromJSON(sampleData))
      end

      # Real implementation
      # Returns an Array of ParkingSpot instances
      def fakeFetchParkingSpots(&block)
        BubbleWrap::HTTP.get(endpoint) do |response|
          if response.ok?
            block.call(true, parkingSpotsFromJSON(response.body))
          else
            block.call(false, nil)
          end
        end
      end

      def parkingSpotsFromJSON(json)
        ParkingSpots.fromJSON(BubbleWrap::JSON.parse(json)['placemarks'])
      end

      # Real data taken from the Car2Go API so I don't have to make a bunch of calls
      # while testing.
      def sampleData
        @sampleData ||= <<-eos
          {"placemarks":[
            {"chargingPole":false,"coordinates":[-123.13092,39.3786,0],"name":"1100 The Castings, Easy Park lot, North of 6th Ave","totalCapacity":2,"usedCapacity":0},
            {"chargingPole":false,"coordinates":[-123.115974,49.26637,0],"name":"595 West 6th Ave, Easy Park lot, West of Cambie St (Olympic Village SkyTrain)","totalCapacity":2,"usedCapacity":0},
            {"chargingPole":false,"coordinates":[-123.100266,49.272594,0],"name":"1500 Main St, Easy Park lot, (Main Street SkyTrain)","totalCapacity":4,"usedCapacity":0},
            {"chargingPole":false,"coordinates":[-123.111824,49.280186,0],"name":"688 Cambie St, Easy Park lot, North of Georgia","totalCapacity":6,"usedCapacity":0},
            {"chargingPole":false,"coordinates":[-123.10785,49.283974,0],"name":"160 Water St, Easy Park lot, West of Abott St (Gastown). Overflow on Roof","totalCapacity":5,"usedCapacity":15},
            {"chargingPole":false,"coordinates":[-123.118774,49.279438,0],"name":"856 Richards St, Easy Park lot, North of Smithe","totalCapacity":35,"usedCapacity":4},
            {"chargingPole":true,"coordinates":[-123.12581,49.290234,0],"name":"490 Broughton St, Easy Park lot, North of Hastings","totalCapacity":2,"usedCapacity":0},
            {"chargingPole":true,"coordinates":[-123.1138,49.2625,0],"name":"453 10th Ave, Easy Park lot, East of Cambie St (Broadway/ City Hall SkyTrain)","totalCapacity":2,"usedCapacity":0}
          ]}
        eos
      end
    end
  end
end
