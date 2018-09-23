//
//  DatesViewController.swift
//  Round
//
//  Created by Jared Boynton on 7/31/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit
import JTCalendar
import Spring

protocol DateVCDelegate{
    func sendDateBack(date: String)
}

class DatesViewController: UIViewController {

    @IBOutlet weak var mainView: SpringView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate: DateVCDelegate?
    @IBOutlet weak var titleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        
    }

    
    @IBAction func saveButtonPressed(_ sender: Any) {
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        delegate?.sendDateBack(date: selectedDate)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func viewTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews(){
        
        mainView.layer.cornerRadius = 15
        titleView.layer.cornerRadius = 15
        //rounds the top corners
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    
}


