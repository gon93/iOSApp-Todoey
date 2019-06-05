//
//  ViewController.swift
//  Todoey
//
//  Created by Seong Kon Kim on 6/4/19.
//  Copyright © 2019 Seong Kon Kim. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Finding Neemo", "Incredibles 2", "Sleeping Beauty"]
    
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
}

