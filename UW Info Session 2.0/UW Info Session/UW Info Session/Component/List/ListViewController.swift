//
//  ListViewController.swift
//  UW Info Session
//
//  Created by Honghao Zhang on 2015-08-10.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {
    
    var MonthlyInfoSessions = [InfoSessionUnit()]
    
	@IBOutlet weak var listTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTableView()
        title = "Info Session"
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        Locator.clinet.updateFromSourceURLForYear(2015, month: .Jul){
            (result: Bool) in
            println("got back: \(result)")
            
            self.MonthlyInfoSessions = Info.shareInstance.InfoSessions
            
            self.listTableView.reloadData()
        }
    }
	
	private func setupTableView() {
		ListCell.registerInTableView(listTableView)
        LoadingCell.registerInTableView(listTableView)
		
		listTableView.dataSource = self
		listTableView.delegate = self
		
		listTableView.rowHeight = UITableViewAutomaticDimension
	}

}

extension ListViewController: UITableViewDataSource {
    
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Info.shareInstance.finishParsing {
            return MonthlyInfoSessions.count
        }else {
            return 1
        }
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if Info.shareInstance.finishParsing {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(ListCell.identifier()) as! ListCell
            
            let InfoSession = MonthlyInfoSessions[indexPath.row]
            cell.configureCellForInfoSession(InfoSession)
            
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier(LoadingCell.identifier()) as! LoadingCell
            return cell
        }
		
	}
}

extension ListViewController: UITableViewDelegate {
    // MARK: - Rows
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if Info.shareInstance.finishParsing {
            return ListCell.estimatedRowHeight()
        }else {
            return LoadingCell.estimatedRowHeight()
        }
        
    }
    
    // MARK: - Selections
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        Locator.detailViewController.shouldHide = false
        
        // https://www.shinobicontrols.com/blog/ios8-day-by-day-day-18-uisplitviewcontroller
        
        Locator.splitViewController.showDetailViewController(Locator.detailNavigationController, sender: self)
    }
    
    //MARK: - for show detail view controller
    
    
}

extension ListViewController: Analytics {
    override func screenName() -> String? {
        return "List View"
    }
}










