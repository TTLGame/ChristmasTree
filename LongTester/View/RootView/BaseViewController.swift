//
//  BaseViewController.swift
//  LongTester
//
//  Created by Long on 4/21/23.
//

import UIKit
import RxSwift
class BaseViewController: UIViewController, BasicViewPresentableView {
    var rootViewModel: BasicViewModel
    var alertViewModel: AlertPresentableViewModel
    
    
    let disposeBag: DisposeBag = DisposeBag()
    init(rootViewModel: BasicViewModel = RootViewModel()) {
        self.rootViewModel = rootViewModel
        alertViewModel = rootViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAlertViewModel(alertViewModel)
        // Do any additional setup after loading the view.
    }
    
    @discardableResult
    func bindAlertViewModel(_ alertViewModel: AlertPresentableViewModel) -> Disposable {
        let disposable = alertViewModel.alertModel.observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (model: AlertModel?) in
                guard let model = model else {
                    return
                }

                let alert = AlertBuilder.buildAlertController(for: model)
                self?.present(alert, animated: true, completion: nil)
            })
        disposable.disposed(by: disposeBag)
        return disposable
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
