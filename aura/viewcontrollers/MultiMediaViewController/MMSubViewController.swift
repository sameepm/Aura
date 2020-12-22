//
//  MMSubViewController.swift
//  Aura
//
//  Created by necixy on 17/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class MMSubViewController: UIViewController {
    
    @IBOutlet var viewAllContent: UIView!
    
    @IBOutlet var scrlView: UIScrollView!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet var btnPrevious: UIButton!
    @IBOutlet var btnReport: UIButton!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var clView: UICollectionView!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTxt: UILabel!
    @IBOutlet weak var imgMoodEmo: UIImageView!
    var data = NSMutableData()
    var pageNumber : Int!
    var isReport : Bool!
    var counter : Int!
    var dict: NSDictionary?
    var type : String!
    var dataDict : NSDictionary?
    var viewComeFrom : String!
    var arrayData : NSMutableArray = []
    var dataString : NSData!
    
    var txtJokeString : NSString!
    override func viewDidLoad()
    {
        super.viewDidLoad()
       // counter = 0
        pageNumber = 0
       
        let headerView : UIView = UIView()
        
        //------- Custom Navigation
        headerView.frame=CGRectMake(70, 0, 180, 44);
        headerView.backgroundColor=UIColor.clearColor()
        self.navigationItem.titleView=headerView
        let headerLbl : UILabel = UILabel()
        headerLbl.frame=CGRectMake(0, 0, 180, 44);
        headerLbl.textAlignment=NSTextAlignment.Center
        headerLbl.textColor=UIColor.whiteColor()
        headerLbl.backgroundColor=UIColor.clearColor()
        
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerLbl.minimumScaleFactor = 0.5
        headerLbl.text = type as String
        headerView.addSubview(headerLbl)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 34)
        
        button.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.leftBarButtonItem = rightItem
        
        isReport = false
        btnShare.layer.cornerRadius = 5
        btnShare.layer.masksToBounds = true
        
        btnReport.layer.cornerRadius = 5
         btnReport.layer.borderColor = appColor.CGColor
        btnReport.layer.borderWidth = 1.0
        btnReport.layer.masksToBounds = true
       
        
        self.clView!.registerNib(UINib(nibName: "ComplimentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")

        dataDict = self.getUserData()
        lblUsername.text = dataDict?.objectForKey("f_name") as? String
        scrlView.maximumZoomScale = 4.0
        scrlView.minimumZoomScale = 1.0
       

        if  dataDict!.objectForKey("thumb") as? NSObject != NSNull()
        {
            let imgStr : NSString = NSString(format: "%@.png", self.getUserIdFromStore())
            let readPath = self.documentDirectoryPath().stringByAppendingPathComponent(imgStr as String)
            let image = UIImage(contentsOfFile: readPath)
            if image != nil
            {
                imgUser.image=image
            }
            else
            {
                imgUser.image = UIImage(named: "userPlace")
            }
            
        }
        else
        {
             imgUser.image = UIImage(named: "cameraBtn.png")
        }
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2
        imgUser.layer.masksToBounds = true

        if viewComeFrom == "dashboard"
        {
            btnShare.hidden = true
            if type == "Joke"
            {
                let imgStr : String = String(format: "joke.png") as String
                imgMoodEmo.image = UIImage(named:imgStr )
                type = "joke"
            }
            else if type == "Quote"
            {
                 let imgStr : String = String(format: "quote.png") as String
                imgMoodEmo.image = UIImage(named:imgStr )
                 type = "quote"
                
            }
            else
            {
                
                let imgStr : String = String(format: "tip.png") as String
                imgMoodEmo.image = UIImage(named:imgStr )
                 type = "tip"
            }
            clView.hidden = true
            btnNext.hidden = true
            btnPrevious.hidden = true
            
            self.getDataFromWeb()
        }
        else
        {
            let indexPath = NSIndexPath(forItem: counter, inSection: 0)
            self.clView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
        
       if type == "Joke"
       {
      //  lblTxt.text = dict?.objectForKey("joke") as? String
       
        let imgStr : String = String(format: "joke.png") as String
        imgMoodEmo.image = UIImage(named:imgStr )
        }
        else if type == "Quote"
       {
        //  lblTxt.text = dict?.objectForKey("quote") as? String
         let imgStr : String = String(format: "quote.png") as String
        imgMoodEmo.image = UIImage(named:imgStr )

        }
        else
       {
       
        let imgStr : String = String(format: "tip.png") as String
        imgMoodEmo.image = UIImage(named:imgStr )
        //lblTxt.text = dict?.objectForKey("tip") as? String
        }
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "onBackButton")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    @IBAction func reportContent(sender: AnyObject) {
        
         let tempDict : NSDictionary = arrayData.objectAtIndex(sender.tag) as! NSDictionary
         let contentStr : String = tempDict.objectForKey("id") as! String
        if type == "Joke"
        {
            
             self.reportContent("4", contentId: contentStr)
        }
        else if type == "Quote"
        {
            
             self.reportContent("2", contentId: contentStr)
        }
        else
        {
          
            self.reportContent("6", contentId: contentStr)
        }

       
        
    }
    @IBAction func shareWithFriends(sender: AnyObject) {
        
        let shareFriendsVC : ShareMoodViewController = ShareMoodViewController(nibName : "ShareMoodViewController" , bundle : nil)
        
        if type == "Joke"
        {
           shareFriendsVC.shareData = dict?.objectForKey("id") as? String
             shareFriendsVC.viewFromCome = "Share Joke"
            shareFriendsVC.mediaType = "206"
            
        }
        else if type == "Quote"
        {
            shareFriendsVC.shareData = dict?.objectForKey("id") as? String
            shareFriendsVC.viewFromCome = "Share Quote"
            shareFriendsVC.mediaType = "204"
            
        }
        else
        {
            
           shareFriendsVC.shareData = dict?.objectForKey("id") as? String
             shareFriendsVC.viewFromCome = "Share Tip"
            shareFriendsVC.mediaType = "208"
        }

        self.navigationController?.pushViewController(shareFriendsVC, animated: true)

    }
    
    func getDataFromWeb()
    {
        let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
        if isInternet == false
        {
           
            globalAlertView("Please check your internet connection", viewCont: self)
        }
        else
        {

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var strUrl : NSString!
        
         strUrl = NSString(format: "%@%@/%@?page=0",self.basicUrl(),type, (dict!.objectForKey("data")as? String)!)
      
        let searchURL : NSURL = NSURL(string: strUrl as String)!
        let request = NSURLRequest(URL: searchURL)
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
            conn?.start()
        self.data.setData(NSData())
        }

    }
    
    
    
    @IBAction func onNextButton(sender: AnyObject) {
        
        if counter < arrayData.count - 1
        {
            
            counter = counter + 1
            let indexPath = NSIndexPath(forItem: counter, inSection: 0)
            self.clView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
            btnNext.hidden = false
            btnPrevious.hidden = false
            
            
        }
        
        
    }
    
    @IBAction func onPreviousBtn(sender: AnyObject) {
        
        if counter > 0
        {
            counter = counter - 1
           // btnPrevious.hidden = false
            let indexPath = NSIndexPath(forItem: counter, inSection: 0)
            self.clView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
            btnPrevious.hidden = false
            btnNext.hidden = false
        }
      
        
    }
    
    func reportContent( type : String  , contentId : String )
    {
        let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
        if isInternet == false
        {
            
            globalAlertView("Please check your internet connection", viewCont: self)
        }
        else
        {
            
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            isReport = true
            
            var request : ASIFormDataRequest?
            let strUrl : NSString = NSString(format: "%@report",self.basicUrl())
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            
            request?.delegate=self
            request?.setPostValue(type, forKey: "type")
            request?.setPostValue(contentId, forKey: "res_id")
            
            request?.startAsynchronous()
        }
        
    }
// MARK: --------------- Scroll Delegate
func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return self.viewAllContent
    }

