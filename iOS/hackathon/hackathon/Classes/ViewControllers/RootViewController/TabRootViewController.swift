//
//  TabRootViewController.swift
//  SmartDesk
//
//  Created by sa on 3/2/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import UIKit

class TabRootViewController: BaseTabBarViewController {

    static var shareInstance = TabRootViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- FUNCTIONS
    
    func setupViews() {
        addControllers()
    }
    
    func addControllers() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)  

        let (jsonObj,message) = Util.jsonFromFile(fileName: "pages")
        if jsonObj != nil {
            if let array = jsonObj?.array {
                var i = 0
                for item in array {
                    if let nibDict = item["nib"].dictionary {
                        if let identifier = nibDict["indentifier"]?.string {
                            let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
                            if identifier == "activityViewController" {
                                viewController.tabBarItem = UITabBarItem.init(title: "Activity", image: UIImage.init(named: "activity"), tag: i)
                                
                            } else if(identifier == "filterViewController") {
                                viewController.tabBarItem = UITabBarItem.init(title: "Setting", image: UIImage.init(named: "settings"), tag: i)
                            }
                            
                            let navigation = BaseNavigationViewController.init(rootViewController: viewController)
                            self.addChildViewController(navigation)

                        }
                        i = i + 1
                    }
                }
            }
            
        }else {
            print(message ?? "")
        }
    }
    
    func setIndexFocus(_ index: Int) {
        self.selectedIndex = index
        didSelectIdx(index)
        NotificationCenter.default.post(name: .SelectMenuIndexNotification, object: NSNumber(value: index))
    }
}

extension TabRootViewController:MenuProtocal {
    func didSelectIdx(_ idx: Int) {
        tabBar.isHidden = true
        self.selectedIndex = idx
    }
}
