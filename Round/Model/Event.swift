//
//  Event.swift
//  Round
//
//  Created by Jared Boynton on 6/30/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import Foundation

class Event{
    
    
    var eventID: String = ""
    var date = ""
    var eventDate = Date()
    var time = ""
    var location: String = ""
    var isActive: Bool = false
    var questionCount: String = ""
    var specialInstructions: String = ""

    
    var questionArray = [Question]()
    
}
