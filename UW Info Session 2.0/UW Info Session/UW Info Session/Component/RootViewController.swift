//
//  RootViewController.swift
//  UW Info Session
//
//  Created by Honghao Zhang on 2015-08-10.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi
import CoreData

class RootViewController: BaseViewController {
    
    @IBOutlet weak var infoSessionsListBarItem: UITabBarItem!
    @IBOutlet weak var favoritesBarItem: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var childView: UIView!
    
    var viewControllers: [UIViewController] = []
    var activeController:UIViewController? = nil
    
    lazy var mySplitViewController: UISplitViewController = {
        var splitController = Locator.splitViewController
        
        // Setup childViewControllers
        switch self.traitCollection.horizontalSizeClass {
        case .Compact:
            splitController.viewControllers = [self.listNavigationController]
        default:
            splitController.viewControllers = [self.listNavigationController, self.detailNavigationController]
        }

        splitController.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        splitController.delegate = self
        splitController.hidesBottomBarWhenPushed = true
        
        return splitController
    }()
    
    var listNavigationController: UINavigationController { return Locator.listNavigationController }
    var listViewController: ListViewController { return Locator.listViewController }
    var detailNavigationController: UINavigationController { return Locator.detailNavigationController }
    var detailViewController: DetailViewController { return Locator.detailViewController }
    var favoritesNavigationController: UINavigationController { return Locator.favoritesNavigationController}
    var favoritesViewController: FavoritesViewController {return Locator.favoritesViewController}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        displayContentViewController(mySplitViewController)
//        tabBarSelectedIndex = 0
       
        //implement tab bar
        self.childView.hidden = true
        viewControllers = [mySplitViewController, favoritesViewController]
        
        self.tabBar.delegate = self
        
        self.tabBar(tabBar, didSelectItem: infoSessionsListBarItem)
        
        // Test for core data
        let session = NSEntityDescription.entityForName("Session", inManagedObjectContext: Locator.managedObjectContext)
        let newSession = Session(entity: session!, insertIntoManagedObjectContext: Locator.managedObjectContext)
        
        newSession.employer = "Dummy"
        newSession.startTime = NSDate()
        newSession.endTime = NSDate()
        newSession.location = "Dummy"
        newSession.website = "Dummy"
        newSession.audience = "Dummy"
        newSession.program = "Dummy"
        newSession.descriptions = "Dummy"
        newSession.rating = Float(4.2)
        
        // adding error handling code according to swift 2 changes
        do{
            try Locator.managedObjectContext.save()
        }catch {
            print("fail to save in managedObjectContext")
        }
        
        let request = NSFetchRequest(entityName: "Session")
        do{
            let sessions = try Locator.managedObjectContext.executeFetchRequest(request) as! [Session]
            log.debug("Session count: \(sessions.count)")
            log.debug("session[0]: \(sessions.first?.startTime)")
        }catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    
    //display and hide controller for tab bar controller 
    func displayContentInTabBar(contentController:UIViewController) {
        self.addChildViewController(contentController)
        contentController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(contentController.view, belowSubview: tabBar)
        
        NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: contentController.view, attribute: .Top, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: contentController.view, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: contentController.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: contentController.view, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
        
        contentController.didMoveToParentViewController(self)
        self.activeController = contentController
    }
    
    func hideContentInTabBar(contentController:UIViewController) {
        contentController.willMoveToParentViewController(nil)
        contentController.view.removeFromSuperview()
        contentController.removeFromParentViewController()
    }
    
}

extension RootViewController: UITabBarDelegate {
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if let activeController = activeController {
            self.hideContentInTabBar(activeController)
        }
        
        guard let items = tabBar.items, let selectedIndex = items.indexOf(item) else { return }

        switch selectedIndex {
        case 0:
            self.displayContentInTabBar(viewControllers[0])
        case 1:
            self.displayContentInTabBar(viewControllers[1])
        default:
            break;
        }
    }
}

extension RootViewController: UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        
        if let navigationController = secondaryViewController as? UINavigationController {
            if let detailViewController = navigationController.topViewController as? DetailViewController {
                return detailViewController.shouldHide
            }
        }
        return true
    }
    
    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController) -> UIViewController? {
        return Locator.detailNavigationController
    }
}


//    //display controller for split view controller
//
//    func displayContentViewController(viewController: UIViewController) {
//        addChildViewController(viewController)
//        currentSelectedViewController = viewController
//
//        viewController.view.translatesAutoresizingMaskIntoConstraints = false
//        view.insertSubview(viewController.view, belowSubview: tabBar)
//
//        // Full Size
//        NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: viewController.view, attribute: .Top, multiplier: 1.0, constant: 0.0).active = true
//        NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: viewController.view, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
//        NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: viewController.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
//        NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: viewController.view, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
//
//        viewController.didMoveToParentViewController(self)
//    }


//    var tabBarSelectedIndex: Int = 0 {
//        didSet {
//            switch tabBarSelectedIndex {
//            case 0:
//                tabBar.selectedItem = infoSessionsListBarItem
//            case 1:
//                tabBar.selectedItem = favoritesBarItem
//            default:
//                break
//            }
//        }
//    }
