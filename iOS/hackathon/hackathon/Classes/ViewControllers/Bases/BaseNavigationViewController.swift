//
//  BaseNavigationViewController.swift
//  SmartDesk
//
//  Created by sa on 3/1/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import UIKit
import REFrostedViewController

public class BaseNavigationViewController: UINavigationController {

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- FUNCTIONS
    
    func showMenu() {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }
    
}
