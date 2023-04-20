//
//  Color.swift
//  LongTester
//
//  Created by Long on 1/3/23.
//

import Foundation
import UIKit

struct Color {

    enum GradientType: Int {
        case topToBottom
        case bottomToTop
        case topLeftToBottomRight
        case bottomLeftToTopRight
    }
    static let greyPrimary = #colorLiteral(red: 0.3493813574, green: 0.3493813574, blue: 0.3493813574, alpha: 1)
    static let redPrimary =  #colorLiteral(red: 0.7928444743, green: 0.2171653211, blue: 0.3652344942, alpha: 1)
    static let normalTextColor =  #colorLiteral(red: 0.4756370187, green: 0.4756369591, blue: 0.4756369591, alpha: 1)
    static let darkGreen =  #colorLiteral(red: 0.2978984118, green: 0.5977677703, blue: 0.5521355271, alpha: 1)
    static let selectTableView = #colorLiteral(red: 0.895850122, green: 0.895850122, blue: 0.895850122, alpha: 1)
    static let selectLogout = #colorLiteral(red: 0.5147323608, green: 0.1563093662, blue: 0.257383287, alpha: 1)
    
    static func makeGradientLayer(size: CGSize, from: UIColor, to color: UIColor, type: GradientType) -> CAGradientLayer {
        let colors = [from.cgColor, color.cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "GradientBackground"
        switch type {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        case .topLeftToBottomRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .bottomLeftToTopRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = colors
        return gradientLayer
    }
}

extension Color {
    static func RGB(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1) -> UIColor {
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
