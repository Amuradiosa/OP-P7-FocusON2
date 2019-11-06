//
//  TaskCustomStaticTableViewCell.swift
//  FocusOn
//
//  Created by Ahmad Murad on 27/10/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit
import CoreData


class TaskCustomStaticTableViewCell: UITableViewCell {
    
    
    
//    func weDontHaveA(task: ToDo?) -> Bool {
//        self.task = task
//        if let todaysTask = task {
//            let dayOfCreation = formatter.calendar.component(.day, from: todaysTask.cd!)
//            let todaysDay = formatter.calendar.component(.day, from: Date())
//            if dayOfCreation != todaysDay {
//                return true
//            } else {
//                return false
//            }
//        } else {
//            return true
//        }
//    }
//    var taskcell: TodayTableViewController?
    
    // MARK: - Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<ToDo>!
    private let formatter = DateFormatter()
    private var task: ToDo!
//    static var currentIndexPath: Int?

    
//    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, task: ToDo) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.task = task
//    }
//
//    init?(task: ToDo) {
//        super.init(coder: NSCoder())
//        self.task = task
//    }
//    required init?(coder aDecoder: NSCoder) {
//       super.init(coder: aDecoder)
//    }
    
    
    
    
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var taskNumber: UIImageView!
    @IBOutlet weak var taskCaption: UITextField!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
}

extension TaskCustomStaticTableViewCell: UITextFieldDelegate {
    
    // MARK: - Actions
    
    
    
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
//        if weDontHaveA(task: task) {
        if isItTheSameDay() {
            let newTask = ToDo(entity: ToDo.entity(), insertInto: context)
            newTask.caption = sender.text!
            newTask.completed = checkmarkButton.isSelected
            newTask.cd = Date()
            newTask.kind = true
            appDelegate.saveContext()
        
        } else {
            let task = fetchedRC.object(at: IndexPath(row: sender.tag, section: 1))
            task.caption = sender.text!
            task.completed = checkmarkButton.isSelected
            appDelegate.saveContext()
        }
    }
    
//    func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
//        if gestureRecognizer.state != .ended {
//            return
//        }
//        let point = gestureRecognizer.location(in: taskcell?.tableView)
//        if let indexPath = taskcell?.tableView.indexPathForRow(at: point) {
//
//        }
//    }
        
        func isItTheSameDay() -> Bool {
            if let tasks = fetchedRC.sections?[1].objects as? [ToDo] {
                let task = tasks.first
                let dayOfCreation = formatter.calendar.component(.day, from: task!.cd!)
                let todaysDay = formatter.calendar.component(.day, from: Date())
                if dayOfCreation != todaysDay {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        }
    
    
    
//    func populatSavedObjectsIntoLocalArray(text: UITextField) {
//        let sections = fetchedRC.sections
//        let objs = sections?[1].objects
//        let numberOfOjects = objs?.count
//        for indexPathRow in 0...2 {
//            let task = objs?[indexPathRow]
//            tasks.append(task as! ToDo)
//        }
//    }
//
//    func IndexPathOfDifferentTask(tasks: [ToDo], text: UITextField) -> IndexPath {
//        let tasks = tasks
//        if let index = tasks.firstIndex(where: {$0.caption == text.text}) {
//            let excludedIndex = index
//        }
//    }
//    func indexPath(forObject object: Int) -> IndexPath? {
//
//    }
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func checkmarkButtonPressed(_ sender: UIButton) {
        checkmarkButton.isSelected = !checkmarkButton.isSelected
        let task = fetchedRC.object(at: IndexPath(row: sender.tag, section: 1))
        task.completed = checkmarkButton.isSelected
        appDelegate.saveContext()
    }
    
    // MARK: - Configuration
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskCaption.delegate = self
        formatter.dateFormat = "dd MM yyyy"
        refresh()
//        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: <#T##Selector?#>)
//        taskcell?.delegate = self
//        refresh()
        // Initialization code
    }
    
    
    
    private func refresh() {
        let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
        let sort    = NSSortDescriptor(key: #keyPath(ToDo.cd), ascending: true)
        request.sortDescriptors = [sort]
        fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(ToDo.kind), cacheName: nil)
        do {
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
//    private func refresh() {
//        let request = Task.fetchRequest() as NSFetchRequest<Task>
//        // FIXME: - if needed, specify the sortdescriptor
//        //let sort    = NSSortDescriptor()
//        let sort    = NSSortDescriptor(key: #keyPath(Task.taskNu), ascending: true)
//        // might need another sort descriptor to differntiate between goals and tasks, for sectioning seperation
//        request.sortDescriptors = [sort]
//        taskFetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        do {
//            try taskFetchedRC.performFetch()
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//
//    }
}


