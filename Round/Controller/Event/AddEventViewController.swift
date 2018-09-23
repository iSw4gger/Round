

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class AddEventViewController: UIViewController {
    
    @IBOutlet weak var specialInstructionLabel: UILabel!
    @IBOutlet weak var surveyQuestionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var surveyButtonOutlet: UIButton!
    
    var date: String?
    var time: String?
    var location: String?
    var question: String?
    var specialInstructions: String?
    var questionArray = [Question]()
    
    var mainDict = [String:[String:Any]]()
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        ref = Database.database().reference()

    }
    
    
    @IBAction func addSurveyButtonPressed(_ sender: Any) {
        
        if (date ?? "").isEmpty || (time ?? "").isEmpty || (location ?? "").isEmpty || (specialInstructions ?? "").isEmpty || (question ?? "").isEmpty{

            let alert = UIAlertController(title: "You must complete all fields", message: "In order to continue, you must complete all fields.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                return
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    
        }else{
            submitData()
            SVProgressHUD.showSuccess(withStatus: "Event Successfully Added")
        }
    }
    
    @IBAction func dateOfEventButtonPressed(_ sender: Any) {
    }
    
    @IBAction func timeOfEventButtonPressed(_ sender: Any) {
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
    }
    
    @IBAction func surveyQuestionButtonPressed(_ sender: Any) {
    }
    
    @IBAction func specialInstructionButtonPressed(_ sender: Any) {
    }
    
    //FIREBASE
    
    func submitData(){
        ref = Database.database().reference()
        let key = ref.childByAutoId().key
        
        let event: [String: Any] = ["id": key,
                                    "location": location as Any,
                                    "date": date as Any,
                                    "time": time as Any,
                                    "special instructions": specialInstructions as Any,
                                    "isActive": true]
        ref.child("Event").child(key).setValue(event)
        ref.child("Event").child(key).child("question").setValue(mainDict)
        
        
    }
    
    
    func setupView(){
        
        surveyButtonOutlet.layer.shadowColor = UIColor.black.cgColor
        surveyButtonOutlet.layer.shadowOpacity = 1
        surveyButtonOutlet.layer.shadowOffset = CGSize.zero
        surveyButtonOutlet.layer.shadowRadius = 1
        surveyButtonOutlet.layer.cornerRadius = 23

    }
    
    
    //NECESSARY TO IMPLEMENT DELEGATE METHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDate"{
            let dateVC = segue.destination as! DatesViewController
            dateVC.delegate = self
        }
        
        if segue.identifier == "segueToTime"{
            let timeVC = segue.destination as! TimesViewController
            timeVC.delegate = self
        }
        
        if segue.identifier == "segueToLocations"{
            let locationVC = segue.destination as! LocationViewController
            locationVC.delegate = self
        }
        
        if segue.identifier == "segueToQuestions"{
            let questionVC = segue.destination as! QuestionViewController
            questionVC.delegate = self
        }
        
        if segue.identifier == "segueToSpecial"{
            let specialVC = segue.destination as! SpecialInstructionViewController
            specialVC.delegate = self
        }
        
    }
}





//IMPLEMENTING PROTOCOL DELEGATE METHODS

extension AddEventViewController: DateVCDelegate{
    func sendDateBack(date: String) {
        dateLabel.text = date
        self.date = date
    }
}

extension AddEventViewController: TimeVCDelegate{
    func sendTimeBack(date: String) {
        timeLabel.text = date
        self.time = date
    }
}

extension AddEventViewController: LocationVCDelegate{
    func sendLocationBack(location: [Location]) {
        locationLabel.text = ""
        for n in location{
            if location.count > 1{
                locationLabel.text?.append("\(n.location)" + "\n")
            }else{
                locationLabel.text?.append(n.location)
            }
            self.location = n.location
        }
        
    }

}

extension AddEventViewController: QuestionVCDelegate{
    
    func sendNumQuestionBack(number: String) {
        surveyQuestionLabel.text = number
        self.question = number
    }
    
    func sendArrayBack(questions: [Question]) {
        self.questionArray = questions
        for n in questions{
            let key = ref.childByAutoId().key
            mainDict[n.questionTitle] =
                    ["ID": key,
                    "title": n.questionTitle,
                    "description": n.questionDescription,
                    "score": n.score,
                    "isActive": n.isActive,
                    "isSelected": n.isSelected,
                    "question type": n.questionType as Any]
            
        }
    }
}

extension AddEventViewController: SpecialVCDelegate{
    func sendSpecialInstructions(instructions: String) {
        self.specialInstructions = instructions
        self.specialInstructionLabel.text = instructions
    }
    
    
}


