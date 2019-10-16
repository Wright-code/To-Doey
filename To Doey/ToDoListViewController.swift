//
//  ToDoListViewController.swift
//  To Doey
//
//  Created by Harry Wright on 04/10/2019.
//  Copyright © 2019 Harry Wright. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : ItemCategory? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Adding New Item
    
    @IBAction func addItemPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add To-doey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.itemContent = textField.text!
            newItem.itemStatus = false
            newItem.parent = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Saving Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving content, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parent.categoryTitle MATCHES %@", selectedCategory!.categoryTitle!)
        
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error getting content from context \(error)")
        }
        
    }

}

    //MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText != "" {
                let request : NSFetchRequest<Item> = Item.fetchRequest()
            
                request.sortDescriptors = [NSSortDescriptor(key: "itemContent", ascending: true)]
                let predicate = NSPredicate(format: "itemContent CONTAINS[cd] %@", searchText)
                loadItems(with: request, predicate: predicate)
                tableView.reloadData()
            }
            else {
                loadItems()
                tableView.reloadData()
            }
    }
}
 
