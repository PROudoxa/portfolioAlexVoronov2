//
//  Repository.swift
//  TestGitHubApi
//
//  Created by Alex Voronov on 09.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import Foundation

class Repository {
    
    // MARK: Properties
    var owner: String?
    var name: String?
    var descriptions: String?
    var url: String?
    var htmlURL: String?
    var language: String?
    var createdAt: String?
    var updatedAt: String?
    var stargazersCount: Int32?
    var myComment: String?
    var ownerAvatarLink: String?
    
    // MARK: Initializers
    init() {}
    
    init(name: String?, stargazersCount: Int32?) {
        self.name = name
        self.stargazersCount = stargazersCount
    }
    
    init(owner: String?, name: String?, descriptions: String?, url: String?, htmlURL: String? , language: String?, createdAt: String?, updatedAt: String?, stargazersCount: Int32?, myComment: String?, ownerAvatarLink: String?) {
        self.owner = owner
        self.name = name
        self.descriptions = descriptions
        self.url = url
        self.htmlURL = htmlURL
        self.language = language
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.stargazersCount = stargazersCount
        self.myComment = myComment
        self.ownerAvatarLink = ownerAvatarLink
    }
    
    // MARK: Deinitializers
    deinit {
        //print("\(self) is about to be deinited!")
    }
}
