//
//  MoodSelectionUPLDViewController.swift
//  Aura
//
//  Created by Apple on 18/11/15.
//  Copyright © 2015 necixy. All rights reserved.
//

import UIKit

class MoodSelectionUPLDViewController: UIViewController {

    @IBOutlet var btnSelectAll: UIButton!
    @IBOutlet var btnDone: UIButton!
    var arrayMoods : NSMutableArray = []
    var arraySelMoods : NSMutableArray = []
    @IBOutlet var tblView: UITableView!
    var selectedAll : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedAll = false
        btnDone.layer.cornerRadius = 5
        btnDone.layer.masksToBounds = true
        arrayMoods = ["Fabulous","Upbeat","Silly","Mysterious","Bored","Stressed","Insecure","Upset","Bullied","Suicidal"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func actionOnSelectAll(sender: AnyObject) {
        
        if selectedAll == false
        {
       // arraySelMoods .removeAllObjects()
            
            arraySelMoods .removeAllObjects()
            appDelegate.arraySelMoods.removeAllObjects()
        selectedAll     = true
        for var i = 0 ; i < arrayMoods.count ; i++
        {
            
            arraySelMoods .addObject(arrayMoods.objectAtIndex(i) as! String)
            let str = String(format: "%d", i+1)
            appDelegate.arraySelMoods.addObject(str)

            
        }
         btnSelectAll.setImage(UIImage(named: "fillCrcl.png"), forState: UIControlState.Normal )
        }
        else
        {
             arraySelMoods .removeAllObjects()
              appDelegate.arraySelMoods.removeAllObjects()
            selectedAll     = false
            btnSelectAll.setImage(UIImage(named: "emptyCrcl.png"), forState: UIControlState.Normal )
        }
        tblView.reloadData()

    }
    @IBAction func actionOnBackButton(sender: AnyObject) {
        appDelegate.hasSelectMood = false
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func actionOnDoneButton(sender: AnyObject) {
        
        
        if arraySelMoods.count == 0
        {
          globalAlertView("Please select atlest one.", viewCont: self)
        }
        else
        {
            appDelegate.hasSelectMood = true
          //  appDelegate.arraySelMoods.removeAllObjects()
            
           // appDelegate.arraySelMoods = arraySelMoods.mutableCopy() as! NSMutableArray
            
            print( appDelegate.arraySelMoods)
            
         self.dismissViewControllerAnimated(true, completion: nil)
        
//         NSNotificationCenter.defaultCenter().postNotificationName("selectedMoods", object: arraySelMoods)
        }
    }
    
    // MARK: - TableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
                    return arrayMoods.count
      
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "Custom"
        
        var cell: MoodSelectionUPLDTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? MoodSelectionUPLDTableViewCell
        
        if cell == nil {
            let viewController : UIViewController = UIViewController(nibName: "MoodSelectionUPLDTableViewCell", bundle: nil)
            
            cell = viewController.view as? MoodSelectionUPLDTableViewCell
            cell.selectionStyle=UITableViewCellSelectionStyle.None
            
        }
        
        let string = NSString (format: "%@.png", (arrayMoods.objectAtIndex(indexPath.row) as! NSString)) as NSString
        cell.imgMood.image = UIImage(named: string as String)
        cell.imgMood.layer.cornerRadius = cell.imgMood.frame.size.width/2
        cell.imgMood.layer.masksToBounds = true
        
        
        cell.lblMoodName.text = String (format: "%@", (arrayMoods.objectAtIndex(indexPath.row) as! NSString))

        let frndId  = arrayMoods.objectAtIndex(indexPath.row) as! String
        
    
      let  hasSel = arraySelMoods .containsObject(frndId) as Bool
        if hasSel == true
        {
            cell.imgSelection.image = UIImage(named: "fillCrcl")!
            
            
        }
        else
        {
           cell.imgSelection.image = UIImage(named: "emptyCrcl.png")!
          
            
        }

        
        // println("%@",section())
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedIndex : Int = indexPath.row
        let strObj : String = arrayMoods.objectAtIndex(indexPath.row) as! String
        let isIn : Bool = arraySelMoods.containsObject(strObj) as Bool
        if isIn == true
        {
            
            for (var i=0 ; i < arraySelMoods.count ; i++)
            {
                if arraySelMoods.objectAtIndex(i) as! String == arrayMoods.objectAtIndex(indexPath.row) as! String
                {
                    selectedIndex = i
                }
                
                
            }

            arraySelMoods.removeObjectAtIndex(selectedIndex)
            appDelegate.arraySelMoods.removeObjectAtIndex(selectedIndex)
            
            selectedAll     = false
            btnSelectAll.setImage(UIImage(named: "emptyCrcl.png"), forState: UIControlState.Normal )
           
            
        }
        else
        {
             arraySelMoods.addObject(arrayMoods.objectAtIndex(indexPath.row) as! String)
            
            let str = String(format: "%d", indexPath.row+1)
            appDelegate.arraySelMoods.addObject(str)
            
            if arraySelMoods.count == arrayMoods.count
                {
                    btnSelectAll.setImage(UIImage(named: "fillCrcl.png"), forState: UIControlState.Normal )
                    selectedAll     = true
                    
                }
          
        }
        
        let indexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
        self.tblView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        
    }

}
