//
//  Constant.swift
//  Aura
//
//  Created by necixy on 09/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

let userDefault = NSUserDefaults.standardUserDefaults()
let synchro = NSUserDefaults.standardUserDefaults().synchronize()
let myId = NSUserDefaults.standardUserDefaults().objectForKey("userId")
let appColor = UIColor(red: 88/255, green: 182/255, blue: 202/255, alpha: 1.0)
let selectedColor = UIColor(red: 53/255, green: 110/255, blue: 119/255, alpha: 1)

class Constant: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
 }


struct MyVariables {
    //static var yourVariable = "someString"
    static var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
}


extension UIViewController {
    // Mark : -Global Alert View
    
    
    
    
    func basicUrl()-> String{
        //let basicUrl : NSString = NSString(string: "http://www.pairroxz.com/developer/aura/api/")
        let basicUrl : NSString = NSString(string: "http://api.aura-app.me/")
    return basicUrl as String
    }
    func basicImgUrl()-> String{
        let basicUrl : NSString = NSString(string: "http://api.aura-app.me/images/")
        return basicUrl as String
    }
    
    func globalAlertView (alertMsg : NSString, viewCont : UIViewController)
    {
        let alert = UIAlertController(title: "Aura", message: alertMsg as String, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        viewCont.presentViewController(alert, animated: true, completion: nil)
        
    }
    func windowAlertView (alertMsg : NSString, viewCont : UIViewController)
    {
        let alert = UIAlertView()
        alert.title = ""
        alert.message = alertMsg as String
        alert.addButtonWithTitle("OK")
        alert.show()
        
    }
    
    func documentDirectoryPath()->NSString
    {
        var strPat : NSString!
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)
       
            if paths.count > 0 {
                strPat = paths[0]
                }
          return strPat
    }
    
    func getUserData()->NSDictionary
    {
        var userData : NSDictionary!
        let archivedData = NSUserDefaults.standardUserDefaults().objectForKey("userInfo") as! NSData
        userData = NSKeyedUnarchiver.unarchiveObjectWithData(archivedData) as? NSDictionary
        
        return userData
    }
    
    func getUserIdFromStore()->NSString
    {
           let strId: NSString? =  NSUserDefaults.standardUserDefaults().objectForKey("userId") as? NSString
        return strId!;
    }
}
extension String {
    var length: Int { return characters.count    }  // Swift 2.0
}
