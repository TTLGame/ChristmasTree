//
//  DropDownView.swift
//  LongTester
//
//  Created by Long on 5/17/23.
//

import Foundation
import UIKit


class DropDownView<T: BaseCell<U>, U>: UIView, UITableViewDelegate, UITableViewDataSource {
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

    public var cellViewModels : [U] = [] {
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
    public var heightOffset : CGFloat = 20 {
        didSet{
            updateTbleView()
        }
    }
    
    public var bgColor : UIColor = UIColor.white {
        didSet{
            tblView.backgroundColor = bgColor
        }
    }
    
    public var highLightColor : UIColor = Color.selectTableView {
        didSet{
            tblView.reloadData()
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
                                                 y: anchorView.frame.origin.y + anchorView.frame.height + heightOffset,
                                                 width: anchorView.frame.width,
                                                 height: tableHeight))
        
        tblView.backgroundColor = bgColor
        tblView.addBottomShadow(height: 3, alpha: 0.2,radius: 5)
        tblView.layer.masksToBounds = false
        
        self.tblView.separatorColor = Color.greyPrimary
        
        self.tblView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tblView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.tblView.layer.borderColor = UIColor.clear.cgColor
        self.tblView.layer.borderWidth = 1.0
        self.tblView.layer.cornerRadius = 4
        

    }
    private func updateTbleView(){
        print("anchorView \(anchorView.frame)")
        print("anchorView \(anchorView.frame.midX) \(anchorView.frame.midY)")
        
        var width = anchorView.frame.width
        if let tableWidth = tableWidth{
            width = tableWidth
        }
        var xPos = anchorView.frame.origin.x
        anchorView.frame
        var yPos = anchorView.frame.origin.y + anchorView.frame.height + heightOffset
        if (horizonalDirection == .left){
            xPos = anchorView.frame.origin.x - width + anchorView.frame.width
        }
        
        if (verticalDirection == .top){
            yPos = anchorView.frame.origin.y - heightOffset - tableHeight
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
        nibSetup()
        setupTableView()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        _containView = loadViewFromNib()
        _containView.frame = bounds
        addSubview(_containView)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DropDownView", bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return nibView!
    }
    
    private func setupTableView(){
        self.tblView.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: String(describing: T.self))

//        tblView.register(T.self, forCellReuseIdentifier: "Cell")
        
        tblView.dataSource = self
        tblView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellHeight = cellHeight {
            return cellHeight
        }
        return UITableView.automaticDimension
    }

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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! T
        
        let cell: T! = tableView.dequeueReusableCell(
            withIdentifier: String(describing: T.self),
            for: indexPath) as? T
        cell.viewModel = cellViewModels[indexPath.row]
        
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = highLightColor
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(indexPath: indexPath)
        if (closeOnSelect) {
            self.hide()
        }
    }
    
}
//
//extension DropDownView : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let cellHeight = cellHeight {
//            return cellHeight
//        }
//        return UITableView.automaticDimension
//    }
//
//}
//extension DropDownView : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let cellHeight = cellHeight {
//            return cellHeight
//        }
//        return UITableView.automaticDimension
//    }
//
//}

//extension DropDownView: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (cellViewModels.count == 0) {
//            tableView.setEmptyData()
//        }
//        else {
//            tableView.restoreNewProduct()
//        }
//        return cellViewModels.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: BaseDropDownCell! = tableView.dequeueReusableCell(
//            withIdentifier: String(describing: nibCell),
//            for: indexPath) as? BaseDropDownCell
//        cell.viewModel = cellViewModels[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        delegate?.didSelect(indexPath: indexPath)
//        if (closeOnSelect) {
//            self.hide()
//        }
//    }
//}

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
