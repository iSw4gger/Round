


import UIKit
import Charts
import Firebase
import FirebaseDatabase


class DashboardViewController: UIViewController {
    
    @IBOutlet weak var dbViewHolder3: UIView!
    @IBOutlet weak var dbViewHolder2: UIView!
    @IBOutlet weak var dBViewHolder1: UIView!
    @IBOutlet weak var resultTableView: UITableView!
    var resultArray = [DashboardResults]()
    var isDepartment = false
    var isProvider = false
    var averageScoreEndUser = false
    var averageScoreSurveyQuestion = false
    var averageScoreDepartment = false
    var yAxisPoints = [Int]()
    var xAxisPoints = [String]()
    var retrieveID = ""
    @IBOutlet weak var numberSurveysLabel: UILabel!
    @IBOutlet weak var averageScoreLabel: UILabel!
    @IBOutlet weak var numberDisciplinesLabel: UILabel!
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    var fromCompleted = false

    
    
    //stores the title of the dashboard; Results by End User, Results by Department, etc.
    var results = DashboardResults()
    
    //stores data about all answers; score, provider, department, surveyTitle
    var surveyResultsArray = [DashboardResults]()

    var scoreArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupArray()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.rowHeight = 120
        retrieveQuestionTitles()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        isDepartment = false
        isProvider = false
        averageScoreEndUser = false
        averageScoreSurveyQuestion = false
        averageScoreDepartment = false
        print("in VWA")
    }

    
    func setupArray(){

        let endUser = DashboardResults()
        endUser.dashboardTitle = "Total Surveys by End User"
        endUser.dashboardDescription = "Displays total number of survey questions completed by provider type."
        resultArray.append(endUser)
        
        let department = DashboardResults()
        department.dashboardTitle = "Total Surveys by Department"
        department.dashboardDescription = "Displays total number of surveys questions completed for each department."
        resultArray.append(department)
        
        let  averageScore = DashboardResults()
        averageScore.dashboardTitle = "Average Score by Survey Question"
        averageScore.dashboardDescription = "Takes the overall total number of survey results per question and computes an average. The scoring range is 1-5, 5 being the best and 1 being the worst."
        resultArray.append(averageScore)
        
        let endUserAverage = DashboardResults()
        endUserAverage.dashboardTitle = "Average Score by End User"
        endUserAverage.dashboardDescription = "Displays an overall average score for each provider type. The scoring range is 1-5, 5 being the best and 1 being the worst."
        resultArray.append(endUserAverage)
        
        let departmentAverage = DashboardResults()
        departmentAverage.dashboardTitle = "Average Score by Department"
        departmentAverage.dashboardDescription = "Displays an overall average score for each department. The scoring range is 1-5, 5 being the best and 1 being the worst."
        resultArray.append(departmentAverage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chartVC = segue.destination as! BarChartViewController
        chartVC.surveyResultsArray = self.surveyResultsArray
        chartVC.xAxisPoints = self.xAxisPoints
        chartVC.department = self.isDepartment
        chartVC.provider = self.isProvider
        chartVC.averageScoreSurveyQuestion = self.averageScoreSurveyQuestion
        chartVC.averageScoreEndUser = self.averageScoreEndUser
        chartVC.averageScoreDepartment = self.averageScoreDepartment
    }
    
    func applyDisciplineCountLabel(){
        xAxisPoints.removeAll()
        var dict = [String: [Int]]()
        for n in surveyResultsArray{
            let titleKey = n.provider
            if let titleRecord = dict[titleKey] {
                dict[titleKey] = titleRecord + [n.score]
            } else {
                dict[titleKey] = [n.score]
            }
        }
        
        for (key,_) in dict{
            xAxisPoints.append(key)
        }
        numberDisciplinesLabel.text = String(xAxisPoints.count)
    }
    
    //drag to dismiss
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        if fromCompleted == true{
            let touchPoint = sender.location(in: self.view?.window)
            
            if sender.state == UIGestureRecognizer.State.began {
                initialTouchPoint = touchPoint
            } else if sender.state == UIGestureRecognizer.State.changed {
                if touchPoint.y - initialTouchPoint.y > 0 {
                    self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }
            } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
                if touchPoint.y - initialTouchPoint.y > 100 {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    })
                }
            }
        }
    }
}
    






