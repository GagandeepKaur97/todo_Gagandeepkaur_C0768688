//
//  AddCategory.swift
//  todo_Gagandeepkaur_C0768688
//
//  Created by Gagan on 2020-06-26.
//  Copyright © 2020 Gagan. All rights reserved.
//

import UIKit
import CoreData
class AddCategory: UITableViewController, UISearchBarDelegate{

    var context: NSManagedObjectContext?
    var folder: [NSManagedObject]?
    @IBOutlet weak var serachBar: UISearchBar!
    
   
    var NoteArray: [String]?
    var isSearching = false
     let mainColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
       serachBar.delegate = self
              
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
              
               context = appDelegate.persistentContainer.viewContext
             
              
              // Uncomment the following line to preserve selection between presentations
              // self.clearsSelectionOnViewWillAppear = false

              // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
                   self.navigationItem.rightBarButtonItem = self.editButtonItem
            
                     self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.8857288957, green: 0.9869052768, blue: 0.9952554107, alpha: 1)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return !isSearching ? (folder?.count ?? 0) : (NoteArray?.count ?? 0)
    }

    
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Newnotes")
                   request.predicate = NSPredicate(format: "title contains[c] %@", searchText)
                   
                   do{
                       NoteArray = []
                                           let noteObjects = try context?.fetch(request) as! [NSManagedObject]
                                           for n in noteObjects{
                                               let cat = n.value(forKey: "category") as! String
                                              if (!(NoteArray?.contains(cat))!){
                                                  NoteArray?.append(cat)
                                              }
                                         }
                                         isSearching = true
                                          tableView.reloadData()
                   }catch{
                       print(error)
                   }
                   tableView.reloadData()
        if searchText == ""{
             // loadData()
        }
        
        
       
    
    }
    
}
