//
//  TodayTableViewController.swift
//  FocusOn
//
//  Created by Ahmad Murad on 20/10/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit
import CoreData

class TodayTableViewController: UITableViewController, UITextFieldDelegate {
    
   
    // MARK: - Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var goalFetchedRC: NSFetchedResultsController<Goal>!
    private var taskFetchedRC: NSFetchedResultsController<Task>!
    private let formatter = DateFormatter()
        
    // MARK: - Goal Cell outlets
    
    @IBOutlet weak var checkmarkButton: UIButton!
    
    @IBOutlet weak var goalCaption: UITextField!
    
    @IBOutlet weak var goalCustomCell: UITableViewCell!
    
    // MARK: - Goal Cell actions
    @IBAction func checkButtonPressed(_ sender: Any) {
        checkmarkButton.isSelected = !checkmarkButton.isSelected
    }
    
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        let goal = Goal(entity: Goal.entity(), insertInto: context)
        goal.caption = sender.text!
        goal.completed = checkmarkButton.isSelected
        goal.cd = Date()
        appDelegate.saveContext()
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
        taskrefresh()
        // do the fetch request here for goals and tasks(using do catch block) and then store the data in the goals and tasks array to populate the tableview
    }
    
    private func configure() {
        registerCell()
        goalCaption.delegate = self
        formatter.dateFormat = "dd MM yyyy"
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    private func registerCell() {
        let cell = UINib(nibName: "TaskCustomStaticTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "customCell")
    }
    
    

    // MARK: - Table view data source
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("\(indexPath.section)")
//        print("\(indexPath.row)")
//        
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
    var customisedIndexPath = IndexPath()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                if validateIndexPath(indexPath, fetchedRC: goalFetchedRC as! NSFetchedResultsController<NSFetchRequestResult>) {
                if let goal = goalFetchedRC?.object(at: indexPath) {
                    goalCaption.text = goal.caption
                    checkmarkButton.isSelected = goal.completed
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
                cell.taskNumber.image = UIImage(named: "\(indexPath.row + 1).circle.fill")
                cell.taskNumber.tag = indexPath.row + 1
                print("\(indexPath.section) and \(indexPath.row)")
                customisedIndexPath = indexPath
                customisedIndexPath.section = customisedIndexPath.section - 1
                if validateIndexPath(customisedIndexPath, fetchedRC: taskFetchedRC as! NSFetchedResultsController<NSFetchRequestResult>) {
                    if let task = taskFetchedRC?.object(at: customisedIndexPath) {
                        cell.taskCaption.text = task.caption
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
    
    
    
    // MARK: - Main private functions
    
    private func refresh() {
        let request = Goal.fetchRequest() as NSFetchRequest<Goal>
        // FIXME: - if needed, specify the sortdescriptor
        //let sort    = NSSortDescriptor()
        let sort    = NSSortDescriptor(key: #keyPath(Goal.cd), ascending: true)
        // might need another sort descriptor to differntiate between goals and tasks, for sectioning seperation
        request.sortDescriptors = [sort]
        goalFetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try goalFetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    private func taskrefresh() {
        let request = Task.fetchRequest() as NSFetchRequest<Task>
        // FIXME: - if needed, specify the sortdescriptor
        //let sort    = NSSortDescriptor()
        let sort    = NSSortDescriptor(key: #keyPath(Task.taskNu), ascending: true)
        // might need another sort descriptor to differntiate between goals and tasks, for sectioning seperation
        request.sortDescriptors = [sort]
        taskFetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try taskFetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func validateIndexPath(_ indexPath: IndexPath,fetchedRC: NSFetchedResultsController<NSFetchRequestResult>) -> Bool {
        if let sections = fetchedRC.sections,
        indexPath.section < sections.count {
            print("\(sections.count)")
            print("\(sections[indexPath.section].numberOfObjects)")
           if indexPath.row < sections[indexPath.section].numberOfObjects {
              return true
           }
        }
        return false
    }
    // MARK: - Secondary helper functions:
    
    


}

