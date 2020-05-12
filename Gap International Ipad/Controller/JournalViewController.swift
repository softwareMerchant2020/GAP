//
//  JournalViewController.swift
//  Gap International Ipad
//
//  Created by Sangeetha Gengaram on 3/5/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit
import CoreData

class JournalViewController: UIViewController {
   
    var ChapterDetObjects:[NSManagedObject] = []
    var chaptersWithComments:[NSManagedObject] = []

    
    @IBOutlet weak var journalTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Journal"
       
        loadTableView()

    }
    
    func loadTableView()  {
        for obj in ChapterDetObjects {
            if obj.value(forKeyPath: "isCompleted")as! Bool {
                chaptersWithComments.append(obj)
            }
        }
        journalTableView.register(UINib(nibName: "JournalTableViewCell", bundle: .main), forCellReuseIdentifier: "JournalCell")
        journalTableView.rowHeight = 120
        journalTableView.dataSource = self
        journalTableView.delegate = self
        
    }

}
extension JournalViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chaptersWithComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as! JournalTableViewCell
        let object = chaptersWithComments[indexPath.row]
        cell.setCellLabels(obj: object)
        return cell
    }
    
    
}
