//
//  BaseViewController.swift
//  SmartDesk
//
//  Created by sa on 3/1/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import UIKit

open class BaseViewController: UIViewController {

    var viewFrame:CGRect?

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewFrame = self.view.frame

    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Public functions
    
    open func setTitleString(_ title : String, font : UIFont) {
        let titleView = self.navigationItem.titleView
        var lblTitle = titleView as? UILabel
        
        if lblTitle == nil || lblTitle!.tag != 1899 {
            lblTitle = UILabel.init(frame: CGRect(x: 0, y: 0, width: 800, height: 48))
            lblTitle!.tag = 1899
            lblTitle!.text = title
            lblTitle!.textColor = APP_COLOR.NAVIGATION_TITLE_COLOR
            lblTitle!.shadowColor = UIColor.clear
            lblTitle!.shadowOffset = CGSize(width: 0, height: 0.5)
            lblTitle!.backgroundColor = UIColor.clear
            lblTitle!.textAlignment = .center
            self.navigationItem.titleView = lblTitle
        }
        lblTitle!.text = title
        lblTitle!.font = font
    }
    
    open func createBarButtonItem(_ normalState: UIImage?, highlightState: UIImage?, widthCap: Int, heightCap: Int,  buttonWidth: NSNumber, title: String, font: UIFont?, color: UIColor?, target: AnyObject?, selector: Selector) -> UIBarButtonItem {
        
        let btn : UIButton!
        btn = UIButton.init(type: .custom)
        if title.characters.count == 0 {
            btn.frame = CGRect(x: 0, y: 0, width: CGFloat(buttonWidth), height: (normalState != nil) ? (normalState?.size.height)! : 0.0)
            
        } else {
            let size = title.getSizeOfString(font: font!)
            btn.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
        }
        
        if normalState != nil {
            btn.setImage(normalState, for: UIControlState())
        }
        
        
        if highlightState != nil {
            btn.setImage(highlightState, for: .highlighted)
        }
        
        btn.addTarget(self, action: selector, for: .touchUpInside)
        
        if title.characters.count > 0 {
            let lbl = UILabel.init(frame: btn.frame)
            lbl.font = font
            lbl.backgroundColor = UIColor.clear
            lbl.textColor = APP_COLOR.BARBUTTON_TITLE_COLOR
            lbl.shadowColor = UIColor.white
            lbl.shadowOffset = CGSize(width: 0, height: 0.5)
            lbl.text = title
            lbl.textAlignment = .center
            lbl.sizeToFit()
            btn.addSubview(lbl)
        }
        
        let barBtnItem = UIBarButtonItem.init(customView: btn)
        return barBtnItem
    
    
    }
    
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                var originViewFrame = viewFrame
                originViewFrame?.size.height -= keyboardHeight
                self.view.frame = originViewFrame!
                
            } else {
                
            }
        } else {
            // no userInfo dictionary in notification
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                var originViewFrame = viewFrame
                originViewFrame!.size.height += keyboardHeight
                self.view.frame = originViewFrame!
                // ...
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
    }
    
    
    static func getResourceBundle() -> Bundle {
        let bundle = Bundle(for: self)
        return bundle
    }
    
    static func loadImageFromResourceBundle(imageName:String)->UIImage?{
        let bundle = self.getResourceBundle()
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        return image
    }
    

}
