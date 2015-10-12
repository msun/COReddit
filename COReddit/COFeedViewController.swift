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
    
    private func updateData() {
        getJSONFromURL(Constants.subredditJsonUrl){[unowned self] (json: JSON) in
            dispatch_async(dispatch_get_main_queue(), {
                self.posts = json["data"]["children"]
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.navTitle

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = UIView(frame: CGRectZero)

        updateData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.feedCellIdentifier, forIndexPath:indexPath) as! COFeedCell
        
        cell.postImageView.image = nil
        cell.titleLabel.text = nil
        cell.authorLabel.text = nil
        cell.createdLabel.text = nil

        if let post = posts?[indexPath.row]["data"] {
            cell.postID = post["id"].string
            
            //if let imageURLString = post["preview"]["images"][0]["resolutions"][0]["url"].string {
            if let imageURLString = post["preview"]["images"][0]["source"]["url"].string {
                if let imageURL = NSURL(string: imageURLString) {
                    let task = NSURLSession.sharedSession().dataTaskWithURL(imageURL) { (data, response, error) in
                        if error == nil && data != nil {
                            let image = UIImage(data: data!)
                            dispatch_async(dispatch_get_main_queue(), {
                                cell.postImageView?.image = image
                            })
                        }
                    }
                    task.resume()
                }
            }
            
            cell.titleLabel.text = post["title"].string
            cell.authorLabel.text = post["author"].string
            if let created = post["created"].int {
                let createdTimeInterval : NSTimeInterval = (String(created) as NSString).doubleValue
                let createdDate = NSDate(timeIntervalSince1970: createdTimeInterval)
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM dd - hh:mm:ss a"
                cell.createdLabel.text = dateFormatter.stringFromDate(createdDate)
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
