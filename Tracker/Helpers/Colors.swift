//
//  Colors.swift
//  Tracker
//
//  Created by Сергей on 07.03.2024.
//

import UIKit

final class Colors {
    
    static let shared = Colors()
    private init(){}

    let plusButtonColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.black
        } else {
            return UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        }
    }
    
    let datePickerBackground = UIColor(red: 240, green: 240, blue: 240, alpha: 1)
    
    let tabBarBorder = UIColor { traitColletion in
        switch traitColletion.userInterfaceStyle {
        case .dark:
            return UIColor.black
        default:
            return  UIColor.lightGray
        }
    }
    
    let buttonsBackground = UIColor { traitColletion in
        switch traitColletion.userInterfaceStyle {
        case .dark:
            return UIColor.white
        default:
            return  UIColor.black
        }
    }
    
    let buttonTextColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.white
        } else {
            return UIColor.black
            
        }
    }
    
    let dark = UIColor { traitColletion in
        switch traitColletion.userInterfaceStyle {
        case .dark:
            return #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 0.8485577312)
        default:
            return  UIColor.ypGray
            
        }
    }
    
    let createButton = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.black
        } else {
            return UIColor.white
            
        }
    }
    
    func setTriColorBorder(view: UIView) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [
                UIColor.red.cgColor,
                UIColor.green.cgColor,
                UIColor.blue.cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 2
            shapeLayer.path = UIBezierPath(rect: view.bounds).cgPath
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = nil
            gradientLayer.mask = shapeLayer

            view.layer.addSublayer(gradientLayer)
        }

}




