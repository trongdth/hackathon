//
//  Util.swift
//  Pods
//
//  Created by sa on 3/8/17.
//
//

import UIKit
import MBProgressHUD
import SwiftyJSON

struct LOADING_VIEW_TAG {
    static let INDICATOR = 100
    static let DOWNLOAD = 101
    static let UPLOAD = 102
}

public class Util: NSObject {
    
    // MARK:- MBPROGRESS
    
    public static func startLoadingView(_ view:UIView, animated:Bool){
        if let loadingNotification = view.viewWithTag(LOADING_VIEW_TAG.INDICATOR) as? MBProgressHUD{
            loadingNotification.show(animated: true)
            return
        }
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: animated)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.tag = LOADING_VIEW_TAG.INDICATOR
        loadingNotification.show(animated: true)
        
    }
    
    public static func stopLoadingView(_ view:UIView, animated:Bool){
        DispatchQueue.main.async {
            if let loadingView = view.viewWithTag(LOADING_VIEW_TAG.INDICATOR) as? MBProgressHUD{
                loadingView.hide(animated: true)
            }
        }
        
    }
    
    public static func showMessagePopup(_ viewController:UIViewController, message:String, completion:((UIAlertAction)->Void)?){
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:completion))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public static func validateEmail(text:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    // MARK:- Read file json
    
    public static func jsonFromFile(fileName:String)->(JSON?,String?) {
        var message:String?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    return (jsonObj,message)
                } else {
                    message = "Could not get json from file, make sure that file contains valid json."
                    print(message ?? "")
                    return (nil,message)
                }
            } catch let error {
                message = error.localizedDescription
                print(error.localizedDescription)
                return (nil,message)
            }
        } else {
            message = "Invalid filename/path."
            print(message ?? "")
            return (nil,message)
        }
    }
}

extension String {
    public func getSizeOfString(font: UIFont) -> CGSize {
        return self.size(attributes: [NSFontAttributeName: font])
    }
}