// MARK: --------------- ASIHTTPRequest Delegate
    func requestFinished( request : ASIHTTPRequest ){
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        
        do {
            
            let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers)
            
            if let aStatus = jsonObject as? NSDictionary{
                let statusCode = aStatus.objectForKey("status") as? NSString
                if statusCode == "200"
                {
                    print("Success")
                    
                    
                    if isReport == true
                    {
                        isReport = false
                        let email_status  = aStatus.objectForKey("email_status") as? Int
                        if email_status == 1
                        {
                            globalAlertView("Reported Successfully", viewCont: self)
                            
                        }
                        else
                        {
                            globalAlertView("Something went a wrong. Please try again later.", viewCont: self)
                            
                        }
                        
                        
                    }
                    else
                    {

                    if   aStatus.objectForKey("success") as! Bool == true
                    {
                        globalAlertView("Error in uploading , Please try later", viewCont: self)
                    }
                    else
                    {
                        globalAlertView("Error in uploading , Please try later", viewCont: self)
                    }
                    }
                    
                }
                
                
            }
        }
        catch
        {
            print(error)
        }
        
        
    }
    
    func requestFailed( req : ASIHTTPRequest ){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.windowAlertView ("Please check your internet connection", viewCont: self)
        print(req.error)
    }

    // MARK: - NSURL Connection Delegate
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // println("didReceiveResponse")
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        self.data.appendData(conData)
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        MBProgressHUD .hideHUDForView(self.view, animated: true)
        globalAlertView("Please check your internet connection", viewCont: self)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        MBProgressHUD .hideHUDForView(self.view, animated: true)
      do
        {
            
        if let jsonResult: AnyObject = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) {
            
                let statusCode = jsonResult.objectForKey("status") as? NSString
                if statusCode == "200"
              {
                    let dictData : NSDictionary = (jsonResult.objectForKey("details") as? NSDictionary)!
                
                let str : String = dictData.objectForKey(type)as! String
                if str.canBeConvertedToEncoding(NSASCIIStringEncoding)
                {
                    let data : NSData = dictData.objectForKey(type)!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let txtString : String = String(data: data, encoding: NSNonLossyASCIIStringEncoding)!
                    lblTxt.text = txtString
                }
                else
                {
                       lblTxt.text = str
                }

                
               
                
                    arrayData.addObject(dictData)
                }
           
        }
        }
            catch
            {
                print(error)
            }
    }
    
    
    
    // MARK: - CollectionView Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ComplimentCollectionViewCell
        
        let tempDict : NSDictionary = arrayData.objectAtIndex(indexPath.row) as! NSDictionary
        
        cell.lblCompliment.font = UIFont(name: "PetitaMedium", size: 14)
        

        
