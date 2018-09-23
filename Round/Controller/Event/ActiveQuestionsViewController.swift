

import UIKit
import Firebase
import FirebaseDatabase

class ActiveQuestionsViewController: UIViewController {
    
    var activeQuestions = [Question]()
    var retrieveID = ""

    @IBOutlet weak var activeQuestionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(retrieveID)
        retrieveData()
        activeQuestionTableView.dataSource = self
        activeQuestionTableView.delegate = self
        activeQuestionTableView.rowHeight = 110
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func retrieveData(){
        
        //will need to send over the ID of the event and add to this reference.
        let ref = Database.database().reference().child("Event/\(retrieveID)/question")
        
        ref.observe(.childAdded){ (snapshot) in
            
            if ( snapshot.value is NSNull ) {
                print("not found")
            }else{
                let snapShotValue = snapshot.value as! Dictionary<String, Any>
                let description = snapShotValue["description"] as! String
                let title = snapShotValue["title"] as! String
                //let score = snapShotValue["score"] as! Int
                let isActive = snapShotValue["isActive"] as! Bool
                let questionType = snapShotValue["question type"] as! String
                let ID = snapShotValue["ID"] as! String
                
                
                let question = Question()
                question.questionDescription = description
                question.questionTitle = title
                question.questionType = questionType
                //question.score = score
                question.isActive = isActive
                question.ID = ID
                self.activeQuestions.append(question)
                for n in self.activeQuestions{
                    print(n.questionTitle)
                }
                self.activeQuestionTableView.reloadData()
            }
            self.activeQuestionTableView.reloadData()

        }
    }
}


extension ActiveQuestionsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeTableViewCell", for: indexPath) as! QuestionTableViewCell
        
        if !activeQuestions.isEmpty{
            let active = activeQuestions[indexPath.row]
            cell.questionTitle.text = active.questionTitle
            cell.questionDescription.text = active.questionDescription
            cell.questionType.text = active.questionType
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Float.ulpOfOne)
    }
    
    
}
