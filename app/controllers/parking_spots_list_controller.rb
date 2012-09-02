class ParkingSpotsListController < UITableViewController
  attr_accessor :table, :data

  def init
    initWithNibName(nil, bundle: nil)
  end

  def viewDidLoad
    initializeTableView
    fetchParkingSpots
  end

  def initializeTableView
    @table = UITableView.alloc.initWithFrame(view.bounds)
    @table.dataSource = self
    @table.delegate   = self

    view.addSubview @table
  end

  def fetchParkingSpots
    Api::Car2Go.fakeFetchParkingSpots do |success, parkingSpots|
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

    # Put your data in the cell
    parkingSpot = @data[indexPath.row]
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap
    cell.textLabel.text = parkingSpot.name.gsub('Easy Park lot, ','')[0..30] + "..."
    cell.detailTextLabel.text = "#{parkingSpot.remainingFreeSpaces} of #{parkingSpot.totalCapacity} spaces are empty"
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
