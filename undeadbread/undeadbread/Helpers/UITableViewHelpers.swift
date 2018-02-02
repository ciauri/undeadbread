//
//  UITableViewHelpers.swift
//  undeadbread
//
//  Created by stephenciauri on 2/1/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func lastRowInSection(section: Int) -> Int {
        return (dataSource?.tableView(self, numberOfRowsInSection: section) ?? 0) - 1
    }
}
