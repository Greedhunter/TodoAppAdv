//
//  CategoryViewController.swift
//  TodoAppAdv
//
//  Created by Jack on 4/29/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Categories]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75
        loadItems()
        tableView.separatorStyle = .none

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categoryArray[indexPath.row].name
        if let colour = UIColor.flatSkyBlue().darken(byPercentage: CGFloat(indexPath.row)/CGFloat(categoryArray.count)){
                cell.backgroundColor = colour
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: colour, isFlat:true)
        }
        
        cell.delegate = self
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newItem = Categories(context: self.context)
            newItem.name = textField.text!
            self.categoryArray.append(newItem)
            
            self.saveData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveData(){
        do {
            try context.save()
            
        } catch {
            print("Error saving catagory")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Categories> = Categories.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error fetching category")
        }
    }

}

extension CategoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let selected = self.categoryArray[indexPath.row]
            self.context.delete(selected)
            self.saveData()
            self.loadItems()
            print("item deleted")
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete Icon")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
