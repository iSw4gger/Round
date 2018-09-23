

import UIKit

class OptionViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var optionList = ["Completed", "Results", "Create New Question"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OptionTableViewCell", bundle: nil), forCellReuseIdentifier: "default")
        
    }

}

extension OptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") as! OptionTableViewCell
        cell.optionLabel.text = optionList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let option = optionList[indexPath.row]
        if option == "Completed"{
            performSegue(withIdentifier: "segueToCompleted", sender: self)
        }
        if option == "Create New Question"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "addQuestionViewController")
            self.present(controller, animated: true, completion: nil)
        }
        
    }
}


