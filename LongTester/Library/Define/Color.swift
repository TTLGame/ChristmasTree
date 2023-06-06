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
    static let redPrimary =  #colorLiteral(red: 0.7921568627, green: 0.2156862745, blue: 0.3647058824, alpha: 1)
    static let orangePrimary = #colorLiteral(red: 1, green: 0.6855316758, blue: 0.184951812, alpha: 1)
    static let normalTextColor =  #colorLiteral(red: 0.4745098039, green: 0.4745098039, blue: 0.4745098039, alpha: 1)
    static let darkGreen =  #colorLiteral(red: 0.2978984118, green: 0.5977677703, blue: 0.5521355271, alpha: 1)
    static let selectTableView = #colorLiteral(red: 0.8941176471, green: 0.895850122, blue: 0.895850122, alpha: 1)
    static let selectLogout = #colorLiteral(red: 0.5147323608, green: 0.1563093662, blue: 0.257383287, alpha: 1)
    static let viewDefaultColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
    static let defaultShadow = #colorLiteral(red: 0.1176470588, green: 0.2549019608, blue: 0.6078431373, alpha: 1)
    
    static let purpleVacancy = #colorLiteral(red: 0.3725490196, green: 0.2078431373, blue: 0.5803921569, alpha: 1)
    
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
