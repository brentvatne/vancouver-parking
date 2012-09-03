class SettingsController < UIViewController
  def init
    initWithNibName(nil, bundle: nil)
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:true)
    tabBarController.title = title
  end

  def title
    "Settings"
  end

  # UITabBarController Hooks
  def tabBarItem
    @tabBarItem ||= UITabBarItem.alloc.initWithTitle(
      'Settings', image:UIImage.imageNamed('icons/settings.png'), tag:1
    )
  end
end
