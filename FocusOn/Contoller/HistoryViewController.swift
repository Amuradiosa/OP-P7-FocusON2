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
    
    
    
    @IBOutlet weak var tableView: UITableView!
    

    
    
    // MARK: - Variables
    
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<ToDo>!
    private let formatter = DateFormatter()
    
    
    func configure() {
        tableView.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            refresh()
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
        return UITableViewCell()
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedRC.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let goals = fetchedRC.sections?[section].objects as? [ToDo], let goal = goals.first {
            return "\(String(describing: goal.cd))"
        }
        return "it didn't work"
    }
    
    
    
    // MARK: - Main private functions
    
    private func refresh() {
        let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
        // FIXME: - if needed, specify the sortdescriptor
        //let sort    = NSSortDescriptor()
        let sort    = NSSortDescriptor(key: #keyPath(ToDo.cd), ascending: true)
        // might need another sort descriptor to differntiate between goals and tasks, for sectioning seperation
        request.sortDescriptors = [sort]
        fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(ToDo.cd), cacheName: nil)
        do {
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    
    // MARK: - Secondary helper functions:
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
