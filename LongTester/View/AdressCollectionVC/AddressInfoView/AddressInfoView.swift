//
//  AddressInfoView.swift
//  LongTester
//
//  Created by Long on 5/18/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AddressInfoView : UIView {
    var baseVC : BaseViewController?
    @IBOutlet weak var tblView: UITableView!
    
    private var viewModel = AddressInfoViewViewModel()
    private let disposeBag = DisposeBag()
    private var monthYearCellData = [AddressCollectionMonthYearViewModel]()
    private var currentMonthYear = MonthYear()
    private var monthYearView : MonthYearView!
    init(frame: CGRect,currentMonthYear : MonthYear, data : [AddressCollectionMonthYearViewModel], baseVC: BaseViewController) {
        super.init(frame: frame)
        self.baseVC = baseVC
        self.monthYearCellData = data
        self.currentMonthYear = currentMonthYear
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        loadViewFromNib()
        setup()
        setupMonthPicker()
        bindData()
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if(newWindow != nil){
            
        }
    }
    
    private func bindData(){
        self.viewModel = AddressInfoViewViewModel(rootViewModel: baseVC?.rootViewModel as! RootViewModel)
        self.viewModel.monthYearCellData = monthYearCellData
        self.viewModel.currentMonthYear = currentMonthYear
        self.viewModel.cellViewModels.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.tblView.reloadData()
            
        }).disposed(by: disposeBag)
        self.viewModel.getData(date: currentMonthYear)
    }
    
    private func setup(){
        self.tblView.register(UINib(nibName: String(describing: AddressInfoViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AddressInfoViewCell.self))
        self.tblView.delegate = self
        self.tblView.dataSource = self

    }
    
    private func setupMonthPicker(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let baseVC = self.baseVC {
                self.monthYearView = MonthYearView(frame: baseVC.view.frame, size: .fixed(400), baseVC: baseVC)
                self.monthYearView.selectedDate = self.currentMonthYear
                self.monthYearView.delegate = self
                self.monthYearView.setupPicker()
            }
        }
    }
}

extension AddressInfoView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 40 : 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: section == 0 ? 40 : 10))
        bg.backgroundColor = .clear
        
        if (section != 0){
            return bg
        }
        else {
            let contentView = UIView()
            let shadowView = UIView()
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            
            bg.addSubview(shadowView)
            bg.addSubview(contentView)
          
            contentView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-5)
                make.top.equalToSuperview().offset(5)
                make.right.equalToSuperview().offset(-30)
            }
            
            shadowView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-8)
                make.top.equalToSuperview().offset(8)
                make.right.equalToSuperview().offset(-33)
            }
            
            let year = viewModel.currentMonthYear.year
            let month = viewModel.currentMonthYear.month
            let date = Date("\(year)-\(month)-01")
            
            label.text = getDateLbl(date: date)
            
            label.font = UIFont.systemFont(ofSize: 12)
            contentView.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            
//            shadowView.backgroundColor = UIColor.white
//            shadowView.addBottomShadow(height: 3, alpha: 0.5,radius: 10)
//            shadowView.layer.masksToBounds = false
    
            contentView.backgroundColor = UIColor.white
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 1.0
            contentView.layer.cornerRadius = 10
            contentView.layer.masksToBounds = true

            let gesture = UITapGestureRecognizer(target: self, action: #selector(monthInfoTapped))
            contentView.addGestureRecognizer(gesture)
            
            return bg
        }
    }
    
    @objc func monthInfoTapped(){
        monthYearView.open()
    }
    
    private func getDateLbl(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT+7")
        formatter.dateFormat = AppConfig.shared.language == .english ? App.Format.englishMonthYear : App.Format.vietnamMonthYear
        return AppConfig.shared.language == .english ? formatter.string(from: date) :
                                                                "Tháng " + formatter.string(from: date)
    }
}

extension AddressInfoView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if (viewModel.cellViewModels.value.count == 0) {
            tableView.setEmptyData()
        }
        else {
            tableView.restoreNewProduct()
        }
        return viewModel.cellViewModels.value.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value[section].cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressInfoViewCell! = tableView.dequeueReusableCell(
            withIdentifier: String(describing: AddressInfoViewCell.self),
            for: indexPath) as? AddressInfoViewCell
        cell.selectionStyle = .none
        cell.viewModel = viewModel.cellViewModels.value[indexPath.section].cellViewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        rootViewModel.alertModel.accept(AlertModel(message: "123"))
//        self.handlePressData(indexPath: indexPath)
    }
}


extension AddressInfoView : MonthYearViewDelegate {
    func didSelectDate(value: Date) {
        let calendar = Calendar.current
        let date = value
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        viewModel.getData(date: MonthYear(month: month, year: year))
    }
}
