//
//  ViewController.swift
//  Todoey
//
//  Created by Scott Gangloff on 8/2/19.
//  Copyright © 2019 Scott Gangloff. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ToDoListViewController: UITableViewController
{
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    //We pass in the category that was selected so that we can save the newly created items to that
    //category's item list!
    //When this variable is set through the previous VC, then it will load the according items
    var selectedCategory : Category?
    {
        didSet
        {
           loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
        //searchBar.delegate = self
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        }
    
    //MARK - Tableview Datasource Methods
    
    //This function populates the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //Reference prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //If the item is not nil....
        if let item = todoItems?[indexPath.row]
        {
            //Set cell label to array value
            cell.textLabel?.text = item.title
            
            //Check to see if the item in the array is checked or not, if it is marked true, assign a checkmark
            //Ternary operator ---->
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else
        {
         cell.textLabel?.text = "No Items added"
        }

        return cell
    }
    
    //How many rows the tableView shall contain
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    //MARK - Tableview Delegate Methods
    
    //Whenever a cell in the table view is selected this is called
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Check to see if the item clicked is nil or not
        //If it is not nil, execute following block
        if let item = todoItems?[indexPath.row]
        {
            do
            {
            try realm.write {
                //Make check mark boolean opposite of the current value when clicked
                item.done = !item.done
            }
            }
            catch
            {
                print("Error saving done status")
            }
        }
        
        //Animate the selected cell row to flash 
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Store added item details into the local variable
        var addItemField = UITextField()
        
        //Add an alert
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        //Create an action that does something when pressed
        let action = UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            //What happens when the user clicks the add item button on the alert
            //If the category passed in is NOT nil, write a new item to the category's list
            if let currentCategory = self.selectedCategory
            {
                do
                {
                try self.realm.write
                    {
                    let newItem = Item()
                    newItem.title = addItemField.text!
                    newItem.dateCreated = Date()
                    //Add the item to the current category's list of items
                    currentCategory.items.append(newItem)
                    }
                }
                catch
                {
                    print("Error saving new items")
                }
            }
                
            
            self.tableView.reloadData()
        })
        
        //Create a second action called cancel that dismisses the alert
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        //Add a text field in the alert. When the add item action button is pressed, the string
        //In the text field will be stored into the local var addItemField. Then the action
        //Will assign the value to the addItemField text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            addItemField = alertTextField
        }
        
        //Add the actions to the alert
        alert.addAction(cancel)
        alert.addAction(action)
        
        //Show the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func loadItems()
    {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}

extension ToDoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0)
        {
            //Call loaditems when the search bar changes to 0 characters. This will display
            //The full list of items again
            loadItems()
            
            DispatchQueue.main.async {
                //Run this method on the main thread queue
                searchBar.resignFirstResponder()
            }
        }
    }
}

