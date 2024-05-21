//
//  TabBarControllerViewController.swift
//  Tracker
//
//  Created by Сергей on 26.11.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let topBorder = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setBorder()
        updateBorder()
    }
    
    private func setupTabBar() {
        
        let vc = UINavigationController(rootViewController: TrackerViewController())
        
        vc.tabBarItem.title = NSLocalizedString("tabBarTrackers", comment: "")
        vc.tabBarItem.image = UIImage(named: "trackerImage")
        
        let statisticVC = setupVC(vc: StatisticViewController(),
                                  title: NSLocalizedString("tabBarStatistic", comment: ""),
                                  image: UIImage(named: "statisticImage"))
        viewControllers = [vc, statisticVC]
    }
    
    private func setupVC(vc: UIViewController, title: String, image: UIImage?) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }
    
    
    private func updateBorder() {
        topBorder.backgroundColor = Colors.shared.tabBarBorder.cgColor
    }
    private func setBorder() {
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
        tabBar.layer.addSublayer(topBorder)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateBorder()
    }
    
}



