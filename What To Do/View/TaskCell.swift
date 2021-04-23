//
//  TaskCell.swift
//  What To Do
//
//  Created by Rifqi Alfaizi on 23/02/21.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var checkBoxOutlet: UIButton!
    @IBOutlet weak var bgTask: UIView!
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
    @IBOutlet weak var checkImage: UIImageView!
    
    static let shared = TaskCell()
    
    var todos:[Todo]?
    
    let task = TaskController()
    
    var checkBox = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgTask.layer.cornerRadius = 10
        
        // Initialization code
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func completed() {
        
    //    items![indexPath.row].completed = !items![indexPath.row].completed
    }
    
    @IBAction func checkBoxAction(_ sender: UIButton) {
     //   let check = self.todos![indexPath.row]
        
        if ( checkBox == false) {
         //   sender.setBackgroundImage((UIImage(named: "circle")), for: UIControl.State.normal)
            checkBox = true
        } else {
         //   sender.setBackgroundImage((UIImage(named: "rec")), for: UIControl.State.normal)
            checkBox = false
        }
    }

}

