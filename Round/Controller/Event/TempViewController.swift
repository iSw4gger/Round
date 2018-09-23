//
//import UIKit
//import Firebase
//import FirebaseDatabase
//
//class SurveyViewController: UIViewController {
//    
//    @IBOutlet weak var questionLabel: UILabel!
//    @IBOutlet weak var surveyTableView: UITableView!
//    @IBOutlet weak var previousButton: UIButton!
//    
//    var answerArray = [Answer]()
//    let answerBank = AnswersBank()
//    var retreivedQuestions = [Question]()
//    var selectedAnswerArray = [Answer]()
//    var counter = 0
//    var answerCounter = 0
//    var receiveEventID: String = ""
//    var retrievedQuestion = Question()
//    let eventVC = EventViewController()
//    
//    let selectAnswer = Answer()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        surveyTableView.delegate = self
//        surveyTableView.dataSource = self
//        surveyTableView.rowHeight = 60
//        surveyTableView.separatorColor = UIColor.clear
//        retrieveData()
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        animateTableView()
//    }
//    
//    
//    @IBAction func previousButtonPressed(_ sender: Any) {
//        if counter != 0{
//            counter = counter - 1
//        }
//        surveyTableView.reloadData()
//    }
//    
//    
//    @IBAction func cancelButtonPressed(_ sender: Any) {
//        //dismisses multiple VC's.
//        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//    }
//    
//    
//    func determineQuestionType(){
//        //update the answers tableView UI
//        if retreivedQuestions[counter].questionType == "Likert"{
//            answerArray = answerBank.loadLikertAnswers()
//        }
//        if retreivedQuestions[counter].questionType == "Yes or No"{
//            answerArray = answerBank.loadYesOrNo()
//        }
//        if retreivedQuestions[counter].questionType == "FACES"{
//            answerArray = answerBank.loadFaces()
//        }
//    }
//    
//    func nextSurveyQuestion(){
//        counter = counter + 1
//        
//        if counter < retreivedQuestions.count-1{
//            questionLabel.text = retreivedQuestions[counter].questionDescription
//            determineQuestionType()
//            selectedAnswerArray.removeAll()
//        }
//        else{
//            counter = 0
//        }
//        surveyTableView.reloadData()
//        return
//        
//    }
//    
//    
//    func endOfSurveyAlert(){
//        let alert = UIAlertController(title: "Submit Survey?", message: "Are you sure you want to submit this survey?" , preferredStyle: .alert)
//        let action = UIAlertAction(title: "Submit", style: .default) { (action) in
//            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//        }
//        
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
//    
//    
//    
//    
//    
//    func animateTableView(){
//        surveyTableView.reloadData()
//        let cells = surveyTableView.visibleCells
//        let tableViewHeight = surveyTableView.bounds.size.height
//        
//        for cell in cells{
//            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
//        }
//        var delayCounter = 0.0
//        for cell in cells{
//            UIView.animate(withDuration: 0.2, delay: Double(delayCounter), usingSpringWithDamping: 5.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: {
//                cell.transform = CGAffineTransform.identity
//            }, completion: nil)
//            delayCounter += 0.1
//        }
//    }
//    
//    
//    func saveQuestionToDatabase(answer: [Answer]){
//        print(answerCounter)
//        
//        if answerCounter < retreivedQuestions.count-1{
//            let ref = Database.database().reference().child("Event/\(self.receiveEventID)/question/\(retreivedQuestions[answerCounter].questionTitle)/Answers").childByAutoId()
//            
//            let dict: [String: Any] = ["score": answer[0].score!, "answer": answer[0].answer]
//            
//            ref.updateChildValues(dict, withCompletionBlock:{error, ref in
//                
//                if error != nil{
//                    print(error!)
//                }
//                else{
//                    print("OK")
//                }
//                
//            })
//        }
//        
//        if answerCounter == retreivedQuestions.count - 1{
//            print("Running inside 2nd")
//            nextSurveyQuestion()
//            let ref = Database.database().reference().child("Event/\(self.receiveEventID)/question/\(retreivedQuestions[answerCounter].questionTitle)/Answers").childByAutoId()
//            
//            let dict: [String: Any] = ["score": answer[0].score!, "answer": answer[0].answer]
//            
//            ref.updateChildValues(dict, withCompletionBlock:{error, ref in
//                
//                if error != nil{
//                    print(error!)
//                }
//                else{
//                    print("OK")
//                    //makes the last view blank
//                    self.questionLabel.text = "End"
//                    self.answerArray.removeAll()
//                    let answer = Answer()
//                    answer.answer = ""
//                    self.answerArray.append(answer)
//                    self.surveyTableView.reloadData()
//                    self.endOfSurveyAlert()
//                    self.answerCounter = 0
//                    self.counter = 0
//                    
//                }
//            })
//            
//        }
//        
//        answerCounter = answerCounter + 1
//        nextSurveyQuestion()
//        animateTableView()
//        
//    }
//    
//}
//
//
//
//
//
//
//
//
//
//extension SurveyViewController: UITableViewDataSource, UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return answerArray.count
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "surveyQuestionCell", for: indexPath) as! SurveyTableViewCell
//        
//        if !answerArray.isEmpty{
//            
//            let answers = answerArray[indexPath.row]
//            cell.answerCellLabel.text = answers.answer
//            cell.answerImageView.image = answers.answerImage
//            cell.answerIndicator.backgroundColor = answers.answerIndicator
//            cell.answerIndicator.layer.cornerRadius = 7
//            
//            if answers.isSelected == true{
//                //not using
//            }else{
//                cell.accessoryType = .none
//                cell.selectedView.backgroundColor = UIColor.clear
//            }
//            
//        }
//        
//        if counter == 0{
//            previousButton.isHidden = true
//        }else{
//            previousButton.isHidden = false
//        }
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        var selectedAnswer = [Answer]()
//        let selAnswer = answerArray[indexPath.row]
//        
//        selectedAnswer.append(selAnswer)
//        
//        saveQuestionToDatabase(answer: selectedAnswer)
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//    }
//    
//    func retrieveData(){
//        
//        //will need to send over the ID of the event and add to this reference.
//        let ref = Database.database().reference().child("Event/\(receiveEventID)/question")
//        
//        //        let ref = Database.database().reference().child("Event/-LJG33qWTluMUrrny9f9/question")
//        ref.observe(.childAdded){ (snapshot) in
//            
//            if ( snapshot.value is NSNull ) {
//                print("not found")
//            }else{
//                
//                let snapShotValue = snapshot.value as! Dictionary<String, Any>
//                let description = snapShotValue["description"] as! String
//                let title = snapShotValue["title"] as! String
//                //let score = snapShotValue["score"] as! Int
//                let isActive = snapShotValue["isActive"] as! Bool
//                let questionType = snapShotValue["question type"] as! String
//                let ID = snapShotValue["ID"] as! String
//                
//                
//                print("question type \(questionType)")
//                let question = Question()
//                
//                question.questionDescription = description
//                question.questionTitle = title
//                question.questionType = questionType
//                //question.score = score
//                question.isActive = isActive
//                question.ID = ID
//                
//                self.retreivedQuestions.append(question)
//                
//                if !self.retreivedQuestions.isEmpty{
//                    //THIS IS CAUSING ISSUES WITH THE SAVING TO FIREBASE
//                    self.questionLabel.text = self.retreivedQuestions[self.counter].questionDescription
//                    if self.retreivedQuestions[self.counter].questionType == "Yes or No"{
//                        self.answerArray = self.answerBank.loadYesOrNo()
//                        self.surveyTableView.reloadData()
//                    }
//                    if self.retreivedQuestions[self.counter].questionType == "Likert"{
//                        self.answerArray = self.answerBank.loadLikertAnswers()
//                        self.surveyTableView.reloadData()
//                    }
//                    if self.retreivedQuestions[self.counter].questionType == "FACES"{
//                        self.answerArray = self.answerBank.loadFaces()
//                        self.surveyTableView.reloadData()
//                    }
//                    //add FACES here
//                }
//                self.surveyTableView.reloadData()
//                
//            }
//        }
//        
//    }
//    
//}
