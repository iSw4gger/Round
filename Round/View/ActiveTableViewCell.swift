//
//  ActiveTableViewCell.swift
//  Round
//
//  Created by Jared Boynton on 7/28/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit

class ActiveTableViewCell: UITableViewCell {
    
    @IBOutlet weak var specialInstructionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var statusIndicator: UIView!
    @IBOutlet weak var specInstrucStaticLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }


}
