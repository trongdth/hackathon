//
//  FilterViewController.swift
//  hackathon
//
//  Created by Trong_iOS on 4/20/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import UIKit

class FilterViewController: BaseTableViewController {
    
    @IBOutlet weak var sliderAge: MySlider!
    @IBOutlet weak var sliderWeight: MySlider!
    @IBOutlet weak var sliderWaterInPastHour: MySlider!
    @IBOutlet weak var swGender: UISwitch!
    @IBOutlet weak var txtGoal: UITextField!
    @IBOutlet weak var txtCelc: UITextField!
    @IBOutlet weak var txtCondition: UITextField!
    
    // MARK:- view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadUI()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- UI
    
    func loadUI() {
        setTitleString("SETTING", font: CUSTOM_FONT.fREGULAR.size(size: 18))
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = SYSTEM_VERSION_LESS_THAN("7.0") ? 0 : -5
        
        self.navigationItem.leftBarButtonItems = NSArray.init(objects: negativeSpacer, super.createBarButtonItem(UIImage.init(named: "fake"),
                                                                                                                 highlightState: nil,
                                                                                                                 widthCap: 5,
                                                                                                                 heightCap: 0,
                                                                                                                 buttonWidth: NSNumber.init(value: 29 as Int32),
                                                                                                                 title: "      ",
                                                                                                                 font: CUSTOM_FONT.fREGULAR.size(size: 15),
                                                                                                                 color: UIColor.white,
                                                                                                                 target: self,
                                                                                                                 selector: #selector(doBack))) as? [UIBarButtonItem]
        
        
        self.navigationItem.rightBarButtonItems = NSArray.init(objects: negativeSpacer, super.createBarButtonItem(UIImage.init(named: "fake"),
                                                                                                                  highlightState: nil,
                                                                                                                  widthCap: 5,
                                                                                                                  heightCap: 0,
                                                                                                                  buttonWidth: NSNumber.init(value: 22 as Int32),
                                                                                                                  title: "Offset",
                                                                                                                  font: CUSTOM_FONT.fREGULAR.size(size: 15),
                                                                                                                  color: UIColor.white,
                                                                                                                  target: self,
                                                                                                                  selector: #selector(offset))) as? [UIBarButtonItem]
        
    }
    
    func doBack() {
        let myNavigation = self.navigationController as! BaseNavigationViewController
        myNavigation.showMenu()
    }
    
    func offset() {
        BTServices.sharedInstance.addAction(action: "s: offset") { (value) -> (Void) in
            
        }
    }
   
    // MARK:- Functions
    
    
    func loadData() {
        sliderAge.value = Float(KEY.AGE)
        sliderWeight.value = Float(KEY.WEIGHT)
        txtCondition.text = "\(KEY.WORK_CONDITION)"
        txtCelc.text = "\(KEY.CEIL)"
        swGender.setOn(Bool.init(KEY.GENDER as NSNumber), animated: true)
        
        self.btnMyGoalTouched(txtGoal)
    }
    
    // MARK:- IBAction methods
    
    @IBAction func btnMyGoalTouched(_ sender: Any) {
        txtGoal.text = "\(AI.sharedInstance.calcWaterIntake(weight: Int(sliderWeight.value), age: Int(sliderAge.value), gender: Int(NSNumber.init(value: swGender.isOn))))"
    }
    
    @IBAction func btnRemindMe(_ sender: Any) {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let time = AI.Time.init(h: hour, m: minutes, s: seconds)
        let remind = AI.sharedInstance.remindDrinkingWater(curTemp: Int(txtCelc.text!)!,
                                              waterLastHour: Int(sliderWaterInPastHour.value),
                                              curTime: time,
                                              workingCondition: Int(txtCondition.text!)!,
                                              adequateIntake: Int(txtGoal.text!)!)
        
        if remind == 1 {
            Util.showMessagePopup(self, message: "Match remind", completion: { (actions) in
                
            })
            BTServices.sharedInstance.addAction(action: "l: b", onSuccess: { (value) -> (Void) in
                print("Led sent")
            })
            
        } else {
            Util.showMessagePopup(self, message: "Not match", completion: { (actions) in
                
            })
        }
    }
    
}

extension FilterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
