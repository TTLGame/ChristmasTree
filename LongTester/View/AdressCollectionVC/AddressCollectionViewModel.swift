//
//  AddressCollectionViewModel.swift
//  LongTester
//
//  Created by Long on 4/22/23.
//

import Foundation

import RxSwift
import RxCocoa
import Moya
import SVProgressHUD

class AddressCollectionViewModel : NSObject {
    var cellViewModels : BehaviorRelay<[AddressCollectionViewCellViewModel]> = BehaviorRelay(value: [])
    
    let api: Provider<MultiTarget>
    private(set) var rootViewModel: RootViewModel
    let limit: Int = 50
    
    private var randomPic = [String]()
    let disposeBag = DisposeBag()
    init(rootViewModel : RootViewModel = RootViewModel(), api: Provider<MultiTarget> = ProviderAPIBasic<MultiTarget>()) {
        self.api = api
        self.rootViewModel = rootViewModel
        super.init()
    }
    
    func getData(){
        let data = [AddressCollectionViewCellViewModel(roomNums: 1, renters: 3, status: "Paid"),
                    AddressCollectionViewCellViewModel(roomNums: 2, renters: 4, status: "Short"),
                    AddressCollectionViewCellViewModel(roomNums: 3, renters: 2, status: "NotPaid"),
                    AddressCollectionViewCellViewModel(roomNums: 4, renters: 2, status: "Paid")]
        
        cellViewModels.accept(data)
    }
}
