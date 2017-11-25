//
//  URLConvertible.swift
//  Architekturen
//
//  Created by Marius Landwehr on 25.11.17.
//  Copyright © 2017 swiftde. All rights reserved.
//

import Foundation

protocol URLConvertible {
    func asURL() throws -> URL
}
