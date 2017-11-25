//
//  RepositoryDetailViewController.swift
//  Architekturen
//
//  Created by Marius Landwehr on 25.11.17.
//  Copyright © 2017 swiftde. All rights reserved.
//

import UIKit
import SafariServices

class RepositoryDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var watcherCountLabel: UILabel!
    @IBOutlet var forkCountLabel: UILabel!
    @IBOutlet var starCountLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repository Name"
        setupCollectionView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 23
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row % 3 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PullRequestCollectionViewCell.self), for: indexPath)
            (cell as? PullRequestCollectionViewCell)?.descriptionLabel.text = "Wow such a pull request title"
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IssueCollectionViewCell.self), for: indexPath)
            (cell as? IssueCollectionViewCell)?.descriptionLabel.text = "Wow such a issue title"
            (cell as? IssueCollectionViewCell)?.commentLabel.text = "\(indexPath.row + 1) Comments"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        present(SFSafariViewController(url: try! GithubAPIService.Endpoint.issues(fullReponame: "mRs-/HexColors").asURL()), animated: true, completion: nil)
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: String(describing: PullRequestCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PullRequestCollectionViewCell.self))
        collectionView.register(UINib(nibName: String(describing: IssueCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: IssueCollectionViewCell.self))
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
