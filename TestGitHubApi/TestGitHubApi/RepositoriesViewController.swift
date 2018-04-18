//
//  ViewController.swift
//  TestGitHubApi
//
//  Created by Alex Voronov on 07.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController {
    
    // MARK: Properties
    var user = User()
    var searchManager = SearchManager()
    
    // MARK: IBOutlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalNumberLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var spinnerActivity: UIActivityIndicatorView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultTextsForLabels()
        
        // "findRepositoriesFor" launches request and notification gets it
        NotificationCenter.default.addObserver(self, selector: #selector(gotRepositoriesAndUser), name: NSNotification.Name(rawValue: "ToRepositories"), object: nil)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
            guard let detailViewController = segue.destination as? DetailRepoViewController, let indexPath = tableView.indexPathForSelectedRow else { fatalError("Application storyboard mis-configuration") }

            detailViewController.repository = self.user.repositories[indexPath.row]
            detailViewController.avatarImageLink = self.user.avatarURL
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: IBActions
extension RepositoriesViewController {
    
    @IBAction func findRepositoriesTapped(_ sender: UIButton) {
        guard textField.text != "", textField.text != nil else { return }
        
        spinnerActivity.startAnimating()
        
        let gitHubLogin = textField.text!
        
        user = User()
        
        setDefaultTextsForLabels()
        searchManager.findRepositories(for: gitHubLogin)
    }
}

// MARK: Private
private extension RepositoriesViewController {
    
    func setDefaultTextsForLabels() {
        self.totalNumberLabel.text = ""
        self.userNameLabel.text = ""
    }
    
    // TODO: change scheme. Now works in pair with notification + func "findRepositoriesFor"
    @objc func gotRepositoriesAndUser(notification: Notification) {
        
        spinnerActivity.stopAnimating()
        
        guard let userInfo = notification.userInfo else { return }
        
        // TODO: make it more elegant
        user.name = userInfo["gitUserName"] as? String
        user.avatarURL = (userInfo["gitUserAvatarURL"] as? String)
        user.login = (userInfo["gitUserLogin"] as? String) ?? ""
        
        self.totalNumberLabel.text = "\(userInfo["repositoriesCount"] ?? "")"
        
        if let userExists = (userInfo["gitUserExists"] as? Bool) {
            if userExists {
                if let repositories = userInfo["repositories"] as? [Repository] {
                    self.user.repositories = repositories.sorted(){ $0.stargazersCount! > $1.stargazersCount! }
                }
                
                userNameLabel.text = user.name ?? "user has not specified his name"
                totalNumberLabel.isHidden = false
                
            } else {
                userNameLabel.text = "Not found user '\(user.login)' :("
                totalNumberLabel.isHidden = true
                self.user.repositories = []
            }
            
        } else {
            userNameLabel.text = "error occured... try again"
            totalNumberLabel.isHidden = true
        }
        
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate
extension RepositoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: indexPath)
    }
}

// MARK: UITableViewDataSource
extension RepositoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "repoListCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RepoListTableViewCell else { fatalError("guard: something wrong with cell '\(cellIdentifier)'") }
        
        let numberOfStars = user.repositories[indexPath.row].stargazersCount ?? 0

        //cell.textLabel?.text = user.repositories[indexPath.row].name
        
        cell.repoNameLabel.text = user.repositories[indexPath.row].name
        cell.numberOfStarsLabel.text = "\(numberOfStars)"
        
        return cell
    }
}
