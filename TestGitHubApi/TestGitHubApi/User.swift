//
//  User.swift
//  TestGitHubApi
//
//  Created by Alex Voronov on 09.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import Foundation

class User {
    
    // MARK: Properties
    var login: String = ""
    var avatarURL: String?
    var url: String = ""
    var name: String?
    var htmlURL: String?
    var reposURL: String?
    var location: String?
    var email: String?
    var createdAt: String?
    var updatedAt: String?
    
    var repositories: [Repository] = []
    
    // MARK: Initializers
    init() {}
    
    init(login: String, avatarURL: String?, name: String?) {
        self.login = login
        self.avatarURL = avatarURL
        self.name = name
    }
    
    init(login: String, avatarURL: String, url: String, name: String?, htmlURL: String?, reposURL: String?, location: String?, email: String?, createdAt: String?, updatedAt: String?) {
        self.login = login
        self.avatarURL = avatarURL
        self.url = url
        self.name = name
        self.htmlURL = htmlURL
        self.reposURL = reposURL
        self.location = location
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // MARK: Deinitializers
    deinit {
        //print("\(self) is about to be deinited!")
    }
}
