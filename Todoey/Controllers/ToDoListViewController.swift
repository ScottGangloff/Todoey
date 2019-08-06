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
    
    //Path to the documents in the iPhone
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call load items. This will fill the list with already saved items
        loadItems()
        
        }
    
    //MARK - Tableview Datasource Methods
    
    //This function populates the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
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
        
        //Call saveItems() which will write the new data to the plist file and update the view
        saveItems()
        
        //Animate the selected cell row to flash 
        tableView.deselectRow(at: indexPath, animated: true)
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
            
            self.saveItems()
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
    
    func saveItems()
    {
        //The encoder will convert objects and their properties into a plist file, or a JSON file
        let encoder = PropertyListEncoder()
        
        do
        {
            //Try to encode the itemArray data
            let data = try encoder.encode(itemArray)
            //Then try to write the data to the specified path where the documents are
            try data.write(to: dataFilePath!)
        }
        catch
        {
            print("error encoding item array \(error)")
        }
        
        //Reload the data so the new data appears
        self.tableView.reloadData()
    }
    
    func loadItems()
    {
        //Try to find the data through the URL path
        if let data = try? Data(contentsOf: dataFilePath!)
        {
            //Initialize the decoder. This will convert the plist data back into usable data
            let decoder = PropertyListDecoder()
            do
            {
            //Try to set the itemArray to the decoded values from the plist
            itemArray = try decoder.decode([Item].self, from: data)
            }
            catch
            {
                print("Couldnt load data \(error)")
            }
        }
    }
}

