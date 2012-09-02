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

    view.addSubview @table
  end

  def fetchParkingSpots
    Api::Car2Go.fakeFetchParkingSpots do |success, parkingSpots|
      @data = parkingSpots.select(&:hasFreeSpace?).map(&:to_s)
      puts "LOADED DATA"
      @table.reloadData
    end
  end

  # UITableView Hooks
  def reuseIdentifier
    @reuseIdentifier ||= "CELL_IDENTIFIER"
  end

  # Return the UITableViewCell for the row
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleDefault,
        reuseIdentifier: @reuseIdentifier
      )
    end

    # Put your data in the cell
    cell.textLabel.text = @data[indexPath.row]
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
    'Parking Spots'
  end

  # UITabBarController Hooks
  def tabBarItem
    @tabBarItem ||= UITabBarItem.alloc.initWithTitle(
      'List', image:UIImage.imageNamed('icons/list.png'), tag:1
    )
  end
end
