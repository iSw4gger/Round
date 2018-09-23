//
//  NewQuestionTitleViewController.swift
//  Round
//
//  Created by Jared Boynton on 8/5/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit

protocol SendTitleBack{
    func sendTitleBack(title: String)
}

class NewQuestionTitleViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleView: UIView!
    var delegate: SendTitleBack?
    @IBOutlet weak var questionTitleTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        questionTitleTextView.becomeFirstResponder()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        questionTitleTextView.resignFirstResponder()
    }
   
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        delegate?.sendTitleBack(title: questionTitleTextView.text)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        mainView.layer.cornerRadius = 15
        titleView.layer.cornerRadius = 15
        //rounds the top corners
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
}
