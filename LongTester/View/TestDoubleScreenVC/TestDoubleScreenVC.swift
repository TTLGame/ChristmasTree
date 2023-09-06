//
//  TestDoubleScreenVC.swift
//  LongTester
//
//  Created by long.trinh on 8/14/23.
//

import Foundation

import UIKit
import RxSwift
class TestDoubleScreenVC : UIViewController {
    private(set) var binding: Disposable?
    var viewModel = TableScreenViewModel()
    var currentColor : UIColor = UIColor(red: 110/255, green: 235/255, blue: 52/255, alpha: 1)
    var pressed = true
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
