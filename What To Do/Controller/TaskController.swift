//
//  TaskController.swift
//  What To Do
//
//  Created by Rifqi Alfaizi on 23/02/21.
//

import UIKit
import CoreData

class TaskController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var taskTable: UITableView!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data for the table
    var todos:[Todo]?
    var todos2 = [Todo]()
    
    // Data from TaskCell -> TAPI ERROR WKWKWK
    static let taskCell = TaskCell()
    
    // Background Set
    var background = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTable.dataSource = self
        taskTable.delegate = self
        
        // Get items from Core Data
        // kalau ga ada ini data tidak muncul di awal
        fetchTask()
        
        // Biar saat masuk langsung load date
        getDate()
        
        
        
        
    }
    
    func fetchTask() {
        do {
            self.todos = try context.fetch(Todo.fetchRequest())
            
            DispatchQueue.main.async {
                self.taskTable.reloadData()
            }
        }
        catch{
            print("error in fetch")
            
        }
    }
    
    
    // MARK: -Add Task
    @IBAction func addTapped(_ sender: Any) {
        
        
        // Create Alert
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        alert.addTextField() // Untuk menaruh textfield di alert
    //    alert.addTextField() // textfield di bawahnya
        
        // Configure button
        let submitButton = UIAlertAction(title: "High Priority", style: .default) { (action) in
            
            // Get the textfield for the alert
            let textfield = alert.textFields!.first // untuk akses textfield pertama atau [0]
            
            // Set the String for priority
            let highPrior = "HIGH PRIORITY"
            
            
            // Create a task object
            let newTask = Todo(context: self.context)
            newTask.task = textfield!.text
            newTask.priority = highPrior
            
            let number = self.todos?.count
            print("number hi prior \(number!)")
            print("newTask \(newTask)")
              
            var array = newTask.priorityNumber
            array = Int64(number!)
            
            var hiPriorNum = [newTask.priorityNumber]
            hiPriorNum.append(array)
            
        //    TaskController.taskCell.bgTask.backgroundColor = UIColor.red
            
            
            // Save the data
            self.saveData()
            
            // Re-fetch the data
            self.fetchTask()
        }
        
        
        let lessPriority = UIAlertAction(title: "Normal Priority", style: .default) { (action) in
            
            // Change Color ( failed )
            // TaskController.taskCell.bgTask!.backgroundColor = UIColor.blue
            
            // Change Priority
            let normalPrior = "NORMAL PRIORITY"
            
            // Get the textfield for the alert
            let textfield = alert.textFields![0]
            
            // Create a task object
            let newTask = Todo(context: self.context)
            newTask.task = textfield.text
            newTask.priority = normalPrior
            
            newTask.priorityNumber += 2
             
            
            // Save the data
            self.saveData()
            
            // Re-fetch the data
            self.fetchTask()
            
            
        }
        
        // Add button
        alert.addAction(submitButton)
        alert.addAction(lessPriority)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            
        }))
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: -Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            
            // Which task to remove
            let taskToRemove = self.todos![indexPath.row]
            
            // Remove the task
            self.context.delete(taskToRemove)
            
            // Save the data
            self.saveData()
            
            // Re-fetch the data
            self.fetchTask()
        }
        
        let action2 = UIContextualAction(style: .normal, title: "Pin") { (action, view, completionHandler) in
            
            
            // Which task to remove
            let taskToRemove = self.todos![indexPath.row]
            
            // Remove the task
            self.context.delete(taskToRemove)
            
            // Save the data
            self.saveData()
            
            // Re-fetch the data
            self.fetchTask()
        }
        
        // Return swipe action
        return UISwipeActionsConfiguration(actions: [action, action2])
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos?.count ?? 0
    }
    
    // MARK: -Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
         
        // Get Task from array and set the label
        let todo = self.todos![indexPath.row]
        let todo2 = self.todos!
  
        var priorNum = [todo.priorityNumber]
        priorNum.sort()
        
        
        let number = self.todos?.count
        
        
        
  //      backgroundCell()
        
        print("jumlah cell \(number!)")
        print("Priority Number \(priorNum)")
        print("todo\(todo)")
        print("todo2 \(todo2)")
        
        
        // Configure with label in storyboard
        cell.taskLabel.text = todo.task
        cell.priorityLabel.text = todo.priority
        
        
      //  todo.priorityNumber = 0
        

        cell.accessoryType = todo.done ? .checkmark : .none
        return cell
    }
    
    // MARK: -DidSelect
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // CheckMark
        let apakahTodoSudahSelesai = !todos![indexPath.row].done // todos![0].sudahSelesai
        
        todos![indexPath.row].done = apakahTodoSudahSelesai
        
        // Selected task
        let task = self.todos![indexPath.row]
        
        // Create alert
        let alert = UIAlertController(title: "Edit Task", message: "", preferredStyle: .alert)
        alert.addTextField()
        
        let textfield = alert.textFields![0]
        textfield.text = task.task
        
        // Configure button Handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // Get the textfield for the alert
            let textfield = alert.textFields![0]
            
            // Edit name property of person object
            task.task = textfield.text
            
            // Save the data
            self.saveData()
            
            // Re-fetch the data
            self.fetchTask()
            
        }
        // Add Button
        alert.addAction(saveButton)
        // Show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // func Save Data
    func saveData() {
        do {
            try self.context.save()
        }
        catch {
            
        }
    }
    
    func getDate() {
        
        // Gets current date n time
        let currentDateTime = Date()
        
        // Initialize the date formatter and set the style:
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "d"
        
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "EEEE"
        
        let formatterMonth = DateFormatter()
        formatterMonth.dateFormat = "MMM, YYYY"
        
        
        // Gets the date n time String from the data object:
        let dateString = formatterDate.string(from: currentDateTime)
        
        let dayString = formatterDay.string(from: currentDateTime)
        
        let monthString = formatterMonth.string(from: currentDateTime)
        
        // Display it on the label
        dateLabel.text = dateString
        
        dayLabel.text = dayString
        
        monthLabel.text = monthString
    }
    
    func backgroundCell() {
        
        if background == true {
            TaskController.taskCell.bgTask.backgroundColor = UIColor.red
        } else {
            TaskController.taskCell.bgTask.backgroundColor = UIColor.blue
        }
    
    }
    
    
}
