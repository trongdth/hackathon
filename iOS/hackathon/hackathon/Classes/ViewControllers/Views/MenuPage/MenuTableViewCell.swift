//
//  MenuTableViewCell.swift
//  Maya
//
//  Created by Trong_iOS on 8/11/16.
//  Copyright © 2016 Autonomous. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imvBkg: UIImageView!
    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imvCircle: UIImageView!
    @IBOutlet weak var lblNo: UILabel!
    
    // MARK:- Properties
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        
        imvBkg.layer.cornerRadius = imvBkg.frame.size.width/2
        imvBkg.layer.borderColor = UIColor.white.cgColor
        imvBkg.clipsToBounds = true
        
        lblTitle.font = CUSTOM_FONT.fREGULAR.size(size: 15)
        
        imvCircle.layer.cornerRadius = imvCircle.frame.size.width/2
        imvCircle.clipsToBounds = true
        lblNo.font = CUSTOM_FONT.fREGULAR.size(size: 15)
        lblNo.textAlignment = .center
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:- Functions
    
    func updateData(_ option : [String : String]) {
        lblTitle.text = option["name"]
        imvIcon.image = UIImage.init(named: option["image"]!)
        
        if option["selected"] == "1" {
            imvBkg.layer.borderColor = UIColor.init(red: 203/255, green: 58/255, blue: 111/255, alpha: 1.0).cgColor
        } else {
            imvBkg.layer.borderColor = UIColor.init(red: 208/255, green: 208/255, blue: 209/255, alpha: 1.0).cgColor
        }
        
    }
    func updateNo(number:Int) {
        if number == 1 {
            imvCircle.isHidden = false
            lblNo.isHidden = false
            lblNo.text = "1"
        }else {
            imvCircle.isHidden = true
            lblNo.isHidden = true
        }
    }
}
