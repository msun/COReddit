//
//  COFeedViewController.swift
//  COReddit
//
//  Created by Matthew Sun on 10/10/15.
//  Copyright © 2015 Matthew Sun. All rights reserved.
//

import UIKit

class COFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private var posts : JSON?

    private struct Constants {
        static let navTitle = "/r/iOS/"
        static let feedCellIdentifier = "Feed Cell"
        static let subredditJsonUrl = "https://www.reddit.com/r/ios.json"
    }

    private func getJSONFromURL(urlString: String, completionHandler: (JSON) -> Void) {
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

    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.navTitle

        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = UIView(frame: CGRectZero)

        getJSONFromURL(Constants.subredditJsonUrl){[unowned self] (json: JSON) in
            self.posts = json["data"]["children"]
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.feedCellIdentifier, forIndexPath:indexPath) as! COFeedCell
        cell.postImage = nil
        cell.titleLabel.text = nil
        cell.authorLabel.text = nil
        cell.createdLabel.text = nil

        if let post = posts?[indexPath.row]["data"] {
            //let postId = post["id"].string
            //cell.postImage = // remember to check id when return
            cell.titleLabel.text = post["title"].string
            cell.authorLabel.text = post["author"].string
            if let created = post["created"].int {
                cell.createdLabel.text = String(created)
                
            }
        }

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts != nil ? posts!.count : 0
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
