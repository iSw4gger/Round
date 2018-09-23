//
//  NewQuestionDescriptionViewController.swift
//  Round
//
//  Created by Jared Boynton on 8/5/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit

protocol SendDescriptionBack{
    func sendDescriptionBack(description: String)
}

class NewQuestionDescriptionViewController: UIViewController {
    

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var questionDescriptionTextView: UITextView!
    var delegate: SendDescriptionBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        questionDescriptionTextView.becomeFirstResponder()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        questionDescriptionTextView.resignFirstResponder()
    }

    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        delegate?.sendDescriptionBack(description: questionDescriptionTextView.text)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        mainView.layer.cornerRadius = 15
        titleView.layer.cornerRadius = 15
        //rounds the top corners
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
}
