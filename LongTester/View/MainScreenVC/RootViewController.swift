import UIKit
import SnapKit

final class RootViewController: UIViewController {
    var currentVC: UIViewController!
    enum ScreenType {
        /// Có 2 loại màn hình change password, xuất hiện khi:
        /// - ChangeDefaultPassViewController:
        /// Khi tài khoản chưa bao giờ thay đổi mật khẩu. (Check tại RootViewController)
        /// ----------------------------------------------------------
        /// - ChangePasswordViewController:
        /// Khi ấn vào item trong menu.
        /// Khi lần cuối thay đổi mật khẩu đến thời điểm hiện tại quá 90 ngày. (API checkPasswordExpire)
        case main
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        currentVC = MainScreenViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(currentVC)
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(currentVC.view)
        currentVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        currentVC.didMove(toParent: self)
    }
    
    func show(_ type: ScreenType) {
        var rootViewController: UIViewController
        switch type {
        case .main:
            rootViewController = MainScreenViewController()
            update(current: rootViewController)
        }
    }
}

// Private func
extension RootViewController {
    private func update(current viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        viewController.didMove(toParent: self)
        
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()
        currentVC = viewController
        currentVC.setNeedsStatusBarAppearanceUpdate()
        addChild(currentVC)
    }
}
