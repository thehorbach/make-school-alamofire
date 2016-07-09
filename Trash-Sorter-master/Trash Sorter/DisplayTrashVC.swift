//
//  DisplayTrashVC.swift
//  Trash Sorter
//
//  Created by Alex Dao on 6/24/16.
//  Copyright © 2016 Alex Dao. All rights reserved.
//

import UIKit

class DisplayTrashVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var oneArray = [String]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("trashCell", forIndexPath: indexPath) as! DisplayCell
        
        let row = indexPath.row
        
        let trash = oneArray[row]
        
        cell.trashNameLbl.text = trash
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oneArray.count
    }
    
}
