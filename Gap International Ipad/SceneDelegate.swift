//
//  SceneDelegate.swift
//  Gap International Ipad
//
//  Created by Sangeetha Gengaram on 3/3/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let window = window else { return }
        guard let splitViewController = window.rootViewController as? UISplitViewController else { return }
        guard let navigationController = splitViewController.viewControllers.last as? UINavigationController else { return }
        navigationController.topViewController?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        navigationController.topViewController?.navigationItem.leftItemsSupplementBackButton = true
        splitViewController.delegate = self
        let masterNavigationController = splitViewController.viewControllers[0] as? UINavigationController
        let masterViewController = masterNavigationController?.topViewController as? MasterViewController
//      The first chapter starts playing immediately on load
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        masterViewController?.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
    }

  

    func sceneDidEnterBackground(_ scene: UIScene) {
       
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            return true
        }
        return false
    }

}

