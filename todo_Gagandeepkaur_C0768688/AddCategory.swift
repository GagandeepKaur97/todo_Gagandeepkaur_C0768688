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
        
             loadData()
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
              loadData()
        }
        
        
       
    
    }
    
    
    @IBAction func add(_ sender: UIBarButtonItem) {
    
    
        let titleString = NSAttributedString(string: "New Folder", attributes: [NSAttributedString.Key.foregroundColor: mainColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
                   
                   let alertController = UIAlertController(title: "", message: "Enter new folder", preferredStyle: .alert)
                   alertController.setValue(titleString, forKey: "attributedTitle")
                   
                   alertController.addTextField { (txtNewFolder) in
                       txtNewFolder.placeholder = "Enter category name..."
                   }
                   
                   let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                   
                   cancelAction.setValue(self.mainColor, forKey: "titleTextColor")
                   
                   let addItemAction = UIAlertAction(title: "Add", style: .default) { (action) in
                       let textField = alertController.textFields![0]
                       
                       if textField.text == "" || textField.text!.trimmingCharacters(in: .whitespaces).isEmpty{
                           
                           self.okAlert(title: "Empty Textfield!!", message: "Please give a name to category")
                           
                       }
                       else{
                           let folderName = textField.text!.uppercased()
                           let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
                           request.returnsObjectsAsFaults = false
                           
                           
                           do{
                               let results = try self.context!.fetch(request)
                               
                               var alreadyExists = false
                               if results.count > 0{
                                   for result in results as! [NSManagedObject]{
                                       if folderName == result.value(forKey: "notename") as! String{
                                           alreadyExists = true
                                           break
                                       }
                                   }
                               }
                               
                               if !alreadyExists{
                                   self.addData(name: folderName)
                               } else{
                                   //                    self.alert(title: "Folder already exsists", message: "Please try other name")
                                   self.okAlert(title: "Duplicate folder!", message: "Please try another folder name.")
                               }
                           }catch{
                               print(error)
                           }
                           
                           self.loadData()
                           self.tableView.reloadData()
                       }
                   }
                   addItemAction.setValue(UIColor.black, forKey: "titleTextColor")
                   
                   alertController.addAction(cancelAction)
                   alertController.addAction(addItemAction)
                   
                   self.present(alertController, animated: false, completion: nil)
               }
               
    
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
             serachBar.resignFirstResponder()
               serachBar.text = ""
                isSearching = false
                loadData()
                tableView.reloadData()
            }
            
            func getNotesCountInFolder(categoryName: String) -> Int{
                 var count = 0
                 
                 let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Newnotes")
                 request.predicate = NSPredicate(format: "category = %@", categoryName)
                 
                 do{
                     let results = try context!.fetch(request)
                     if results is [NSManagedObject]{
                         count = results.count
                     }
                 }catch{
                     print(error)
                 }
                 return count
             }
             
            func loadData(){
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
                request.returnsObjectsAsFaults = false
                
                // we find our data
                do{
                    let results = try context?.fetch(request)
                    
                    if results is [NSManagedObject]{
                        folder = results as! [NSManagedObject]
                        tableView.reloadData()
                    }
                } catch{
                    print("Error2...\(error)")
                }
            }
            
            func addData(name: String){
                let newFolder = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context!)
                newFolder.setValue(name, forKey: "notename")
                saveData()
            }
            
            func saveData(){
                do{
                    try context!.save()
                }catch{
                    print(error)
                }
            }
            
            func okAlert(title: String, message: String){
                let titleString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: mainColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20) ])
                
                let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alertController.setValue(titleString, forKey: "attributedTitle")
                
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                okAction.setValue(mainColor, forKey: "titleTextColor")
                
                alertController.addAction(okAction)
                self.present(alertController, animated: false, completion: nil)
                
            }
            
            func deleteNotesFromCategory(_ catagoryName: String) {
                   
                   let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Newnotes")
                   request.predicate = NSPredicate(format: "category = %@", catagoryName)
                   
                   do{
                       let results = try context!.fetch(request) as! [NSManagedObject]
                       if results.count > 0{
                           
                           for r in results{
                               context?.delete(r)
                           }
                           saveData()
                       }
                       
                   }catch{
                       print(error)
                   }
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



     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            
            if let destination = segue.destination as? TaskTableViewController{
                destination.categoryName = (sender as! UITableViewCell).textLabel?.text
                
            }
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            loadData()
        }
        
    }


