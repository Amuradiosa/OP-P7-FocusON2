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
    
    // MARK: - Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<ToDo>!
    private let formatter = DateFormatter()
    
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
        let task = ToDo(entity: ToDo.entity(), insertInto: context)
        task.caption = sender.text!
        // FIXME: - using frc delegate to update checkmarkButton status to the database
        task.completed = checkmarkButton.isSelected
        //task.taskNu = Float(taskNumber!.tag)
        task.kind = true
        task.cd = Date()
        print("task editing did end is working")
        appDelegate.saveContext()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func checkmarkButtonPressed(_ sender: Any) {
        checkmarkButton.isSelected = !checkmarkButton.isSelected
    }
    
    // MARK: - Configuration
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskCaption.delegate = self
        formatter.dateFormat = "dd MM yyyy"
//        refresh()
        // Initialization code
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

