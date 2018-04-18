//
//  SearchManager.swift
//  TestGitHubApi
//
//  Created by Alex Voronov on 09.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import Foundation
import GithubPilot

class SearchManager {
    
    // MARK: Properties
    var avatarImageLink: String?
    var dictionary: [String: Any] = [:]

    // MARK: Initializers
    init() {}
    
    // MARK: Deinitializers
    deinit {
        //print("\(self) is about to be deinited!")
    }
}

// MARK: Internal
extension SearchManager {

    // MARK: Export
    func getUser(with login: String) {
        
        if let client = Github.authorizedClient {
            
            client.users.getUser(username: login).response({ (githubUser, error) -> Void in
                
                guard let gitUserAvatarURL = githubUser?.avatarURL, gitUserAvatarURL != "" else {
                    print(error?.description ?? "error getting user avatar url")
                    return
                }
                //print(githubUser.description)
                self.dictionary["avatarURL"] = gitUserAvatarURL
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Favourite->Detail"), object: nil, userInfo: self.dictionary)
            })
        }
    }
    
    func findRepositories(for login: String) {
        
        if let client = Github.authorizedClient {
            
            client.users.getUser(username: login).response({ (githubUser, error) -> Void in
                if let user = githubUser {
                    //print(user.description)
                    self.dictionary["gitUserName"] = user.name
                    self.dictionary["gitUserAvatarURL"] = user.avatarURL // String
                    self.dictionary["gitUserLogin"] = user.login
                    self.dictionary["gitUserExists"] = true
                    
                } else {
                    self.dictionary = [:]
                    self.dictionary["gitUserExists"] = false
                    self.dictionary["gitUserLogin"] = login
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ToRepositories"), object: nil, userInfo: self.dictionary)

                    print(error?.description ?? "error occured")
                }
            })
        }
        
        if let client = Github.authorizedClient {
            
            client.repos.getRepoFrom(owner: login).response({ (nextPage, result, error) -> Void in
                
                if let repos = result {
                    self.dictionary["repositoriesCount"] = repos.count // Int
                    
                    var repositories: [Repository] = []
                    for r in repos {
                        //print(r.description)
                        let repository = Repository(owner: (r.owner?.login)!, name: r.name, descriptions: r.descriptions, url: r.url, htmlURL: r.htmlURL, language: r.language, createdAt: r.createdAt, updatedAt: r.updatedAt, stargazersCount: r.stargazersCount, myComment: nil, ownerAvatarLink: nil)
                        
                        repositories.append(repository)
                    }
                    self.dictionary["repositories"] = repositories // [Repository]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ToRepositories"), object: nil, userInfo: self.dictionary)
                }
                
                if let requestError = error {
                    print(requestError.description)
                }
            })
        }
    }
}
