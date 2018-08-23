//
//  TableView.swift
//  dimsum
//
//  Created by tyfoo on 21/08/2018.
//  Copyright © 2018 foo. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
}
extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }

    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
