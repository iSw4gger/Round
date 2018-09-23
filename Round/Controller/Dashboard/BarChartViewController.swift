
import UIKit
import Charts

class BarChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var barChartTitleLabel: UILabel!
    
    var numberOfSurveys = [Double]()
    var xAxisPoints = [String]()
    var dataEntry: [BarChartDataEntry] = []
    var department = false
    var provider = false
    var averageScoreEndUser = false
    var averageScoreSurveyQuestion = false
    var averageScoreDepartment = false
    var sendDetailsOver = ""
    
    //receive data from DB VC
    var surveyResultsArray = [DashboardResults]()

    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
        barChartSetup()
        barChartView.delegate = self
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Bar selected")
        let intX = Int(highlight.x)
        if intX < xAxisPoints.count{
            sendDetailsOver = xAxisPoints[intX]
            performSegue(withIdentifier: "segueToDetail", sender: self)
        }
    }
    
    
    func barChartSetup(){
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
    
    func setBarChart(dataPoints: [String], values: [Double]){
        
        //no data
        barChartView.noDataText = "No Data Available"
        barChartView.noDataTextColor = UIColor.white
        barChartView.backgroundColor = UIColor.white
        
        for i in 0..<dataPoints.count{
            let dataPoint = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntry.append(dataPoint)
            
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "Number of Surveys")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
        chartDataSet.colors = ChartColorTemplates.joyful()

        let formatter: ChartFormatter = ChartFormatter()
        let xaxis: XAxis = XAxis()
        xaxis.valueFormatter = formatter
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        formatter.setValues(values: dataPoints)
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelRotationAngle = 90

        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.chartDescription?.enabled = false
        barChartView.highlightPerTapEnabled = true
        barChartView.legend.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = true
        barChartView.highlightFullBarEnabled = true
        
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1.0
        barChartView.xAxis.decimals = 2
        barChartView.xAxis.labelCount = xAxisPoints.count
        barChartView.data = chartData
    }
    
    func populateData(){
        xAxisPoints = []
        numberOfSurveys = []
        var count = [String: Double]()
        if department == true{
            barChartTitleLabel.text = "Total Surveys by Department"
            for item in surveyResultsArray{
                count[item.department] = (count[item.department] ?? 0) + 1
            }
        }
        
        if provider == true{
            barChartTitleLabel.text = "Total Surveys by End User"
            for item in surveyResultsArray{
                count[item.provider] = (count[item.provider] ?? 0) + 1

            }
        }
        
        if averageScoreSurveyQuestion == true{
            getAverageScoreSurveyQuestion()
        }
        
        if averageScoreEndUser == true{
            getAverageScoreEndUser()
        }
        
        if averageScoreDepartment == true{
            getAverageScoreDepartment()
        }
        
        let dictValInc = count.sorted(by: { $0.value > $1.value })

        for (key, value) in dictValInc {
            xAxisPoints.append(key)
            numberOfSurveys.append(value)
        }
        
        setBarChart(dataPoints: xAxisPoints, values: numberOfSurveys)
        
    }

    func getAverageScoreSurveyQuestion(){
        barChartTitleLabel.text = "Average Score by Survey Question"
        var dict = [String: [Int]]()
        for n in surveyResultsArray{
            let titleKey = n.dashboardTitle
            if let titleRecord = dict[titleKey] {
                dict[titleKey] = titleRecord + [n.score]
            } else {
                dict[titleKey] = [n.score]
            }
            print("when does this run")
        }
        let dictValInc = dict.sorted(by: { $0.value[0] > $1.value[0] })

        for (key,value) in dictValInc{
            let total = Double(value.reduce(0, +))
            let count = Double(value.count)
            let average = total/count
            xAxisPoints.append(key)
            numberOfSurveys.append(average)
            }
        }
    
    func getAverageScoreEndUser(){
        barChartTitleLabel.text = "Average Score by End User"

        var dict = [String: [Int]]()
        for n in surveyResultsArray{
            let titleKey = n.provider
            if let titleRecord = dict[titleKey] {
                dict[titleKey] = titleRecord + [n.score]
            } else {
                dict[titleKey] = [n.score]
            }
            print("when does this run")
        }
        
        for (key,value) in dict{
            let total = Double(value.reduce(0, +))
            let count = Double(value.count)
            let average = total/count
            xAxisPoints.append(key)
            numberOfSurveys.append(average)
        }
    }
    
    func getAverageScoreDepartment(){
        barChartTitleLabel.text = "Average Score by Department"
        var dict = [String: [Int]]()
        for n in surveyResultsArray{
            let titleKey = n.department
            if let titleRecord = dict[titleKey] {
                dict[titleKey] = titleRecord + [n.score]
            } else {
                dict[titleKey] = [n.score]
            }

        }

        for (key,value) in dict{
            let total = Double(value.reduce(0, +))
            let count = Double(value.count)
            let average = total/count
            xAxisPoints.append(key)
            numberOfSurveys.append(average)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetail"{
            let detailVC = segue.destination as! DetailDashboardViewController
            detailVC.detailArray = surveyResultsArray
            detailVC.receiveDetailQuery = sendDetailsOver
        }
    }
    
}






public class ChartFormatter: NSObject, IAxisValueFormatter{
    
    var xAxisPoints = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return xAxisPoints[Int(value)]
    }
    
    public func setValues(values: [String]){
        self.xAxisPoints = values
    }
}


