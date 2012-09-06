class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    window.rootViewController = navigationController
    window.makeKeyAndVisible
    window.rootViewController.wantsFullScreenLayout = true
    true
  end

  def window
    @window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def navigationController
    @navigationController ||= AppNavigationController.alloc.initWithRootViewController(tabBarController)
  end

  def tabBarController
    @tabBarController ||= AppTabBarController.alloc.init.tap do |tabController|
      tabController.viewControllers = [mapController, listController, settingsController]
    end
  end

  def mapController
    @mapController ||= ParkingMapController.alloc.init
  end

  def listController
    @listController ||= ParkingListController.alloc.init
  end

  def settingsController
    @settingsController ||= SettingsController.alloc.init
  end
end
