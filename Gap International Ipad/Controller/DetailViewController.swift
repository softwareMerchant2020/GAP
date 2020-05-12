//
//  DetailViewController.swift
//  Gap International Ipad
//
//  Created by Sangeetha Gengaram on 3/3/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//
import AVFoundation
import AVKit
import UIKit
import CoreData

class DetailViewController: UIViewController {

    var avPlayer: AVPlayer!
    var avPlayerController = AVPlayerViewController()
    var delegate:MasterViewControllerDelegate?
    var masterViewController:MasterViewController!
    @IBOutlet weak var videoPlayerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .bookmarks, target: self, action: #selector(journalButtonClicked))
        
        if let split = splitViewController {
            let controllers = split.viewControllers
             masterViewController = (controllers[0] as! UINavigationController).topViewController as? MasterViewController
        }
//        set up the video player
        avPlayer = AVPlayer()
        avPlayerController.view.frame.size.height = videoPlayerView.bounds.height
        avPlayerController.view.frame.size.width = videoPlayerView.bounds.width
        videoPlayerView.addSubview(avPlayerController.view)
        NotificationCenter.default.addObserver(self , selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        self.title = "Management Training"
    }
    var detailItem: NSManagedObject? {
        didSet {
            configureView()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        avPlayerController.player?.cancelPendingPrerolls()
        super.viewWillDisappear(animated)

    }
    @objc func playerDidFinishPlaying()
    {
        getChapterComments()       
    }
    func configureView() {
          // Update the user interface for the detail item.
          avPlayer = AVPlayer(url: URL(string: (detailItem!.value(forKeyPath: "url") as? String)!)!)
          avPlayerController.player = avPlayer
          avPlayer.play()
      }
    func getChapterComments() {
        let ac = UIAlertController(title: "Leave a comment", message: "What did you think about this chapter", preferredStyle: .alert)
        ac.addTextField()
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
        let answer = ac.textFields![0]
        self.detailItem?.setValue(answer.text, forKey: "comment")
        self.delegate?.updateChapaterList(object: self.detailItem!)
        self.delegate?.activateNextChapter(object: self.detailItem!)
    }

    ac.addAction(submitAction)

    present(ac, animated: true)
    }
    @objc func journalButtonClicked()  {
       
        avPlayerController.player?.pause()
        self.performSegue(withIdentifier: "showJournal", sender:self )
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        avPlayer.pause()
        if segue.identifier == "showJournal" {
            let destinationVC = segue.destination as! JournalViewController
            destinationVC.ChapterDetObjects = masterViewController.chapterDetList
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

