//
//  ViewController.swift
//  ApolloGraphQLSPA
//
//  Created by Kielan Lemons on 4/22/2561 BE.
//  Copyright © 2561 Kielan Lemons. All rights reserved.
//
import UIKit
import Apollo

class PostListViewController: UITableViewController {
    var posts: [AllPostsQuery.Data.Post]? {
        didSet {
            tableView.reloadData()
        }
    }
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 64
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    // MARK: - Data loading
    var watcher: GraphQLQueryWatcher<AllPostsQuery>?
    func loadData() {
        watcher = apollo.watch(query: AllPostsQuery()) { (result, error) in
            if let error = error {
                NSLog("Error while fetching query: \(error.localizedDescription)")
                return
            }
            //            self.posts = result?.data?.posts
            //NSLog("Fetching AllPostsQuery")
            self.posts = (result?.data?.posts as! [AllPostsQuery.Data.Post])
        }
    }
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    /*func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferPreview", for: indexPath as IndexPath)
        return cell
    }*/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OfferPreview", for: indexPath) as? PostTableViewCell else {
            fatalError("Could not dequeue PostTableViewCell")
        }

//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OfferPreview", for: indexPath) as? PostTableViewCell else {
//            fatalError("Could not dequeue PostTableViewCell")
 //       }
        guard let post = posts?[indexPath.row] else {
            fatalError("Could not find post at row \(indexPath.row)")
        }
        NSLog("cell.configure 1: \(post)")
        NSLog("cell.configure 2: \(post.fragments.postDetails)")

        cell.configure(with: post.fragments.postDetails)
        return cell

    }
}
