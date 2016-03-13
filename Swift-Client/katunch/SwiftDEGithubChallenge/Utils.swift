//
//  Utils.swift
//  SwiftDEGithubChallenge
//
//  Created by Silas Knobel on 13/03/16.
//  Copyright © 2016 Katun. All rights reserved.
//

import Foundation

class Utils {
    class func dispatchOnMainQueue(block: dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
}