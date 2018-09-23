//
//  EventViewController.swift
//  Round
//
//  Created by Jared Boynton on 7/28/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EventViewController: UIViewController {
    
    let event = Event()
    var eventArray: [Event] = [Event]()
    var completedEvents: [Event] = [Event]()
    var sendEventID: String = ""
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var bottonView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        setupView()

        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.revealViewController()?.rearViewRevealWidth = 240

    }
 
    @IBAction func optionsButtonPressed(_ sender: Any) {

    }
    
    
    @IBAction func addSurveyButtonPressed(_ sender: Any) {
        
        //if event is currently active, show popup
        if event.isActive == false{
            let alert = UIAlertController(title: "No Active Event", message: "You will need to create an event before completing surveys.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                //empty
                return
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func addEventButtonPressed(_ sender: Any) {
        
        //if event is currently active, show popup
        if event.isActive == true{
            let alert = UIAlertController(title: "Event Active", message: "Cannot add another event while another event is ongoing", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                //empty
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func setupView(){
        
        eventTableView.rowHeight = 273
        addEventButton.layer.cornerRadius = 23
        
        bottonView.layer.shadowColor = UIColor.black.cgColor
        bottonView.layer.shadowOpacity = 1
        bottonView.layer.shadowOffset = CGSize.zero
        bottonView.layer.shadowRadius = 1
        
        addEventButton.layer.shadowColor = UIColor.black.cgColor
        addEventButton.layer.shadowOpacity = 1
        addEventButton.layer.shadowOffset = CGSize.zero
        addEventButton.layer.shadowRadius = 1
                
    }
    
    func retrieveData(){
        
        let eventDB = Database.database().reference().child("Event")
        
        eventDB.observe(.childAdded) { (snapshot) in
            //.value sends back an object type of 'any', so we have to cast it to dictionary.
            let snapShotValue = snapshot.value as! Dictionary<String, Any>

            let date = snapShotValue["date"] as! String
            let time = snapShotValue["time"] as! String
            let location = snapShotValue["location"] as! String
            let isActive = snapShotValue["isActive"] as! Bool
            let eventID = snapShotValue["id"] as! String
            let specialInstructions = snapShotValue["special instructions"] as! String

            //let event = Event()
            self.event.date = date
            self.event.time = time
            self.event.location = location
            self.event.isActive = isActive
            self.event.eventID = eventID
            self.event.specialInstructions = specialInstructions
            

            if self.event.isActive == true{
                self.eventArray.append(self.event)
                //to send over to surveyVC
                self.sendEventID = self.event.eventID
            }
            if self.event.isActive == false{
                self.completedEvents.append(self.event)
            }
            self.eventTableView.reloadData()
            
            for n in self.completedEvents{
                print(n.location)
            }
            
        }
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSurvey"{
            let userVC = segue.destination as! SurveyViewController
            userVC.receiveEventID = sendEventID
            
        }
        
        if segue.identifier == "segueToActiveQuestions"{
            let activeQuestionVC = segue.destination as! ActiveQuestionsViewController
            activeQuestionVC.retrieveID = sendEventID
        }
        
        if segue.identifier == "segueToDashboard"{
            let dashboardVC = segue.destination as! DashboardViewController
            dashboardVC.retrieveID = self.sendEventID
        }
        
        if segue.identifier == "segueToCompleted"{
            let completedVC = segue.destination as! CompletedViewController
            completedVC.completedEventArray = self.completedEvents
            
        }
    }
}






extension EventViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !eventArray.isEmpty{
            return eventArray.count
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as!ActiveTableViewCell
        
        if !eventArray.isEmpty{
            let event = eventArray[indexPath.row]
            
            
            cell.dateLabel.text = event.date
            cell.timeLabel.text = event.time
            cell.locationLabel.text = event.location
            
            
            cell.specialInstructionLabel.text = event.specialInstructions
            cell.specialInstructionLabel.sizeToFit()
            cell.statusIndicator.isHidden = false
            cell.statusIndicator.layer.cornerRadius = 5
            cell.specInstrucStaticLabel.isHidden = false
        }else{
            cell.dateLabel.text = ""
            cell.timeLabel.text = ""
            cell.specialInstructionLabel.text = ""
            cell.locationLabel.text = "No active rounding events"
            cell.statusIndicator.isHidden = true
            cell.specInstrucStaticLabel.isHidden = true
            cell.infoButton.isHidden = true
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if event.isActive == true{
            performSegue(withIdentifier: "segueToDashboard", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if event.isActive == true{
            let complete = UITableViewRowAction(style: .normal, title: "Complete") { (action, indexPath) in
                let ref = Database.database().reference().child("Event").child(self.event.eventID)
                
                let alert = UIAlertController(title: "Are you sure you want to complete this event?", message: "You will no longer be able to complete any more surveys.", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes, I'm sure", style: .default, handler: { (action) in
                    ref.updateChildValues(["isActive" : false])
                    self.eventArray.remove(at: indexPath.row)
                    //tableView.deleteRows(at: [indexPath], with: .fade)
                    self.eventTableView.reloadData()
                    
                    //this allows the user to add another event without closing app
                    self.event.isActive = false
                })
                let noAction = UIAlertAction(title: "Nope", style: .default, handler: { (action) in
                    //empty
                })

                alert.addAction(yesAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)

            }
            complete.backgroundColor = UIColor.flatGreen
            return[complete]
        }
        return nil
    }
    
}
    
    

