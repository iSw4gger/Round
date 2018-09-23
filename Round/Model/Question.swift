//
//  Question.swift
//  Round
//
//  Created by Jared Boynton on 7/4/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class Question{
    
    var questionTitle = ""
    var questionDescription = ""
    var isActive = false
    var isSelected = false
    var score = 0
    var questionType = ""
    var ID = ""
    var answer = Answer()
    var answerArray = [Answer]()
    var answerDict = [String: Answer]()
    
    enum QuestionType: String{
        case Likert = "Likert"
        case YesOrNo = "Yes or No"
        case PainScale = "Pain Scale"
    }
    
}
