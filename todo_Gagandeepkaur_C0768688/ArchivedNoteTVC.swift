//
//  ArchivedNoteTVC.swift
//  todo_Gagandeepkaur_C0768688
//
//  Created by Gagan on 2020-06-28.
//  Copyright © 2020 Gagan. All rights reserved.
//

import UIKit
import CoreData

class ArchivedNoteTVC: UITableViewController {
    
    var contextEntity : NSManagedObjectContext?
    var tasks : [NSManagedObject]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        print("\(tasks?.count)")
        
        let appdeleagte = UIApplication.shared.delegate as! AppDelegate
            let context = appdeleagte.persistentContainer.viewContext
            contextEntity = context
        
            loadCoreData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveCell")
                    cell?.textLabel?.text = tasks![indexPath.row].value(forKey: "title") as? String
        cell?.detailTextLabel?.text = "Task Complted"
        cell?.backgroundColor = .orange
        
                    return cell!
                
    }


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
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func loadCoreData(){
           let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ArchivedNotes")
           
           do{
               let result = try contextEntity?.fetch(request)
               tasks = (result as! [NSManagedObject])
           }catch{
               print(error)
           }
           tableView.reloadData()
       }

}
