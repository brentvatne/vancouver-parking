class ParkingSpotsListController < UIViewController
  attr_accessor :table, :data, :locationManager

  def init
    initWithNibName(nil, bundle: nil)
  end

  def viewDidLoad
    initializeTableView
    styleNavigationBar
    startTrackingLocation
    fetchParkingSpots
  end

  def startTrackingLocation
    @locationManager ||= CLLocationManager.alloc.init.tap do |l|
      l.desiredAccuracy = KCLLocationAccuracyNearestTenMeters
      l.startUpdatingLocation
      l.delegate = self
   end
  end

  def currentLocation
    locationManager.location
  end

  def distanceFromCurrentLocation(otherLocation)
    other = CLLocation.alloc.initWithLatitude(otherLocation.latitude, longitude: otherLocation.longitude)
    p currentLocation.coordinate
    p other.coordinate
    currentLocation.distanceFromLocation(other) / 1000
  end

  def styleNavigationBar
    navigationController.navigationBar.tintColor = UIColor.blackColor
  end

  def initializeTableView
    @table = UITableView.alloc.initWithFrame(view.bounds)
    @table.dataSource = self
    @table.delegate   = self

    view.addSubview @table
  end

  def fetchParkingSpots
    Api::Car2Go.fetchParkingSpots do |success, parkingSpots|
      @data = parkingSpots.select(&:hasFreeSpace?)
      @table.reloadData
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
    cell.detailTextLabel.text = "#{parkingSpot.remainingFreeSpaces} spaces available, " +
                                "#{distanceFromCurrentLocation(parkingSpot.coordinate)}km away"
    cell
  end

  # Return the number of rows
  def tableView(tableView, numberOfRowsInSection: section)
    if @data.nil?
      0
    else
      @data.count
    end
  end

  # UINavigationController Hooks
  def title
    'Available Parking Spots'
  end

  # UITabBarController Hooks
  def tabBarItem
    @tabBarItem ||= UITabBarItem.alloc.initWithTitle(
      'List', image:UIImage.imageNamed('icons/list.png'), tag:1
    )
  end
end
