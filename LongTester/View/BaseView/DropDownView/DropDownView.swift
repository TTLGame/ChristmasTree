//
//  DropDownView.swift
//  LongTester
//
//  Created by Long on 5/17/23.
//

import Foundation
import UIKit


class DropDownView : UIView {
    enum HozitonalDirection {
        case left
        case right
    }
    
    enum VerticalDirection {
        case top
        case bottom
    }
    //Private variables
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet var _contentView: UIView!
    
    private var tblView: UITableView!
    private var _containView: UIView!
    
    weak var delegate : DropDownViewDelegate?
   
    //Public variables
    public var nibCell : UITableViewCell.Type = BaseDropDownCell.self {
        didSet {
            self.tblView.register(UINib(nibName: String(describing: nibCell), bundle: nil), forCellReuseIdentifier: String(describing: nibCell))
            tblView.reloadData()
        }
    }

    public var cellViewModels : [BaseDropDownCellViewModel] = [] {
        didSet{
            tblView.reloadData()
        }
    }
    
    public var tableWidth : CGFloat?  {
        didSet{
            updateTbleView()
        }
    }
    
    public var cellHeight : CGFloat? {
        didSet{
            tblView.reloadData()
        }
    }
    
    public var tableHeight : CGFloat = 250 {
        didSet{
            updateTbleView()
        }
    }
    
    public var horizonalDirection : HozitonalDirection = .right {
        didSet{
            updateTbleView()
        }
    }
    
    public var verticalDirection : VerticalDirection = .bottom {
        didSet{
            updateTbleView()
        }
    }
    
    public var bgColor : UIColor = UIColor.white {
        didSet{
            tblView.backgroundColor = bgColor
        }
    }
    
    public var closeOnSelect : Bool = true
    
    
    private var anchorView :UIView!
    //Variable
    init(frame: CGRect, anchorView: UIView) {
        super.init(frame: frame)
        self.anchorView = anchorView
        setupUI()
        setupDismissView()
        DispatchQueue.main.async {
            self._contentView.addSubview(self.tblView)
        }
        
        self.commonInit()
    }
    private func setupDismissView(){
        DispatchQueue.main.async {
            let uiTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDismiss))
            self.dismissView.addGestureRecognizer(uiTapGesture)
        }
    }
    
    @objc func handleDismiss() {
        hide()
    }
    
    private func setupUI(){
        self.tblView = UITableView(frame: CGRect(x: anchorView.frame.origin.x,
                                                 y: anchorView.frame.origin.y + anchorView.frame.height + 8,
                                                 width: anchorView.frame.width,
                                                 height: 250.0))
        
        tblView.backgroundColor = bgColor
        tblView.addBottomShadow(height: 3, alpha: 0.2,radius: 5)
        tblView.layer.masksToBounds = false
        
        self.tblView.separatorColor = UIColor.lightGray
        self.tblView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tblView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.tblView.layer.borderColor = UIColor.clear.cgColor
        self.tblView.layer.borderWidth = 1.0
        self.tblView.layer.cornerRadius = 4
        

    }
    private func updateTbleView(){
        
        var width = anchorView.frame.width
        if let tableWidth = tableWidth{
            width = tableWidth
        }
        var xPos = anchorView.frame.origin.x
        var yPos = anchorView.frame.origin.y + anchorView.frame.height + 12
        if (horizonalDirection == .left){
            xPos = anchorView.frame.origin.x - width + anchorView.frame.width/2
        }
        
        if (verticalDirection == .top){
            yPos = anchorView.frame.origin.y - 12 - tableHeight
        }
        
        tblView.frame = CGRect(x: xPos, y: yPos, width: width, height: tableHeight)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    func commonInit(){
        loadViewFromNib()
        setupTableView()
    }
    
    private func setupTableView(){
        self.tblView.register(UINib(nibName: String(describing: BaseDropDownCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BaseDropDownCell.self))

        tblView.dataSource = self
        tblView.delegate = self
    }
}

//MARK: Public Function which can be access
extension DropDownView {
    
}
extension DropDownView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellHeight = cellHeight {
            return cellHeight
        }
        return UITableView.automaticDimension
    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let bg = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
//        bg.backgroundColor = .clear
//        return bg
//    }
    
}

extension DropDownView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (cellViewModels.count == 0) {
            tableView.setEmptyData()
        }
        else {
            tableView.restoreNewProduct()
        }
        return cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: String(describing: nibCell),
//            for: indexPath)
        
        var cell: BaseDropDownCell! = tableView.dequeueReusableCell(
            withIdentifier: String(describing: nibCell),
            for: indexPath) as? BaseDropDownCell
        cell.viewModel = cellViewModels[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(indexPath: indexPath)
        if (closeOnSelect) {
            self.hide()
        }
    }
}

extension DropDownView {
    func show() {
        if let supperView = self.anchorView.superview {
            self._contentView.tag = 6788
            supperView.addSubview(self._contentView)
        }
        
        _contentView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self._contentView.alpha = 1
            self.layoutIfNeeded()
        } completion: { _ in }
        delegate?.didOpenDropDown()
    }
    
    func hide() {
        _contentView.alpha = 1
        UIView.animate(withDuration: 0.2) {
            self._contentView.alpha = 0
            self.layoutIfNeeded()
        } completion: { _ in
            if let supperView = self.anchorView.superview {
                if let tableView = supperView.viewWithTag(6788) {
                    tableView.removeFromSuperview()
                }
            }
        }
        delegate?.didCloseDropdown()
    }
}
