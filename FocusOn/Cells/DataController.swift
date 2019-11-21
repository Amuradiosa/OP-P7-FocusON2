//
//  DataController.swift
//  FocusOn
//
//  Created by Ahmad Murad on 15/11/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController: NSManagedObject {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<ToDo>!
    var monthlyCompletedGoals: [[Double]]?
    var weeklyCompletedGoals: [[Double]]?
    private let formatter = DateFormatter()
//    typealias MonthlyEntry = (month: Int, count: Double)

    
//    func totalGoals() -> Int {
//        refresh()
//        guard let totalGoalsNumber = fetchedRC.sections?[0].numberOfObjects else {
//            return 1
//        }
//        return totalGoalsNumber
//    }
    
//    func totalNumberOfAchievedGoals() -> [Int] {
//        refresh()
//        let monthsArray = [01,02,03,04,05,06,07,08,09,10,11,12]
//        var monthlyAchievedGoals = [MonthlyEntry]()
//        var totalNumberOfAchievedGoals = [ToDo]()
//        guard let totalGoalsNumber = fetchedRC.sections?[0].numberOfObjects else {
//            return [1]
//        }
//        for indexRow in 0...totalGoalsNumber - 1 {
//        let goal = fetchedRC?.object(at: IndexPath(row: indexRow, section: 0))
//            if goal?.completed == true {
//                for month in 0...11 {
//                    let monthOfCreation = formatter.calendar.component(.month, from:goal!.cd!)
//                        if monthOfCreation == monthsArray[month] {
//                            let goalTuple = (month: monthOfCreation, count:)
//
//                        }
//                    totalNumberOfAchievedGoals.append(goal!)
//                    }
//
//            }
//        }
//        return [totalNumberOfAchievedGoals.count]
//    }
    
    func totalGoals() -> Int {
        refresh()
        guard let totalGoalsNumber = fetchedRC.sections?[0].numberOfObjects else {
            return 1
        }
        return totalGoalsNumber
    }
    func totalNumberOfAchievedGoals() -> [Int] {
        refresh()
        var totalNumberOfAchievedGoals = [ToDo]()
        guard let totalGoalsNumber = fetchedRC.sections?[0].numberOfObjects else {
            return [1]
        }
        for indexRow in 0...totalGoalsNumber - 1 {
        let goal = fetchedRC?.object(at: IndexPath(row: indexRow, section: 0))
            if goal?.completed == true {
                totalNumberOfAchievedGoals.append(goal!)
            }
        }
        return [totalNumberOfAchievedGoals.count]
    }

    
//    func monthlyAchivedGoals() -> [[Double:Double]] {
//        refresh()
//        var totalNumberOfAchievedGoals = [ToDo]()
//        var currentMonthAchievedGoalsTracker = Double()
//        let monthsArray = [01,02,03,04,05,06,07,08,09,10,11,12]
//        guard let allGoalsObjects = fetchedRC.sections?[0].objects as? [ToDo] else {
//            return [[0:0]]
//        }
//        for goal in 0...allGoalsObjects.count - 1 {
//            if allGoalsObjects[goal].completed == true {
//                totalNumberOfAchievedGoals.append(allGoalsObjects[goal])
//            }
//        }
//        for month in 0...11 {
//            currentMonthAchievedGoalsTracker = 0
//            for achievedGoal in 0...totalNumberOfAchievedGoals.count - 1 {
//                let monthOfCreation = formatter.calendar.component(.month, from: totalNumberOfAchievedGoals[achievedGoal].cd!)
//                if monthOfCreation == monthsArray[month] {
//                    currentMonthAchievedGoalsTracker += 1
//                }
//            }
//            monthlyCompletedGoals?.append([Double(monthsArray[month]): currentMonthAchievedGoalsTracker])
//        }
//            return monthlyCompletedGoals!
//    }
    
//    func weeklyAchivedGoals() -> [[Double:Double]] {
//        refresh()
//        let weeksArray = [01,02,03,04]
//        var currentWeekAchievedGoalsTracker = 0.0
//        var totalNumberOfAchievedGoals = [ToDo]()
//        guard let allGoalsObjects = fetchedRC.sections?[0].objects as? [ToDo] else {
//            return [[0:0]]
//        }
//        for goal in 0...allGoalsObjects.count - 1 {
//            if allGoalsObjects[goal].completed == true {
//                totalNumberOfAchievedGoals.append(allGoalsObjects[goal])
//            }
//        }
//        let todaysMonth = formatter.calendar.component(.month, from: Date())
////        let todaysMonthAchievedGoals = monthlyCompletedGoalsTracker?[todaysMonth - 1]
//
////        for month in 0...11 {
//        for week in 0...3 {
//            currentWeekAchievedGoalsTracker = 0
//            for achievedGoal in 0...totalNumberOfAchievedGoals.count - 1 {
//                let monthOfCreation = formatter.calendar.component(.month, from: totalNumberOfAchievedGoals[achievedGoal].cd!)
//                if monthOfCreation == todaysMonth {
//                    let weekOfCreation = formatter.calendar.component(.weekOfMonth, from: totalNumberOfAchievedGoals[achievedGoal].cd!)
//                        if weekOfCreation == weeksArray[week] {
//                            currentWeekAchievedGoalsTracker += 1
//                        }
//                    }
//                }
//            weeklyCompletedGoals?.append([Double(weeksArray[week]): currentWeekAchievedGoalsTracker])
//            }
////        }
//            return weeklyCompletedGoals!
//        }
    
