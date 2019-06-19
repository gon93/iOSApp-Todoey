//
//  ViewController.swift
//  Todoey
//
//  Created by Seong Kon Kim on 6/4/19.
//  Copyright © 2019 Seong Kon Kim. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    //making the category optional so initial is none
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        tableView.separatorStyle = .none
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            
            //change the name on the navigation bar
        title = selectedCategory?.name
        
        guard let colorhex = selectedCategory?.hexColor else {fatalError() }
        
        UpdateNavBar(withHexCode: colorhex)
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        UpdateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK - Nav Bar Setup Methods
    
    func UpdateNavBar(withHexCode colorHexCode : String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode)else { fatalError()}
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchbar.tintColor = navBarColor
    }
    
    //MARK - Tableview Datasource Methods
    
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    //print the particular data into the cell
    //goes here when called reloadData()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
        
            //cell text = current row of the current path
            cell.textLabel?.text = item.title
            
            
            
            if let color = UIColor(hexString: selectedCategory!.hexColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)){
                
                
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
            cell.accessoryType = item.done ? .checkmark : .none
        
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        //deselect the grey highlight
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //making closure on handler
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving item, \(error)")
                }
            }
            self.tableView.reloadData()
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
    
    
    //Read
    //parameter: external internal names; give default value for request (when we want to call total data)
    //automatically load data
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let deleteItem = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(deleteItem)
                }
            }catch{
                print("Error deleting item,\(error)")
            }
        }
    }
    
}
//MARK: - Search bar methods
extension TodoListViewController:UISearchBarDelegate {


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
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

