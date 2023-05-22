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
    var radioViewModels : BehaviorRelay<AddressCollectionRadioViewModel> = BehaviorRelay(value: AddressCollectionRadioViewModel(cellViewModels: []))
    var dropdownCellViewModels : BehaviorRelay<[AddressCollectionDropDownCellViewModel]> = BehaviorRelay(value: [])
    private var defaultCellViewModels = [AddressCollectionViewCellViewModel]()
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
        let rooms = Int.random(in: 1..<20)
        let status = ["Paid", "Short", "NotPaid","Vacancy"]
        var data = [AddressCollectionViewCellViewModel]()
        
        for roomNum in 0..<rooms {
            let statusNo = Int.random(in: 0..<status.count)
            let renters = Int.random(in: 1..<5)
            let water = Int.random(in: 1..<100)
            let electric = Int.random(in: 1..<100)
            let total = Int.random(in: 1000000..<10000000)
            
            data.append(AddressCollectionViewCellViewModel(roomNums: roomNum + 1,
                                                           renters: renters,
                                                           status: status[statusNo],
                                                           waterNum: water,
                                                           electricNum: electric,
                                                           totalNum: total))
        }
        defaultCellViewModels = data
        cellViewModels.accept(data)
    }
    
    func getDropdownData(){
        let data = [AddressCollectionDropDownCellViewModel(image: UIImage(systemName: "book.fill"),
                                                           title: Language.localized("addData")),
                    AddressCollectionDropDownCellViewModel(image: UIImage(systemName: "info.circle.fill"),
                                                           title:  Language.localized("getInfo"))]
        dropdownCellViewModels.accept(data)
    }
    
    func getRadioData(){
        let cell = [AddressCollectionRadioViewCellViewModel(title: Language.localized("radioAll"),type: "ALL"),
                    AddressCollectionRadioViewCellViewModel(title: Language.localized("radioUnPaid"),type: "UNPAID"),
                    AddressCollectionRadioViewCellViewModel(title: Language.localized("radioPaid"),type: "PAID"),
                    AddressCollectionRadioViewCellViewModel(title: Language.localized("radioVancancy"),type: "VACANCY")
        ]
        
        let data = AddressCollectionRadioViewModel(cellViewModels: cell)
        radioViewModels.accept(data)
    }
    
    func handlePressData(index : IndexPath){
        self.rootViewModel.pushViewModel.accept(PushModel(viewController: DetailScreenViewController(),
                                                          title: Language.localized("roomDetailTitle") + " " + String(cellViewModels.value[index.row].roomNums ?? 0)))
    }
}

extension AddressCollectionViewModel {
    func sortData(type: String){
        switch type {
        case "ALL":
            cellViewModels.accept(defaultCellViewModels)
        case "PAID":
            let sortedData = defaultCellViewModels.filter { data in
                return data.status == "Paid"
            }
            cellViewModels.accept(sortedData)
        case "VACANCY" :
            let sortedData = defaultCellViewModels.filter { data in
                return data.status == "Vacancy"
            }
            cellViewModels.accept(sortedData)
            
        default:
            let sortedData = defaultCellViewModels.filter { data in
                return data.status == "Short" || data.status == "NotPaid"
            }
            cellViewModels.accept(sortedData)
        }
    }
}
