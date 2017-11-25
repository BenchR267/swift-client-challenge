//
//  RepositoriesListViewController.swift
//  Architekturen
//
//  Created by Marius Landwehr on 25.11.17.
//  Copyright © 2017 swiftde. All rights reserved.
//

import UIKit

final class RepositoriesListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Username Repositories"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Name of the repository"
        cell.detailTextLabel?.text = "Full name of the repository"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(RepositoryDetailViewController(), animated: true)
    }
}
