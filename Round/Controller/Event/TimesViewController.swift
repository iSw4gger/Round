//
//  TimeViewController.swift
//  Round
//
//  Created by Jared Boynton on 7/31/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit

protocol TimeVCDelegate{
    func sendTimeBack(date: String)
}

class TimesViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    var delegate: TimeVCDelegate?
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)

    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        timePicker.datePickerMode = .time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let selectedTime = timeFormatter.string(from: timePicker.date)
        delegate?.sendTimeBack(date: selectedTime)
        
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
