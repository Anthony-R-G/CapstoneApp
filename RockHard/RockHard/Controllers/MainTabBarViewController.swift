//
//  MainTabBarViewController.swift
//  RockHard
//
//  Created by Anthony Gonzalez on 1/27/20.
//  Copyright © 2020 Rockstars. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    //MARK: -- Lazy Property VCs
    lazy var feedVC = UINavigationController(rootViewController: FeedViewController())
    
    lazy var exerciseVC =  UINavigationController(rootViewController: ExerciseViewController())
    
    lazy var workoutVC =  UINavigationController(rootViewController: WorkoutViewController())
    
    lazy var profileVC =  UINavigationController(rootViewController: ProfileViewController())
    
    
    
    
    //MARK: -- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: nil, tag: 0)
        exerciseVC.tabBarItem = UITabBarItem(title: "Exercises", image: nil, tag: 1)
        workoutVC.tabBarItem = UITabBarItem(title: "Workouts", image: nil, tag: 2)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: nil, tag: 3)
        
        self.viewControllers = [feedVC, exerciseVC, workoutVC, profileVC]
    }
}
