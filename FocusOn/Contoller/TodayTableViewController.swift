//
//  TodayTableViewController.swift
//  FocusOn
//
//  Created by Ahmad Murad on 20/10/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TodayTableViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<ToDo>!
    private let formatter = DateFormatter()
    // Global goal variable to hold the latest goal entered
    private var goal: ToDo!
        
    // MARK: - Goal Cell outlets
    
    @IBOutlet private weak var checkmarkButton: UIButton!
    @IBOutlet private(set) weak var goalCaption: UITextView!
    @IBOutlet private weak var goalCustomCell: UITableViewCell!
    
    // MARK: - Goal Cell actions
    
    @IBAction private func checkButtonPressed(_ sender: Any) {
        checkmarkButton.isSelected = !checkmarkButton.isSelected
        // Calling the delegate method textViewDidChange to update the CoreData database with the change of checkmarkButton isSelected status
        textViewDidChange(goalCaption)
        checkmarkButton.isSelected ?
            displayAlertAnimation(title: "Well Done 🥳", message: "Congrats on achieving your goal!") :
            displayAlertAnimation(title: "ah, no biggie, you’ll get it next time!", message: "")
        // to update the notification captions
        manageLocalNotifications()
    }
    
    // to promote the user with an animatin when marking a task or a goal as ‘completed’ or to ‘undo’ an action
    private func displayAlertAnimation(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    // alert action when app first launch in the day to give user the option to re-list the last uncompleted goal as today's goal
    private func displayAlertAction() {
        let alert = UIAlertController(title: "Your goal has not been achived yet!", message: "Would you like to re-list it as today's goal?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            self.clearOldGoalsAndTasks()
        }))
        // re-list last uncompleted goal and its tasks(by basically changing the creation date)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            let goal = self.fetchedRC?.object(at: IndexPath(row: self.dayIndexPathRow(forSection: 0), section: 0))
            goal?.cd = self.removeTimeStamp(fromDate: Date())
            self.appDelegate.saveContext()
            self.goal = goal
            for indexPathRow in 0...2 {
                let task = self.fetchedRC?.object(at: IndexPath(row: indexPathRow + self.dayIndexPathRow(forSection: 1), section: 1))
                task?.cd = self.removeTimeStamp(fromDate: Date())
                self.appDelegate.saveContext()
            }
        }))
        self.present(alert, animated: true)
    }
    
    private func clearOldGoalsAndTasks() {
        goalCaption.text = ""
        let goal = ToDo(entity: ToDo.entity(), insertInto: self.context)
        goal.caption = ""
        goal.kind = false
        goal.cd = self.removeTimeStamp(fromDate: Date())
        goal.completed = false
        appDelegate.saveContext()
        self.goal = goal
        for _ in 0...2 {
            let newTask = ToDo(entity: ToDo.entity(), insertInto: context)
            newTask.caption = ""
            newTask.completed = false
            newTask.cd = self.removeTimeStamp(fromDate: Date())
            newTask.kind = true
            appDelegate.saveContext()
            refresh()
        }
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1), IndexPath(row: 1, section: 1), IndexPath(row: 2, section: 1)], with: .automatic)
    }
    
    private func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // begin and end updates of the tableview to make sure cells are expanding simultanesously with the caption text inside the textView
        tableView.beginUpdates()
        tableView.endUpdates()
        if WeDontHaveA(goal: goal) {
            let goal = ToDo(entity: ToDo.entity(), insertInto: context)
            goal.caption = textView.text!
            goal.completed = checkmarkButton.isSelected
            goal.cd = removeTimeStamp(fromDate: Date())
            goal.kind = false
            appDelegate.saveContext()
            self.goal = goal
        } else {
            goal.caption = textView.text!
            goal.completed = checkmarkButton.isSelected
            appDelegate.saveContext()
        }
    }
    // checking if we do a have a goal today by comparing the creation date day of the last goal stored in the database with today's date
    func WeDontHaveA(goal: ToDo?) -> Bool {
        if let todaysGoal = goal {
            let dayOfCreation = formatter.calendar.component(.day, from: todaysGoal.cd!)
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
    
    // MARK: - Configuration:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if WeDontHaveA(goal: goal) {
            if isThereGoalToFetch(localFetchedRC: fetchedRC as! NSFetchedResultsController<NSFetchRequestResult>) {
                if goal.completed == false {
                    displayAlertAction()
                } else {
                    clearOldGoalsAndTasks()
                    checkmarkButton.isSelected = !checkmarkButton.isSelected
                    configureTextview()
                }
            }
        }
        configureTextview()
        manageLocalNotifications()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func configure() {
        registerCell()
        goalCaption.delegate = self
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        refresh()
        configureTapGesture()
    }
    
    // tapGesture to hide keyboard when tapped anywhere on the tabelview
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("hideKeyboard")))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    //Textview congiguration:
    private func configureTextview() {
        if goalCaption.text.isEmpty {
            goalCaption.text = "Set your goal..."
            goalCaption.textColor = UIColor.lightGray
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
            textView.text = "Set your goal..."
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
    }

    private func registerCell() {
        let cell = UINib(nibName: "TaskCustomStaticTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "customCell")
    }
    
    
    // MARK: - Table view data source
    
    private func dayIndexPathRow(forSection: Int) -> Int {
            switch forSection {
            case 0:
                if isThereGoalToFetch(localFetchedRC: fetchedRC as! NSFetchedResultsController<NSFetchRequestResult>) {
                    return (fetchedRC.sections?[forSection].numberOfObjects)! - 1 // cuz index startsfrom 0 and we have only one goal every day
                }
            case 1:
                if isThereTaskToFetch(localFetchedRC: fetchedRC as! NSFetchedResultsController<NSFetchRequestResult>) {
                    return (fetchedRC.sections?[forSection].numberOfObjects)! - 3 // cuz index starts from 0 and we have three tasks every day
                }
            default:
            return 0
            }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                if validateIndexPath(IndexPath(row: indexPath.row + dayIndexPathRow(forSection: indexPath.section), section: indexPath.section), fetchedRC: fetchedRC as! NSFetchedResultsController<NSFetchRequestResult>) {
                    if let goal = fetchedRC?.object(at: IndexPath(row: indexPath.row + dayIndexPathRow(forSection: indexPath.section), section: indexPath.section)) {
                        goalCaption.text = goal.caption
                        checkmarkButton.isSelected = goal.completed
                        self.goal = goal
                        return goalCustomCell
                    } else {
                        return goalCustomCell
                    }
                } else {
                    print("Attempting to configure a cell for an indexPath that is out of bounds: \(indexPath)")
                    return goalCustomCell
            }
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as? TaskCustomStaticTableViewCell else {
                    return UITableViewCell()
                }
                // make UITableViewCell to follow the height of the UITextView
                cell.textChanged { [weak tableView] (newText: String) in
                    // make updating the tableview happens in the main thread to avoid a weird scrolling behavior caused by the conflict between the focusing of the cursor and the layout of the tableView
                    DispatchQueue.main.async {
                        // tell tableView just to re-layout itself
                        tableView?.beginUpdates()
                        tableView?.endUpdates()
                    }
                }
                cell.taskNumber.image = UIImage(named: "\(indexPath.row + 1)-circle-filled")
                cell.taskCaption.tag = indexPath.row + dayIndexPathRow(forSection: indexPath.section)
                cell.checkmarkButton.tag = indexPath.row + dayIndexPathRow(forSection: indexPath.section)
                if validateIndexPath(IndexPath(row: indexPath.row + dayIndexPathRow(forSection: indexPath.section), section: indexPath.section), fetchedRC: fetchedRC as! NSFetchedResultsController<NSFetchRequestResult>) {
                    if let task = fetchedRC?.object(at: IndexPath(row: indexPath.row + dayIndexPathRow(forSection: indexPath.section), section: indexPath.section)) {
                        if task.caption == "" || cell.taskCaption.text == "" {
                            cell.taskCaption.textColor = UIColor.lightGray
                            cell.taskCaption.text = "Set your task"
                        } else {
                            cell.taskCaption.textColor = UIColor.black
                            cell.taskCaption.text = task.caption
                        }
                        cell.checkmarkButton.isSelected = task.completed
                        return cell
                    } else {
                        return cell
                    }
                } else {
                    return cell
            }
            default:
            return UITableViewCell()
        }
    }
    
    // MARK: - Secondary helper functions:

    private func refresh() {
        let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
        let sort    = NSSortDescriptor(key: #keyPath(ToDo.kind), ascending: true)
        request.sortDescriptors = [sort]
        fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(ToDo.kind), cacheName: nil)
        do {
            fetchedRC.delegate = self
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func validateIndexPath(_ indexPath: IndexPath,fetchedRC: NSFetchedResultsController<NSFetchRequestResult>) -> Bool {
        if let sections = fetchedRC.sections,
        indexPath.section < sections.count {
           if indexPath.row < sections[indexPath.section].numberOfObjects {
              return true
           }
        }
        return false
    }
    
    // making sure that there's a goal to fetch
    private func isThereGoalToFetch(localFetchedRC: NSFetchedResultsController<NSFetchRequestResult>) -> Bool {
            if localFetchedRC.sections?.count != 0 {
                    return true
            }
        return false
    }
    // making sure that there's a task to fetch
    private func isThereTaskToFetch(localFetchedRC: NSFetchedResultsController<NSFetchRequestResult>) -> Bool {
        if isThereGoalToFetch(localFetchedRC: fetchedRC as! NSFetchedResultsController<NSFetchRequestResult>) {
            if localFetchedRC.sections?.count != 1 {
                    return true
            }
        } else {
            if localFetchedRC.sections?.count != 0 {
                    return true
            }
        }
        return false
    }
    
    // MARK: - Notifications
    
    private func manageLocalNotifications() {
        var title: String?
        var body: String?
        if WeDontHaveA(goal: goal) {
            title = "It's the time now"
            body = "You need to set your goal for today"
        } else {
            title = "Come on buddy"
            body = "Don't forget you have a goal to achieve today"
        }
        scheduleLocalNotification(title: title, body: body)
    }
    
    private func scheduleLocalNotification(title: String?, body: String?) {
        let identifier = "goalsListSummary"
        let notificationCenter = UNUserNotificationCenter.current()
        // remove previously scheduled notifications
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
        if let newTitle = title, let newBody = body {
            // create content
            let content = UNMutableNotificationContent()
            content.title = newTitle
            content.body = newBody
            content.sound = UNNotificationSound.default
            // create trigger
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10800, repeats: true)
            // create request
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            // schedule notification
            notificationCenter.add(request, withCompletionHandler: nil)
        }
        
    }
}

// Fetched Results Controller delegate:
extension TodayTableViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            checkmarkButton.isSelected = goal.completed
        default:
            break
        }
    }
}
