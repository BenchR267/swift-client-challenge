// ---------------------------------------------------
//  MainViewController.swift
//  LoginScreen
//
//  Copyright © 2016 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------


import UIKit


class MainViewController: UIViewController, LoginViewControllerDelegate, UnwindLogin {

    @IBOutlet weak var thumbUpField: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    private var firstStart = true
    private var loggedIn = false {
        didSet {
            thumbUpField.text = loggedIn ? "👍" : "❌"
            loginButton.setTitle(loggedIn ? "Logout" : "Login", forState: .Normal)
        }
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstStart {
            if let loginViewController = storyboard?.instantiateViewControllerWithIdentifier("Login") as? LoginViewController {
                loginViewController.delegate = self
                presentViewController(loginViewController, animated: false, completion: nil)
            }
            firstStart = false
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let loginViewController = segue.destinationViewController as? LoginViewController {
            loginViewController.delegate = self
        }
    }


    @IBAction func loginInOut() {
        if loggedIn {
            loggedIn = false
        }
        else {
            self.performSegueWithIdentifier("ShowLogin", sender: self)
        }
    }
}


// MARK: - LoginViewControllerDelegate Protocol

extension MainViewController {

    func checkAccessForEmail(email: String, password: String) -> Bool {
        return email == "login@example.de" && password == "Geheim"
    }
}


// MARK: - UnwindLogin Protocol

extension MainViewController {

    @IBAction func unwindLoginCanceled(sender: UIStoryboardSegue) {
    }


    @IBAction func unwindLoginSuccess(sender: UIStoryboardSegue) {
        loggedIn = true
    }
}