//        func monthlyAchivedGoals() -> [[Double]] {
//                refresh()
//                var totalNumberOfAchievedGoals = [ToDo]()
//                var currentMonthAchievedGoalsTracker = Double()
//                let monthsArray = [01,02,03,04,05,06,07,08,09,10,11,12]
//                guard let allGoalsObjects = fetchedRC.sections?[0].objects as? [ToDo] else {
//                    return [[0.0]]
//                }
//                for goal in 0...allGoalsObjects.count - 1 {
//                    if allGoalsObjects[goal].completed == true {
//                        totalNumberOfAchievedGoals.append(allGoalsObjects[goal])
//                    }
//                }
//                for month in 0...11 {
//                    currentMonthAchievedGoalsTracker = 0
//                    for achievedGoal in 0...totalNumberOfAchievedGoals.count - 1 {
//                        let monthOfCreation = formatter.calendar.component(.month, from: totalNumberOfAchievedGoals[achievedGoal].cd!)
//                        if monthOfCreation == monthsArray[month] {
//                            currentMonthAchievedGoalsTracker += 1
//                        }
//                    }
//                    monthlyCompletedGoals?.append([currentMonthAchievedGoalsTracker])
//                }
//                    return monthlyCompletedGoals!
//            }
//
//            func weeklyAchivedGoals() -> [[Double]] {
//                refresh()
//                let weeksArray = [01,02,03,04]
//                var currentWeekAchievedGoalsTracker = 0.0
//                var totalNumberOfAchievedGoals = [ToDo]()
//                guard let allGoalsObjects = fetchedRC.sections?[0].objects as? [ToDo] else {
//                    return [[0.0]]
//                }
//                for goal in 0...allGoalsObjects.count - 1 {
//                    if allGoalsObjects[goal].completed == true {
//                        totalNumberOfAchievedGoals.append(allGoalsObjects[goal])
//                    }
//                }
//                let todaysMonth = formatter.calendar.component(.month, from: Date())
//        //        let todaysMonthAchievedGoals = monthlyCompletedGoalsTracker?[todaysMonth - 1]
//
//        //        for month in 0...11 {
//                for week in 0...3 {
//                    currentWeekAchievedGoalsTracker = 0
//                    for achievedGoal in 0...totalNumberOfAchievedGoals.count - 1 {
//                        let monthOfCreation = formatter.calendar.component(.month, from: totalNumberOfAchievedGoals[achievedGoal].cd!)
//                        if monthOfCreation == todaysMonth {
//                            let weekOfCreation = formatter.calendar.component(.weekOfMonth, from: totalNumberOfAchievedGoals[achievedGoal].cd!)
//                                if weekOfCreation == weeksArray[week] {
//                                    currentWeekAchievedGoalsTracker += 1
//                                }
//                            }
//                        }
//                    weeklyCompletedGoals?.append([currentWeekAchievedGoalsTracker])
//                    }
//        //        }
//                    return weeklyCompletedGoals!
//                }
//
//        guard let numberOfCompletedGoals = fetchedRC.sections?[0] else {
//            return 1
//        }
//        let num = numberOfCompletedGoals.objects?.filter({ (i) -> Bool in
//
//        })
//        return numberOfCompletedGoals
        
    
//    private func refreshWithPredicate() {
//        let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
//        request.predicate = NSPredicate(format: "completed == %@", NSNumber(value: true))
//        let sort    = NSSortDescriptor(key: #keyPath(ToDo.completed), ascending: true)
//            request.sortDescriptors = [sort]
//            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//            do {
//                fetchedRC.delegate = self as? NSFetchedResultsControllerDelegate
//                try fetchedRC.performFetch()
//            } catch let error as NSError {
//                print("Could not fetch. \(error), \(error.userInfo)")
//            }
//    }
    private func refresh() {
        let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
        let sort    = NSSortDescriptor(key: #keyPath(ToDo.kind), ascending: true)
        request.sortDescriptors = [sort]
        fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(ToDo.kind), cacheName: nil)
        do {
            fetchedRC.delegate = self as? NSFetchedResultsControllerDelegate
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
