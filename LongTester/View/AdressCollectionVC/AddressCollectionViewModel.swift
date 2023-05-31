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
import OHHTTPStubs

class AddressCollectionViewModel : NSObject {
    var radioViewModels : BehaviorRelay<AddressCollectionRadioViewModel> = BehaviorRelay(value: AddressCollectionRadioViewModel(cellViewModels: []))
    var dropdownCellViewModels : BehaviorRelay<[AddressCollectionDropDownCellViewModel]> = BehaviorRelay(value: [])
    var collectionViewCellDropdownCellViewModels : BehaviorRelay<[AddressCollectionDropDownCellViewModel]> = BehaviorRelay(value: [])
    
    var cellViewModels : BehaviorRelay<[AddressCollectionViewCellViewModel]> = BehaviorRelay(value: [])
    
    var addressDataMonthModel : BehaviorRelay<[AddressDataMonthModel]> = BehaviorRelay(value: [])
    var monthYearViewModel : BehaviorRelay<[AddressCollectionMonthYearViewModel]> = BehaviorRelay(value: [])
 
    var addressDataModel : AddressDataModel = AddressDataModel()
    var currentMonthYear = MonthYear()
    
    let api: Provider<MultiTarget>
    private(set) var rootViewModel: RootViewModel
    private let limit: Int = 50
    private let rooms = Int.random(in: 1..<20)
    private var randomPic = [String]()
    private var defaultCellViewModels = [AddressCollectionViewCellViewModel]()
    
    let disposeBag = DisposeBag()
    init(rootViewModel : RootViewModel = RootViewModel(), api: Provider<MultiTarget> = ProviderAPIBasic<MultiTarget>()) {
        self.api = api
        self.rootViewModel = rootViewModel
        super.init()
        bindToEvents()
    }
    
    private func convertMonthYear(monthYear: String?) -> MonthYear {
        var monthYearData = MonthYear()
        if let monthYear = monthYear?.split(separator: "/"),
            monthYear.count > 1{
            if let month = Int(monthYear[0]), let year = Int(monthYear[1]) {
                monthYearData = MonthYear(month: month,
                                          year: year)
            }
           
        }
        return monthYearData
    }
    func bindToEvents() {
        addressDataMonthModel.map {data in
            data.map {cell in
//                var monthYearData = MonthYear()
//                if let monthYear = cell.monthYear?.split(separator: "/"),
//                    monthYear.count > 1{
//                    if let month = Int(monthYear[0]), let year = Int(monthYear[1]) {
//                        monthYearData = MonthYear(month: month,
//                                                  year: year)
//                    }
//
//                }
            
                var monthYearData = self.convertMonthYear(monthYear: cell.monthYear)
                
                let roomData = cell.roomData.map { data in
                    data.map { cell in
                        return AddressCollectionViewCellViewModel(roomNums: cell.roomNums,
                                                                  renters: cell.renters,
                                                                  status: cell.status,
                                                                  waterNum: cell.waterNum,
                                                                  lastWaterNum: cell.lastWaterNum,
                                                                  electricNum: cell.electricNum,
                                                                  lastElectricNum: cell.lastElectricNum,
                                                                  totalNum: cell.totalNum)
                    }
                }
                return AddressCollectionMonthYearViewModel(monthYear: monthYearData,
                                                           cellViewModels: roomData ?? [])
            }
        }.bind(to: monthYearViewModel).disposed(by: disposeBag)
    }
    
    func getMonthYearData() {
        createStubData()
        rootViewModel.handleProgress(true)
        api.request(MultiTarget(AddressCollectionTarget.getAddressData(id: "123")))
            .map(AddressDataModel.self, using: JSONDecoder.decoderAPI(), failsOnEmptyData: false)
            .subscribe {[weak self] event in
                guard let self = self else { return }
                switch event {
                case .success(let value):
                    self.addressDataModel = value
                    if let data = value.data {
                        self.addressDataMonthModel.accept(data)
                    }
                    SVProgressHUD.dismiss()
                case .failure(_):
                    SVProgressHUD.dismiss()
                    break
                }
            }.disposed(by: disposeBag)
    }
    