//        cell.lblCompliment.text = tempDict.objectForKey("content") as? String
        
        
        
        if type == "Joke"
        {
            
            let str : NSString = tempDict.objectForKey("joke") as! NSString
          
        
            if str.canBeConvertedToEncoding(NSASCIIStringEncoding)
            {
                dataString = str.dataUsingEncoding(NSUTF8StringEncoding)!
                
                txtJokeString  = NSString(data: dataString, encoding: NSNonLossyASCIIStringEncoding)!
            }
            else
            {
                dataString = str.dataUsingEncoding(NSUTF32StringEncoding)!
                
                txtJokeString  = NSString(data: dataString, encoding: NSUTF32StringEncoding)!
            }
            
           cell.lblCompliment.text = txtJokeString as String
            
        }
        else if type == "Quote"
        {
            
            let str : NSString = tempDict.objectForKey("quote") as! NSString
            
            
            if str.canBeConvertedToEncoding(NSASCIIStringEncoding)
            {
                dataString = str.dataUsingEncoding(NSUTF8StringEncoding)!
                
                txtJokeString  = NSString(data: dataString, encoding: NSNonLossyASCIIStringEncoding)!
            }
            else
            {
                dataString = str.dataUsingEncoding(NSUTF32StringEncoding)!
                
                txtJokeString  = NSString(data: dataString, encoding: NSUTF32StringEncoding)!
            }
            
            cell.lblCompliment.text = txtJokeString as String

        }
            else
            {
               
                let str : NSString = tempDict.objectForKey("tip") as! NSString
                
                if str.canBeConvertedToEncoding(NSASCIIStringEncoding)
                {
                    dataString = str.dataUsingEncoding(NSUTF8StringEncoding)!
                    
                    txtJokeString  = NSString(data: dataString, encoding: NSNonLossyASCIIStringEncoding)!
                }
                else
                {
                    dataString = str.dataUsingEncoding(NSUTF32StringEncoding)!
                    
                    txtJokeString  = NSString(data: dataString, encoding: NSUTF32StringEncoding)!
                }
                
                cell.lblCompliment.text = txtJokeString as String
                
            }
        if arrayData.count - 1 == counter
        {
            btnNext.hidden = true
            btnPrevious.hidden = false
        }
         if  counter == 0
         {
            btnNext.hidden = false
            btnPrevious.hidden = true
        }
        
        // Configure the cell
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(260, 130)
        
        
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        //        if indexPath.row < 0
        //        {
        //            pageNumber = pageNumber+1
        //
        //            self.getCompliments()
        //        }
        //          let lastIndexPath : NSIndexPath = NSIndexPath(forRow: lastIndexOfCell, inSection: 0)
        //        print(lastIndexPath.item)
        //        if indexPath.row == lastIndexPath.row
        //        {
        //            pageNumber = pageNumber + 1
        //            print("aa gya");
        //            
        //        }
        
    }

}
