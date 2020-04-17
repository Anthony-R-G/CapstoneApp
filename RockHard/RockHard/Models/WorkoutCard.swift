//
//  WorkoutModel.swift
//  RockHard
//
//  Created by albert coelho oliveira on 2/6/20.
//  Copyright © 2020 Rockstars. All rights reserved.
//

import Foundation

struct WorkoutCard: Codable {
    let workoutDay: String
    let workoutName: String
    let exercises: [Exercise]
    
    init?(from dict: [String: Any]) {
            guard let workoutDay = dict["workoutDay"] as? String,
                let workoutName = dict["workoutName"] as? String,
                let exercises = (dict["exercises"] as? [[String: Any]]) else { return nil }
            self.workoutDay = workoutDay
            self.workoutName = workoutName
            self.exercises = exercises.compactMap({Exercise(from: $0) })
        }
    var fieldsDict: [String: Any] {
              return [
                  "workoutDay": self.workoutDay,
                  "workoutName": self.workoutName ,
                  "exercises": self.exercises.map({$0.fieldsDict})]
          }
    init( workoutDay: String,workoutName: String,exercises: [Exercise]  ){
        self.exercises = exercises
        self.workoutName = workoutName
        self.workoutDay = workoutDay
    }
}