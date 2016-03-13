//
//  RepoTableViewController.swift
//  SwiftDEGithubChallenge
//
//  Created by Silas Knobel on 09/03/16.
//  Copyright © 2016 Katun. All rights reserved.
//

import UIKit

class RepoTableViewController: UITableViewController {
    
    // MARK: Properties
    var tableData: [GithubRepo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var onceToken: dispatch_once_t = 0
    
    //MARK: Lifecycle
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_once(&onceToken) {
            self.askUsername()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRepoDetails" {
            let vc = segue.destinationViewController as! RepoDetailViewController
            vc.repo = tableData[(sender as! NSIndexPath).row]
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)

        let repo = tableData[indexPath.row]
        cell.textLabel!.text = repo.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showRepoDetails", sender: indexPath)
    }
    
    //MARK: Internals
    @IBAction func askUsername(sender: AnyObject? = nil) {
        let alert = UIAlertController(title: "Gib bitte einen Github Benutzernamen ein", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(nil)
        alert.addAction(UIAlertAction(title: "Repos laden", style: .Default, handler: { (action) -> Void in
            guard let textField = alert.textFields?.first else { return }
            guard let username = textField.text else { return }
            self.loadRepositoryListForUser(username)
        }))
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func loadRepositoryListForUser(username: String) {
        navigationItem.title = "Github/\(username)"
        Api.sharedInstance.username = username
        Api.sharedInstance.repositoryList { (repos, error) -> Void in
            self.handleError(error)
            self.tableData = repos
        }
    }
    
    private func handleError(error: ErrorType?) {
        guard let e = error else { return }
        if e is ApiError {
            switch e as! ApiError {
            case .NotFound:
                presentApiAlert("Keine Repos gefunden")
            }
        }
        else {
            presentApiAlert((e as NSError).localizedDescription)
        }
    }
    
    private func presentApiAlert(message: String) {
        let alert = UIAlertController(title: "ApiError", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

}
