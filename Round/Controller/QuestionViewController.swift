//
//  QuestionViewController.swift
//  Round
//
//  Created by Jared Boynton on 7/28/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol QuestionVCDelegate{
    func sendNumQuestionBack(number: String)
    func sendArrayBack(questions: [Question])
}

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var addQuestionButtonOutlet: UIButton!
    var questionList = [Question]()
    var selectedQuestions = [Question]()
    var delegate: QuestionVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addAdditionalQuestions()
        loadInitialQuestions()

    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //save to FireBase
        if selectedQuestions.count != 0{
            let num = String(selectedQuestions.count)
            delegate?.sendNumQuestionBack(number: num)
            delegate?.sendArrayBack(questions: selectedQuestions)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewQuestionPressed(_ sender: Any) {
        //performSegue to addNewQuestionVC, then delegate back
    }
    
    
    func loadInitialQuestions(){
        
        let defaultQuestion1 = Question()
        let defaultQuestion2 = Question()
        let defaultQuestion3 = Question()
        
        //question 1
        defaultQuestion1.questionTitle = "Workflow Applicability"
        defaultQuestion1.questionDescription = "Did the training you received apply to your current workflows that you use for your department?"
        defaultQuestion1.isSelected = false
        defaultQuestion1.isActive = false
        defaultQuestion1.questionType = "Likert"
        questionList.append(defaultQuestion1)
        
        //question 2
        defaultQuestion2.questionTitle = "Initial Training"
        defaultQuestion2.questionDescription = "Do you feel like your initial training was sufficient?"
        defaultQuestion2.isSelected = false
        defaultQuestion2.isActive = false
        defaultQuestion2.questionType = "Likert"
        questionList.append(defaultQuestion2)
        
        //question 3
        defaultQuestion3.questionTitle = "Refresher Training"
        defaultQuestion3.questionDescription = "Do you feel like you could benefit from refresher training?"
        defaultQuestion3.isSelected = false
        defaultQuestion3.isActive = false
        defaultQuestion3.questionType = "Likert"
        questionList.append(defaultQuestion3)
        
    }
    
    func addAdditionalQuestions(){
        //user added question from FireBase
        let ref = Database.database().reference().child("Questions")
        
        ref.observe(.childAdded) { (snapshot) in
            
            //.value sends back an object type of 'any', so we have to cast it to dictionary.
            let snapShotValue = snapshot.value as! Dictionary<String, Any>
            
            let title = snapShotValue["title"] as! String
            let description = snapShotValue["description"] as! String
            let type = snapShotValue["type"] as! String
            
            let question = Question()
            
            question.questionTitle = title
            question.questionDescription = description
            question.questionType = type
            
            self.questionList.append(question)
            self.questionTableView.reloadData()
            
        }

        questionTableView.reloadData()
    }
    
    func setupViews(){
        
        addQuestionButtonOutlet.layer.cornerRadius = 15
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.rowHeight = 119
        
    }
    
}





//EXTENDING TO MAKE IT CLEANER

extension QuestionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "surveyCell", for: indexPath) as! QuestionTableViewCell
        
        let question = questionList[indexPath.row]
        cell.questionTitle.text = question.questionTitle
        cell.questionDescription.text = question.questionDescription
        cell.questionDescription.sizeToFit()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = questionList[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                question.isSelected = false
                selectedQuestions.remove(at: 0)
            } else {
                cell.accessoryType = .checkmark
                question.isSelected = true
                selectedQuestions.append(question)
            }
        }
        print(question.isSelected)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
