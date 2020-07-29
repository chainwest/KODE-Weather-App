//
//  AppCoordinator.swift

import UIKit

class AppCoordinator: Coordinator {
    let window: UIWindow?
    
    let rootViewController: UINavigationController = {
      return UINavigationController(rootViewController: UIViewController())
    }()
    
    init(window: UIWindow?) {
      self.window = window
    }
    
    override func start() {
      guard let window = window else {
        return
      }
      
      let mapCoordinator = MapCoordinator(rootViewController: rootViewController)
      self.addChildCoordinator(mapCoordinator)
      mapCoordinator.start()
      
      window.rootViewController = rootViewController
      window.makeKeyAndVisible()
    }
    
    override func finish() {
    }
}
