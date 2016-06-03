// ---------------------------------------------------
//  SafeWheelView.swift
//  LoginScreen
//
//  Copyright © 2016 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------


import UIKit


class SafeWheelView: UIView, RotationAnimation {

    private let scaleLayer = CALayer()
    private let oneStepAngle = M_PI * 3.6 / 180.0
    private var currentAngle = 0.0
    private var completion: ((Bool) -> Void)? = nil

    @IBInspectable var wheelImageName: String = "SafeWheel"
    @IBInspectable var scaleImageName: String = "Scale"


    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayers()
        resetWheel()
    }


    private func setupLayers() {
        guard let wheelImage = UIImage(named: wheelImageName)?.CGImage else { return }
        guard let image = UIImage(named: scaleImageName ?? "")?.CGImage else { return }

        layer.contents = wheelImage
        layer.addSublayer(scaleLayer)
        scaleLayer.contents = image
        scaleLayer.bounds = layer.bounds
        scaleLayer.position = CGPoint(x: layer.bounds.size.width / 2.0, y: layer.bounds.size.height / 2.0)
    }


    func resetWheel() {
        currentAngle = 0.0
        scaleLayer.transform = CATransform3DIdentity
    }


    func rotate(steps: [Int], completion: ((Bool) -> Void)?) {
        guard let modelLayer = scaleLayer.modelLayer() as? CALayer else { return }
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")

        var angle = 0.0
        let angles = [angle] + steps.map {
            angle -= Double($0) * oneStepAngle
            return angle
        }

        let keyDurations = steps.map { $0 != 0 ? Double(abs($0) / 30) * 0.6 + 0.5 : 0.025 }
        let duration = keyDurations.reduce(0.0) { $0 + $1 }

        var keyTime = 0.0
        let keyTimes = [keyTime] + keyDurations.map {
            keyTime += $0 / duration
            return keyTime
        }

        animation.duration = duration
        animation.values = angles
        animation.keyTimes = keyTimes
        animation.timingFunctions = steps.map { _ in CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) }
        animation.delegate = self

        if let finalAngle = angles.last {
            modelLayer.transform = CATransform3DRotate(scaleLayer.transform, CGFloat(finalAngle), 0.0, 0.0, 1.0)
        }

        self.completion = completion
        scaleLayer.addAnimation(animation, forKey: nil)
    }


    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        guard let completion = completion else { return }
        completion(flag)
        self.completion = nil
    }
}
