//
//  TLToDoItemDetailViewController.swift
//  TodoList
//
//  Created by Sky on 9/12/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import DatePickerDialog

class TLToDoItemDetailViewController: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var lblPriority: UILabel!
    @IBOutlet weak var slPriority: UISlider!
    @IBOutlet weak var lblDate: UILabel!
    
    let df = DateFormatter()
    
    var toDoListItem: TLToDoItem?
    var tempItem = TLToDoItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        df.dateFormat = "yyyy-MM-dd HH:mm a"
        if let item = toDoListItem {
            tempItem.id = item.id
            tempItem.title = item.title
            tempItem.priority = item.priority
            tempItem.date = item.date
            tempItem.content = item.content
        }
        
        tfTitle.text = tempItem.title
        tvContent.text = tempItem.content
        lblPriority.text = String(tempItem.priority)
        slPriority.value = Float(tempItem.priority)
        lblDate.text = "Date: \(df.string(from: tempItem.date))"
        // Do any additional setup after loading the view.
    }

    
    @IBAction func onSliderPriorityValueChanged(_ sender: UISlider, forEvent event: UIEvent) {
        let priority = Int(sender.value)
        sender.setValue(Float(priority), animated: true)
        lblPriority.text = String(priority)
        
        tempItem.priority = priority
    }
    
    @IBAction func onClickDate(_ sender: Any) {
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: toDoListItem?.date ?? Date(), datePickerMode: .dateAndTime) {
            (date) -> Void in
            
            guard let date = date else {
                return
            }
            self.lblDate.text = "Date: \(self.df.string(from: date))"
            self.tempItem.date = date
        }
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        
        let title = tfTitle.text!
        
        if title.isEmpty {
            let myAlert = UIAlertController(title: "Warning", message: "Please enter title", preferredStyle: UIAlertControllerStyle.alert)
    
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            myAlert.addAction(ok)
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        
        tempItem.title = title
        
        if let content = tvContent.text {
            tempItem.content = content
        }
        
        if tempItem.id.isEmpty {
            tempItem.id = UUID.init().uuidString
            TLRealmService.sharedInstance().addToDoItem(tempItem)
        }else {
            TLRealmService.sharedInstance().updateToDoItem(tempItem)
        }
        
        navigationController?.popViewController(animated: true)
    }

}
