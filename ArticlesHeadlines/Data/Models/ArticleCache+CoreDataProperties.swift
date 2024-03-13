//
//  ArticleCache+CoreDataProperties.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/8.
//
//

import Foundation
import CoreData


extension ArticleCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleCache> {
        return NSFetchRequest<ArticleCache>(entityName: "ArticleCache")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var author: String?
    @NSManaged public var title: String
    @NSManaged public var url: URL
    @NSManaged public var urlToImage: URL?

}

extension ArticleCache : Identifiable {

}