//TABLE VIEW CALLS
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath) as! DashboardTableViewCell
        
        if !resultArray.isEmpty{
            let result = resultArray[indexPath.row]
            cell.titleLabel.text = result.dashboardTitle
            cell.descriptionLabel.text = result.dashboardDescription
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        print(resultArray[indexPath.row].dashboardTitle)
        let result = resultArray[indexPath.row].dashboardTitle
        if result == "Total Surveys by Department"{
            isDepartment = true
            for n in surveyResultsArray{
                xAxisPoints.append(n.department)
            }
            performSegue(withIdentifier: "segueToChart", sender: self)

        }
        
        if result == "Total Surveys by End User"{
            isProvider = true
            for n in surveyResultsArray{
                xAxisPoints.append(n.provider)
            }
            performSegue(withIdentifier: "segueToChart", sender: self)
        }
        
        if result == "Average Score by Survey Question"{
            averageScoreSurveyQuestion = true
            performSegue(withIdentifier: "segueToChart", sender: self)
        }
        
        if result == "Average Score by End User"{
            averageScoreEndUser = true
            performSegue(withIdentifier: "segueToChart", sender: self)
        }
        
        if result == "Average Score by Department"{
            averageScoreDepartment = true
            performSegue(withIdentifier: "segueToChart", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0005
    }
}





//FIREBASE CALLS
extension DashboardViewController{
    
    func retrieveData(surveyQuestion: String){
        let ref = Database.database().reference().child("Event/\(retrieveID)/question/\(surveyQuestion)/answers")
        ref.observe(.childAdded){ (snapshot) in

            if ( snapshot.value is NSNull ) {
                print("not found")
            }else{
                
                let snapShotValue = snapshot.value as! Dictionary<String, Any>
                let title = snapShotValue["title"] as! String
                let score = snapShotValue["score"] as! Int
                let department = snapShotValue["department"] as! String
                let provider = snapShotValue["provider"] as! String
                let description = snapShotValue["description"] as! String
                
                let dashboardResults = DashboardResults()
                dashboardResults.dashboardDescription = description
                dashboardResults.dashboardTitle = title
                dashboardResults.score = score
                dashboardResults.department = department
                dashboardResults.provider = provider
                self.surveyResultsArray.append(dashboardResults)

            }
            
            self.numberSurveysLabel.text = String(self.surveyResultsArray.count)
            
            var score:Double = 0.0
            for n in self.surveyResultsArray{
                score += Double(n.score)
            }
            
            score = score/Double(self.surveyResultsArray.count)
            let doubleScore = String(format: "%.1f", score)
            self.averageScoreLabel.text = doubleScore
            self.applyDisciplineCountLabel()
            print(self.xAxisPoints.count)
        }
    }
    
    func retrieveQuestionTitles(){
        //will need to send over the ID of the event and add to this reference.
        var questionTitle = [DashboardResults]()
        let ref = Database.database().reference().child("Event/\(retrieveID)/question")
        ref.observe(.childAdded){ (snapshot) in
            if ( snapshot.value is NSNull ) {
                print("not found")
            }else{
                let snapShotValue = snapshot.value as! Dictionary<String, Any>
                let title = snapShotValue["title"] as! String
                
                let dashboardQuestionTitle = DashboardResults()
                dashboardQuestionTitle.questionTitle = title
                questionTitle.removeAll()
                questionTitle.append(dashboardQuestionTitle)
                
                for n in questionTitle{
                    self.retrieveData(surveyQuestion: n.questionTitle)
                }
            }
        }
    }
}
