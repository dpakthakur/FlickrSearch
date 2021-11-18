//
//  AppCoordinator.swift
//  FlickrSearch
//
//  Created by Deepak Thakur on 17/11/21.
//

import UIKit

class AppCoordinator {
    private let navigationController = UINavigationController()
    var rootViewController: UIViewController {
        return navigationController
    }
    
    func start() {
        showImages()
    }
    
    private func showImages() {
        // Initialize Quotes View Controller
        guard let quotesViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            fatalError("Unable to Instantiate View Controller")
        }

        // Push Quotes View Controller Onto Navigation Stack
        navigationController.pushViewController(quotesViewController, animated: true)
    }
}
