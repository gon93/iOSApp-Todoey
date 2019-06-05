//
//  ViewController.swift
//  Todoey
//
//  Created by Seong Kon Kim on 6/4/19.
//  Copyright © 2019 Seong Kon Kim. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Finding Neemo", "Incredibles 2", "Sleeping Beauty"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK - Tableview Datasource Methods
    
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //print the particular data into the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //cell text = current row of the current path
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        //checkmark or none on selected cell
        //Ternary Operator - question ? True : False
        (tableView.cellForRow(at: indexPath)!.accessoryType == .checkmark) ? (tableView.cellForRow(at: indexPath)!.accessoryType = .none) : (tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark)
        
        //deselect the grey highlight
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //making closure on handler
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            print(textField.text!)
            
            self.itemArray.append(textField.text!)
            
            //refresh the data so that new text is added
            self.tableView.reloadData()
            
//            print("Add item pressed")
        }
        
        //getting the text from textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
}

