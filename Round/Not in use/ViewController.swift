//
//  ViewController.swift
//  Round
//
//  Created by Jared Boynton on 6/29/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit
import Spring
import Firebase
import FirebaseDatabase

import ChameleonFramework

class ViewController: UIViewController{
    
    @IBOutlet var activeView: UIView!

    @IBOutlet weak var dashboardView: UIView!
    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var addEventView: UIView!
    @IBOutlet weak var numberSurveysCompletedLabel: UILabel!
    @IBOutlet weak var averageScoreLabel: UILabel!
    @IBOutlet weak var rolesRoundedOnLabel: UILabel!
    @IBOutlet weak var dayOfWeekIndicator: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        


    }

    
    
    func retrieveData(){
    

    }
    
    func setupViews(){
        
        activeView.layer.cornerRadius = 20
        dashboardView.layer.cornerRadius = 20
        
        numberSurveysCompletedLabel.layer.borderWidth = 1
        numberSurveysCompletedLabel.layer.borderColor = UIColor.flatGray.cgColor
        numberSurveysCompletedLabel.layer.cornerRadius = 10
        
        rolesRoundedOnLabel.layer.borderWidth = 1
        rolesRoundedOnLabel.layer.borderColor = UIColor.flatGray.cgColor
        rolesRoundedOnLabel.layer.cornerRadius = 10
        
        averageScoreLabel.layer.borderWidth = 1
        averageScoreLabel.layer.borderColor = UIColor.flatGray.cgColor
        averageScoreLabel.layer.cornerRadius = 10
        
        dayOfWeekIndicator.layer.cornerRadius = 5

        
    }
    

    
}

