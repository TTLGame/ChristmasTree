//
//  DetailScreenViewController.swift
//  LongTester
//
//  Created by Long on 5/8/23.
//

import UIKit

class DetailScreenViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        bindToViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
//    private func bindToViewModel() {
//        self.viewModel = AddressCollectionViewModel(rootViewModel: rootViewModel as! RootViewModel)
//    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {
//        self.pushNavigationView(AddressCollectionViewController(), Language.localized("addressCollectionMainTitle"))
    }
}
