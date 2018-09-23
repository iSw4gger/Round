

import UIKit

protocol SendQuestionType{
    func sendQuestionType(type: [String])
}

class NewQuestionTypeViewController: UIViewController {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleView: UIView!
    var questionTypeArray = ["Likert", "FACES", "Yes or No"]
    var selectedQuestionType = [String]()
    var delegate: SendQuestionType?
    @IBOutlet weak var newQuestionTypeTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        newQuestionTypeTableView.dataSource = self
        newQuestionTypeTableView.delegate = self
        newQuestionTypeTableView.rowHeight = 75
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        delegate?.sendQuestionType(type: selectedQuestionType)
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension NewQuestionTypeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newQuestionCell", for: indexPath) as! NewQuestionTableViewCell
        
        let questionType = questionTypeArray[indexPath.row]
        cell.questionTypeLabel.text = questionType
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedQuestionType.removeAll()
        let questionType = questionTypeArray[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                selectedQuestionType.remove(at: 0)
            } else {
                cell.accessoryType = .checkmark
            selectedQuestionType.append(questionType)
                
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func setupView(){
        mainView.layer.cornerRadius = 15
        titleView.layer.cornerRadius = 15
        //rounds the top corners
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
}