    func getData(date: MonthYear){
        currentMonthYear = date
        var data = [AddressCollectionViewCellViewModel]()
        let checkData = monthYearViewModel.value.contains(where: { $0.monthYear == date})
        if (checkData){
            if let cellViewModel = monthYearViewModel.value.filter({$0.monthYear == date}).first?.cellViewModels {
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
        
        let cellData = [AddressCollectionDropDownCellViewModel(image: UIImage(named: "yesSymbol"),
                                                               title: Language.localized("yesSymbolText"),
                                                               imageHeight: 40),
                        AddressCollectionDropDownCellViewModel(image: UIImage(named: "pendingSymbol"),
                                                               title:  Language.localized("pendingSymbolText"),
                                                               imageHeight: 40),
                        AddressCollectionDropDownCellViewModel(image: UIImage(named: "vacancySymbol"),
                                                               title:  Language.localized("vacancySymbolText"),
                                                               imageHeight: 40)]
        
        dropdownCellViewModels.accept(data)
        collectionViewCellDropdownCellViewModels.accept(cellData)
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

//Reload Data when RoomView Data Changed
extension AddressCollectionViewModel{
    func updateAddressDataModel(roomData: [RoomDataModel], monthYear: MonthYear) {
        if let pos = self.addressDataModel.data?.firstIndex(where: { data in
            var monthYearData = self.convertMonthYear(monthYear: data.monthYear)
            return monthYearData == monthYear
        }) {
            var addressData = self.addressDataModel
            addressData.data?[pos].roomData = roomData
            self.addressDataModel = addressData
            if let data = addressDataModel.data {
                self.addressDataMonthModel.accept(data)
            }
        }
    }
}

// Create Dummy data
extension AddressCollectionViewModel {
    func createStubData(){
        let monthYear = MonthYear()
        let totalRoom = Int.random(in: 3..<20)
        var roomData : [String:Any] = ["address" : "99/4A, KP2A, P. Dong Hung Thuan, Q12, TP.Ho Chi Minh",
                                       "totalRoom" : totalRoom]
        
        var lastWater = Array(repeating: 0, count: totalRoom)
        var lastElectric = Array(repeating: 0, count: totalRoom)
        
        var dataTemp = [[String : Any]]()
        for interator in 0...12 {
            let currentMonth = monthYear - 12 + interator
            let monthString = "\(currentMonth.month)/\(currentMonth.year)"
            var data : [String:Any] = ["monthYear" : monthString,
                                       "globalElectric" : 3000,
                                       "globalWater" : 7000,
                                       "globalQuota" : 4,
                                       "globalQuotaPrice": 3000,
                                       "globalRoomPrice": Int.random(in: 1500000..<2000000).roundNumber(numberOfZero: 5, type: .toNearestOrEven)]
            
            let status = ["Paid", "Pending", "NotPaid","Vacancy"]

            var roomDataTemp = [[String : Any]]()
            for roomNum in 0..<totalRoom {
                var roomData : [String:Any] = [:]

                let quota = data["globalQuota"] as! Int
                let quotaPrice = data["globalQuotaPrice"] as! Int
                let roomPrice = data["globalRoomPrice"] as! Int
                
                let waterNum = lastWater[roomNum] + Int.random(in: 5..<40)
                let waterPrice = data["globalWater"] as! Int
                let lastWaterNum = lastWater[roomNum]
                lastWater[roomNum] = waterNum
                
                let electricNum = lastElectric[roomNum] + Int.random(in: 5..<40)
                let electricPrice = data["globalElectric"] as! Int
                let lastElectricNum = lastElectric[roomNum]
                lastElectric[roomNum] = electricNum
                
                roomData["status"] = status[Int.random(in: 0..<status.count)]
                roomData["roomNums"] = roomNum + 1
                roomData["renters"] = Int.random(in: 1..<5)
                roomData["quota"] = data["globalQuota"]
                roomData["quotaPrice"] = data["globalQuotaPrice"]
                
                roomData["waterNum"] = waterNum
                roomData["waterPrice"] = waterPrice
                roomData["lastWaterNum"] = lastWaterNum
                
                roomData["electricNum"] = electricNum
                roomData["electricPrice"] = electricPrice
                roomData["lastElectricNum"] = lastElectricNum
                
                roomData["roomPrice"] = roomPrice
                
                var water = 0
                if (waterNum - lastWaterNum > quota){
                    let usedWater = waterNum - lastWaterNum
                    water = ((usedWater - quota) * quotaPrice) + (usedWater * waterPrice)
                }
                else {
                    water = (waterNum - lastWaterNum) * waterPrice
                }
                let total = roomPrice + ((electricNum - lastElectricNum)*electricPrice) + water
                roomData["totalNum"] = total
                
                roomDataTemp.append(roomData)
            }
            data["roomData"] = roomDataTemp
            dataTemp.append(data)
        }
        
        roomData["data"] = dataTemp
        
        let baseURl = "reqres.in"
        stub(condition: isHost("\(baseURl)") &&  isPath("/api/getaddress")) { _ in
            return HTTPStubsResponse(jsonObject: roomData, statusCode: 200, headers: nil)
        }
    }
}

