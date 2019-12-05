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
    var textChanged: ((String) -> Void)?
//    var tableView = TodayTableViewController()
//    let defaults = UserDefaults.standard
//    let tasksDayUserDefaultsKey = "taskKey"
//    var savedtasksDayIndex: Int {
//        get {
//            let savedIndex = defaults.value(forKey: tasksDayUserDefaultsKey)
//            if savedIndex == nil {
//                defaults.set(0, forKey: tasksDayUserDefaultsKey)
//            }
//            return defaults.integer(forKey: tasksDayUserDefaultsKey)
//        }
//        set {
//            defaults.set(newValue, forKey: tasksDayUserDefaultsKey)
//        }
//    }
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

    @IBOutlet weak var taskCaption: UITextView!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    
    
}
extension TaskCustomStaticTableViewCell: UITextViewDelegate {
    
    // MARK: - Actions
    
//    @IBAction func valueChanged(_ sender: UITextField) {
//        if isItTheSameDay() {
//            let newTask = ToDo(entity: ToDo.entity(), insertInto: context)
//            newTask.caption = sender.text!
//            newTask.completed = checkmarkButton.isSelected
//            newTask.cd = Date()
//            newTask.kind = true
//            appDelegate.saveContext()
//
//        } else {
//            let task = fetchedRC.object(at: IndexPath(row: sender.tag, section: 1))
//            task.caption = sender.text!
//            task.completed = checkmarkButton.isSelected
//            appDelegate.saveContext()
//        }
//    }
    public func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
        if isItNotTheSameDay(forThisTask: textView.tag) {
            let newTask = ToDo(entity: ToDo.entity(), insertInto: context)
            newTask.caption = textView.text!
            newTask.completed = checkmarkButton.isSelected
            newTask.cd = removeTimeStamp(fromDate: Date())
            newTask.kind = true
            appDelegate.saveContext()
            textView.tag += 3
//          tableView.tableView.reloadData()
        } else {
            let task = fetchedRC.object(at: IndexPath(row: textView.tag, section: 1))
            task.caption = textView.text!
            task.completed = checkmarkButton.isSelected
            appDelegate.saveContext()
        }
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func ereaseTasksCells() {
        
    }
//    @IBAction func editingChanged(_ sender: UITextField) {
//        if isItTheSameDay(forThisTask: sender.tag) {
//            let newTask = ToDo(entity: ToDo.entity(), insertInto: context)
//            newTask.caption = sender.text!
//            newTask.completed = checkmarkButton.isSelected
//            newTask.cd = Date()
//            newTask.kind = true
//            appDelegate.saveContext()
//            sender.tag += 3
////            tableView.tableView.reloadData()
//        } else {
//            let task = fetchedRC.object(at: IndexPath(row: sender.tag, section: 1))
//            task.caption = sender.text!
//            task.completed = checkmarkButton.isSelected
//            appDelegate.saveContext()
//        }
//
//    }
    
//    @IBAction func editingDidEnd(_ sender: UITextField) {
////        if weDontHaveA(task: task) {
//        if isItTheSameDay() {
//            let newTask = ToDo(entity: ToDo.entity(), insertInto: context)
//            newTask.caption = sender.text!
//            newTask.completed = checkmarkButton.isSelected
//            newTask.cd = Date()
//            newTask.kind = true
//            appDelegate.saveContext()
//
//        } else {
//            let task = fetchedRC.object(at: IndexPath(row: sender.tag, section: 1))
//            task.caption = sender.text!
//            task.completed = checkmarkButton.isSelected
//            appDelegate.saveContext()
//        }
//    }
    
//    func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
//        if gestureRecognizer.state != .ended {
//            return
//        }
//        let point = gestureRecognizer.location(in: taskcell?.tableView)
//        if let indexPath = taskcell?.tableView.indexPathForRow(at: point) {
//
//        }
//    }
        
