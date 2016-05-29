// ---------------------------------------------------
//  RotationOperation.swift
//  LoginScreen
//
//  Copyright © 2016 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------


import UIKit


protocol RotationAnimation {
    func rotate(steps: [Int], completion: ((Bool) -> Void)?)
}


class RotationOperation: NSOperation {

    private let view: RotationAnimation
    private let steps: [Int]
    private var animationFinished = false

    override var finished: Bool { return animationFinished }


    init(view: RotationAnimation, steps: [Int]) {
        self.view = view
        self.steps = steps
        super.init()
    }


    override func main() {
        if cancelled {
            return
        }

        view.rotate(steps) { flag in
            self.willChangeValueForKey("isFinished")
            self.animationFinished = true
            self.didChangeValueForKey("isFinished")
        }
    }
}
