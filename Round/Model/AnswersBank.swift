//
//  AnswersBank.swift
//  Round
//
//  Created by Jared Boynton on 8/5/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import Foundation

class AnswersBank{
    
    func loadLikertAnswers() -> [Answer]{
        
        var answerArray = [Answer]()
        
        let highlySatisfiedAnswer = Answer()
        highlySatisfiedAnswer.answer = "Highly Satisfied"
        highlySatisfiedAnswer.score = 5
        highlySatisfiedAnswer.answerIndicator = UIColor.flatGreenDark
        answerArray.append(highlySatisfiedAnswer)
        
        let satisfiedAnswer = Answer()
        satisfiedAnswer.answer = "Satisfied"
        satisfiedAnswer.score = 4
        satisfiedAnswer.answerIndicator = UIColor.flatGreen
        answerArray.append(satisfiedAnswer)
        
        let neutralAnswer = Answer()
        neutralAnswer.answer = "Neutral"
        neutralAnswer.score = 3
        neutralAnswer.answerIndicator = UIColor.flatYellow
        answerArray.append(neutralAnswer)

        
        let dissatisfiedAnswer = Answer()
        dissatisfiedAnswer.answer = "Dissatisfied"
        dissatisfiedAnswer.score = 2
        dissatisfiedAnswer.answerIndicator = UIColor.flatOrange
        answerArray.append(dissatisfiedAnswer)

        
        let highlyDissatisfiedAnswer = Answer()
        highlyDissatisfiedAnswer.answer = "Highly Dissatisfied"
        highlyDissatisfiedAnswer.score = 1
        highlyDissatisfiedAnswer.answerIndicator = UIColor.flatRed
        answerArray.append(highlyDissatisfiedAnswer)

        return answerArray
    }
    
    func loadYesOrNo() -> [Answer]{
        
        var answer = [Answer]()
        
        let yesAnswer = Answer()
        yesAnswer.answer = "Yes"
        yesAnswer.score = 5
        yesAnswer.answerIndicator = UIColor.flatGreen
        answer.append(yesAnswer)
        
        let noAnswer = Answer()
        noAnswer.answer = "No"
        noAnswer.score = 1
        noAnswer.answerIndicator = UIColor.flatRed
        answer.append(noAnswer)
        
        return answer
    }
    
    func loadFaces() -> [Answer]{
    
        var answer = [Answer]()
        
        let happyAnswer = Answer()
        happyAnswer.answerImage = UIImage(named: "happy")
        happyAnswer.score = 5
        happyAnswer.answer = "No Hurt"
        answer.append(happyAnswer)
        
        let kindOfHappyAnswer = Answer()
        kindOfHappyAnswer.answerImage = UIImage(named: "happy")
        kindOfHappyAnswer.score = 4
        kindOfHappyAnswer.answer = "Hurts a Little Bit"
        answer.append(kindOfHappyAnswer)
        
        let neutralAnswer = Answer()
        neutralAnswer.answerImage = UIImage(named: "happy")
        neutralAnswer.score = 3
        neutralAnswer.answer = "Hurts a Little More"
        answer.append(neutralAnswer)
        
        let kindOfUpsetAnswer = Answer()
        kindOfUpsetAnswer.answerImage = UIImage(named: "happy")
        kindOfUpsetAnswer.score = 2
        kindOfUpsetAnswer.answer = "Hurts a Whole Lot"
        answer.append(kindOfUpsetAnswer)
        
        let upsetAnswer = Answer()
        upsetAnswer.answerImage = UIImage(named: "happy")
        upsetAnswer.score = 1
        upsetAnswer.answer = "Hurts the Worst"
        answer.append(upsetAnswer)
        return answer
    
    }
    
    func loadProviderArray() -> [String]{
        
        let answer = ["Physician", "Nurse", "Nurse Practitioner", "Pharmacist", "Lab Tech", "PCA", "Respiratory Therapist", "Occupational Therapist", "Physical Therapist", "Dietician", "Medical Assistant", "Case Manager", "Social Worker", "Rad Tech", "Speech Therapist", "Other"]
        return answer
    }
    
    func loadDepartment() -> [String]{
        
        let answer = ["Med Surg", "Critical Care", "Perioperative", "Emergency Department", "Laboratory", "Radiology", "Pharmacy", "Imaging", "Admitting", "HIM", "Non-Invasive Cardiology", "Dietary", "Case Management", "Social Services", "Physical Therapy", "Occupational Therapy", "Speech Therapy", "Respiratory Care", "Other"]
        return answer
    }
    
    func loadProviderArray() -> [Answer]{
        
        var answer = [Answer]()
        var answerArray = ["Physician", "Nurse", "Nurse Practitioner", "Pharmacist", "Lab Tech", "PCA", "Respiratory Therapist", "Occupational Therapist", "Physical Therapist", "Dietician", "Medical Assistant", "Case Manager", "Social Worker", "Rad Tech", "Speech Therapist", "Other"]
        answerArray = answerArray.sorted(by: <)

        for n in answerArray{
            let answerObject = Answer()
            answerObject.answer = n
            answer.append(answerObject)
        }

        return answer
    }
    
    func loadDepartmentArray() -> [Answer]{
        
        var answer = [Answer]()
        
        var answerArray = ["Med Surg", "Critical Care", "Perioperative", "Emergency Department", "Laboratory", "Radiology", "Pharmacy", "Imaging", "Admitting", "HIM", "Non-Invasive Cardiology", "Dietary", "Case Management", "Social Services", "Physical Therapy", "Occupational Therapy", "Speech Therapy", "Respiratory Care", "Other"]
        answerArray = answerArray.sorted(by: <)


        for n in answerArray{
            let answerObject = Answer()
            answerObject.answer = n
            answer.append(answerObject)
        }
        
        
        return answer
    }
    
}


