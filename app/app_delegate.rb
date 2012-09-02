class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    window.rootViewController = navigationController
    window.makeKeyAndVisible
    window.rootViewController.wantsFullScreenLayout = true
    true
  end

  def window
    @window ||=
      UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def navigationController
    @navigationController ||=
      UINavigationController.alloc.initWithRootViewController(tabBarController)
  end

  def tabBarController
    return @tabBarController unless @tabBarController.nil?

    @tabBarController = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    @tabBarController.viewControllers = [mapController, listController]

    @tabBarController
  end

  def listController
    @listController ||= UINavigationController.alloc.initWithRootViewController(
      ParkingSpotsListController.alloc.init
    )
  end

  def mapController
    @mapController ||= ParkingSpotsMapController.alloc.init
  end
end
