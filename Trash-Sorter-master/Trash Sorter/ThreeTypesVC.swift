//
//  ThreeTypesVC.swift
//  Trash Sorter
//
//  Created by Alex Dao on 6/24/16.
//  Copyright © 2016 Alex Dao. All rights reserved.
//

import UIKit

class ThreeTypesVC: UIViewController {
    
    var composte1 = [String]()
    var recyclable1 = [String]()
    var trash1 = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func composteBtnClicked(sender: AnyObject) {
        print("1")
    }
    @IBAction func recybleBtnClicked(sender: AnyObject) {
        print("2")
    }
    @IBAction func trashBtnClicked(sender: AnyObject) {
        print("3")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let displayTrashVC = segue.destinationViewController as! DisplayTrashVC
        
        if let identifier = segue.identifier {
            if identifier == "composteSegue" {
                // composte button was clicked
                
                displayTrashVC.navigationTitle.title = "List of Composed Items"
                displayTrashVC.oneArray = composte1
                
            } else if identifier == "recyclableSegue" {
                // recyclable button was clicked
                
                displayTrashVC.navigationTitle.title = "List of Recycled Items"
                displayTrashVC.oneArray = recyclable1
                
            } else if identifier == "trashSegue" {
                // trash button was clicked
                
                displayTrashVC.navigationTitle.title = "List of Trashed Items"
                displayTrashVC.oneArray = trash1
            }
        }
    }
}
