//
//  AddNewMainViewController.swift
//  Round
//
//  Created by Jared Boynton on 8/5/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddNewMainViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var questionDescriptionLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var questionTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 15

    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        let question = Question()
        question.questionDescription = questionDescriptionLabel.text!
        question.questionType = questionTypeLabel.text!
        question.questionTitle = questionTitleLabel.text!
        question.isActive = false
        question.isSelected = false
        
        let ref = Database.database().reference().child("Questions").childByAutoId()
        
        let dict: [String: Any] = ["type": question.questionType, "title": question.questionTitle, "description": question.questionDescription, "score": 0, "isActive": false, "isSelected":false]
        
        ref.setValue(dict)
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToQuestionType"{
            let typeVC = segue.destination as! NewQuestionTypeViewController
            typeVC.delegate = self
        }
        
        if segue.identifier == "segueToTitle"{
            let titleVC = segue.destination as! NewQuestionTitleViewController
            titleVC.delegate = self
        }
        
        if segue.identifier == "segueToDescription"{
            let descriptionVC = segue.destination as! NewQuestionDescriptionViewController
            descriptionVC.delegate = self
        }
    }
    
    
}



extension AddNewMainViewController: SendQuestionType{
    func sendQuestionType(type: [String]) {
        for n in type{
            questionTypeLabel.text?.append(n)
        }
    }
}

extension AddNewMainViewController: SendTitleBack{
    func sendTitleBack(title: String) {
        questionTitleLabel.text = title
    }
}


extension AddNewMainViewController: SendDescriptionBack{
    func sendDescriptionBack(description: String) {
        questionDescriptionLabel.text = description
    }
}
