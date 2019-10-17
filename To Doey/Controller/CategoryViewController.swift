//
//  CategoryViewController.swift
//  To Doey
//
//  Created by Harry Wright on 15/10/2019.
//  Copyright © 2019 Harry Wright. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var itemArray : Results<ItemCategory>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
    
    //MARK: - Table Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
        cell.textLabel?.text = itemArray?[indexPath.row].categoryTitle ?? "No Categories Added Yet"
        
        return cell
        
    }
    
    //MARK: - Table Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "categorySegue", sender: self)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = itemArray?[indexPath.row]
        }
    }
    
    //MARK: - Adding New Items
    
    @IBAction func addCategoryButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create Category", style: .default) { (action) in
            
            let newItem = ItemCategory()
            
            newItem.categoryTitle = textField.text!

            self.saveItems(category: newItem)
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "New Category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Model Saving Methods
    
    func saveItems(category: ItemCategory) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Failed to save context, \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadItems() {
        
        itemArray = realm.objects(ItemCategory.self)
        
    }

}
