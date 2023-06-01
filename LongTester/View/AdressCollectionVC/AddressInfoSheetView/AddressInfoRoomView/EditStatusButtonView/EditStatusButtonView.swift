//
//  EditStatusButtonView.swift
//  LongTester
//
//  Created by Long on 6/1/23.
//

import Foundation
import UIKit
import RxSwift

protocol EditStatusButtonViewDelegate : AnyObject {
    func didChangeData()
    func didChangeStatusEditState(state: Bool)
}
class EditStatusButtonView : UIView {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    weak var delegate : EditStatusButtonViewDelegate?
    var baseVC : BaseViewController? {
        didSet {
            bindData()
        }
    }
    private var viewModel = EditStatusButtonViewModel()
    private let disposeBag = DisposeBag()
    private var pickerView : BasePickerView!
    
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
    }
    
    private func bindData(){
        self.viewModel = EditStatusButtonViewModel(rootViewModel: baseVC?.rootViewModel as! RootViewModel)
        self.viewModel.editingState.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.changeEditState()
            self.delegate?.didChangeStatusEditState(state: self.viewModel.editingState.value)
            
        }).disposed(by: disposeBag)
    }
    
    private func setup(){
        cancelBtn.backgroundColor = .white
        cancelBtn.setTitle(Language.localized("cancelBtn"), for: .normal)
        editBtn.backgroundColor = .white
        editBtn.setTitle(Language.localized("editStatusBtn"), for: .normal)

        cancelBtn.layer.cornerRadius = 10
        cancelBtn.backgroundColor = .white
        cancelBtn.layer.masksToBounds = true
        
        editBtn.layer.cornerRadius = 10
        editBtn.backgroundColor = .white
        editBtn.layer.masksToBounds = true
        
        statusImageView.isHidden = true
        self.changeEditState()
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        let change = viewModel.editingState.value
        if (change) {
            delegate?.didChangeData()
            viewModel.changeEditState(change: false)
        }
        else {
            pickerView.open()
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        viewModel.changeEditState(change: false)
    }
    
    private func changeEditState(){
        let change = viewModel.editingState.value
        cancelBtn.isHidden = !change
        cancelBtn.isUserInteractionEnabled = change
        statusImageView.isHidden = !change
        editBtn.setTitle(change ? Language.localized("doneBtn") : Language.localized("editStatusBtn"), for: .normal)
    }
    
    func setupPicker(viewModel: [PickerViewModel]){
        self.viewModel.addDataStatus(data: viewModel)
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let baseVC = self.baseVC else { return }
            self.pickerView = BasePickerView(frame: baseVC.view.frame, size: .fixed(300), baseVC: baseVC)
            self.pickerView.delegate = self
            self.pickerView.viewModel = viewModel
//            self.pickerView.pickerType = .withoutImage
            self.pickerView.setupPicker()
        }
    }
    
    func resetData(){
        viewModel.changeEditState(change: false)
        viewModel.changeCurrentStatus(status: "")
    }
}

extension EditStatusButtonView : BasePickerViewDelegate {
    func didSelectIndex(index: Int, id: String?) {
        viewModel.changeCurrentStatus(status: id ?? "")
        viewModel.changeEditState(change: true)
        statusImageView.image = viewModel.dataStatus.value[index].image
    }
}
