//
//  CategoriesViewController.swift
//  Documents Core Data Relationships
//
//  Created by Hayden Harrill on 9/27/18.
//  Copyright © 2018 Hayden Harrill. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try managedContext.fetch(fetchRequest)
            
            categoriesTableView.reloadData()
        } catch {
            print("Could not fetch")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ExpensesViewController,
           let selectedRow = categoriesTableView.indexPathForSelectedRow?.row else {
            return
        }
        
        destination.category = categories[selectedRow]
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        guard let managedContext = category.managedObjectContext else {
            return
        }
        
        managedContext.delete(category)
        

        do {
            try managedContext.save()
            
            self.categories.remove(at: indexPath.row)
            self.categoriesTableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Could not delete")
            
            self.categoriesTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (categories[indexPath.row].expenses?.count ?? 0 > 0){
                let alert = UIAlertController(title: "Delete Category", message: "Are you sure you would like to delete this category?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (alertAction) -> Void in return
                }))
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { (alertAction) -> Void in self.deleteCategory(at: indexPath)
        }))
                self.present(alert, animated: true, completion: nil)
            } else {
                deleteCategory(at: indexPath)
            }
        }
    }
}
