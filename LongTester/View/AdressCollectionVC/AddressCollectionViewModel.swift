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
    var monthYearViewModel : [AddressCollectionMonthYearViewModel] = []
    
    var radioViewModels : BehaviorRelay<AddressCollectionRadioViewModel> = BehaviorRelay(value: AddressCollectionRadioViewModel(cellViewModels: []))
    var dropdownCellViewModels : BehaviorRelay<[AddressCollectionDropDownCellViewModel]> = BehaviorRelay(value: [])
    private var defaultCellViewModels = [AddressCollectionViewCellViewModel]()
    let api: Provider<MultiTarget>
    private(set) var rootViewModel: RootViewModel
    private let limit: Int = 50
    private let rooms = Int.random(in: 1..<20)
    private var randomPic = [String]()
    let disposeBag = DisposeBag()
    init(rootViewModel : RootViewModel = RootViewModel(), api: Provider<MultiTarget> = ProviderAPIBasic<MultiTarget>()) {
        self.api = api
        self.rootViewModel = rootViewModel
        super.init()
    }
    
    var currentMonthYear = MonthYear()
    
    func getMonthYearData(){
        let monthYear = MonthYear()
        for interator in 0...12 {
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
            monthYearViewModel.append(AddressCollectionMonthYearViewModel(monthYear: monthYear - interator,
                                                                          cellViewModels: data))
        }
    }
    func getData(date: MonthYear){
        currentMonthYear = date
        var data = [AddressCollectionViewCellViewModel]()
        let checkData = monthYearViewModel.contains(where: { $0.monthYear == date})
        if (checkData){
            if let cellViewModel = monthYearViewModel.filter({$0.monthYear == date}).first?.cellViewModels {
                data = cellViewModel
                defaultCellViewModels = data
                cellViewModels.accept(data)
            }
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
    
    func sortData(interator: Int){
        switch radioViewModels.value.cellViewModels?[interator].type {
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
                return data.status == "Pending" || data.status == "NotPaid"
            }
            cellViewModels.accept(sortedData)
        }
    }
}
