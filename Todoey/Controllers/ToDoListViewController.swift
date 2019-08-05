//
//  ViewController.swift
//  Todoey
//
//  Created by Scott Gangloff on 8/2/19.
//  Copyright © 2019 Scott Gangloff. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    let newItem = Item(itemName: "Sausage", itemChecked: false)
    itemArray.append(newItem)
        
    let newItem2 = Item(itemName: "Milk", itemChecked: false)
    itemArray.append(newItem2)
        
    if let items = defaults.array(forKey: "TodoListArray") as? [Item]
    {
        itemArray = items
        }

        // Do any additional setup after loading the view.
    }
    
    //MARK - Tableview Datasource Methods
    
    //This function populates the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Reference prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        
        //Set cell label to array value
        cell.textLabel?.text = item.itemName
        
        //Check to see if the item in the array is checked or not, if it is marked true, assign a checkmark
        //Ternary operator ---->
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.itemChecked ? .checkmark : .none
        
        return cell
    }
    
    //How many rows the tableView shall contain
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - Tableview Delegate Methods
    
    //Whenever a cell in the table view is selected this is called
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Check for checkmark, if no checkmark, set itemChecked value to true
        //Checks for the opposite of the current value and assigns it to that
        
        itemArray[indexPath.row].itemChecked = !itemArray[indexPath.row].itemChecked
        
        //Animate the selected cell row to flash 
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Reload the tableview so the check mark values reload and the cellForRowAt method gets triggered
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
            let newItem = Item(itemName: addItemField.text!, itemChecked: false)
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            
            //Reloads the table
        })
        
        //Create a second action called cancel that dismisses the alert
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        //Add a text field in the alert. When the add item action button is pressed, the string
        //In the text field will be stored into the local var addItemField. Then the action
        //Will print the contents of the addItemField
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
    
}

