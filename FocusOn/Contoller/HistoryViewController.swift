//
//  HistoryViewController.swift
//  FocusOn
//
//  Created by Ahmad Murad on 13/10/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit
import CoreData


class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var currentMonth: UILabel!
    
    @IBOutlet weak var totalNumberOfAchievedGoals: UILabel!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<ToDo>!
    private let formatter = DateFormatter()
    let data = DataController()
    
    // MARK: - Configuration
    
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        refresh()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        currentMonth.text = formatter.string(from: removeTimeStamp(fromDate: Date()))
        totalNumberOfAchievedGoals.text = "\(data.allGoalsObjects(achieved: true).count) out of \(data.allGoalsObjects(achieved: false).count) goals completed"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        tableView.reloadData()
            // do the fetch request here for goals and tasks(using do catch block) and then store the data in the goals and tasks array to populate the tableview
        }

    // MARK: - Table view data source

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedRC.sections, let objs = sections[section].objects else {
            return 0
        }
        return objs.count
    }
        

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell") as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        if let toDo = fetchedRC?.object(at: indexPath) {
            if toDo.kind == false {
                cell.toDoCellLabel.font = cell.toDoCellLabel.font.withSize(28)
            } else {
                cell.toDoCellLabel.font = cell.toDoCellLabel.font.withSize(20)
            }
            cell.toDoCellLabel.text = toDo.caption
            if toDo.completed {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedRC.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let toDoObjects = fetchedRC.sections?[section].objects as? [ToDo], let firstToDo = toDoObjects.first {
            let date = formatter.string(from: firstToDo.cd!)
            return date
        }
        return "it didn't work"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else {
            return 40
        }
    }
    
    
    // MARK: - Main private functions
    
    private func refresh() {
        let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
        // FIXME: - if needed, specify the sortdescriptor
        //let sort    = NSSortDescriptor()
        let sort    = NSSortDescriptor(key: #keyPath(ToDo.kind), ascending: true)
        let date = NSSortDescriptor(key: #keyPath(ToDo.cd), ascending: true)
        request.sortDescriptors = [date, sort]
        fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(ToDo.cd), cacheName: nil)
        do {
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    // MARK: - Secondary helper functions:
    
    public func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    
    

}


