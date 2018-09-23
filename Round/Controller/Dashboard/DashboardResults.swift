


import Foundation
import Firebase
import FirebaseDatabase

class DashboardResults{
    
    var dashboardTitle = ""
    var dashboardDescription = ""
    var dashboardSummary = ""
    var provider = ""
    var department = ""
    var score = 0
    var totalSurveys = 0
    var isSelected = false
    var questionDescription = ""
    //used to query firebase for specific answers
    var questionTitle = ""
    var xAxisPoint = [String]()
    var resultsArray = [Double]()

}




