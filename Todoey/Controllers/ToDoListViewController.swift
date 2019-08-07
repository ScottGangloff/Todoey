//
//  ViewController.swift
//  Todoey
//
//  Created by Scott Gangloff on 8/2/19.
//  Copyright © 2019 Scott Gangloff. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController
{
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray = [Item]()
    //This line of code uses UIApplication to access the current app that is running, then it takes its delegate
    //(Which is the AppDelegate.swift file) and downcasts it into an AppDelegate type.=
    //After the AppDelegate file is found it then finds the viewContext within the persistent Container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        cell.textLabel?.text = item.title
        
        //Check to see if the item in the array is checked or not, if it is marked true, assign a checkmark
        //Ternary operator ---->
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //Call saveItems() which will commit the data out of the context and into the database
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
            //Uses the context before it can upload the data to the database
            //Context is where you can edit the data before submission
            let newItem = Item(context: self.context)
            
            newItem.title = addItemField.text!
            
            newItem.done = false
            
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
        do
        {
            try context.save()
        }
        catch
        {
           print("Error saving context \(error)")
        }
        
        //Reload the data so the new data appears
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest())
    {
        // set a constant of type NSFetchRequest<Item> equal to the Item database model's fetch request
        do
        {
        //Try to populate the array by fetching the data through the context
        itemArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

extension ToDoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Make another request for data
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //The predicate will be what we are telling the searchbar to search for.
        //Checks if the title from the Item database contains what the user entered in the search bar
        //the format is written in SQL code. The cd after contains means it is not case sensitive
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //Create a sort descriptor. This makes the results of the search sorted in ascending order
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        //Set the requests sortDescriptors property to the sortDescriptor we created
        //Must be in an array even if it is just on descriptor
        request.sortDescriptors = [sortDescriptor]
        //Call loadItems with the new request. This will replace the default request value.
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0)
        {
            //Call loaditems when the search bar changes to 0 characters. This will display
            //The full list of items again
            loadItems()
            //This line of code goes into the main thread and stops the keyboard from being displayed
            //As well as stops the search bar from being selected
            //We have to tap into the main thread because this all takes plae in a background thread.
            //Doing this from the background would be laggy.
            DispatchQueue.main.async {
                //Run this method on the main thread queue
                searchBar.resignFirstResponder()
            }
        }
    }
}

