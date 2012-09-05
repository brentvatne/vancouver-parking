class ParkingSpotsListController < UITableViewController
  attr_accessor :data, :locationManager

  def init
    initWithNibName(nil, bundle: nil)
  end

  def viewDidLoad
    initializeTableView
    startTrackingLocation
    fetchParkingSpots
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:false)
    tabBarController.title = title
  end

  def initializeTableView
    view.frame      = tabBarController.view.bounds
    view.dataSource = self
    view.delegate   = self
  end

  def fetchParkingSpots
    Api::Car2Go.fetchParkingSpots do |success, parkingSpots|
      @data = parkingSpots.hasFreeSpace.sortByDistanceFrom(currentLocation)
      view.reloadData
    end
  end

  # UITableView Hooks
  def reuseIdentifier
    @reuseIdentifier ||= 'A'
  end

  # Return the UITableViewCell for the row
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleSubtitle,
        reuseIdentifier: @reuseIdentifier
      )
    end

    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton

    # Put your data in the cell
    parkingSpot = @data[indexPath.row]
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap
    cell.textLabel.text = parkingSpot.name.gsub('Easy Park lot, ','')[0..25] + "..."

    distance = parkingSpot.metersFromLocation(currentLocation)
    if distance > 100
      distanceText = 'really far away'
    else
      distanceText = "#{roundToTwoPlaces(distance)}km away"
    end

    cell.detailTextLabel.text = "#{parkingSpot.remainingFreeSpaces} spaces available, #{distanceText}"
    cell
  end

  # Used by the UITableView to determine the number of rows in the data set
  def tableView(tableView, numberOfRowsInSection: section)
    if @data.nil? then 0 else @data.count end
  end

  # UINavigationController Hooks
  # Displayed in the UINavigationController title bar
  def title
    'Available Parking Spots'
  end

  # UITabBarController Hooks
  # The text and icon to use in the UITabBar
  def tabBarItem
    @tabBarItem ||= UITabBarItem.alloc.initWithTitle(
      'Sorted List', image:UIImage.imageNamed('icons/list.png'), tag:1
    )
  end

  # To be refactored
  # Not sure how to properly do this with Rubymotion so here's a quick hack
  def roundToTwoPlaces(number)
    (number * 100).floor.to_s.insert(-3, '.')
  end

  # The location should be tracked on some shared object between the map and list
  # Maybe there is a way to add an object like this to UIApplication.sharedApplication?
  def startTrackingLocation
    @locationManager ||= CLLocationManager.alloc.init.tap do |locationManager|
      locationManager.desiredAccuracy = KCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation
      locationManager.delegate = self
   end
  end

  def currentLocation
    locationManager.location
  end
end
