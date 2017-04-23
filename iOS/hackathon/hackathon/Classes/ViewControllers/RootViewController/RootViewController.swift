//
//  RootViewController.swift
//  SmartDesk
//
//  Created by sa on 3/2/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import UIKit
import REFrostedViewController

class RootViewController: UIViewController {

    static let shareInstance = RootViewController()
    
    var isLoaded:Bool = false
    var arrRetains:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initObjects()
        self.createUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.arrRetains.removeAllObjects()

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.arrRetains.removeAllObjects()
    }
    
    //MARK:- FUNCTIONS
    
    func initObjects() {
        
    }
    
    func createUI() {
        self.run()
    }
    
    func run(){
        
        if (!isLoaded) {
            isLoaded = true
            
            //load structure there is have left menu
            loadLeftMenuTabbar()
        }
    }
    
    //This is the structure which has a left menu and tabbar
    
    func loadLeftMenuTabbar() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let menuViewController = storyBoard.instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
        menuViewController.delegate = TabRootViewController.shareInstance
        
        let frostedViewController = REFrostedViewController(contentViewController: TabRootViewController.shareInstance, menuViewController: menuViewController)
        frostedViewController?.direction = .left
        frostedViewController?.liveBlurBackgroundStyle = .light
        frostedViewController?.panGestureEnabled = false
        frostedViewController?.liveBlur = true
        frostedViewController?.delegate = self
        
        self.view.addSubview((frostedViewController?.view)!)
        self.arrRetains.add(frostedViewController!)
    }
    
    //This is the structure which has only tabbar
    
    func loadTabbar() {
        let myNavigationController = BaseNavigationViewController(rootViewController: TabRootViewController.shareInstance)
        myNavigationController.isNavigationBarHidden = true
        self.view.addSubview(myNavigationController.view)
        self.arrRetains.add(myNavigationController)
    }


}
extension RootViewController:REFrostedViewControllerDelegate {
    func frostedViewController(_ frostedViewController: REFrostedViewController!, didRecognizePanGesture recognizer: UIPanGestureRecognizer!){
    }
    
    func frostedViewController(_ frostedViewController: REFrostedViewController!, willShowMenuViewController menuViewController: UIViewController!){
        
    }
    
    func frostedViewController(_ frostedViewController: REFrostedViewController!, didShowMenuViewController menuViewController: UIViewController!){
        
    }
    func frostedViewController(_ frostedViewController: REFrostedViewController!, willHideMenuViewController menuViewController: UIViewController!){
        
    }
    func frostedViewController(_ frostedViewController: REFrostedViewController!, didHideMenuViewController menuViewController: UIViewController!){
        
    }
}
