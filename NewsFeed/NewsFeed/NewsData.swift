//
//  NewsData.swift
//  NewsFeed
//
//  Created by Akash Subramanian
//  Copyright © 2016 CIS 195 University of Pennsylvania. All rights reserved.
//

import Foundation

final class NewsData {
    
    fileprivate static var newsItems = [String]()
    
    // TODO: - methods to let the View interact with the data in our app
    
    // add new item method
    static func addNewItem(item : String) {
        newsItems.append(item)
    }
    
    // access data method
    static func getRowItem(row : Int) -> String {
        return newsItems[newsItems.count - row - 1]
    }
    
    // newsItems Length
    static func getNewsItemsLength() -> Int {
        return newsItems.count
    }
    
}
