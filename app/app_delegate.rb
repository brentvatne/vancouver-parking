class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    @window.makeKeyAndVisible

    Api::Car2Go.fetch_parking_spots do |success, spots|
      p spots
    end

    true
  end
end
