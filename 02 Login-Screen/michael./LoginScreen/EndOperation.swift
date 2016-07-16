// ---------------------------------------------------
//  EndOperation.swift
//  LoginScreen
//
//  Copyright © 2016 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------


import UIKit


class EndOperation: NSOperation {

    private let controller: LoginViewController
    private var animationFinished = false

    override var finished: Bool { return animationFinished }


    init(controller: LoginViewController) {
        self.controller = controller
        super.init()
    }


    override func main() {
        if  cancelled {
            animationFinished = true
            return
        }

        if controller.accessGranted {
            controller.showSafeWheel(true) { flag in
                self.willChangeValueForKey("isFinished")
                self.animationFinished = true
                self.didChangeValueForKey("isFinished")
                self.controller.performSegueWithIdentifier("Login", sender: self.controller)
            }
        }
        else {
            controller.hideSafeWheel()
            willChangeValueForKey("isFinished")
            animationFinished = true
            didChangeValueForKey("isFinished")
        }
    }
}
