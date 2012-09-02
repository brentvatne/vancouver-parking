class ParkingSpotsMapController < UITableViewController
  def init
    initWithNibName(nil, bundle: nil)
  end

  def viewDidLoad
    initializeMapView
    fetchParkingSpots
  end

  def initializeMapView
    # @table = UITableView.alloc.initWithFrame(view.bounds)
    # @table.dataSource = self

    # view.addSubview @table
  end

  def fetchParkingSpots
    Api::Car2Go.fakeFetchParkingSpots do |success, parkingSpots|
      # @data = parkingSpots.select(&:hasFreeSpace?).map(&:to_s)
      # puts "LOADED DATA"
      # @table.reloadData
    end
  end

  # UITabBarController Hooks
  def tabBarItem
    @tabBarItem ||= UITabBarItem.alloc.initWithTitle(
      'Map', image:UIImage.imageNamed('icons/map.png'), tag:1
    )
  end
end
