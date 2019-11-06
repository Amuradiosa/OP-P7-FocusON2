//
//  TodayTableViewController.swift
//  FocusOn
//
//  Created by Ahmad Murad on 20/10/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit
import CoreData

//protocol todaysTasksDelegate {
//    func weDontHaveA(task: ToDo?) -> Bool
//}

class TodayTableViewController: UITableViewController, UITextFieldDelegate {
    
   
    // MARK: - Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<ToDo>!
    private let formatter = DateFormatter()
    private var selected: IndexPath!
    private var goal: ToDo!
//    var delegate: todaysTasksDelegate?
        
    // MARK: - Goal Cell outlets
    
    @IBOutlet weak var checkmarkButton: UIButton!
    
    @IBOutlet weak var goalCaption: UITextField!
    
    @IBOutlet weak var goalCustomCell: UITableViewCell!
    
    
    // MARK: - Goal Cell actions
    @IBAction func checkButtonPressed(_ sender: Any) {
        checkmarkButton.isSelected = !checkmarkButton.isSelected
        editingDidEnd(goalCaption)
    }
    
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        if WeDontHaveA(goal: goal) {
            let goal = ToDo(entity: ToDo.entity(), insertInto: context)
            goal.caption = sender.text!
            goal.completed = checkmarkButton.isSelected
            goal.cd = Date()
            goal.kind = false
            appDelegate.saveContext()
            self.goal = goal
        } else {
            goal.caption = sender.text!
            goal.completed = checkmarkButton.isSelected
            appDelegate.saveContext()
        }
        
    }
    
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    // MARK: - Configuration:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        // do the fetch request here for goals and tasks(using do catch block) and then store the data in the goals and tasks array to populate the tableview
    }
    
    private func configure() {
        registerCell()
        goalCaption.delegate = self
        formatter.timeStyle = .none
        formatter.dateStyle = .short
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEdit(_:)))
//        tableView.addGestureRecognizer(tapGesture)
//        tapGesture.delegate = self
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
//    @objc func tapEdit(_ recognizer: UITapGestureRecognizer)  {
//        if recognizer.state == .ended {
//            let tapLocation = recognizer.location(in: self.tableView)
//            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
//                if let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? TaskCustomStaticTableViewCell {
//                    let task = fetchedRC.object(at: tapIndexPath)
//                    task.caption = tappedCell.taskCaption.text
//                    task.completed = tappedCell.checkmarkButton.isSelected
//                    //do what you want to cell here
//
//                }
//            }
//        }
//    }
    private func registerCell() {
        let cell = UINib(nibName: "TaskCustomStaticTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "customCell")
    }
    
    

    // MARK: - Table view data source
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selected = indexPath
//        print("this is the selected cell \(String(describing: selected))")
//    }

    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        /*guard let sections = fetchedRC.sections, let objs = sections[section].objects else {
//            return 0
//        }
//        return objs.count*/
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return 3
//        default:
//            return 0
//        }
//    }
//
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                if validateIndexPath(indexPath, fetchedRC: fetchedRC as! NSFetchedResultsController<NSFetchRequestResult>) {
                    if let goal = fetchedRC?.object(at: indexPath) {
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
                cell.taskNumber.image = UIImage(named: "\(indexPath.row + 1)-circle-filled")
                if validateIndexPath(indexPath, fetchedRC: fetchedRC as! NSFetchedResultsController<NSFetchRequestResult>) {
                    if let task = fetchedRC?.object(at: indexPath) {
                        cell.taskCaption.tag = indexPath.row
                        cell.checkmarkButton.tag = indexPath.row
                        cell.taskCaption.text = task.caption
                        cell.checkmarkButton.isSelected = task.completed
//                        TaskCustomStaticTableViewCell.currentIndexPath = indexPath.row
//                        delegate?.weDontHaveA(task: task)
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
    
    
    
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        //return fetchedRC.sections?.count ?? 0
//        return 2
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Actions
    
//    @IBAction func handleTap(gestureRcognizer: UIGestureRecognizer) {
//        let point = gestureRcognizer.location(in: tableView)
//        if let indexPath = tableView.indexPathForRow(at: point) {
//            selected = indexPath
//        }
//    }
    
    
    // MARK: - Main private functions
    
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
    
    func validateIndexPath(_ indexPath: IndexPath,fetchedRC: NSFetchedResultsController<NSFetchRequestResult>) -> Bool {
        if let sections = fetchedRC.sections,
        indexPath.section < sections.count {
           if indexPath.row < sections[indexPath.section].numberOfObjects {
              return true
           }
        }
        return false
    }
    // MARK: - Secondary helper functions:
    
    


}

// Fetched Results Controller delegate:

//extension TodayTableViewController: NSFetchedResultsControllerDelegate {
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        <#code#>
//    }
//}

