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
    
    private var posts : [CORedditPost]?

    private struct Constants {
        static let feedCellIdentifier = "Feed Cell"
        static let subreddit = "/r/iOS"
    }

    private func updateData() {
        CORedditAPI.getPostsForSubreddit(Constants.subreddit) { (posts: [CORedditPost]) in
            dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                self.posts = posts
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.subreddit

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

        if let post = posts?[indexPath.row] {
            cell.postID = post.postID
            cell.titleLabel.text = post.title
            cell.authorLabel.text = post.author

            if let imageURLString = post.imageURL, imageURL = NSURL(string: imageURLString) {
                let task = NSURLSession.sharedSession().dataTaskWithURL(imageURL) { (data, response, error) in
                    if error == nil && data != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            if post.postID == cell.postID {
                                cell.postImageView?.image = UIImage(data: data!)
                            }
                        })
                    }
                }
                task.resume()
            }

            if let created = post.created {
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
