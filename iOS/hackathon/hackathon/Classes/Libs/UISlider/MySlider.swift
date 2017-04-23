//
//  MySlider.swift
//  hackathon
//
//  Created by Trong_iOS on 4/21/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import Foundation

class MySlider: UISlider {
    var label: UILabel?
    var labelXMin: Float = 0
    var labelXMax: Float = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        if (label == nil) {
            label = UILabel.init()
        }
        labelXMin = Float(self.frame.origin.x + 10)
        labelXMax = Float(self.frame.origin.x + self.frame.size.width - CGFloat(11))
        let labelXOffset = labelXMax - labelXMin
        let valueOffset = self.maximumValue - self.minimumValue
        let valueDifference = self.value - self.minimumValue
        let valueRatio = valueDifference/valueOffset
        let labelXPos = labelXOffset*valueRatio + labelXMin
        label?.frame = CGRect.init(x: CGFloat(labelXPos), y: self.frame.origin.y - 8, width: 150, height: 10)
        label?.textAlignment = .center;
        label?.font = CUSTOM_FONT.fREGULAR.size(size: 11.0)
        self.superview?.addSubview(label!)
    }
    
    override func layoutSubviews() {
        self.updateLabel()
        super.layoutSubviews()
    }
    
    func updateLabel() {
        label?.text = String.init(format: "%.0f", self.value)
    }
    
    func onValueChanged() {
        self.updateLabel()
    }

}
