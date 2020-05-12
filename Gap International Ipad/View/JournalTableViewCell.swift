//
//  JournalTableViewCell.swift
//  Gap International Ipad
//
//  Created by Sangeetha Gengaram on 3/6/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit
import CoreData

class JournalTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateCompleted: UILabel!
    @IBOutlet weak var chapterTitle: UILabel!
    var chapterObj:NSManagedObject?
     let formatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
         formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    func setCellLabels(obj:NSManagedObject) {
        let name:String = (obj.value(forKeyPath: "name") as? String)!
        let dateCompleted:String = formatter.string(from: obj.value(forKeyPath: "dateCompleted") as! Date)
        let journalComment:String = obj.value(forKeyPath: "comment") as! String
        self.chapterTitle.text = String(format: "Chapter: %@", name)
        self.dateCompleted.text = String(format: "Date: %@", dateCompleted)
        self.commentLabel.text = String(format: "Comment: %@",journalComment)
        
    }
    
}
