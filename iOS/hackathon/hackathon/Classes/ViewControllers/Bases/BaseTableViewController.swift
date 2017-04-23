//
//  BaseTableViewController.swift
//  SmartDesk
//
//  Created by sa on 3/1/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import UIKit

open class BaseTableViewController: BaseViewController {

    var refreshControl:UIRefreshControl?
    
    @IBOutlet open weak var tblView : TouchUITableView?
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createRefreshControl()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tblView?.addSubview(refreshControl!)
    }
    
    // Table Page should override this function
    //In override function. Should call API to refresh data. After refresh data, should call 'refreshControl?.endRefreshing()'
    open func refreshData() {
        
    }

}
