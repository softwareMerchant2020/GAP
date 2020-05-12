//
//  AppDelegate.swift
//  Gap International Ipad
//
//  Created by Sangeetha Gengaram on 3/3/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let audioSession = AVAudioSession.sharedInstance()

        do {

            try audioSession.setCategory(.playback, mode: .moviePlayback)

        }

        catch {

            print("Setting category to AVAudioSessionCategoryPlayback failed.")

        }
        
        
        
        guard let splitViewController = window?.rootViewController as? UISplitViewController else { return false }
                guard let navigationController = splitViewController.viewControllers.last as? UINavigationController else { return false}
                navigationController.topViewController?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
                navigationController.topViewController?.navigationItem.leftItemsSupplementBackButton = true
        splitViewController.delegate = self as? UISplitViewControllerDelegate
                let masterNavigationController = splitViewController.viewControllers[0] as? UINavigationController
                let masterViewController = masterNavigationController?.topViewController as? MasterViewController
        //      The first chapter starts playing immediately on load
                let indexPath:IndexPath = IndexPath(row: 0, section: 0)
                masterViewController?.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        return true
    }

    // MARK: UISceneSession Lifecycle

//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        if #available(iOS 13.0, *) {
//            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//        }
//    }

    // MARK: - Core Data stack

      lazy var persistentContainer: NSPersistentContainer = {
          
          let container = NSPersistentContainer(name: "DataModel")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {
                  
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()

      // MARK: - Core Data Saving support

      func saveContext () {
          let context = persistentContainer.viewContext
          if context.hasChanges {
              do {
                  try context.save()
              } catch {
                  
                  let nserror = error as NSError
                  fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
              }
          }
      }

}

