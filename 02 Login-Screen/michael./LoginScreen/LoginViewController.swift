// ---------------------------------------------------
//  LoginViewController.swift
//  LoginScreen
//
//  Copyright © 2016 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------


import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButon: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var combinationLabel: UILabel!
    @IBOutlet weak var openerConstraint: NSLayoutConstraint! { didSet { openerConstraint.constant = 0 } }
    @IBOutlet weak var splitContstaint: NSLayoutConstraint!
    @IBOutlet weak var safeWheel: SafeWheelView!

    private var showObserver: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?

    var accessGranted: Bool = false


    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }


    // MARK: - Keyboard Handling

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Center the interface above the keyboard
        showObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil) { notification in
            guard self.splitContstaint.constant == 0 else { return }
            let frame = self.passwordField.convertRect((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue(), fromView: nil)
            UIView.animateWithDuration((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue) {
                self.splitContstaint.constant = frame.size.height
                self.view.layoutIfNeeded()
            }
        }

        // Move the interface back
        hideObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil) { notification in
            UIView.animateWithDuration((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue) {
                self.splitContstaint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }


    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let observer = showObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
            showObserver = nil;
        }
        if let observer = hideObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
            hideObserver = nil
        }
    }


    // MARK: - Login Handling

    private func calculateCombination() -> [Int] {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        let emailSplit = email.characters.count / 2
        let passwordSplit = password.characters.count / 2

        guard emailSplit > 0 && passwordSplit > 0 else { return [0, 0, 0, 0] }

        let firstNumber = abs(email.substringToIndex(email.startIndex.advancedBy(emailSplit)).hashValue % 123 + 1)
        let secondNumber = abs(email.substringFromIndex(email.startIndex.advancedBy(emailSplit)).hashValue % 123 + 1)
        let thirdNumber = abs(password.substringToIndex(password.startIndex.advancedBy(passwordSplit)).hashValue % 123 + 1)
        let fourthNumber = abs(password.substringFromIndex(password.startIndex.advancedBy(passwordSplit)).hashValue % 123 + 1)

        return [firstNumber, -secondNumber, thirdNumber, -fourthNumber]
    }


    func checkLogin() {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }

        if email == "login@example.de" && password == "Geheim" {
            accessGranted = true
        }
    }


    @IBAction func cancel() {
        hideKeyboard()
        self.performSegueWithIdentifier("Cancel", sender: self)
    }


    private func hideKeyboard() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }


    @IBAction func login() {
        hideKeyboard()

        let combination = calculateCombination()
        combinationLabel.text = "\(combination[0])L - \(abs(combination[1]))R - \(combination[2])L - \(abs(combination[3]))R"

        // Create Operations with dependencies
        let startOperation = StartOperation(controller: self)
        let rotationOperation = RotationOperation(view: safeWheel, steps: combination)
        let checkOperation = NSBlockOperation { self.checkLogin() }
        let endOperation = EndOperation(controller: self)

        rotationOperation.addDependency(startOperation)
        endOperation.addDependency(checkOperation)
        endOperation.addDependency(rotationOperation)

        // Let the operations do its work
        let mainQueue = NSOperationQueue.mainQueue()
        mainQueue.addOperations([startOperation, rotationOperation, endOperation], waitUntilFinished: false)

        let queue = NSOperationQueue()
        queue.addOperation(checkOperation)
    }


    // MARK: - Animations

     func hideSafeWheel() {
        safeWheel.resetWheel()

        // Hide the safe wheel
        UIView.animateKeyframesWithDuration(0.5, delay: 0, options: .CalculationModeCubic, animations: {
            for (start, duration, value) in [(0.0, 0.5, 0.0), (0.5, 0.125, 60.0), (0.625, 0.125, 0.0), (0.75, 0.125, 30.0), (0.875, 0.125, 0.0)] {
                UIView.addKeyframeWithRelativeStartTime(start, relativeDuration: duration) {
                    self.openerConstraint.constant = CGFloat(value)
                    self.view.layoutIfNeeded()
                }
            }}, completion: nil)

        // Enable input
        emailField.enabled = true
        passwordField.enabled = true
        loginButon.enabled = true
        cancelButton.enabled = true
    }


    func showSafeWheel(full: Bool = false, completion: ((Bool) -> Void)?) {
        // Disable input
        emailField.enabled = false
        passwordField.enabled = false
        loginButon.enabled = false
        cancelButton.enabled = false

        // Show the safe wheel
        UIView.animateWithDuration(0.25, delay: 0.3, options: .CurveEaseInOut, animations: {
            self.openerConstraint.constant = full ? self.view.bounds.size.height : self.view.bounds.size.width
            self.view.layoutIfNeeded()
            }, completion: completion)
    }


    // MARK: - UITextFieldDelegate Protocoll

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else {
            emailField.becomeFirstResponder()
        }

        return true
    }
}
