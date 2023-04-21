//
//  BaseViewModel.swift
//  LongTester
//
//  Created by Long on 4/21/23.
//

import Foundation

protocol BasicViewModel: AlertPresentableViewModel {
}

protocol BasicViewPresentableView: AlertPresentableView {
    var rootViewModel: BasicViewModel { get }
}
