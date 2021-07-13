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
    // Fetch Data
    func fetchTask() {
        do {
            self.todos = try context.fetch(Todo.fetchRequest())
            
            sortData()
            
            DispatchQueue.main.async {
                self.taskTable.reloadData()
            }
        }
        catch{
            print("error in fetch")
        }
    }

    // Save Data
    func saveData() {
        do {
            try self.context.save()
        }
        catch {
            print(error)
        }
    }
    
    // Sort Data
    func sortData() {
        var sortedData = [Todo]()
        sortedData = todos!.sorted(by: { $0.priorityNumber < $1.priorityNumber})
        todos = sortedData
    }
    
    
    // MARK: -Add Task
    @IBAction func addTapped(_ sender: Any) {
        
        // Create Alert
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        alert.addTextField() // Untuk menaruh textfield di alert
        //    alert.addTextField() // textfield di bawahnya
        
        // Configure button
        let highPriority = UIAlertAction(title: "High Priority", style: .default) { (action) in
            
            // Get the textfield for the alert
            let textfield = alert.textFields!.first // untuk akses textfield pertama atau [0]
            
            // Set the String for priority
            let highPrior = "HIGH PRIORITY"
            
            // Create a task object
            let newTask = Todo(context: self.context)
            newTask.task = textfield!.text
            newTask.priority = highPrior
            newTask.done = false
            
            let number = self.todos?.count
            newTask.priorityNumber = Int64(number!)
            
            // Save the data
            self.saveData()
            
            // Re-fetch the data
            self.fetchTask()
        }

        let lessPriority = UIAlertAction(title: "Normal Priority", style: .default) { (action) in
            
            // Change Priority
            let normalPrior = "NORMAL PRIORITY"
            
            // Get the textfield for the alert
            let textfield = alert.textFields![0]
            
            // Create a task object
            let newTask = Todo(context: self.context)
            newTask.task = textfield.text
            newTask.priority = normalPrior
            newTask.done = false
            
            let two = Int64(100)
            
            let number = self.todos?.count
            newTask.priorityNumber = Int64(number!) + two
            
            
            // Save the data
            self.saveData()
            
            // Re-fetch the data
            self.fetchTask()
        }
        
        // Add button
        alert.addAction(highPriority)
        alert.addAction(lessPriority)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            
        }))
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: -Delete or Trailing
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
        
        let action2 = UIContextualAction(style: .normal, title: "Change Priority") { (action, view, completionHandler) in
            
            // Which task to change
            let taskChangePrior = self.todos![indexPath.row]
            
            let number = self.todos?.count
            let hiPriority = "HIGH PRIORITY"
            let norPriority = "NORMAL PRIORITY"
            
            if taskChangePrior.priorityNumber > 100 {
                taskChangePrior.priorityNumber = Int64(number!)
                taskChangePrior.priority = hiPriority
            } else if taskChangePrior.priorityNumber < 100 {
                taskChangePrior.priority = norPriority
                let two = Int64(100)
                taskChangePrior.priorityNumber = Int64(number!) + two
            }
            
            // Save the data
            self.saveData()
            
            // Re-fetch the data
            self.fetchTask()
        }
        let action3 = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            
            // Which task to change
            let taskEdit = self.todos![indexPath.row]

            // Create Alert
            let alert = UIAlertController(title: "Edit Task", message: "", preferredStyle: .alert)
            alert.addTextField()
            
            let textfield = alert.textFields![0]
            textfield.text = taskEdit.task
            
            // Configure button handler
            let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
                
                // Get the textfield for the alert
                let textfield = alert.textFields![0]
                
                // Edit name of task
                taskEdit.task = textfield.text
                
                // Save the data
                self.saveData()
                
                // Re-fetch the data
                self.fetchTask()
            }
            // Add Button
            alert.addAction(saveButton)
            // Show Alert
            self.present(alert, animated: true, completion: nil)
            

        }
        
        // Return swipe action
        return UISwipeActionsConfiguration(actions: [action, action2, action3])
       
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos?.count ?? 0
    }
    
    
    // MARK: -Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell

        // PERKARA ERROR JANGAN DI PAKE
        // let newDone = Todo(context: self.context)
        
        // Get Task from array and set the label
        let todo = self.todos![indexPath.row]
        
        // Set Cell color
        let viewCell = cell.bgTask
        
        if todo.priorityNumber < 100 {
            viewCell!.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else if todo.priorityNumber > 200 {
            viewCell!.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else {
            viewCell!.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
        
        // Set circle image
       
        let checkIcon = cell.checkImage
        
        if todo.done == true {
            todo.done = true
            checkIcon!.image = UIImage(named: "circle")
        } else {
            todo.done = false
            checkIcon!.image = UIImage(named: "rec")
            
        }
        
        // Configure with label in storyboard
        cell.taskLabel.text = todo.task
        cell.priorityLabel.text = todo.priority
        
        // Original check from UIKit for cell
        //cell.accessoryType = todo.done ? .checkmark : .none
        
        print("Todo = self.todos![indexPath.row] \(todo)")
        
        return cell
    }
    
    // MARK: -DidSelect
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todo = self.todos![indexPath.row]
        let recentNumber = self.todos?.count
        let three = Int64(100)
        let four = Int64(200)
        
        
        // CheckMark
        let apakahTodoSudahSelesai = !todos![indexPath.row].done // todos![0].sudahSelesai
        
        todos![indexPath.row].done = apakahTodoSudahSelesai
        
        // Done Priority
        if todo.priorityNumber < 200 {
            todo.priorityNumber = Int64(recentNumber!) + four
        } else if todo.priority == "NORMAL PRIORITY" {
            todo.priorityNumber = Int64(recentNumber!) + three
        } else {
            todo.priorityNumber = Int64(recentNumber!)
        }
        
        // Save Data
        self.saveData()
        
        // Re-fetch the data
        self.fetchTask()
        
        // Selected task
 //       let task = self.todos![indexPath.row]

        // Untuk delete yang sudah checkMark
//     self.context.delete(task)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
}

