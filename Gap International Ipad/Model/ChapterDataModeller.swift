//
//  ChapterDataModeller.swift
//  Gap International Ipad
//
//  Created by Sangeetha Gengaram on 3/6/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit
import CoreData

class ChapterDataModeller {
 var chapters: ChapterList?
    var appDelegate:AppDelegate?
    var managedContext:NSManagedObjectContext?
    var entity:NSEntityDescription?
    
    
    
init() {
    let hasLaunchedKey = "HasLaunched"
    let defaults = UserDefaults.standard
    let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
   
    appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    managedContext = appDelegate!.persistentContainer.viewContext
    entity = NSEntityDescription.entity(forEntityName: "ChapterDet",
                                        in: managedContext!)!
//    write the chapter details to coredata only once
    if !hasLaunched {
            defaults.set(true, forKey: hasLaunchedKey)
            getChapterDetails()
            saveChapterDeatils(chapters: chapters!)
        }
    
    
}
//Read the plist file for chapter information
      func getChapterDetails() {
             let plistPath: String? = Bundle.main.path(forResource: "Chapters", ofType: "plist")! //the path of the data
             let plistXML = FileManager.default.contents(atPath: plistPath!)!
             
             do {
                 let decoder = PropertyListDecoder()
                 chapters = try decoder.decode(ChapterList.self, from: plistXML)
             } catch {
                 print(error)
             }
         }
//    create coredata entity for chapters
         func saveChapterDeatils(chapters:ChapterList)  {
             for chapterObj in chapters.Chapters!{
             
                let chapter = NSManagedObject(entity: entity!,
                                          insertInto: managedContext)
             chapter.setValue(chapterObj.name, forKeyPath: "name")
             chapter.setValue(chapterObj.url, forKeyPath: "url")
             chapter.setValue(false  , forKeyPath: "isCompleted")
             chapter.setValue(nil, forKeyPath: "dateCompleted")
             chapter.setValue(false , forKeyPath: "isActive")
                 let firstObj = chapters.Chapters?.first
                 if firstObj!.name==chapterObj.name{
                     chapter.setValue(true , forKeyPath: "isActive")
                 }
             chapter.setValue("", forKeyPath: "comment")

             do {
                try managedContext!.save()
             } catch let error as NSError {
               print("Could not save. \(error), \(error.userInfo)")
             }
             }
         }
//    chapter information read from datamodel
      func readChapterDetails() ->[NSManagedObject] {
      var chapterDetList:[NSManagedObject]?
          let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ChapterDet")
          do{
            chapterDetList = try (managedContext!.fetch(fetchRequest) as? [NSManagedObject])
          }
          catch{
              print("error retrieing data:\(error)")
          }
        return chapterDetList!

      }
//    update the chapter to include comments on completion
    func updateChapterDetails(object:NSManagedObject) {

        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ChapterDet")
        fetchRequest.predicate = NSPredicate(format: "url = %@", ((object.value(forKeyPath: "url") as? String)!))
        do{
            let obj = try managedContext?.fetch(fetchRequest)
            let chapDetObject = obj?[0] as! NSManagedObject
            chapDetObject.setValue(true, forKey: "isCompleted")
            chapDetObject.setValue(true, forKey: "isActive")
            chapDetObject.setValue(Date(), forKeyPath: "dateCompleted")
            let comment:String = object.value(forKeyPath: "comment") as! String
            chapDetObject.setValue(comment, forKey: "comment")
            do{
                try managedContext?.save()
            }
            catch{
                print("error saving update:\(error)")
            }
        }
        catch{
            print("error fetching update:\(error)")
        }
        
    }
//    Next chapter becomes available 
    func activateNextChapter(object:NSManagedObject, chapterDetList:[NSManagedObject])
    {
        let chapName:String = object.value(forKeyPath: "name") as! String
         var nextChapObj:NSManagedObject?
         for (index,chapterObject) in chapterDetList.enumerated() {
             let objName:String = chapterObject.value(forKeyPath: "name") as! String
             if chapName==objName {
                 nextChapObj = chapterDetList[index+1]
                 nextChapObj?.setValue(true, forKey: "isActive")
                 break
             }
         }
        
         let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ChapterDet")
         fetchRequest.predicate = NSPredicate(format: "url = %@", ((nextChapObj!.value(forKeyPath: "url") as? String)!))
         do{
            let obj = try managedContext?.fetch(fetchRequest)
            let chapDetObject = obj?[0] as! NSManagedObject
             chapDetObject.setValue(true, forKey: "isActive")
             do{
                try managedContext?.save()
             }
             catch{
                 print("error saving update:\(error)")
             }
         }
         catch{
             print("error fetching update:\(error)")
         }
    }
}
