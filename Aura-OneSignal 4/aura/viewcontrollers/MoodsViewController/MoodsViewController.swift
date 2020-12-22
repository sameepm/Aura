//
//  MoodsViewController.swift
//  Aura
//
//  Created by necixy on 21/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class MoodsViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , SlideNavigationControllerDelegate {
    var arrData : NSMutableArray = []
    
    
    @IBOutlet weak var clview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        var params=["link":"http://www.eatbyapp.com/", "message":"Convert your kitchen to smart kitchen "]
//        
//        
//        
//        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        fbLoginManager .logInWithReadPermissions(["publish_actions"], handler: {
//            (result, error) -> Void in
//            if (error == nil){
//                var fbloginresult : FBSDKLoginManagerLoginResult = result
//                if(fbloginresult.grantedPermissions.contains("publish_actions"))
//                {
//                    if((FBSDKAccessToken.currentAccessToken()) != nil){
//                        FBSDKGraphRequest(graphPath: "/me/feed", parameters: params ,  HTTPMethod:"POST").startWithCompletionHandler({ (connection, result, error) -> Void in
//                            if (error == nil){
//                                println(result)
//                                
//                                
//                            }
//                        })
//                    }
//
//                }
//            }
//        })
//        
//
//
        
        let headerView : UIView = UIView()
        //------- Custom Navigation
        headerView.frame=CGRectMake(70, 0, 220, 44);
        headerView.backgroundColor=UIColor.clearColor()
        self.navigationItem.titleView=headerView
        let headerLbl : UILabel = UILabel()
        headerLbl.frame=CGRectMake(0, 0, 220, 44);
        headerLbl.textAlignment=NSTextAlignment.Center
        headerLbl.textColor=UIColor.whiteColor()
        headerLbl.backgroundColor=UIColor.clearColor()
        headerLbl.text="How are you feeling?"
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
    
        let scoreHpns: String? = userDefault.objectForKey("happinesScore") as? String
        if scoreHpns == "11"
        {

          self.globalAlertView("Please first select your mood.", viewCont: self)
        }
    //  NSNotificationCenter.defaultCenter().addObserver(self, selector:"showMessageForUser", name: "userFirstTimeInApp", object: nil)
      //  arrData = []
        arrData.addObject("Fabulous" as String)
        arrData.addObject("Upbeat" as String)
        arrData.addObject("Silly" as String)
        arrData.addObject("Mysterious" as String)
        arrData.addObject("Bored")
        arrData.addObject("Stressed" as String)
        arrData.addObject("Insecure" as String)
        arrData.addObject("Upset" as String)
        arrData.addObject("Bullied" as String)
        arrData.addObject("Suicidal" as String)
      
        
        
        clview!.registerNib(UINib(nibName: "MoodsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
//        clview.registerClass(MoodsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
       return true;
    }
    func showMessageForUser()
    {
        let scoreHpns: String? = userDefault.objectForKey("happinesScore") as? String
        if scoreHpns == "11"
        {
            globalAlertView("Please first select your mood.", viewCont: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - CollectionView Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
      
        
       let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MoodsCollectionViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        let string = NSString (format: "%@.png", (arrData.objectAtIndex(indexPath.row) as! NSString)) as NSString
        cell.imgMood.image = UIImage(named: string as String)
        cell.lblMoodTxt.text = String (format: "%@", (arrData.objectAtIndex(indexPath.row) as! NSString))
        // Configure the cell
        return cell
    }
   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    
    let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
    if isInternet == false
    {
        MBProgressHUD .hideHUDForView(self.view, animated: true)
        globalAlertView("Please check your internet connection", viewCont: self)
    }
    else
    {
        let moodVC : MoodsSubViewController = MoodsSubViewController(nibName : "MoodsSubViewController" , bundle : nil)
        
        //let moodVC : InternetAvailabiltyClass = InternetAvailabiltyClass(nibName : "InternetAvailabiltyClass" , bundle : nil)
        
        let mood  : String =  String (format: "%@", (arrData.objectAtIndex(indexPath.row) as! NSString))
        let moodValue  : String =  String (format: "%d", indexPath.row )
        userDefault.setObject(mood, forKey:"mymood")
        userDefault.setObject(moodValue, forKey: "moodValue")
          // moodVC.mood =  String (format: "%@", (arrData.objectAtIndex(indexPath.row) as! NSString))
           moodVC.scale = String (format: "%d", indexPath.row+1)
       self.navigationController?.pushViewController(moodVC, animated: true)
    }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        if UIScreen.mainScreen().bounds.size.height < 600
//        {
              return CGSizeMake(153, 93)
//        }
//        else
//        {
//        return CGSizeMake(180, 113)
//        }
       
    }

}
