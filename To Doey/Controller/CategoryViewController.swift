//
//  CategoryViewController.swift
//  To Doey
//
//  Created by Harry Wright on 15/10/2019.
//  Copyright © 2019 Harry Wright. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var itemArray = [ItemCategory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
    
    //MARK: - Table Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.categoryTitle
        return cell
        
    }
    
    //MARK: - Table Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "categorySegue", sender: self)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = itemArray[indexPath.row]
        }
    }
    
    //MARK: - Adding New Items
    
    @IBAction func addCategoryButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create Category", style: .default) { (action) in
            
            let newItem = ItemCategory(context: self.context)
            
            newItem.categoryTitle = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "New Category"
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
            print("Failed to save context, \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<ItemCategory> = ItemCategory.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Falied to laod context \(error)")
        }
        
    }

}
