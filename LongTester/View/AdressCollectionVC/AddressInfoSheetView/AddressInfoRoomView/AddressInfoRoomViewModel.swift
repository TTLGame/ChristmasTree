//
//  AddressInfoRoomViewModel.swift
//  LongTester
//
//  Created by Long on 5/29/23.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class AddressInfoRoomViewModel : NSObject {
    var cellViewModels : BehaviorRelay<[AddressInfoRoomViewCellViewModel]> = BehaviorRelay(value: [])
    var addressDataMonthModel : BehaviorRelay<[AddressDataMonthModel]> = BehaviorRelay(value: [])
    var roomDataModel : BehaviorRelay<[RoomDataModel]> = BehaviorRelay(value: [])
    
    let api: Provider<MultiTarget>
    private(set) var rootViewModel: RootViewModel

    var addressDataModel : AddressDataModel = AddressDataModel()
    var currentMonthYear = MonthYear()
    
    let disposeBag = DisposeBag()
    init(rootViewModel : RootViewModel = RootViewModel(), api: Provider<MultiTarget> = ProviderAPIBasic<MultiTarget>()) {
        self.api = api
        self.rootViewModel = rootViewModel
        super.init()
        bindToEvents()
        
    }
    
    func bindToEvents() {
        roomDataModel.map {data in
            data.map {cell in
                var total = 0
                let currentElectric = cell.electricNum ?? 0
                let lastElectric = cell.lastElectricNum ?? 0
                let totalElectric = (currentElectric - lastElectric) * (cell.electricPrice ?? 0)
                
                let currentWater = cell.waterNum ?? 0
                let lastWater = cell.lastWaterNum ?? 0
                let quota = cell.quota ?? 0
                let qutotaPrice = cell.quotaPrice ?? 0
                var totalWater = ((currentWater - lastWater) * (cell.waterPrice ?? 0))
                
                totalWater += currentWater - lastWater > quota ? (currentWater - lastWater - quota) * qutotaPrice : 0
                total += totalWater + totalElectric
                
                if let trashPrice = cell.trashPrice {
                    total += trashPrice
                }
                
                if let internetPrice = cell.internetPrice {
                    total += internetPrice
                }
                
                total += cell.roomPrice ?? 0
                return AddressInfoRoomViewCellViewModel(status: cell.status, roomNum: cell.roomNums, lastWater: cell.lastWaterNum, currentWater: cell.waterNum, totalWater: totalWater, waterPrice:  cell.waterPrice, quotaPrice: cell.quotaPrice, quota: cell.quota, lastElectric: cell.lastElectricNum, currentElectric: cell.electricNum, electricPrice: cell.electricPrice, totalElectric: totalElectric, trashPrice: cell.trashPrice, internetPrice: cell.internetPrice, roomPrice: cell.roomPrice, total: total)
            }
        }.bind(to: cellViewModels).disposed(by: disposeBag)
    }
    
    
    func setupData(){
        if let data = addressDataModel.data {
            self.addressDataMonthModel.accept(data)
        }
    }
    func getData(date: MonthYear){
        currentMonthYear = date

        let checkData = addressDataMonthModel.value.contains(where: { cell in
            var monthYearData = MonthYear()
            if let monthYear = cell.monthYear?.split(separator: "/"),
                monthYear.count > 1{
                if let month = Int(monthYear[0]), let year = Int(monthYear[1]) {
                    monthYearData = MonthYear(month: month,
                                              year: year)
                }
            }
            return monthYearData == date
        })
        
        if (checkData){
            if let monthYearData = addressDataMonthModel.value.filter({ cell in
                var monthYearData = MonthYear()
                if let monthYear = cell.monthYear?.split(separator: "/"),
                    monthYear.count > 1{
                    if let month = Int(monthYear[0]), let year = Int(monthYear[1]) {
                        monthYearData = MonthYear(month: month,
                                                  year: year)
                    }
                }
                return monthYearData == date
            }).first , let mainCellData = monthYearData.roomData {
                roomDataModel.accept(mainCellData)
            }
        }
    }
}
