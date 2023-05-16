//
//  AddressCollectionViewController.swift
//  LongTester
//
//  Created by Long on 4/22/23.
//

import UIKit
import RxCocoa
import RxSwift

class AddressCollectionViewController: BaseViewController {

    @IBOutlet weak var radioViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var radioView: AddressCollectionRadioView!
    
    private var shouldChangeValue = true
    private var lastOffset : CGFloat = 0
    private var viewModel = AddressCollectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindToViewModel()
        // Do any additional setup after loading the view.
    }

    private func setup(){
        setupCollectionView()
        radioView.delegate = self
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
        viewModel.cellViewModels.value.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (contentSize < scrollView.frame.size.height + 50){
            return
        }
        
        let sizeMax = CGFloat(40)
        if (lastOffset < scrollPos) { // scroll down
            
            radioViewHeightConstraint.constant = radioViewHeightConstraint.constant - 1 < 0 ? 0 : radioViewHeightConstraint.constant - 1
            radioView.alpha = CGFloat(radioViewHeightConstraint.constant / sizeMax)
        }
        else {
            radioViewHeightConstraint.constant = radioViewHeightConstraint.constant + 1 > sizeMax ? sizeMax : radioViewHeightConstraint.constant + 1
            radioView.alpha = CGFloat(radioViewHeightConstraint.constant / sizeMax)
        }
        
        if (scrollPos <= 0){
            radioViewHeightConstraint.constant = sizeMax
            radioView.alpha = 1
        }
        else if (scrollPos >= contentSize){
            radioViewHeightConstraint.constant = 0
            radioView.alpha = 0
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
        viewModel.sortData(type: type)
    }
}
