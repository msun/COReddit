//
//  CORedditAPI.swift
//  COReddit
//
//  Created by Matthew Sun on 10/11/15.
//  Copyright © 2015 Matthew Sun. All rights reserved.
//

import Foundation

class CORedditAPI {
    private class func getJSONForURL(urlString: String, completionHandler: (JSON) -> Void) {
        if let url = NSURL(string: urlString){
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                if error == nil && data != nil {
                    let json = JSON(data: data!)
                    completionHandler(json)
                }
            }
            task.resume()
        }
    }
    
    class func getPostsForSubreddit(subreddit : String,  completionHandler: ([CORedditPost]) -> Void) {
        let url = "https://www.reddit.com\(subreddit).json"
        getJSONForURL(url) { (json: JSON) in
            var posts = [CORedditPost]()

            if let jsonPosts = json["data"]["children"].array {
                for jsonPost in jsonPosts {
                    let jsonPostData = jsonPost["data"]
                    let post = CORedditPost()
                    post.postID = jsonPostData["id"].string
                    //post.imageURL = jsonPostData["preview"]["images"][0]["resolutions"][0]["url"].string
                    post.imageURL = jsonPostData["preview"]["images"][0]["source"]["url"].string
                    post.title = jsonPostData["title"].string
                    post.author = jsonPostData["author"].string
                    post.created = jsonPostData["created"].int
                    posts.append(post)
                }
            }

            completionHandler(posts)
        }
    }
}
