//
//  NSPredicate+helper.swift
//  taskmanager
//
//  Created by Balogun Kayode on 05/09/2025.
//

import Foundation

extension NSPredicate {
    static let all =  NSPredicate(format: "TRUEPREDICATE")
    static let none = NSPredicate(format: "FALSEPREDICATE")
}
