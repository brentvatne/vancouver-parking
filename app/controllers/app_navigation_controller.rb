class AppNavigationController < UINavigationController

  def initWithRootViewController(rootController)
    super(rootController)
    customizeAppearance
    self
  end

  def customizeAppearance
    navigationBar.tintColor = UIColor.blackColor
  end

end
