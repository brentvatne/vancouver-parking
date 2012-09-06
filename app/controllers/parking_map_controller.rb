class ParkingMapController < UIViewController
  attr_reader :parkingSpots

  def init; self; end

  def loadView
    self.view = MKMapView.alloc.init
    view.delegate = self
  end

  def viewDidLoad
    view.frame = tabBarController.view.bounds
    view.setRegion(originalViewRegion)
    view.showsUserLocation = true
    fetchParkingSpots
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(true, animated:false)
  end


  def originalViewRegion
    MKCoordinateRegionMake(CLLocationCoordinate2D.new(49.27, -123.12), MKCoordinateSpanMake(0.1, 0.1))
  end

  def fetchParkingSpots
    Api::Car2Go.fetchParkingSpots do |success, parkingSpots|
      @parkingSpots = parkingSpots.hasFreeSpace
      refreshMap
    end
  end

  def refreshMap
    @parkingSpots.each do |parkingSpot|
      view.addAnnotation(parkingSpot)
    end
  end

  # UITabBarController Hooks
  def tabBarItem
    @tabBarItem ||= UITabBarItem.alloc.initWithTitle(
      'Map', image:UIImage.imageNamed('icons/map.png'), tag:1
    )
  end
end
