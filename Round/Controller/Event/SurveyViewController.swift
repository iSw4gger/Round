
import UIKit
import Firebase
import FirebaseDatabase
import Spring
import Charts


class SurveyViewController: UIViewController {
    
    
    @IBOutlet weak var staticBar: UIView!
    @IBOutlet weak var numQuestionLabel: SpringLabel!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var questionLabel: SpringLabel!
    @IBOutlet weak var surveyTableView: UITableView!
    @IBOutlet weak var previousButton: UIButton!
    
    var questionArray = [Question]()
    let answerBank = AnswersBank()
    var counter = 0
    var receiveEventID: String = ""
    var retrievedQuestion = Question()
    let eventVC = EventViewController()
    let selectAnswer = Answer()
    var numQuestions: Int = 1
    let impact = UIImpactFeedbackGenerator()
    var receiveProvider = ""
    var receiveDepartment = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        surveyTableView.delegate = self
        surveyTableView.dataSource = self
        
        loadProviderOrDepartment()
        surveyTableView.rowHeight = 60
        surveyTableView.separatorColor = UIColor.clear
        retrieveData()
        
    }
    
    func loadProviderOrDepartment(){
        let providerQuestion = Question()
        let answer = AnswersBank()
        providerQuestion.questionTitle = "Provider"
        providerQuestion.questionDescription = "What title best fits your role?"
        providerQuestion.answerArray = answer.loadProviderArray()
        questionArray.append(providerQuestion)

        
        let departmentQuestion = Question()
        departmentQuestion.questionDescription = "Department"
        departmentQuestion.questionDescription = "What department do you currently work in?"
        departmentQuestion.answerArray = answer.loadDepartmentArray()
        questionArray.append(departmentQuestion)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        if counter > 0{
            counter = counter - 1
            numQuestions = numQuestions - 1
            updateProgress()

        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //dismisses multiple VC's.
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateProgress(){
        UIView.animate(withDuration: 1) {
            self.progressBar.frame.size.width = (self.staticBar.frame.size.width / CGFloat(self.questionArray.count) ) * CGFloat(self.counter)
        }
        
        if numQuestions <= questionArray.count{
            numQuestionLabel.text = "Question \(String(numQuestions)) of \(questionArray.count)"
        }
        else{
            print("running")
            numQuestionLabel.text = "Question \(String(numQuestions)) of \(questionArray.count)"
        }
        surveyTableView.reloadData()
    }
    
    
    func determineQuestionType(){
        
        let questionType = questionArray[counter]
        questionLabel.text = questionType.questionDescription
        if questionType.questionType == "Likert"{
            questionType.answerArray = answerBank.loadLikertAnswers()
        }
        if questionType.questionType == "FACES"{
            questionType.answerArray = answerBank.loadFaces()
        }
        if questionType.questionType == "Yes or No"{
            questionType.answerArray = answerBank.loadYesOrNo()
        }
    }


    func endOfSurveyAlert(){
        let alert = UIAlertController(title: "Submit Survey?", message: "Are you sure you want to submit this survey?" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Submit", style: .default) { (action) in
            let transition: CATransition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: nil)
            //self.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    

    
    
    func animateTableView(){
        surveyTableView.reloadData()
        let cells = surveyTableView.visibleCells
        let tableViewHeight = surveyTableView.bounds.size.height
        
        for cell in cells{
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        var delayCounter = 0.0
        for cell in cells{
            UIView.animate(withDuration: 1, delay: Double(delayCounter), usingSpringWithDamping: 5.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 0.1
        }

    }
    
    
    func saveQuestionToDatabase(question: String, title: String, description: String, score: Int, receiveProvider: String, receiveDepartment: String){
        
        let ref = Database.database().reference().child("Event").child(receiveEventID).child("question").child(question)
        
        let question: [String: Any] = ["title": title,
                                  "score": score,
                                  "provider": self.receiveProvider,
                                  "department": self.receiveDepartment,
                                  "description": description]
        

        ref.child("answers").childByAutoId().setValue(question)
    }
}









extension SurveyViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray[counter].answerArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "surveyQuestionCell", for: indexPath) as! SurveyTableViewCell

        
        cell.selectedView.backgroundColor = UIColor.clear
        if counter == 0{
            previousButton.isHidden = true
        }else{
            previousButton.isHidden = false
        }
        
        if !questionArray.isEmpty{
            
            let question = questionArray[counter].answerArray[indexPath.row]
            questionLabel.text = questionArray[counter].questionDescription
            cell.answerCellLabel.text = question.answer
            cell.answerImageView.image = question.answerImage
            cell.answerIndicator.backgroundColor = question.answerIndicator
            cell.answerIndicator.layer.cornerRadius = 7
            
        }
        numQuestionLabel.text = "Question \(String(numQuestions)) of \(questionArray.count)"

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        numQuestions = numQuestions + 1
        impact.impactOccurred()
        
        self.surveyTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

        
        let selAnswer = questionArray[counter].answerArray[indexPath.row]
        let selQuestion = questionArray[counter]
        

        if counter == 0{
            receiveProvider = questionArray[counter].answerArray[indexPath.row].answer!
        }
        
        if counter == 1{
            receiveDepartment = questionArray[counter].answerArray[indexPath.row].answer!
        }
        
        counter = counter + 1
        if counter >= 3 {
            saveQuestionToDatabase(question: selQuestion.questionTitle, title: selQuestion.questionTitle, description: selQuestion.questionDescription, score: selAnswer.score!, receiveProvider: receiveProvider, receiveDepartment: receiveDepartment)
            tableView.setContentOffset(.zero, animated: true)
            
            self.surveyTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            //surveyTableView.reloadData()

        }
        if counter == questionArray.count{
            //updateProgress()
            endOfSurveyAlert()
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        if counter < questionArray.count-1{
            updateProgress()
            determineQuestionType()
            surveyTableView.reloadData()
        }
        
        if counter == questionArray.count - 1{
            updateProgress()
            determineQuestionType()

            surveyTableView.reloadData()
        }

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    
    func retrieveData(){
        
        let ref = Database.database().reference().child("Event/\(receiveEventID)/question")
        ref.observe(.childAdded){ (snapshot) in
            
            if ( snapshot.value is NSNull ) {
                print("not found")
            }else{
                
                let snapShotValue = snapshot.value as! Dictionary<String, Any>
                let description = snapShotValue["description"] as! String
                let title = snapShotValue["title"] as! String
                let isActive = snapShotValue["isActive"] as! Bool
                let questionType = snapShotValue["question type"] as! String
                let ID = snapShotValue["ID"] as! String
                
                
                let question = Question()
                question.questionDescription = description
                question.questionTitle = title
                question.questionType = questionType
                question.isActive = isActive
                question.ID = ID
                
                if question.questionType == "FACES"{
                    question.answerArray = self.answerBank.loadFaces()
                }
                if question.questionType == "Yes or No"{
                    question.answerArray = self.answerBank.loadYesOrNo()
                }
                if question.questionType == "Likert"{
                    question.answerArray = self.answerBank.loadLikertAnswers()
                }
                
                self.questionArray.append(question)
                self.surveyTableView.reloadData()
            }
        }
        

    }
}
