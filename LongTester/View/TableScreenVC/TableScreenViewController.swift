//
//  TableScreenViewController.swift
//  LongTester
//
//  Created by Long on 1/4/23.
//

import Foundation
import UIKit
import RxSwift
class TableScreenViewController : UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    private(set) var binding: Disposable?
    var viewModel = TableScreenViewModel()
    var currentColor : UIColor = UIColor(red: 110/255, green: 235/255, blue: 52/255, alpha: 1)
    var pressed = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
    }
    @IBAction func pressMeBtn(_ sender: Any) {
        pressed = !pressed
        currentColor = pressed ? UIColor(red: 110/255, green: 235/255, blue: 52/255, alpha: 1) :
                                 UIColor(red: 115/255, green: 25/255, blue: 152/255, alpha: 1)
        tblView.reloadData()
    }
    
    private func setupTableView(){
        self.tblView.register(UINib(nibName: String(describing: TableScreenCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TableScreenCell.self))
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
}
extension TableScreenViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension TableScreenViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueCell(TableScreenCell.self)
//        return cell
        
        let cell: TableScreenCell! = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TableScreenCell.self),
            for: indexPath) as? TableScreenCell
        cell.renderColor(color: currentColor, pressed : pressed)
        return cell
    }
    
    
}
