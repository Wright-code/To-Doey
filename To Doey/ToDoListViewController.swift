//
//  ToDoListViewController.swift
//  To Doey
//
//  Created by Harry Wright on 04/10/2019.
//  Copyright © 2019 Harry Wright. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem = ToDoItem()
        
        newItem.itemContent = "Find Mike"
        itemArray.append(newItem)
    }
      
    // MARK: - Tabele View Data Source Methods
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.itemContent
        
        // Ternary Operator 
        cell.accessoryType = item.itemStatus ? .checkmark : .none
    
        return cell
    }
    
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].itemStatus = !itemArray[indexPath.row].itemStatus
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Adding New Item
    
    @IBAction func addItemPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add To-doey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            let newItem = ToDoItem()
            
            newItem.itemContent = textField.text ?? "New Item"
            self.itemArray.append(newItem)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
