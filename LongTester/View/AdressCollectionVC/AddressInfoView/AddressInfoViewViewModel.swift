//
//  AddressInfoViewViewModel.swift
//  LongTester
//
//  Created by Long on 5/20/23.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

struct AddressInfoViewTableHeaderViewModel {
    var title : String
    var cellViewModels : [AddressInfoViewCellViewModel]
}
class AddressInfoViewViewModel : NSObject {
    var cellViewModels : BehaviorRelay<[AddressInfoViewTableHeaderViewModel]> = BehaviorRelay(value: [])
    let api: Provider<MultiTarget>
    private(set) var rootViewModel: RootViewModel

    var monthYearCellData = [AddressCollectionMonthYearViewModel]()
    var currentMonthYear = MonthYear()
    
    let disposeBag = DisposeBag()
    init(rootViewModel : RootViewModel = RootViewModel(), api: Provider<MultiTarget> = ProviderAPIBasic<MultiTarget>()) {
        self.api = api
        self.rootViewModel = rootViewModel
        super.init()
    }
    
    func getData(date: MonthYear){
        currentMonthYear = date
        
        let checkData = monthYearCellData.contains(where: { $0.monthYear == date})
        if (checkData){
            if let mainCellData = monthYearCellData.filter({$0.monthYear == date}).first?.cellViewModels {
                let currentCellData = mainCellData.filter {$0.status != "Vacancy"}
                let vacanCellData = mainCellData.filter {$0.status == "Vacancy"}
                
                
                let waterMoney = Int.random(in: 3000..<7000)
                let electricMoney = Int.random(in: 2000..<4000)
                let rent = currentCellData.map({$0.totalNum ?? 0}).reduce(0, +)
                let renterMax = mainCellData.max(by: {$0.renters ?? 0 < $1.renters ?? 0})
                let renterMin = mainCellData.max(by: {$0.renters ?? 0 > $1.renters ?? 0})
                
                
                var advWater = 0
                var advElectric = 0
                var averageIncome = 0
                
                if (currentCellData.count != 0) {
                    let totalSumWater = currentCellData.map({$0.waterNum ?? 0}).reduce(0, +)
                    advWater = totalSumWater / currentCellData.count
                    
                    let totalSumElectric = currentCellData.map({$0.electricNum ?? 0}).reduce(0, +)
                    advElectric = totalSumElectric / currentCellData.count
                    averageIncome = rent / currentCellData.count
                }
             
                let infoCell : [AddressInfoViewCellViewModel] =
                [AddressInfoViewCellViewModel(title: Language.localized("address"),
                                              value: "99/4A DHT18, KP2, P DONG HUNG THUAN, Q12, TP.HO CHI MINH"),
                 AddressInfoViewCellViewModel(title: Language.localized("totalRoom"),
                                              value: "\(currentCellData.count)/\(currentCellData.count + vacanCellData.count)"),
                 AddressInfoViewCellViewModel(title: Language.localized("averageRenters"),
                                              value: "\(renterMin?.renters ?? 0)-\(renterMax?.renters ?? 0)")
                ]
                
                let infoHeaderCell = AddressInfoViewTableHeaderViewModel(title: Language.localized("facilityInfo"),
                                                                         cellViewModels: infoCell)
                
                let comsumptionCell : [AddressInfoViewCellViewModel] =
                [AddressInfoViewCellViewModel(title: Language.localized("averageWaterComsumption"),
                                              value: String(advWater),
                                              shouldHighlightTitle: true),
                 
                 AddressInfoViewCellViewModel(title: Language.localized("waterUnit"),
                                              value: waterMoney.formatnumberWithDot() + " VND"),
                 
                 AddressInfoViewCellViewModel(title: Language.localized("averageElectricComsumption"),
                                              value: String(advElectric),
                                              shouldHighlightTitle: true),
                 
                 AddressInfoViewCellViewModel(title: Language.localized("electricUnit"),
                                              value: electricMoney.formatnumberWithDot() + " VND"),
                 
                 AddressInfoViewCellViewModel(title: Language.localized("averageIncome"),
                                              value: averageIncome.formatnumberWithDot() + " VND",
                                              shouldHighlightTitle: true),
                 
                 AddressInfoViewCellViewModel(title: Language.localized("totalRent"),
                                              value: rent.formatnumberWithDot() + " VND",
                                              shouldHighlightTitle: true,
                                              shouldHighlightValue: true)
                 
                ]
                let comsumptionHeaderCell = AddressInfoViewTableHeaderViewModel(title: Language.localized("consumptionInfo"),
                                                                         cellViewModels: comsumptionCell)
                
                cellViewModels.accept([infoHeaderCell,comsumptionHeaderCell])
            }
        }
    }
}
