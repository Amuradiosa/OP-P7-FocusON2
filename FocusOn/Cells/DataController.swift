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

class DataController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedRC: NSFetchedResultsController<ToDo>!
    let formatter = DateFormatter()
    
    func allGoalsObjects(achieved: Bool) -> [ToDo]? {
        refresh()
        if isThereDataToFetch(fetchedRC: fetchedRC as! NSFetchedResultsController<NSFetchRequestResult>) {
            let allGoals = fetchedRC.sections?[0].objects as? [ToDo]
            let allAchievedGoals = allGoals!.filter({ (goal) -> Bool in
                goal.completed == true
            })
            return achieved ? allAchievedGoals : allGoals!
        }
        return nil
    }
    
    func isThereDataToFetch(fetchedRC: NSFetchedResultsController<NSFetchRequestResult>) -> Bool {
        if fetchedRC.sections?.count != 0 {
            return true
        }
        return false
    }
    
    func monthly(goals: [ToDo]) -> [Double] {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var monthlyGoals = [Double]()
        var numberOfgoalsInOneMonth: Double
        let months = [01,02,03,04,05,06,07,08,09,10,11,12]
        for month in 0...11 {
            numberOfgoalsInOneMonth = 0.0
            let isoDate = "\(currentYear())-\(months[month])-01T00:00:00+0000"
            let currentMonth = removeDayStamp(fromDate: formatter.date(from: isoDate)!)
            for goal in 0..<goals.count {
                if removeDayStamp(fromDate: goals[goal].cd!) == currentMonth {
                    numberOfgoalsInOneMonth += 1.0
                }
            }
            monthlyGoals.append(numberOfgoalsInOneMonth)
        }
        return monthlyGoals
    }
    
    func weekly(goals: [ToDo]) -> [Double] {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var weeklyGoals = [Double]()
        var numberOfgoalsInOneWeek: Double
        let weeks = [02,09,15,22,27]
                    for week in 0...4 {
                        numberOfgoalsInOneWeek = 0.0
                        for goal in 0..<goals.count {
                        if removeDayStamp(fromDate: goals[goal].cd!) == removeDayStamp(fromDate: Date()) {
                        let isoDate = "\(currentYear())-\(currentMonth())-\(weeks[week])T00:00:00+0000"
                            if theWeekNumberOfMonth(fromDate: goals[goal].cd!) == theWeekNumberOfMonth(fromDate: formatter.date(from: isoDate)!) {
                            numberOfgoalsInOneWeek += 1
                        }
                    }
                }
                    weeklyGoals.append(numberOfgoalsInOneWeek)
            }
        return weeklyGoals
    }
    
    private func currentYear() -> String {
        guard let date = Calendar.current.dateComponents([.year], from: Date()).year else {
            fatalError("Failed to strip day from Date object")
        }
        return "\(date)"
    }
    
    private func currentMonth() -> String {
        guard let date = Calendar.current.dateComponents([.month], from: Date()).month else {
            fatalError("Failed to strip day from Date object")
        }
        return "\(date)"
    }
    
    private func removeDayStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: fromDate)) else {
            fatalError("Failed to strip day from Date object")
        }
        return date
    }

    private func theWeekNumberOfMonth(fromDate: Date) -> Int {
        let date = Calendar.current.dateComponents([.weekOfMonth], from: fromDate).weekOfMonth!
        return date
    }
    
    func refresh() {
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
