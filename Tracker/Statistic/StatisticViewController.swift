//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Сергей on 26.11.2023.
//

import UIKit


final class StatisticViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("statistic", comment: "")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let placeholderTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.label
        label.text = NSLocalizedString("empty statistic", comment: "")
        return label
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "stat")
        return view
    }()
    
    private let completTrackersView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 16
        return view
    }()
    
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor.label
        label.text = "\(5)"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor.label
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBorder()
        setViews()
        setConstraints()
        setStatViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatViews()
    }
    
    
    
    private func setViews() {
        view.backgroundColor = .systemBackground
        [titleLabel, placeholderTitle, placeholderImage, completTrackersView].forEach {
            view.addSubview($0)
        }
        [countLabel, descriptionLabel].forEach {
            completTrackersView.addSubview($0)
        }
        
    }
    
    func getCompletedCount(count: Int) -> String {
        let formatString: String = NSLocalizedString("completedTrackersCount", comment: "")
        let resultString: String = String.localizedStringWithFormat(formatString, count)
        return resultString
    }
    
    private func showPlaceholder() {
        placeholderImage.isHidden = false
        placeholderTitle.isHidden = false
        completTrackersView.isHidden = true
    }
    
    private func showStatistic() {
        placeholderImage.isHidden = true
        placeholderTitle.isHidden = true
        completTrackersView.isHidden = false
    }
    
    private func setStatViews() {
        let completed = TrackerRecordStore.shared.getCountOfCompletedTrackers()
        if completed ==  0 {
            showPlaceholder()
        } else {
            countLabel.text = "\(completed)"
            descriptionLabel.text = getCompletedCount(count: completed)
            showStatistic()
        }
    }
    
    private func setBorder() {
        let gradient = UIImage.gradientImage(bounds: view.bounds, colors: [.systemRed, .systemGreen, .systemBlue])
        let gradientColor = UIColor(patternImage: gradient)
        completTrackersView.layer.borderColor = gradientColor.cgColor
    }
    
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            placeholderTitle.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completTrackersView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            completTrackersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completTrackersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completTrackersView.heightAnchor.constraint(equalToConstant: 90),
            countLabel.topAnchor.constraint(equalTo: completTrackersView.topAnchor, constant: 12),
            countLabel.leadingAnchor.constraint(equalTo: completTrackersView.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: completTrackersView.trailingAnchor, constant: -12),
            descriptionLabel.topAnchor.constraint(equalTo: completTrackersView.topAnchor, constant: 60),
            descriptionLabel.leadingAnchor.constraint(equalTo: completTrackersView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: completTrackersView.trailingAnchor, constant: -12),
        ])
    }
}

extension  UIImage {
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map(\.cgColor)
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
    }
}
