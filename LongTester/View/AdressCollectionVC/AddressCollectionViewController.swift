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
    private var dropdown : DropDownView!
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
        dropdown = DropDownView(frame: self.view.frame, anchorView: settingBtn)
        dropdown.tableWidth = 200
        dropdown.cellHeight = 50
        dropdown.horizonalDirection = .left
        dropdown.cellViewModels = [BaseDropDownCellViewModel(title: "Add Data"),
                                   BaseDropDownCellViewModel(title: "Add Data")]
        dropdown.delegate = self
        
//        dropDown.anchorView = settingBtn
//        dropDown.dataSource = ["Add Data", "Info"]
//        dropDown.direction = .bottom
//        DropDown.appearance().trailingAnchor.constraint(equalTo: self.settingBtn.trailingAnchor, constant: 0)
//        DropDown.DismissMode
////        calendarView.trailingAnchor.constraint(equalTo: self.vWindowCalendar.trailingAnchor, constant: 0),
//        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
//
//        let cellViewModels = [AddressCollectionDropDownCellViewModel(image: UIImage(named: "book.fill"), title: "Add Data"),
//                              AddressCollectionDropDownCellViewModel(image: UIImage(named: "info.circle.fill"), title: "Info")]
//        dropDown.cellNib = UINib(nibName: String(describing: AddressCollectionDropDownCell.self), bundle: nil)
//
//        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
//           guard let cell = cell as? AddressCollectionDropDownCell else { return }
//
//            cell.viewModel = cellViewModels[index]
//        }
        
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
        
        viewModel.getData()
        viewModel.getRadioData()
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
        
        dropdown.show()

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
            radioViewHeightConstraint.constant = sizeMax
            radioView.alpha = 1
            settingBtn.alpha = 1
        }
        else if (scrollPos >= contentSize){
            radioViewHeightConstraint.constant = 0
            radioView.alpha = 0
            settingBtn.alpha = 0
        }
        
        if (radioView.alpha <= 0.9){
            radioView.isUserInteractionEnabled = false
            settingBtn.isUserInteractionEnabled = false
        }
        else {
            radioView.isUserInteractionEnabled = true
            settingBtn.isUserInteractionEnabled = true
        }
        lastOffset = scrollPos
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
        print("Selected at \(indexPath.row)")
    }
    
    func didCloseDropdown(){
        
    }
}
