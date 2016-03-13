//
//  RepoDetailTableViewController.swift
//  SwiftDEGithubChallenge
//
//  Created by Silas Knobel on 13/03/16.
//  Copyright © 2016 Katun. All rights reserved.
//

import UIKit

class RepoDetailViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: Properties
    var repo: GithubRepo?

    //MARK: Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    //MARK: Internals
    func updateUI() {
        guard let r = repo else { return }
        titleLabel.text = r.name
        descriptionTextView.text = r.description
    }

}
