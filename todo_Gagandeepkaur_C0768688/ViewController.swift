//
//  ViewController.swift
//  todo_Gagandeepkaur_C0768688
//
//  Created by Gagan on 2020-06-24.
//  Copyright © 2020 Gagan. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var categorytxt: UITextField!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var titletxt: UITextField!
    @IBOutlet weak var daystxt: UITextField!
    @IBOutlet weak var descfeild: UITextView!
    
       var titleVC = ""
       var selectedTask : NSManagedObject?
        var categoryName: String?
    
    
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        categorytxt.text = categoryName!
        UNUserNotificationCenter.current().delegate = self
        
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
                       let context = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksEntity")
                request.predicate = NSPredicate(format: "title contains %@", titleVC)
                request.returnsObjectsAsFaults = false
                do{
                    let data = try context.fetch(request)
                    for object in data as! [NSManagedObject] {
                        selectedTask = object
                        titletxt.text = (object.value(forKey: "title") as! String)
                        daystxt.text = "\(object.value(forKey: "daysNeeded") as? Int ?? 0)"
                        descfeild.text = (object.value(forKey: "taskDescription") as! String)
                        let date = (object.value(forKey: "taskStarted") as! Date)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEE, MMM, dd"
                        let hourFormatter = DateFormatter()
                        hourFormatter.dateFormat = "h:mm a"
                        datelbl.text = dateFormatter.string(from: date)
                        timelbl.text = hourFormatter.string(from: date)
        //                datelbl.text = "\(object.value(forKey: "taskStarted") as! NSDate)"
                    }
                    
                }catch{
                    print(error)
                }
                let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
                view.addGestureRecognizer(tapgesture)
                
            }
    
    
    
    
    @IBAction func addTasks(_ sender: UIButton) {
    
    
    let title = titletxt.text
            let daysneeded = Int(daystxt.text ?? "0") ?? 0
            let desc = descfeild.text
            
            
            if title == "" || daysneeded == 0{
               
                let alert = UIAlertController(title: "Empty feilds", message: "Fill all the feilds", preferredStyle: .alert)
                       let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                       alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{

                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appdelegate.persistentContainer.viewContext
                
                if selectedTask == nil{
                    
                    
                    let taskentity = NSEntityDescription.insertNewObject(forEntityName: "TasksEntity", into: context)
                           
                           taskentity.setValue(title, forKey: "title")
                           taskentity.setValue(daysneeded, forKey: "daysNeeded")
                           taskentity.setValue(0, forKey: "daysAdded")
                           taskentity.setValue(desc, forKey: "taskDescription")
                           taskentity.setValue(Date(), forKey: "taskStarted")
                    taskentity.setValue(categorytxt.text!, forKey: "category")
                    
                    
                           
                           do{
                               try context.save()
                           }catch{
                               print(error)
                           }
                }
                
                if selectedTask != nil{
                    selectedTask?.setValue(title, forKey: "title")
                    selectedTask?.setValue(daysneeded, forKey: "daysNeeded")
                    selectedTask?.setValue(desc, forKey: "taskDescription")
                    selectedTask?.setValue(categorytxt.text!, forKey: "category")
                    
                    
                    // check - if changed category already exist
                    
                    var catagoryPresent = false
                           let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
                           request.returnsObjectsAsFaults = false
                           
                           // we find our data
                           do{
                            let results = try context.fetch(request) as! [NSManagedObject]
                               
                               for r in results{
                                   
                                   if categorytxt.text! == (r.value(forKey: "notename") as! String) {
                                       catagoryPresent = true;
                                       break
                                       
                                   }
                                   
                               }
                           } catch{
                               print("Error2...\(error)")
                           }
                           
                           
                           if !catagoryPresent{
                               
                            let newFolder = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context)
                               newFolder.setValue(categorytxt.text!, forKey: "notename")
                               
                           }
                    
                    // cat exist
                    
                    // cat not present - add
                    
                    
                    
                    
                    do{
                        try context.save()
                    }catch{
                        print(error)
                    }
                }
                
                titletxt.text = ""
                daystxt.text = ""
                descfeild.text = ""
                datelbl.text = ""
                timelbl.text = ""
                titletxt.resignFirstResponder()
                 daystxt.resignFirstResponder()
                descfeild.resignFirstResponder()
            }
            
             
            
        }
        
        @objc func tapped()  {
            titletxt.resignFirstResponder()
            daystxt.resignFirstResponder()
            descfeild.resignFirstResponder()
        }
   
        
    }

extension ViewController: UNUserNotificationCenterDelegate{
   func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                 completionHandler([.alert, .sound])

             }
}

