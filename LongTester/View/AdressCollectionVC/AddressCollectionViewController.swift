//
//  AddressCollectionViewController.swift
//  LongTester
//
//  Created by Long on 4/22/23.
//

import UIKit

class AddressCollectionViewController: UIViewController {

    @IBOutlet weak var radioViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    private var shouldChangeValue = false
    private var contentY : CGFloat = 0
    private var currentHeight : CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    private func setup(){
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        detailCollectionView.register(UINib(nibName: String(describing: AddressCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: AddressCollectionViewCell.self))
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AddressCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(indexPath: indexPath)
    }
}


//MARK: Handle Cell Pressed
extension AddressCollectionViewController {
    private func didSelectItem(indexPath: IndexPath){

    }
    
}
extension AddressCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingFinished(scrollView: scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            //didEndDecelerating will be called for sure
            return
        }
        scrollingFinished(scrollView: scrollView)
    }

    func scrollingFinished(scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.2) {
            if (self.contentY < 5){
                self.radioViewHeightConstraint.constant = 50
            }
            if (self.radioViewHeightConstraint.constant > 30){
                self.radioViewHeightConstraint.constant = 50
            }
            else {
                self.radioViewHeightConstraint.constant = 0
            }
            self.shouldChangeValue = false
        } completion: { _ in
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var scrollPos = scrollView.contentOffset.y
        if (!shouldChangeValue) {
            shouldChangeValue = true
            contentY = scrollPos
            currentHeight = radioViewHeightConstraint.constant
        }
        
        else if (shouldChangeValue) {
            let changePos = (scrollPos - contentY)/2
            if (changePos) > 0 {
                radioViewHeightConstraint.constant = currentHeight - changePos < 0 ? 0 : currentHeight - changePos
            }
            else {
                radioViewHeightConstraint.constant = currentHeight - changePos > 50 ? 50 : currentHeight - changePos
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: AddressCollectionViewCell! = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: AddressCollectionViewCell.self),
            for: indexPath) as? AddressCollectionViewCell
        
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
