//
//  TabBarControllerViewController.swift
//  Tracker
//
//  Created by Сергей on 26.11.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        //        setTabBarAppearance()
    }
    
    private func setupTabBar() {
        
       
        let vc = UINavigationController(rootViewController: TrackerViewController())
        
        vc.tabBarItem.title = "Трекеры"
        vc.tabBarItem.image = UIImage(named: "trackerImage")
        
        let statisticVC = setupVC(vc: StatisticViewController(),
                                  title: "Стастистика",
                                  image: UIImage(named: "statisticImage"))
        viewControllers = [vc, statisticVC]
    }
    
    private func setupVC(vc: UIViewController, title: String, image: UIImage?) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }
    
    //    private func setTabBarAppearance() {
    //        let roundLayer = CAShapeLayer()
    //
    //    }
}



