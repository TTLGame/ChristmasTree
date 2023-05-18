//
//  AddressCollectionViewController.swift
//  LongTester
//
//  Created by Long on 4/22/23.
//

import UIKit
import RxCocoa
import RxSwift
import DropDown

class AddressCollectionViewController: BaseViewController {

    @IBOutlet weak var radioViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var radioView: AddressCollectionRadioView!
    
    @IBOutlet weak var monthLbl: UILabel!
    
    @IBOutlet weak var monthInfoView: UIView!
    
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var settingBtn: UIButton!
    private var shouldChangeValue = true
    private var lastOffset : CGFloat = 0
    private var viewModel = AddressCollectionViewModel()
    private let sizeMax = CGFloat(40)
//    private var dropdown : DropDownView<BaseDropDownCell, BaseDropDownCellViewModel>!
    private var dropdown : DropDownView<AddressCollectionDropDownCell, AddressCollectionDropDownCellViewModel>!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindToViewModel()
        // Do any additional setup after loading the view.
    }
    private func setup(){
        monthInfoView.addBottomShadow(height: 0, alpha: 0.4,radius: 5)
        setupCollectionView()
        setupDate()
        setupBtnSetting()
        radioView.delegate = self
    }
    
    private func  setupBtnSetting() {
        settingBtn.setTitle("", for: .normal)
//        dropdown = DropDownView<BaseDropDownCell, BaseDropDownCellViewModel>(frame: self.view.frame, anchorView: settingBtn)
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = view
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dropdown = DropDownView<AddressCollectionDropDownCell, AddressCollectionDropDownCellViewModel>(frame: self.view.frame, anchorView: self.settingBtn)
            self.dropdown.tableWidth = 200
            self.dropdown.tableHeight = 100
            self.dropdown.cellHeight = 50
            self.dropdown.heightOffset = 12
            self.dropdown.highLightColor = .clear
            self.dropdown.horizonalDirection = .left
            self.dropdown.delegate = self
        }
      
    }
    private func setupDate(){
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = AppConfig.shared.language == .english ? App.Format.englishMonthYear : App.Format.vietnamMonthYear
        monthLbl.text = AppConfig.shared.language == .english ? formatter.string(from: currentDateTime) :
                                                                "Tháng " + formatter.string(from: currentDateTime)
    }
    private func bindToViewModel() {
        self.viewModel = AddressCollectionViewModel(rootViewModel: rootViewModel as! RootViewModel)
        self.viewModel.cellViewModels.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.detailCollectionView.reloadData()
            
        }).disposed(by: disposeBag)
        
        self.viewModel.radioViewModels.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] viewModel in
            guard let self = self else {return}
            self.radioView.viewModel = viewModel
            
        }).disposed(by: disposeBag)
        
        self.viewModel.dropdownCellViewModels.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] viewModels in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.dropdown.cellViewModels = viewModels
            }
           
        }).disposed(by: disposeBag)
        
        viewModel.getData()
        viewModel.getRadioData()
        viewModel.getDropdownData()
    }
    
    private func setupCollectionView(){
        detailCollectionView.register(UINib(nibName: String(describing: AddressCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: AddressCollectionViewCell.self))
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func settingBtnTapped(_ sender: Any) {
        radioViewInteract(hide: false)
        dropdown.show()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
            [weak self] in
            self?.settingBtn.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (animated) in }
        
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AddressCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(indexPath: indexPath)
    }
}


//MARK: Handle Cell Pressed
extension AddressCollectionViewController {
    private func didSelectItem(indexPath: IndexPath){
        self.viewModel.handlePressData(index: indexPath)
    }
    
}
extension AddressCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (viewModel.cellViewModels.value.count == 0) {
            detailCollectionView.setEmptyData()
        }
        else {
            detailCollectionView.restoreNewProduct()
        }
        return viewModel.cellViewModels.value.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height - (scrollView.frame.size.height)

//        if (contentSize < 0){
//            return
//        }
//
      
        if (lastOffset < scrollPos) { // scroll down
            radioViewHeightConstraint.constant = radioViewHeightConstraint.constant - 1 < 0 ? 0 : radioViewHeightConstraint.constant - 1
            radioView.alpha = CGFloat(radioViewHeightConstraint.constant / sizeMax)
            settingBtn.alpha = CGFloat(radioViewHeightConstraint.constant / sizeMax)
        }
        else {
            radioViewHeightConstraint.constant = radioViewHeightConstraint.constant + 1 > sizeMax ? sizeMax : radioViewHeightConstraint.constant + 1
            radioView.alpha = CGFloat(radioViewHeightConstraint.constant / sizeMax)
            settingBtn.alpha = CGFloat(radioViewHeightConstraint.constant / sizeMax)
        }
        
        if (scrollPos <= 0){
            radioViewInteract(hide: false)
        }
        else if (scrollPos >= contentSize){
            radioViewInteract(hide: true)
        }
        
        if (radioView.alpha <= 0.5){
            radioView.isUserInteractionEnabled = false
            settingBtn.isUserInteractionEnabled = false
        }
        else {
            radioView.isUserInteractionEnabled = true
            settingBtn.isUserInteractionEnabled = true
        }
        lastOffset = scrollPos
    }
    
    private func radioViewInteract(hide: Bool){
        radioViewHeightConstraint.constant = hide ? 0 : sizeMax
        radioView.alpha = hide ? 0 : 1
        settingBtn.alpha = hide ? 0 : 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: AddressCollectionViewCell! = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: AddressCollectionViewCell.self),
            for: indexPath) as? AddressCollectionViewCell
        cell.viewModel = viewModel.cellViewModels.value[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension AddressCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.size.width - 40) / 2.0
        return CGSize(width: width, height: 150)
    }
}

extension AddressCollectionViewController : AddressCollectionRadioViewDelegate {
    func didSortData(type: String) {
        let rootView = rootViewModel as! RootViewModel
        rootView.handleProgress(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            rootView.handleProgress(false)
            self.viewModel.sortData(type: type)
        }
        
        self.detailCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        radioViewHeightConstraint.constant = sizeMax
        radioView.alpha = 1
        settingBtn.alpha = 1
    }
}

extension AddressCollectionViewController : DropDownViewDelegate {
    func didSelect(indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Selected at \(indexPath.row)")
        case 1:
            openSheetViewInfo()
        default:
            break
        }
    }
    
    func didCloseDropdown(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
            [weak self] in
            self?.settingBtn.transform = CGAffineTransform.identity
        }) { (animated) in }
    }
}

//MARK: Handle dropdown Selection
extension AddressCollectionViewController {
    func openSheetViewInfo(){
        let sheetView = BaseSheetView(frame: self.view.frame, size: .percent(0.5), baseVC: self, view: UIView())
        sheetView.open()
    }
}
