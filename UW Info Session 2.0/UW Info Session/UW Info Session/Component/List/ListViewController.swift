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
    var leftInfoSessionNumber = 0
    var date = NSDate()
    
	@IBOutlet weak var listTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
        title = "Info Session"
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        Locator.clinet.updateFromSourceURLForYear(2015, month: .Sep){
            (result: Bool) in
            print("got back: \(result)")
            
            self.MonthlyInfoSessions = Info.shareInstance.InfoSessions
            self.leftInfoSessionNumber = self.removePassedInfoSession()
            
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
    
    private func removePassedInfoSession() -> Int {
        let sum = MonthlyInfoSessions.count
        var sumPassed = 0
        for info in MonthlyInfoSessions {
            if info.employer == "No info sessions" || info.employer == "Info sessions begin" || info.employer == "Lectures begin" {
                sumPassed = sumPassed + 1
                MonthlyInfoSessions.removeAtIndex(0)
            }
        }
        MonthlyInfoSessions.removeAtIndex(0)
        return sum - sumPassed
    }
    
    private func provideDateLine() -> Int {
        let infoSessionDateFormatter = NSDateFormatter()
        infoSessionDateFormatter.dateFormat = "d"
        let dateLineString = infoSessionDateFormatter.stringFromDate(date)
        let dateLine = Int(dateLineString)
        return dateLine!
    }
    
    private func extractNumFromDate() {
        
    }
}

extension ListViewController: UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Info.shareInstance.finishParsing {
            return leftInfoSessionNumber
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
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailVC.infoSession = MonthlyInfoSessions[indexPath.row]
        
        Locator.splitViewController.showDetailViewController(detailVC, sender: self)
    }

}

extension ListViewController{
    override func screenName() -> String? {
        return "List View"
    }
}












