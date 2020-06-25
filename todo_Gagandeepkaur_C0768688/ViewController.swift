//
//  ViewController.swift
//  todo_Gagandeepkaur_C0768688
//
//  Created by Gagan on 2020-06-24.
//  Copyright © 2020 Gagan. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    
    @IBOutlet weak var titletxt: UITextField!
    
    @IBOutlet weak var daystxt: UITextField!
    
    @IBOutlet weak var descfeild: UITextView!
    
    var titleVC = ""
       var selectedTask : NSManagedObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                      let context = appDelegate.persistentContainer.viewContext
               let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksEntity")
               request.predicate = NSPredicate(format: "title contains %@", titleVC)
               request.returnsObjectsAsFaults = false
        // Do any additional setup after loading the view.
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
                    
                    do{
                        try context.save()
                    }catch{
                        print(error)
                    }
                }
                
                titletxt.text = ""
                daystxt.text = ""
                descfeild.text = ""
              
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

