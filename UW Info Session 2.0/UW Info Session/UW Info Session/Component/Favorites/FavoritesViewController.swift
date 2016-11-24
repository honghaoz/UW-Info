//
//  FavoritesViewController.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-10-05.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseViewController {

    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

extension FavoritesViewController {
	override func screenName() -> String? {
		return "Favorite View"
	}
}
