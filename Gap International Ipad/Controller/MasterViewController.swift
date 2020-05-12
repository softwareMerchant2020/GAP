//
//  MasterViewController.swift
//  Gap International Ipad
//
//  Created by Sangeetha Gengaram on 3/3/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var chapters: ChapterList?
    var chapterDetList: [NSManagedObject] = []
    var chapterDataModel:ChapterDataModeller?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        chapterDataModel = ChapterDataModeller()
       
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        chapterDetList = (chapterDataModel?.readChapterDetails())!
        detailViewController?.detailItem = chapterDetList[0]
        detailViewController?.delegate = self
        loadTableView()
    }
   
    func loadTableView() {
        self.tableView.rowHeight = 100
        self.tableView.delegate = self
        self.tableView.dataSource = self
       }
    
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = chapterDetList[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
                detailViewController?.delegate = self
                self.splitViewController?.toggleMasterView()
            }
        }
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (chapterDetList.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterMenuCell", for: indexPath)
        let object = chapterDetList[indexPath.row]
        cell.textLabel?.text = object.value(forKeyPath: "name") as? String
       
//        Active chapters
        if ((object.value(forKeyPath: "isActive") as? Bool)!) {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            cell.isUserInteractionEnabled = true
        }
        else
        {
            cell.backgroundColor = #colorLiteral(red: 0.1391222775, green: 0.1981398463, blue: 0.2276092172, alpha: 1)
            cell.textLabel?.textColor = UIColor.white
            cell.isUserInteractionEnabled = false
        }
    
       
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.performSegue(withIdentifier: "showDetail", sender: self)
        
    }

}
extension UISplitViewController {
    func toggleMasterView() {
        let barButtonItem = self.displayModeButtonItem
        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: nil, for: nil)
    }
}
protocol MasterViewControllerDelegate {
    func updateChapaterList(object: NSManagedObject)
    func activateNextChapter(object: NSManagedObject)
}
extension MasterViewController:MasterViewControllerDelegate
{
    func activateNextChapter(object:NSManagedObject) {
        chapterDataModel?.activateNextChapter(object: object, chapterDetList: chapterDetList)
         self.tableView.reloadData()
    }
    
    func updateChapaterList(object:NSManagedObject) {
        chapterDataModel?.updateChapterDetails(object: object)
    }
}
