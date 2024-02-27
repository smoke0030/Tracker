//
//  ViewController.swift
//  Tracker
//
//  Created by Сергей on 22.02.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var blueController = UIViewController()
    
    private lazy var redController = UIViewController()
    
    private let blueBoardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "blueBoard")
        return imageView
    }()
    
    private let redBoardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "redBoard")
        return imageView
    }()
    
    lazy var pages: [UIViewController] = {
        let blue = blueController
        let red = redController
        return [blue, red]
    }()
    
    private let blueVCLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = "Отслеживайте только \nто, что хотите"
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    private let redVCLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = "Даже если это \nне литры воды и йога"
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupViews()
        setupContraints()
    }
    
    private func setupContraints() {
        NSLayoutConstraint.activate([
            blueBoardImageView.topAnchor.constraint(equalTo: blueController.view.topAnchor),
            blueBoardImageView.bottomAnchor.constraint(equalTo: blueController.view.bottomAnchor),
            blueBoardImageView.leadingAnchor.constraint(equalTo: blueController.view.leadingAnchor),
            blueBoardImageView.trailingAnchor.constraint(equalTo: blueController.view.trailingAnchor),
            redBoardImageView.topAnchor.constraint(equalTo: redController.view.topAnchor),
            redBoardImageView.bottomAnchor.constraint(equalTo: redController.view.bottomAnchor),
            redBoardImageView.leadingAnchor.constraint(equalTo: redController.view.leadingAnchor),
            redBoardImageView.trailingAnchor.constraint(equalTo: redController.view.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -84),
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blueVCLabel.leadingAnchor.constraint(equalTo: blueController.view.leadingAnchor, constant: 16),
            blueVCLabel.trailingAnchor.constraint(equalTo: blueController.view.trailingAnchor, constant: -16),
            blueVCLabel.centerYAnchor.constraint(equalTo: blueController.view.centerYAnchor),
            redVCLabel.leadingAnchor.constraint(equalTo: redController.view.leadingAnchor, constant: 16),
            redVCLabel.trailingAnchor.constraint(equalTo: redController.view.trailingAnchor, constant: -16),
            redVCLabel.centerYAnchor.constraint(equalTo: redController.view.centerYAnchor),
        ])
    }
    
    private func setup() {
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
            
        }
        
        if !isFirstLaunch {
            UserDefaults.standard.setValue(true, forKey: "isFirstLaunch")
        }
    }
    
    private func setupViews() {
        self.view.addSubview(button)
        view.addSubview(pageControl)
        [blueBoardImageView, blueVCLabel].forEach {
            blueController.view.addSubview($0)
        }
        
        [redBoardImageView, redVCLabel].forEach {
            redController.view.addSubview($0)
        }
    }
    
    
    
    @objc private func buttonDidTapped() {
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}


extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
