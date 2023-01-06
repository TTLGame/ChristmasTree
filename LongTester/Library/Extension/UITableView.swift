//
//  UITableView.swift
//  LongTester
//
//  Created by Long on 1/4/23.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(_ withClass: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: withClass)
        guard let cell = dequeueReusableCell(withIdentifier: className, for: indexPath) as? T else {
            fatalError("\(className) isn't register")
        }
        return cell
    }

    func dequeueCell<T: UITableViewCell>(_ withClass: T.Type) -> T {
        let className = String(describing: withClass)
        guard let cell = dequeueReusableCell(withIdentifier: className) as? T else {
            fatalError("\(className) isn't register")
        }
        return cell
    }
}
