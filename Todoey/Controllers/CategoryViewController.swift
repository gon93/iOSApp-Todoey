//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Seong Kon Kim on 6/5/19.
//  Copyright © 2019 Seong Kon Kim. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    //make the variable optional just in case loadcategories doesnt work
    //collection of results
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    
  
    //MARK: - TableView Datsouce Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //nil coales
        return categories?.count ?? 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        
        if let category = categories?[indexPath.row]{
            
            guard  let navBar = navigationController?.navigationBar else {fatalError()}
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.hexColor) else {fatalError()}
            guard let navColor = UIColor(hexString: "1D9Bf6") else {fatalError()}
        //Change Color
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navColor, returnFlat: true)]
        }
        return cell
    }
    
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //selecting the segue destination to TodoListViewController
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] 
        }
    }
    
    //MARRK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.hexColor = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        alert.addTextField { (field) in
            field.placeholder = "Create a new category"
            textField = field
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Data Maniipulation Methods
    
    //save
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //fetch
    //auto update with .objects
    func loadCategories(){
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        //****it will bring function inside updatemodel in the superclass
        super.updateModel(at: indexPath)
        
        if let categoryDeletion = categories?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(categoryDeletion)
                }
            } catch{
                print("Error deleting category,\(error)")
            }

        }
    }
}
