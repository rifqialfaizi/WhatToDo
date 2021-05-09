//
//  TaskCell.swift
//  What To Do
//
//  Created by Rifqi Alfaizi on 23/02/21.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var bgTask: UIView!
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
    @IBOutlet weak var checkImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgTask.layer.cornerRadius = 10
        
        // Initialization code
        
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}

