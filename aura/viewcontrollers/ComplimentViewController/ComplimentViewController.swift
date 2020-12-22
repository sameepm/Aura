//
//  ComplimentViewController.swift
//  Aura
//
//  Created by Apple on 29/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class ComplimentViewController: UIViewController {
    
    @IBOutlet var scrlView: UIScrollView!
    
    
    @IBOutlet var viewAllContent: UIView!
    @IBOutlet var clView: UICollectionView!
    @IBOutlet var imgUser: UIImageView!
    
    @IBOutlet var btnReport: UIButton!
    @IBOutlet var btnPrevious: UIButton!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var btnShare: UIButton!
  var dict: NSDictionary?
    @IBOutlet var icon: UIImageView!
    @IBOutlet var lblUserN: UILabel!
    @IBOutlet var lblCompliments: UILabel!
    var data = NSMutableData()
    var idOfComp : String!
    var hasComeDash : Bool!
    var indexOfContent : Int!
    var pageNumber : Int!
    var lastIndexOfCell : Int!
    var counter : Int!
    var zumpTo : Int!
    var newCompConn : NSURLConnection!
    var getOldCompConn : NSURLConnection!
    var arrayData : NSMutableArray = []
    var tempData : NSMutableArray = []
    var strId : NSString!
    var isReport : Bool!
    var leftBtnHide : Bool!
    

    
    override func viewDidLoad() {
        leftBtnHide = false
        super.viewDidLoad()
         strId = userDefault.objectForKey("userId") as? NSString

        // Do any additional setup after loading the view.
        
        counter = 0
        
      //  btnPrevious.hidden = true
        //btnNext.hidden = true
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
        headerLbl.text = "Compliment"
        
        headerView.addSubview(headerLbl)
        
        scrlView.maximumZoomScale = 4.0
        scrlView.minimumZoomScale = 1.0
        

        isReport = false
        //--------------- Navigation Buttons
        
       
         btnShare.hidden = true
            let button: UIButton = UIButton()
            button.setImage(UIImage(named: "backBtn"), forState: .Normal)
            button.frame = CGRectMake(5, 5, 28, 28)
            
            button.addTarget(self, action: "gotoBackViewCOntroller", forControlEvents: UIControlEvents.TouchUpInside)
            
            let rightItem:UIBarButtonItem = UIBarButtonItem()
            rightItem.customView = button
            self.navigationItem.leftBarButtonItem = rightItem
                btnShare.layer.cornerRadius = 5.0
        btnShare.layer.masksToBounds = true
        btnReport.layer.cornerRadius = 5.0
        btnReport.layer.masksToBounds = true
    
        
        dict = self.getUserData()
        
        lblUserN.text = dict?.objectForKey("f_name") as? String
        if  dict!.objectForKey("thumb") as? NSObject != NSNull()
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
            imgUser.image = UIImage(named: "userPlace")
        }
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2
        imgUser.layer.masksToBounds = true
        
        icon.image = UIImage(named: "compliment_icon")
        
        self.clView!.registerNib(UINib(nibName: "ComplimentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
      
        pageNumber = 0
       // lastIndexOfCell = 3 * (pageNumber+1)
        if hasComeDash == true
        {
            self.getCompliments()
            
        }
        else
        {
             btnShare.hidden = false
            counter = zumpTo
            let indexPath = NSIndexPath(forItem: zumpTo, inSection: 0)
            self.clView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
     
        }
    }

    
    @IBAction func actionOnBtnReportContent(sender: AnyObject) {
      let temp =  arrayData.objectAtIndex(counter) as! NSDictionary
     
        self.reportContent("7", contentId: temp.objectForKey("id") as! String)
    }
    // MARK: -------------- Report Connection Delegate
    
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


    @IBAction func shareComplimentsWithFriend(sender: AnyObject) {
        
        let shareFriendsVC : ShareMoodViewController = ShareMoodViewController(nibName : "ShareMoodViewController" , bundle : nil)
        shareFriendsVC.viewFromCome = "Share Compliment"
        shareFriendsVC.shareData = idOfComp
        shareFriendsVC.mediaType = "202"
        self.navigationController?.pushViewController(shareFriendsVC, animated: true)
 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
     func gotoBackViewCOntroller()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
// MARK: --------------- Scroll Delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return self.viewAllContent
    }
 
    @IBAction func onNextButton(sender: AnyObject) {
        
        if counter < arrayData.count - 1
        {
            btnPrevious.hidden = false
          counter = counter + 1  
        let indexPath = NSIndexPath(forItem: counter, inSection: 0)
        self.clView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
            
            }
        else
        {
            btnNext.hidden = true
       
        }
        
    }
    
    @IBAction func onPreviousBtn(sender: AnyObject) {
        
        if counter > 0
        {
            
            counter = counter - 1
            
            let indexPath = NSIndexPath(forItem: counter, inSection: 0)
            self.clView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
        }
        else
        {
            pageNumber = pageNumber+1
            btnPrevious.hidden  = true
           // self.getMultipleCompliments()
            
        }
        
    }
        
    
  func getCompliments()
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
    if hasComeDash == true
    {
        strUrl = NSString(format: "%@compliment/%@",self.basicUrl(), idOfComp)
        btnNext.hidden = true
        btnPrevious.hidden = true
    }
    else
    {
        strUrl = NSString(format: "%@user/compliment/new/%@?page=0",self.basicUrl(), (dict!.objectForKey("id")as? String)!)
    }
    
    
    let searchURL : NSURL = NSURL(string: strUrl as String)!
    let request = NSURLRequest(URL: searchURL)
    newCompConn = NSURLConnection(request: request, delegate: self, startImmediately: true)
    newCompConn.start()
    self.data.setData(NSData())
        
    }
    
    }
    
    // MARK: - ASIHTTPRequest Delegate
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
                    if aStatus.objectForKey("success") as! Bool == true
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
                    if ( newCompConn != nil)
                    {
                        
                        if  jsonResult.objectForKey("details") as? NSObject != NSNull()
                        {

                    let dictData : NSDictionary = (jsonResult.objectForKey("details") as? NSDictionary)!
                    arrayData.addObject(dictData)
                        clView.reloadData()
                        let scrolTo  : Int =  arrayData.count - 1
                        
                        counter = scrolTo
                        if ( counter > 0)
                        {
                        let indexPath = NSIndexPath(forItem: scrolTo, inSection: 0)
                            self.clView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
                        }
                    
//                    lblCompliments.text = dictData.objectForKey("content") as? String
                        else
                        {
                    idOfComp =  dictData.objectForKey("id") as? String
                        clView.reloadData()
                        }
                    }
                        else
                        {
                            globalAlertView("Something went wrong , Please try again later.", viewCont: self)
                            btnNext.hidden = true
                            btnPrevious.hidden = true
                            btnReport.hidden = true
                            btnShare.hidden = true
                        }
                    }
                    else
                    {
                        self.tempData   = jsonResult.objectForKey("details") as! NSMutableArray
                      //  print(tempData)
                        
                    if tempData.count > 0
                    {
                       
                         for var i = 0 ; i < tempData.count ; i++
                         {
                            if self.arrayData.count == 0
                                {
                                   arrayData.addObject(tempData.objectAtIndex(i))
                                }
                                else
                                {
                            arrayData.insertObject(tempData.objectAtIndex(i), atIndex: 0)
                                }
                         
                        }
                        
                       
                        
                        UIView.animateWithDuration(0.5, animations: {
                             self.clView .reloadData()
                            }, completion: { (finished: Bool) in
                                //self.storedCells.removeAtIndex(1)
                                
                                var scrolTo : Int?
                                if self.pageNumber == 0
                                {
                                    scrolTo = 99
                                    
                                }
                                else
                                {
                                     scrolTo = (self.pageNumber * self.arrayData.count ) - 101
                                }
                               
                                self.counter = scrolTo
                                let indexPath = NSIndexPath(forItem: scrolTo!, inSection: 0)
                                self.clView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
                        })
                        
                        }
                        else
                    {
                        leftBtnHide = true
                        btnPrevious.hidden = true
                        
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
        
        
//        let data : NSData = tempDict.objectForKey("content")!.dataUsingEncoding(NSUTF8StringEncoding)!
//        let txtString : String = String(data: data, encoding: NSNonLossyASCIIStringEncoding)!
//        
          idOfComp =  tempDict.objectForKey("id") as? String
        let str : String  = tempDict.objectForKey("content") as! String
        if str.canBeConvertedToEncoding(NSASCIIStringEncoding)
        {
            let data : NSData = tempDict.objectForKey("content")!.dataUsingEncoding(NSUTF8StringEncoding)!
            let txtString : String = String(data: data, encoding: NSUTF8StringEncoding)!
             cell.lblCompliment.text = txtString
            
        }
        else
        {
            cell.lblCompliment.text = str
        }
        if arrayData.count - 1 == indexPath.row
        {
            btnNext .hidden = true
        }
        else
        {
             btnNext .hidden = false
        }
        
         if  indexPath.row == 0
         {
            btnPrevious . hidden = true
        }
        else
        {
            btnPrevious . hidden = false
        }
        //cell.lblCompliment.text = txtString
        
        
            // Configure the cell
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
           
            return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height)
    }
   
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {

        
    }
    
}
