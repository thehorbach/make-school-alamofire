//
//  ViewController.swift
//  Trash Sorter
//
//  Created by Alex Dao on 6/24/16.
//  Copyright © 2016 Alex Dao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var trashNameTextField: UITextField!
    @IBOutlet weak var trashTypeSegmentedControl: UISegmentedControl!
    
    var composte = [String]()
    var recyclable = [String]()
    var trash = [String]()
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onThrowAwayBtnClicked(sender: UIButton) {
        print("test")
        
        if let trashName = trashNameTextField.text {
            switch trashTypeSegmentedControl.selectedSegmentIndex {
            case 0:
                composte.append(trashName)
            case 1:
                recyclable.append(trashName)
            case 2:
                trash.append(trashName)
            default:
                break
            }
            
            trashNameTextField.text = ""
            print(composte)
            print(recyclable)
            print(trash)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let threeTypesVC = segue.destinationViewController as! ThreeTypesVC
        threeTypesVC.composte1 = composte
        threeTypesVC.recyclable1 = recyclable
        threeTypesVC.trash1 = trash
    }
}

