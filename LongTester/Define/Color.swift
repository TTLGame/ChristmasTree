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
    static let esignBackground2 = RGB(245, 246, 247)
    static let esignBackground = RGB(249, 250, 251)
    static let esignBlue = RGB(45, 156, 219)
    static let background = RGB(255, 232, 232)
    static let primary = RGB(0, 102, 179)                   // RGB(238, 28, 46)
    static let totalPendingEnd = RGB(255, 150, 128)
    static let totalAssignedEnd = RGB(236, 201, 92)
    static let popUpBackground = RGB(0, 0, 0, 0.5)
    static let currentLoanEnd = RGB(255, 214, 0)
    static let currentLocation = RGB(167, 222, 255, 0.67)
    static let locationOverlay = RGB(65, 155, 249, 0.1)
    static let primaryTextColor = RGB(53, 58, 65)
    static let normalTextColor = RGB(102, 102, 102)
    static let placeHolderColor = RGB(153, 153, 153)
    static let addressView = RGB(237, 237, 237)
    static let formBackground = RGB(250, 250, 250)
    static let border = RGB(204, 204, 204)
    static let statusGreen = RGB(87, 191, 0)
    static let backgroundTextField = RGB(253, 253, 253)
    static let normalSegment = RGB(247, 250, 253)           // RGB(255, 147, 147)
    static let nonSelectButton = RGB(232, 232, 232)
    static let selectButton = RGB(107, 179, 11)
    static let noResultBackground = RGB(249, 249, 249)
    static let route = RGB(65, 155, 249)
    static let backgroundAlertAction = RGB(233, 233, 233)
    static let addressUnselectedTitle = RGB(229, 229, 229)
    static let placeholderSearchBar = RGB(255, 127, 127)
    static let colorCheckInButton = RGB(226, 226, 226)
    static let backgroundNotifUnread = RGB(247, 250, 253)   // RGB(255, 237, 237)
    static let separatorLine = RGB(228, 228, 228)
    // FC Cell
    static let cellHightlightContainer = RGB(227, 227, 227)
    static let cellHightlightContact = RGB(210, 210, 210)
    // New FC Cell
    static let selectedLoanTitleBackground = RGB(158, 196, 250)
    static let deSelectedLoanTitleBackground = RGB(221, 221, 221)
    static let loanTitleRed = RGB(206, 0, 0)
    static let loanTitleOrange = RGB(232, 146, 42)
    static let loanTitleGreen = RGB(104, 169, 74)
    
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
