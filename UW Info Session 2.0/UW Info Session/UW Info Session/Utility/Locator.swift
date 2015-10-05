//
//  Locator.swift
//  UW Info Session
//
//  Created by Honghao Zhang on 2015-08-10.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi
import CoreData

class Locator {
    static let sharedInstance = Locator()
    
    // MARK: - Client
    class var clinet: Client { return Client.sharedInstance }
    
    // MARK: - Root View Controller
    private lazy var _rootViewController: RootViewController = {
        var controller = UIViewController.viewControllerInStoryboard("Root", viewControllerName: "RootViewController") as! RootViewController
        return controller
    }()
    class var rootViewController: RootViewController {
        return sharedInstance._rootViewController
    }
    
    // MARK: - Split View Controller
    private lazy var _splitViewController: UISplitViewController = {
        var splitController = UISplitViewController()
        return splitController
    }()
    class var splitViewController: UISplitViewController {
        return sharedInstance._splitViewController
    }
    
    // MARK: - List View Controller
    private lazy var _listNavigationController: UINavigationController = {
        var controller = UIViewController.viewControllerInStoryboard("Root", viewControllerName: "ListNavigationController") as! UINavigationController
        return controller
    }()
    
    class var listNavigationController: UINavigationController {
        return sharedInstance._listNavigationController
    }
    
    private lazy var _listViewController: ListViewController = {
        var controller = UIViewController.viewControllerInStoryboard("Root", viewControllerName: "ListViewController") as! ListViewController
        return controller
    }()
    
    class var listViewController: ListViewController {
        return sharedInstance._listViewController
    }
    
    // MARK: - Detail View Controller
    private lazy var _detailNavigationController: UINavigationController = {
        var controller = UIViewController.viewControllerInStoryboard("Root", viewControllerName: "DetailNavigationController") as! UINavigationController
        return controller
    }()
    
    class var detailNavigationController: UINavigationController {
        return sharedInstance._detailNavigationController
    }
    
    private lazy var _detailViewController: DetailViewController = {
        var controller = UIViewController.viewControllerInStoryboard("Root", viewControllerName: "DetailViewController") as! DetailViewController
        return controller
    }()
    
    class var detailViewController: DetailViewController {
        return sharedInstance._detailViewController
    }
    
    class var delegate: AppDelegate { return UIApplication.sharedApplication().delegate as! AppDelegate }
    
    // MARK: - Core Data
    class var managedObjectContext: NSManagedObjectContext {
        if let context = Locator.delegate.managedObjectContext {
            return context
        } else {
            log.error("managedObjectContext is nil")
            assertionFailure("")
            return NSManagedObjectContext()
        }
    }
    
}
