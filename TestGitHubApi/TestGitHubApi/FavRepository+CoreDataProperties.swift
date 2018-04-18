//
//  FavRepository+CoreDataProperties.swift
//  TestGitHubApi
//
//  Created by Alex Voronov on 12.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension FavRepository {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavRepository> {
        return NSFetchRequest<FavRepository>(entityName: "FavRepository");
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var htmlURL: String?
    @NSManaged public var language: String?
    @NSManaged public var name: String?
    @NSManaged public var owner: String?
    @NSManaged public var stargazersCount: Int32
    @NSManaged public var updatedAt: String?
    @NSManaged public var url: String?

}
