//
//  AI.swift
//  hackathon
//
//  Created by Trong_iOS on 4/20/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import Foundation

class AI {
    
    public static let sharedInstance = AI()
    
    init() {
        
    }
    
    public struct Time {
        var hour: Int = 0
        var minute: Int = 0
        var second: Int = 0
        init(h: Int, m: Int, s: Int) {
            hour = h
            minute = m
            second = s
        }
    }
    
    // cal goal of user base on weight
    
    func calcWaterIntakeFromWeight(weight: Int) -> Int {
        var intakeWeight: Int
        if (weight <= 10){
            intakeWeight = weight * 100
        }
        else if (weight <= 20){
            let overWeight = weight - 10;
            intakeWeight = 1000 + overWeight * 50
        }
        else if (weight <= 70){
            let overWeight = weight - 20
            intakeWeight = 1500 + overWeight * 20
        }
        else {
            intakeWeight = 2500
        }
        return intakeWeight
    }
    
    // cal goal of user base on age and gender
    
    func calcWaterIntakeFromAge(age: Int, gender: Int) -> Int {
        // gender: 0 - girl, 1 - boy, 2 - any
        var intake: Int
        if (age < 1){
            intake = 800
        }
        else if (age <= 3){
            intake = 1300
        }
        else if (age <= 8){
            intake = 1700
        }
        else if (age <= 13){
            switch(gender){
            case 0:
                intake = 2100
                break
            default:
                intake = 2400
                break
            }
        }
        else if (age <= 18){
            switch(gender){
            case 0:
                intake = 2300
                break
            default:
                intake = 3300
                break
            }
        }
        else {
            switch(gender){
            case 0:
                intake = 2700
                break
            default:
                intake = 3700
            }
        }
        return intake
    }
    
    // cal goal of user base on age, gender and weight

    func calcWaterIntake(weight: Int, age: Int, gender: Int) -> Int {
        let intakeWeight = calcWaterIntakeFromWeight(weight: weight)
        let intakeAge = calcWaterIntakeFromAge(age: age, gender: gender)
        if (intakeWeight > intakeAge) {
            return intakeWeight
        }
        return intakeAge
    }
    
    func convertCelToFah(celcius: Int) -> Int {
        let fahrenheit: Int = (celcius * 9/5) + 32
        return fahrenheit
    }
    
    func getExtraWaterIntakePerHour(temperature: Int, workingCondition: Int) -> Int {
        var extra = 1
        if (temperature > 90){
            extra = 4
        }
        else if (temperature > 85){
            extra = (workingCondition > 1) ? 4 : 3 // easy work: 3
        }
        else if (temperature > 78){
            extra = (workingCondition > 0) ? 3 : 2 // easy work: 2
        }
        return extra
    }
    
    func remindDrinkingWater(curTemp: Int, waterLastHour: Int, curTime: Time, workingCondition: Int, adequateIntake: Int) -> Int {
        // cur_temp: Celcius
        // water_last_hour: ml
        // cur_time:
        // workingCondition: 0 - easy, 1 - moderate, 2 - hard
        var recommend = 0 // 0 - not recommend or 1 - recommend
        let curTempFah = convertCelToFah(celcius: curTemp)
        let extraWater = getExtraWaterIntakePerHour(temperature: curTempFah, workingCondition: workingCondition);
        let waterRequirement = extraWater * (adequateIntake / 15); // assume there are 15 active hours per day
        if ( !((curTime.hour < 6) || (curTime.hour > 23))){
            if (waterLastHour < waterRequirement){
                recommend = 1;
            }	
        }
        return recommend;
    }
}

