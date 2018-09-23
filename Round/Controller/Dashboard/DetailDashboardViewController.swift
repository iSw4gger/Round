
import UIKit

class DetailDashboardViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailTitle: UILabel!
    var detailArray = [DashboardResults]()
    var filteredDetailArray = [DashboardResults]()
    var receiveDetailQuery = ""
    var isDepartment = false
    var isProvider = false
    var sorted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(receiveDetailQuery)
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.rowHeight = 107
        updateArray()

        detailTitle.text = receiveDetailQuery
    }
    
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Provider", style: .default, handler: { (action) -> Void in
            self.filteredDetailArray = self.filteredDetailArray.sorted(by: { $0.provider < $1.provider })
            self.detailTableView.reloadData()        })
        
        let action2 = UIAlertAction(title: "Department", style: .default, handler: { (action) -> Void in
            self.filteredDetailArray = self.filteredDetailArray.sorted(by: { $0.department < $1.department })
            self.detailTableView.reloadData()        })
        
        let action3 = UIAlertAction(title: "Score (Ascending)", style: .default, handler: { (action) -> Void in
            self.filteredDetailArray = self.filteredDetailArray.sorted(by: { $0.score < $1.score })
            self.detailTableView.reloadData()
            
        })
        
        let action4 = UIAlertAction(title: "Score (Descending)", style: .default, handler: { (action) -> Void in
            self.filteredDetailArray = self.filteredDetailArray.sorted(by: { $0.score > $1.score })
            self.detailTableView.reloadData()
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    
    func updateArray(){
        for n in detailArray{
            print(n.provider)
            print(receiveDetailQuery)
            if n.provider == receiveDetailQuery{
                filteredDetailArray.append(n)
                isDepartment = true
            }
            if n.department == receiveDetailQuery{
                filteredDetailArray.append(n)
                isProvider = true
            }
            if n.dashboardTitle == receiveDetailQuery{
                filteredDetailArray.append(n)
                isDepartment = true
            }
        }
        filteredDetailArray = filteredDetailArray.sorted(by: { $0.score > $1.score })

    }
}

extension DetailDashboardViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailDashboardCell", for: indexPath) as! DetailDashboardTableViewCell
        let result = filteredDetailArray[indexPath.row]
        cell.questionTitle.text = result.dashboardTitle
        cell.questionDescription.text = result.dashboardDescription
        cell.questionScore.text = String(result.score)
        if isDepartment == true{
            cell.detailLabel.text = result.department
        }
        if isProvider == true{
            cell.detailLabel.text = result.provider
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.05
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
