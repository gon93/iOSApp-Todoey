//
//  ViewController.swift
//  Todoey
//
//  Created by Seong Kon Kim on 6/4/19.
//  Copyright © 2019 Seong Kon Kim. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    
    //making the category optional so initial is none
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }
    
    //MARK - Tableview Datasource Methods
    
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //print the particular data into the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        print("cellForRowatIndexPath Called")
        
        //reusing the tableView cell; so if the cell does not appear on the screen, the cell goes to the bottom and be reused.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        //cell text = current row of the current path
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        let item = itemArray[indexPath.row]
        
        //Update
        //set the value when selected
//        item.setValue("Completed", forKey: "title")
        
        
        //Delete
        //2 parts - order matters
        //1. remove data from context first
        //2. remove data from ItemArray
//        context.delete(item)
//        itemArray.remove(at: indexPath.row)
        
        item.done = !item.done
        
        saveItems()
        
        //deselect the grey highlight
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //making closure on handler
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            //CoreData Context
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        //getting the text from textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
    
    //Create
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context, \(error)")
        }
        
        
        //reload everytime cell is clicked
        tableView.reloadData()
    }
    
    //Read
    //parameter: external internal names; give default value for request (when we want to call total data)
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //query so that only the items in each category shows
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        //check if the predicate is nil. if not, do NSCompoundPredicate to combine two queries to search.
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        do{
          itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
    
}
//MARK: - Search bar methods
extension TodoListViewController:UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //look for the title containing searchbar text
        //[cd] - makes the predicate cases and diacritic insensitive
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            //picking the main thread so that you can remove the cursor and keyboard from the screen
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}
