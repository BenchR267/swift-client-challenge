// ---------------------------------------------------
//  MainViewController.swift
//  LoginScreen
//
//  Copyright © 2016 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------


import UIKit


class MainViewController: UIViewController {

    @IBOutlet weak var thumbUpField: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    private var loggedIn = false {
        didSet {
            thumbUpField.text = loggedIn ? "👍" : "❌"
            loginButton.setTitle(loggedIn ? "Logout" : "Login", forState: .Normal)
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

    @IBAction func unwindLoginCanceled(sender: UIStoryboardSegue) {}


    @IBAction func unwindLoginSuccess(sender: UIStoryboardSegue) {
        loggedIn = true
    }
}
