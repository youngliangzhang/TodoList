//
//  TLToDoListTableViewController.swift
//  TodoList
//
//  Created by Sky on 9/12/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class TLToDoListTableViewController: UITableViewController {
    
    @IBOutlet weak var tvSearch: UISearchBar!
    @IBOutlet weak var btnSort: UIBarButtonItem!
    
    var toDoLists = [TLToDoItem]()
    var originalToDoLists = [TLToDoItem]()
    var notificationToken: NotificationToken? = nil
    var isDateSort: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        tvSearch.delegate = self
        let toDoListResult = TLRealmService.sharedInstance().getToDoListItems()
        
        guard let realmResult = toDoListResult else {
            return
        }
        
        notificationToken = realmResult.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                self?.originalToDoLists = Array(realmResult)
                self?.sortTodoList((self?.isDateSort)!)
                tableView.reloadData()
                break
            case .update(_, let delections, _, _):
                self?.originalToDoLists = Array(realmResult)
                self?.sortTodoList((self?.isDateSort)!)
                if delections.count == 0 {
                    tableView.reloadData()
                }
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }

    //MARK: - Button Actions
    
    @IBAction func onClickBtnAddToDoItem(_ sender: Any) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: String(describing: TLToDoItemDetailViewController.self)) as! TLToDoItemDetailViewController
        detailVC.title = "Create Todo Item"
        navigationController?.pushViewController(detailVC, animated: true)
    }

    //MARK: - Sort Button
    @IBAction func onClickBtnSort(_ sender: Any) {
        isDateSort = !isDateSort
        btnSort.title = isDateSort ? "By Date" : "By Priority"
        sortTodoList(isDateSort)
        self.tableView.reloadData()
    }
    
    fileprivate func sortTodoList(_ isDateSort: Bool) {
        
        toDoLists.removeAll()
        toDoLists.append(contentsOf:originalToDoLists)
        
        if isDateSort {
            toDoLists.sort(by: { (item1, item2) -> Bool in
                return item1.date.compare(item2.date) == ComparisonResult.orderedAscending
            })
        } else {
            toDoLists.sort(by: { (item1, item2) -> Bool in
                return item1.priority > item2.priority
            })
        }
        
        guard let search = tvSearch.text else {
            return
        }
        
        if search.isEmpty {
            return
        }
        
//        var tempArray = [TLToDoItem]()
//        
//        for item in toDoLists {
//            if item.title.contains(search) {
//                tempArray.append(item)
//            }
//        }
//        toDoLists = tempArray
        toDoLists = toDoLists.filter{$0.title.lowercased().range(of: search.lowercased()) != nil}
    }

    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TLToDoTableViewCell.self), for: indexPath) as! TLToDoTableViewCell
        cell.item = toDoLists[indexPath.row]
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alertVC = UIAlertController(title: "Delete Todo", message: "Are you sure?", preferredStyle: .alert)
            let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
            let yes = UIAlertAction(title: "Yes", style: .default) { (result : UIAlertAction) -> Void in
                TLRealmService.sharedInstance().deleteToDoItem(self.toDoLists.remove(at: indexPath.row))
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            alertVC.addAction(no)
            alertVC.addAction(yes)
            present(alertVC, animated: true, completion: nil)            
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: String(describing: TLToDoItemDetailViewController.self)) as! TLToDoItemDetailViewController
        let item = toDoLists[indexPath.row]
        detailVC.toDoListItem = item
        detailVC.title = item.title
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension TLToDoListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sortTodoList(self.isDateSort)
        self.tableView.reloadData()
    }
}
