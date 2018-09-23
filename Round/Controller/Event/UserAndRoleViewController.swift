//
//  UserAndRoleViewController.swift
//  Round
//
//  Created by Jared Boynton on 8/10/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit
import Spring

class UserAndRoleViewController: UIViewController {

    
    @IBOutlet weak var staticBar: UIView!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var numQuestions: SpringLabel!
    @IBOutlet weak var previousButton: UIButton!
    var receiveEventID: String = ""
    @IBOutlet weak var userAndRoleTableView: UITableView!
    @IBOutlet weak var questionLabel: SpringLabel!
    var providerOrDepartmentArray = [String]()
    var answerBank = AnswersBank()
    var isSelected = false
    var counter = 0
    var questions = ["What title best fits your role?",
                     "What department do you currently work in?"]
    var questionCounter: Int = 1
    let impact = UIImpactFeedbackGenerator()
    var department: String?
    var provider: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTempView(title: "Demographics")

        
        self.userAndRoleTableView.delegate = self
        self.userAndRoleTableView.dataSource = self
        self.userAndRoleTableView.rowHeight = 60
        self.providerOrDepartmentArray = self.answerBank.loadProviderArray()
        self.questionLabel.text = self.questions[self.counter]
        self.updateProgress()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createTempView(title: "Demographics")
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateQuestion(){
        if counter <= questions.count - 1{
            questionLabel.text = questions[counter]
        }
    }
    
    func updateProgress(){
        numQuestions.animate()
        questionLabel.animate()
        UIView.animate(withDuration: 1) {
            self.progressBar.frame.size.width = (self.staticBar.frame.size.width / CGFloat(2) ) * CGFloat(self.counter)
        }
        
        if questionCounter <= 2{
            numQuestions.text = "Question \(String(questionCounter)) of \(2)"
        }
        else{
            print("running")
            numQuestions.text = "Question \(String(2)) of \(2)"
            
        }
    }
    
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        if counter != 0{
            counter = counter - 1
        }
        questionCounter = questionCounter - 1
        updateQuestion()
        updateProgress()
        userAndRoleTableView.reloadData()
        
    }
    
    
    
    
    func animateTableView(){
        userAndRoleTableView.reloadData()
        let cells = userAndRoleTableView.visibleCells
        
        let tableViewHeight = userAndRoleTableView.bounds.size.height
        
        for cell in cells{
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        var delayCounter = 0.5
        for cell in cells{
            UIView.animate(withDuration: 1, delay: Double(delayCounter), usingSpringWithDamping: 5.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 0.1
        }
    }
    
    func createTempView(title: String){
        let tempView = SpringView(frame: self.view.frame)
        tempView.tag = 0
        let label = UILabel()

        tempView.backgroundColor = UIColor.white
        DispatchQueue.main.async {
            tempView.animation = "slideUp"
            tempView.animate()
        }

        self.view.addSubview(tempView)
        label.frame = CGRect(x: self.view.frame.height/2, y: self.view.frame.width/2, width: self.view.frame.width, height: 100)
        label.center = tempView.center
        label.textAlignment = .center
        label.text = title
        label.font = UIFont(name: "EuphemiaUCAS-Bold", size: 20)
        label.textColor = UIColor.darkGray
        tempView.addSubview(label)
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (timer) in
                tempView.animation = "fadeOut"
                tempView.duration = 0.5
                tempView.animate()
            }
        }
        

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSurvey"{
            let surveyVC = segue.destination as! SurveyViewController
            surveyVC.receiveEventID = receiveEventID
            surveyVC.receiveProvider = provider!
            surveyVC.receiveDepartment = department!
            
        }
    }}



extension UserAndRoleViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return providerOrDepartmentArray.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userQuestionCell", for: indexPath) as! UserAndRoleTableViewCell
        
        if counter == 0{
            providerOrDepartmentArray = answerBank.loadProviderArray()
            providerOrDepartmentArray = providerOrDepartmentArray.sorted(by: <)
            let answer = providerOrDepartmentArray[indexPath.row]
            cell.userOrRoleLabel.text = answer
            previousButton.isHidden = true
            
        }else{
            providerOrDepartmentArray = answerBank.loadDepartment()
            providerOrDepartmentArray = providerOrDepartmentArray.sorted(by: <)
            let answer = providerOrDepartmentArray[indexPath.row]
            cell.userOrRoleLabel.text = answer
            previousButton.isHidden = false
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if questionCounter == 1{
            provider = answerBank.loadProviderArray()[indexPath.row]
            questionCounter = questionCounter + 1
        }
        counter = counter + 1
        updateQuestion()
        impact.impactOccurred()
        updateProgress()
        providerOrDepartmentArray.removeAll()
        providerOrDepartmentArray = answerBank.loadDepartment()
                
        if questionCounter == 2{
            if answerBank.loadDepartment().count >= indexPath.row{
                department = answerBank.loadDepartment()[indexPath.row]
            }
        }
        
        if counter == 2{
            _ = Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) { (timer) in
                self.createTempView(title: "Survey Questions")
            }
            _ = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (timer) in
                self.performSegue(withIdentifier: "segueToSurvey", sender: self )
            }
        }
        //questionCounter = questionCounter + 1
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

}
