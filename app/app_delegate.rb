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
    return @navigationController unless @navigationController.nil?

    @navigationController = UINavigationController.alloc.initWithRootViewController(tabBarController)
    @navigationController.navigationBar.tintColor = UIColor.blackColor

    @navigationController
  end

  def tabBarController
    return @tabBarController unless @tabBarController.nil?

    @tabBarController = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    @tabBarController.viewControllers = [mapController, listController, settingsController]

    @tabBarController
  end

  def mapController
    @mapController ||= ParkingSpotsMapController.alloc.init
  end

  def listController
    @listController ||= ParkingSpotsListController.alloc.init
  end

  def settingsController
    @settingsController ||= SettingsController.alloc.init
  end
end
