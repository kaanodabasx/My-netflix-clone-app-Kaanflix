//
//  Extension.swift
//  Kaanflix
//
//  Created by Kaan Odabaş on 16.08.2023.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
