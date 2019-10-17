//
//  ToDoListViewController.swift
//  To Doey
//
//  Created by Harry Wright on 04/10/2019.
//  Copyright © 2019 Harry Wright. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let searchbar = UISearchBar()
    
    var didTapDeleteKey = false
    
    let realm = try! Realm()
    
    var toDoItems : Results<Item>?
    
    var selectedCategory : ItemCategory? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    // MARK: - Table View Data Source Methods
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.itemContent
        
        // Ternary Operator
        // value = condition ? value if true : value if false
            
            cell.accessoryType = item.itemStatus ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.itemStatus = !item.itemStatus
                }
            } catch {
                print("Error updating items \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Adding New Item

    @IBAction func addItemPressed(_ sender: Any) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add To-doey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.itemContent = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items\(error)")
                }
            }
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in

            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    //MARK: - Model Saving Methods
    
    func saveItems(item: Item) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving content, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "itemContent")
    }

}

    //MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar,
                   shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool
    {
        didTapDeleteKey = text.isEmpty
        
        return true
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            toDoItems = selectedCategory?.items.filter("itemContent CONTAINS[cd] %@", searchText)
            tableView.reloadData()
        } else {
            loadItems()
            tableView.reloadData()
        }
        
        if !didTapDeleteKey && searchText.isEmpty {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
        didTapDeleteKey = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
 
