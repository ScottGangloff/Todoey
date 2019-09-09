//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Scott Gangloff on 8/7/19.
//  Copyright © 2019 Scott Gangloff. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController
 {

    let realm = try! Realm()
    
    //Is of type result because it will be filled from the Realm database
    //It is a container of all of the categories. Similar to an array, but is auto updated and used with Realm only.
    var todoCategories : Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.rowHeight = 80
        
        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = todoCategories?[indexPath.row]
        {
            cell.textLabel?.text = category.name
            
            guard let catColorHex = UIColor.init(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = catColorHex
            
            cell.textLabel?.textColor = ContrastColorOf(catColorHex, returnFlat: true)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoCategories?.count ?? 1
        //If todoCategories is not nil, return count. If it is nil, return 1
    }
    
    //MARK: - TableView Manipulation Methods
    
    func save(category: Category)
    {
        do
        {
            try realm.write {
                realm.add(category)
            }
        }
        catch
        {
            print("Error saving context \(error)")
        }
        
        //Reload the data so the new data appears
        self.tableView.reloadData()
    }
    
    func loadCategories()
    {
        //Assign the category array (Which has to be of type result) to the result of the realm query
        //todoCategories will now be set to auto update 
         todoCategories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK : Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.todoCategories?[indexPath.row]
        {
            do
            {
                try self.realm.write {
                     self.realm.delete(categoryForDeletion)
                }
            }
            catch
            {
                print("Error deleting")
            }
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var addButtonField = UITextField()
        
        let alert = UIAlertController(title: "Add a category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add a category", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = addButtonField.text!
            
            newCategory.color = UIColor.randomFlat.hexValue()
            //because the Category Array is auto-updating, you never have to append things to it
            //It is done automatically and monitors itself for the changes done to the added object
            
            //This line commits the category to the database
            self.save(category: newCategory)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            addButtonField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    //When preparing for the segue, this function will create a reference to the destination, and set the category variable
    //as the category of the one selected. This will trigger the loadItems method in the next view controller, which will
    //Load all of the items that have a parentCategory of the newly set category value.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            //The selected category of the destination View Controller will be the selected category if it is not nil
            destinationVC.selectedCategory = todoCategories?[indexPath.row]
        }
    }
}


