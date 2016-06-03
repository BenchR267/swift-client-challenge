// ---------------------------------------------------
//  StartOperation.swift
//  LoginScreen
//
//  Copyright © 2016 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------


import UIKit


class StartOperation: NSOperation {

    private let controller: LoginViewController
    private let full: Bool
    private var animationFinished = false

    override var finished: Bool { return animationFinished }


    init(controller: LoginViewController, full: Bool = false) {
        self.controller = controller
        self.full = full
        super.init()
    }


    override func main() {
        if cancelled {
            return
        }

        controller.showSafeWheel(full) { flag in
            self.willChangeValueForKey("isFinished")
            self.animationFinished = true
            self.didChangeValueForKey("isFinished")
        }
    }
}
