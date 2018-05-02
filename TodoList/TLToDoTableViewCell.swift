//
//  TLToDoTableViewCell.swift
//  TodoList
//
//  Created by Sky on 9/12/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class TLToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPriority: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var item: TLToDoItem? = nil {
        didSet {
            guard let item = item else {
                return
            }
            
            lblTitle.text = item.title
            lblPriority.text = "Priority: \(item.priority)"
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd\nHH:mm a"
            lblDate.text = df.string(from: item.date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
