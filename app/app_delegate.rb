class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    window.rootViewController = tabBarController
    true
  end

  def window
    return @window unless @window.nil?

    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    @window.makeKeyAndVisible

    @window
  end

  def listController
    @listController ||= UINavigationController.alloc.initWithRootViewController(
      ParkingSpotsListController.alloc.init
    )
  end

  def mapController
    @mapController ||= ParkingSpotsMapController.alloc.init
  end

  def tabBarController
    return @tabBarController unless @tabBarController.nil?

    @tabBarController = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    @tabBarController.viewControllers = [mapController, listController]

    @tabBarController
  end
end
