//
//  SurveyTableViewCell.swift
//  Round
//
//  Created by Jared Boynton on 8/5/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit

class SurveyTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var answerCellLabel: UILabel!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var answerIndicator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


}
