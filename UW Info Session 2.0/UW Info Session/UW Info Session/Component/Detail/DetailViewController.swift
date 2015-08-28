//
//  DetailViewController.swift
//  UW Info Session
//
//  Created by Honghao Zhang on 2015-08-11.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {
    
    var shouldHide: Bool = true
    
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupTableView() {
        BaseInfoCell.registerInTableView(detailTableView)
        DetailInfoCell.registerInTableView(detailTableView)
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
    }
    
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BaseInfoCell.identifier()) as! BaseInfoCell
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    
}

extension DetailViewController: Analytics {
    override func screenName() -> String? {
        return "Detail View"
    }
}
