//
//  BaseNavigationView.swift
//  LongTester
//
//  Created by Long on 4/14/23.
//

import Foundation
import UIKit

import SnapKit

//final class BaseNavigationView: UINavigationController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.isEnabled = false
//        delegate = self
//        navigationBar.setColors(background: Color.primary, text: .white)
////        navigationBar.shadowImage = R.image.imageShadowNavibarBlue()
//        self.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.red,
//            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
//        ]
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if let preferredStatusBarStyle = topViewController?.preferredStatusBarStyle {
//            return preferredStatusBarStyle
//        }
//        return .lightContent
//    }
//
//    func setTile(title: String){
//        navigationBar.topItem?.title = title
//
//    }
//}
//
//extension BaseNavigationView: UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        viewController.navigationItem.backBarButtonItem = backBarButton
//    }
//}

extension UINavigationBar {
    public func setColors(background: UIColor, text: UIColor) {
        isTranslucent = false
        backgroundColor = background
        barTintColor = background
//        setBackgroundImage(UIImage(), for: .default)
        tintColor = text
        titleTextAttributes = [.foregroundColor: text]
    }
}


class BaseNavigationView: UINavigationController {
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Customize the navigation bar appearance
//        navigationBar.setColors(background: Color.primary, text: .white)
        
        self.initLabel()
        
//        self.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
//        self.navigationBar.tintColor = UIColor.white
//        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func initLabel(){
        self.navigationBar.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
    }
    func setTitle(title: String, color : UIColor = .red){
        navigationBar.topItem?.title = ""
        navigationBar.tintColor = color
        self.navigationBar.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        let attribute = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        label.attributedText =  NSAttributedString(string: title,
                                                   attributes: attribute)
        
        
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if self.viewControllers.count > 1 {
            let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(BaseNavigationView.back(sender:)))
            viewController.navigationItem.backBarButtonItem = backBarButton
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        print("Going here")
        _ = navigationController?.popViewController(animated: true)
    }
    
}