    func isItNotTheSameDay(forThisTask: Int) -> Bool {
//            if let tasks = fetchedRC.sections?[1].objects as? [ToDo] {
//                let task = tasks.first
        refresh()
        if fetchedRC.sections?.count == 0 || fetchedRC.sections?.count == 1 {
            return true
        }
        if forThisTask + 1 > (fetchedRC.sections?[1].numberOfObjects)! {
           return true
        }
        let task = fetchedRC?.object(at: IndexPath(row: forThisTask, section: 1))
        let dayOfCreation = formatter.calendar.component(.day, from: (task?.cd!)!)
            let todaysDay = formatter.calendar.component(.day, from: Date())
                if dayOfCreation != todaysDay {
//                    savedtasksDayIndex += 3
                    return true
                } else {
                    return false
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
    
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//    }
    
    @IBAction func checkmarkButtonPressed(_ sender: UIButton) {
        checkmarkButton.isSelected = !checkmarkButton.isSelected
        let task = fetchedRC.object(at: IndexPath(row: sender.tag, section: 1))
        task.completed = checkmarkButton.isSelected
        appDelegate.saveContext()
        if isAllTasksCompleted() {
            displayAlertAction()
        } else {
        if checkmarkButton.isSelected == true {
            let alert = UIAlertController(title: "Great job on making progress! 👍🏻", message: nil, preferredStyle: UIAlertController.Style.alert)
            let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
            keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
              alert.dismiss(animated: true, completion: nil)
            }
        }
        }
//           let todaysGoalIndex = (fetchedRC.sections?[0].numberOfObjects)! - 1
//            let goal = fetchedRC.object(at: IndexPath(row: todaysGoalIndex, section: 0))
//            goal.completed = true
        
        }
    func displayAlertAction() {
            let alert = UIAlertController(title: "You've marked all tasks as completed", message: "Would you like to mark goal as completed too?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                let todaysGoalIndex = (self.fetchedRC.sections?[0].numberOfObjects)! - 1
                let goal = self.fetchedRC.object(at: IndexPath(row: todaysGoalIndex, section: 0))
                goal.completed = true
            }))
            let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
            keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    
    func isAllTasksCompleted() -> Bool {
        let todaysFirstTaskIndex = (fetchedRC.sections?[1].numberOfObjects)! - 3
        let todaysLastTaskIndex = (fetchedRC.sections?[1].numberOfObjects)! - 1
        let todaysTasksCount = todaysLastTaskIndex - todaysFirstTaskIndex + 1
        var numberOfCompletedTasks = 0
        for taskIndexPathRow in todaysFirstTaskIndex...todaysLastTaskIndex {
            let task = fetchedRC.object(at: IndexPath(row: taskIndexPathRow, section: 1))
            if task.completed == true {
                numberOfCompletedTasks += 1
                if numberOfCompletedTasks == todaysTasksCount {
                    return true
                }
            }
        }
        return false
    }
    
//        func displayAlertAnimation() {
//            let alert = UIAlertController(title: "Well Done 🥳", message: "Congrats on achieving your goal!", preferredStyle: UIAlertController.Style.alert)
//            Present(alert, animated: true)
//
//            let when = DispatchTime.now() + 2
//            DispatchQueue.main.asyncAfter(deadline: when){
//              // your code with delay
//              alert.dismiss(animated: true, completion: nil)
//            }
//        }
//
    
    // MARK: - Configuration
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
//        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: <#T##Selector?#>)
//        taskcell?.delegate = self
//        refresh()
        // Initialization code
    }
    private func configure() {
        taskCaption.delegate = self
        formatter.dateFormat = "dd MM yyyy"
        refresh()
        configureTextview()
    }
    private func configureTextview() {
        taskCaption.delegate = self
        if taskCaption.text.isEmpty {
            taskCaption.text = "Set your goal..."
            taskCaption.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            taskCaption.text = "Set your goal..."
            taskCaption.textColor = UIColor.lightGray
        }
    }
    
    
    
    private func refresh() {
        let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
        let sort    = NSSortDescriptor(key: #keyPath(ToDo.kind), ascending: true)
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

//extension UIView {
//    var parentViewController: UIViewController? {
//        var parentResponder: UIResponder? = self
//        while parentResponder != nil {
//            parentResponder = parentResponder!.next
//            if parentResponder is UIViewController {
//                return parentResponder as? UIViewController
//            }
//        }
//        return nil
//    }
//}



