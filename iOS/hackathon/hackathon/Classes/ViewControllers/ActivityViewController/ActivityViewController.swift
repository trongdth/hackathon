//
//  ActivityViewController.swift
//  hackathon
//
//  Created by Trong_iOS on 4/19/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import UIKit
import Charts

class ActivityViewController: BaseTableViewController {
    
    @IBOutlet weak var chartView: BarChartView!
    var dictLogs: [String:Int] = [:]
    var timer: Timer?
    var backdoor: Bool = false
    
    // MARK:- view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadUI()
        loadCharts()
        runTimer()
    }
    
    deinit {
        timer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- UI
    
    func loadUI() {
        setTitleString("ACTIVITY", font: CUSTOM_FONT.fREGULAR.size(size: 18))
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = SYSTEM_VERSION_LESS_THAN("7.0") ? 0 : -5
        
        self.navigationItem.leftBarButtonItems = NSArray.init(objects: negativeSpacer, super.createBarButtonItem(UIImage.init(named: "left_menu"),
                                                                                                                 highlightState: nil,
                                                                                                                 widthCap: 5,
                                                                                                                 heightCap: 0,
                                                                                                                 buttonWidth: NSNumber.init(value: 29 as Int32),
                                                                                                                 title: "",
                                                                                                                 font: CUSTOM_FONT.fREGULAR.size(size: 15),
                                                                                                                 color: UIColor.white,
                                                                                                                 target: self,
                                                                                                                 selector: #selector(doBack))) as? [UIBarButtonItem]
        
        
        self.navigationItem.rightBarButtonItems = NSArray.init(objects: negativeSpacer, super.createBarButtonItem(UIImage.init(named: "fake"),
                                                                                                                  highlightState: nil,
                                                                                                                  widthCap: 5,
                                                                                                                  heightCap: 0,
                                                                                                                  buttonWidth: NSNumber.init(value: 22 as Int32),
                                                                                                                  title: " Sync ",
                                                                                                                  font: CUSTOM_FONT.fREGULAR.size(size: 14),
                                                                                                                  color: UIColor.white,
                                                                                                                  target: self,
                                                                                                                  selector: #selector(sync))) as? [UIBarButtonItem]
        
    }
    
    func doBack() {
        let myNavigation = self.navigationController as! BaseNavigationViewController
        myNavigation.showMenu()
    }
    
    func empty() {
        
    }
    

    //MARK:- Functions
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 50.0,
                                                          target: self,
                                                        selector: #selector(ActivityViewController.sync),
                                                        userInfo: nil,
                                                         repeats: true)
    }
    
    func sync() {
        print("sync")
        BTServices.sharedInstance.addAction(action: "t: 0") { (value) -> (Void) in
            GlobalMainQueue.asyncAfter(deadline: DispatchTime.now() + 3, execute: { 
                self.loadData()
            })
        }
    }
    
    func loadCharts() {
        chartView.delegate = self
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.maxVisibleCount = 10;
    
        chartView.chartDescription?.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.rightAxis.enabled = false
        
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = CUSTOM_FONT.fREGULAR.size(size: 10)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0
        xAxis.labelCount = 7
        xAxis.valueFormatter = DayAxisValueFormatter.init(forChart: chartView)
        
        let leftAxisFormatter = NumberFormatter.init()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = ""
        leftAxisFormatter.positiveSuffix = ""
        
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = CUSTOM_FONT.fREGULAR.size(size: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0.0
        
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 9.0
        l.font = CUSTOM_FONT.fREGULAR.size(size: 11)
        l.xEntrySpace = 4.0
        
        
        let marker = XYMarkerView.init(color: UIColor.blue, font: CUSTOM_FONT.fREGULAR.size(size: 12), textColor: UIColor.white, insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0), xAxisValueFormatter: chartView.xAxis.valueFormatter!)
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        chartView.marker = marker
        
        loadData()
    }
    
    func loadData() {
        print("loadData")
        let offset = UserDefaults.standard.integer(forKey: KEY.OFFSET)
        var max = 0
        let arr = Database.sharedInstance.allWaterLogs()
        var out_of_water = 0
        dictLogs = [:]
        for water in arr! {
            let key = self.myKey(time: water.time)
            if key.characters.count > 0 {
                var ori = 0
                if dictLogs[key] != nil {
                    ori = dictLogs[key]!
                }
                
                let data = water.weight - offset
                out_of_water = data
                if data >= 0 {
                    if max == 0 {
                        max = water.weight
                    } else {
                        if max > water.weight {
                            dictLogs[key] = (max - water.weight) + ori

                        } else {
                            max = water.weight
                        }
                    }
                }
                
            }
            
        }
        
        if out_of_water <= 20 &&
            (arr?.count)! > 0 &&
            !backdoor {
            
            if UserDefaults.standard.value(forKey: KEY.OFFSET) != nil {
                backdoor = true
                let offset = UserDefaults.standard.integer(forKey: KEY.OFFSET)
                if offset != 0 {
                    // send warning led
                    GlobalBackgroundQueue.asyncAfter(deadline: DispatchTime.now() + 5, execute: {
                        self.sendWarningLed()
                        self.backdoor = false
                    })
                }
                
            }
            
        }
        
        setDataCount(range: Double(max + 100))
    }
    
    func myKey(time: String) -> String {
        let arr = time.components(separatedBy: " ")
        if arr.count == 2 {
            return arr[0]
        }
        return ""
    }
    
    func sendWarningLed() {
        BTServices.sharedInstance.addAction(action: "l: g") { (value) -> (Void) in
            print("sent led green")
        }
    }
    
    
    func setDataCount(range: Double) {
        var start = 1
        var yVals = [BarChartDataEntry]()
        
        for (_, numbers) in dictLogs {
            yVals.append(BarChartDataEntry.init(x: Double(start), y: Double(numbers)))
            start = start + 1
        }

        var set1: BarChartDataSet? = nil
        if ((chartView.data != nil) && (chartView.data?.dataSetCount)! > 0)
        {
            set1 = chartView.data?.dataSets[0] as? BarChartDataSet
            set1?.values = yVals
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
            
        } else {
            set1 = BarChartDataSet.init(values: yVals, label: "ml/day")
            set1?.setColors(ChartColorTemplates.material(), alpha: 1.0)
        
            var dataSets = [BarChartDataSet]()
            dataSets.append(set1!)
            
            let data = BarChartData.init(dataSets: dataSets) 
            data.setValueFont(CUSTOM_FONT.fREGULAR.size(size: 10.0))
            data.barWidth = 0.9
            chartView.data = data
        }
    }
}

extension ActivityViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("chartValueNothingSelected")
    }

}
