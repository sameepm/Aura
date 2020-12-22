//
//  ShareMoodViewController.swift
//  Aura
//
//  Created by necixy on 25/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class ShareMoodViewController: UIViewController , UIActionSheetDelegate , FriendshipStatusDelegate {
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var btnShareMood: UIButton!
    @IBOutlet weak var btnAllFriends: UIButton!
    @IBOutlet var scrlView: UIScrollView!
    @IBOutlet weak var btnInnerCircle: UIButton!
      @IBOutlet weak var txtSearch: UITextField!
    var friStatus : FriendStatus = FriendStatus()
    var arraySelFriends : NSMutableArray = []
    var hasSel : Bool!
    var selectedAll : Bool!
    var arrayFriends : NSMutableArray = []
    var arrayInnerFriends : NSMutableArray = []
    var arrayTemp : NSMutableArray = []
    var data = NSMutableData()
    var appDel : AppDelegate!
    var strId: NSString!
    var isInnerCircle : Bool!
    var moodType : String!
    var viewFromCome: NSString!
    var shareData : String!
    var mediaType : String!
    var lastIndexOfCell : Int!
    var pageNumber : Int!
    var ref_id : String!
    

    var selectedTag : Int!
    
    @IBOutlet var btnSelectAllFriends: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedAll = false
         pageNumber = 0
        lastIndexOfCell = 99
        self.initView()
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
       self.getAllUser()
        friStatus.delegate = self
        selectedTag = 0
       
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initView()
    {
        hasSel=false
        isInnerCircle = false
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
        headerLbl.text = viewFromCome as String
      btnShareMood .setTitle(viewFromCome as String, forState: UIControlState.Normal)
        
        headerLbl.font=UIFont(name: "PetitaMedium", size: 20)
        headerView.addSubview(headerLbl)
        
        //--------------- Navigation Buttons
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "addFriend"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 24)
        
        button.addTarget(self, action: "onAddButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.rightBarButtonItem = rightItem
        
        
        let buttonBack: UIButton = UIButton()
        buttonBack.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        buttonBack.frame = CGRectMake(5, 5, 34, 34)
        
        buttonBack.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftItem:UIBarButtonItem = UIBarButtonItem()
        leftItem.customView = buttonBack
        self.navigationItem.leftBarButtonItem = leftItem
        
        if UIScreen.mainScreen().bounds.size.height < 500
        {
            scrlView.contentSize = CGSizeMake(320, 700)
        }
        
        btnAllFriends.backgroundColor=UIColor(red: 53/255, green: 110/255, blue: 119/255, alpha: 1)
        btnInnerCircle.backgroundColor=UIColor(red: 88/255, green: 182/255, blue: 202/255, alpha: 1.0)
        //FriendsCell
        strId = userDefault.objectForKey("userId") as? NSString
        btnShareMood.layer.cornerRadius = 5.0
        btnShareMood.layer.masksToBounds = true

        clView!.registerNib(UINib(nibName: "FriendsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShareFriendsCell")
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFriendList", name: "updateUserRequest", object: nil)
    }
    
    func updateFriendList()
    {
        self.getAllUser()
    }
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func actionSelecteAllFriends(sender: AnyObject)
    {
        
        if selectedAll == false
        {
            if isInnerCircle == true
            {
                arraySelFriends .removeAllObjects()
                
                 for var i = 0 ; i < arrayInnerFriends.count ; i++
                 {
                    let tempDict : NSDictionary = arrayFriends.objectAtIndex(i) as! NSDictionary
                    
                    arraySelFriends .addObject(tempDict.objectForKey("friend_id") as! String)
                   
                }
                
               
            }
            else
            {
                 arraySelFriends .removeAllObjects()
                
                for var i = 0 ; i < arrayFriends.count ; i++
                {
                    let tempDict : NSDictionary = arrayFriends.objectAtIndex(i) as! NSDictionary
                    arraySelFriends .addObject(tempDict.objectForKey("friend_id") as! String)
                    
                }
              
            }
            selectedAll = true
            btnSelectAllFriends.setImage(UIImage(named: "fillCrcl.png"), forState: UIControlState.Normal )
        }
        else
        {
            arraySelFriends .removeAllObjects()
            selectedAll     = false
            btnSelectAllFriends.setImage(UIImage(named: "emptyCrcl.png"), forState: UIControlState.Normal )
        }
        self.clView.reloadData()

    }
    
   
    @IBAction func actionOnShareMoodButton(sender: AnyObject) {
        if arraySelFriends.count > 0
        {
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            
        let strUrl : NSString = NSString(format: "%@user/notify/%@",self.basicUrl() , strId!)
        
         let searchURL : NSURL = NSURL(string: strUrl as String)!
        var request : ASIFormDataRequest?
        
        request = ASIFormDataRequest(URL:searchURL as NSURL)
        request?.delegate=self
            //var friendsIds : NSString!
            
          
            
            let friendsIds = arraySelFriends.componentsJoinedByString(",")
//             for var i = 0 ; i < arraySelFriends.count ; i++
//            {
//                if i == arraySelFriends.count - 1
//                {
//                     friendsIds = NSString(format:"%@",arraySelFriends.objectAtIndex(i) as! NSString)
//                }
//                else
//                {
//                friendsIds = NSString(format:"%@,",arraySelFriends.objectAtIndex(i) as! NSString)
//                }
//            }
//        
        request?.setPostValue(friendsIds, forKey: "friend_id")
      
            
            if viewFromCome == "Share Mood"
            {
                 request?.setPostValue("201", forKey: "type")
                  request?.setPostValue(shareData, forKey: "data")
            }
            else  if mediaType == "202"
            {
                  request?.setPostValue("202", forKey: "type")
                  request?.setPostValue(shareData, forKey: "data")
            }
            else
            {
                request?.setPostValue(mediaType, forKey: "type")
                request?.setPostValue(shareData, forKey: "data")
                
                let mediaT : Int = Int(mediaType)!
                
                switch (mediaT)
                {
                case 203:
                   request?.setPostValue(ref_id, forKey: "ref_id")
                    break;
                case 205:
                   request?.setPostValue(ref_id, forKey: "ref_id")
                    break;
              
                case 207:
                   request?.setPostValue(ref_id, forKey: "ref_id")
                    break;
                default :
                    break ;
                }

            }
      
        request?.startAsynchronous()
        }
        else
        {
            self.globalAlertView("Please select friends", viewCont: self)
        }
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtSearch .resignFirstResponder()
        
        if !txtSearch.text!.isEmpty
        {
            if isInnerCircle == true
            {
                arrayTemp = arrayInnerFriends .mutableCopy() as! NSMutableArray
                arrayInnerFriends .removeAllObjects()
                for var i = 0 ; i < arrayTemp.count ; i++
                {
                    let dictTemp : NSDictionary = arrayTemp.objectAtIndex(i) as! NSDictionary
                      if ((dictTemp.objectForKey("f_name") as! String).caseInsensitiveCompare(txtSearch.text!) == NSComparisonResult.OrderedSame  )
                      {
                        arrayInnerFriends.addObject(arrayTemp.objectAtIndex(i))
                    }
                    if ((dictTemp.objectForKey("email") as! String).caseInsensitiveCompare(txtSearch.text!) == NSComparisonResult.OrderedSame  )
                    {
                        arrayInnerFriends.addObject(arrayTemp.objectAtIndex(i))
                    }
                }
                
    
                
            }
            else
            {
                 arrayTemp = arrayFriends .mutableCopy() as! NSMutableArray
                 arrayFriends .removeAllObjects()
                for var i = 0 ; i < arrayTemp.count ; i++
                {
                    //(dictTemp.objectForKey("f_name") as! String.caseInsensitiveCompare(txtSearch.text) == NSComparisonResult.OrderedSame  || dictTemp.objectForKey("email") as! String == txtSearch.text)
                    let dictTemp : NSDictionary = arrayTemp.objectAtIndex(i) as! NSDictionary
                    if ((dictTemp.objectForKey("f_name") as! String).caseInsensitiveCompare(txtSearch.text!) == NSComparisonResult.OrderedSame  )
                    {
                        arrayFriends.addObject(arrayTemp.objectAtIndex(i))
                    }
                    
                   
                    if ((dictTemp.objectForKey("email") as! String).caseInsensitiveCompare(txtSearch.text!) == NSComparisonResult.OrderedSame  )
                    {
                      arrayFriends.addObject(arrayTemp.objectAtIndex(i))
                    }
                }

                
            }
            self.clView .reloadData()
        }
        return true;
        
    }
    @IBAction func clearTextField(sender: AnyObject) {
       if self.txtSearch.text!.isEmpty == false
       {
        if isInnerCircle == true
        {
            arrayInnerFriends = arrayTemp .mutableCopy() as! NSMutableArray
            
        }
        else
        {
            arrayFriends = arrayTemp .mutableCopy() as! NSMutableArray
            
        }
        txtSearch.text = ""
        txtSearch .resignFirstResponder()
        self.clView .reloadData()
        }
        
    }
    
    
    @IBAction func onInnerCircle(sender: AnyObject)
    {
        txtSearch.text = ""
        self.clView .reloadData()
        selectedAll     = false
        btnSelectAllFriends.setImage(UIImage(named: "emptyCrcl.png"), forState: UIControlState.Normal )
        
        if(arrayTemp.count>0)
        {
         arrayFriends = arrayTemp .mutableCopy() as! NSMutableArray
        }
        if (arrayInnerFriends.count <= 0)
        {
            btnSelectAllFriends.hidden = true
        }
        else
        {
            btnSelectAllFriends.hidden = false
        }
        arraySelFriends .removeAllObjects()
        isInnerCircle = true
        btnInnerCircle.backgroundColor=UIColor(red: 53/255, green: 110/255, blue: 119/255, alpha: 1)
        btnAllFriends.backgroundColor = appColor
        self.clView .reloadData()

    }

    @IBAction func onAllFriends(sender: AnyObject) {
        selectedAll     = false
        btnSelectAllFriends.setImage(UIImage(named: "emptyCrcl.png"), forState: UIControlState.Normal )
        if(arrayTemp.count>0)
        {
        arrayInnerFriends = arrayTemp .mutableCopy() as! NSMutableArray
        }
        if (arrayFriends.count <= 0)
        {
            btnSelectAllFriends.hidden = true
        }
        else
        {
            btnSelectAllFriends.hidden = false
        }
        txtSearch.text = ""
        self.clView .reloadData()
         arraySelFriends .removeAllObjects()
        isInnerCircle = false
        btnAllFriends.backgroundColor=UIColor(red: 53/255, green: 110/255, blue: 119/255, alpha: 1)
        btnInnerCircle.backgroundColor = appColor
        self.clView .reloadData()
    }
    func onAddButton()
    {
        let searchFriend : SearchFriendsViewController = SearchFriendsViewController(nibName : "SearchFriendsViewController" , bundle : nil)
        
        self.navigationController?.pushViewController(searchFriend, animated: true)
    }
    
    func FrindsAction (sender : UILongPressGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.Began
        {
        selectedTag = sender.view!.tag
       // var tempDict : NSMutableDictionary!
        
        
        if isInnerCircle == true
        {
     
         self.showInneraCircleActiosheet()
            
        }
        else
        {
            if (arrayFriends.objectAtIndex(selectedTag).objectForKey("status") as! String == "102")
            {
                
                let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil , otherButtonTitles: "Remove from Inner Circle", "Remove from Friends")
                
                actionSheet.tag = 1
                actionSheet.showInView(self.view)
            }
            else
            {
                
           
          self.showNonInneraCircleActiosheet()
            }
        }
        }

        
    }
    
    func showNonInneraCircleActiosheet()
    {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil , otherButtonTitles: "Add to Inner Circle", "Remove from Friends")
        actionSheet.tag = 1
        actionSheet.showInView(self.view)
    }
    
    func showInneraCircleActiosheet()
    {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil , otherButtonTitles: "Remove from Inner Circle", "Remove from Friends")
        actionSheet.tag = 2
        actionSheet.showInView(self.view)

    }

    
  
// MARK: - Showing Other User Profile 
    
    func showUserProfile (sender : UIGestureRecognizer)
    {
        let tag : Int = sender.view!.tag
        var tempDict : NSMutableDictionary!
        
        if isInnerCircle == true{
            tempDict  = arrayInnerFriends .objectAtIndex(tag) as! NSMutableDictionary
        }
        else
        {
            tempDict  = arrayFriends .objectAtIndex(tag) as! NSMutableDictionary
        }
        let otherUserProfileVC : OtherUserProfileViewController = OtherUserProfileViewController(nibName : "OtherUserProfileViewController" , bundle : nil)
        otherUserProfileVC.dictData = tempDict
        otherUserProfileVC.isFromSearch = false
        otherUserProfileVC.fromPendingReq = false
        otherUserProfileVC.userId = tempDict.objectForKey("friend_id") as! String
        self.navigationController?.pushViewController(otherUserProfileVC, animated: true)
    }

    // MARK: - ASIHTTP  Delegate Methode
  
    func requestFinished( request : ASIHTTPRequest ){
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let response = request.responseString()
        print(response)
        do{
        
        let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers)
        
        if let aStatus = jsonObject as? NSDictionary{
            let statusCode = aStatus.objectForKey("status") as? NSString
            if statusCode == "200"
            {
                print("Success")
                
                if viewFromCome == "Share Mood"
                {
                     globalAlertView("Your mood has been shared successfully!", viewCont: self)
                }
                 else  if mediaType == "202"
                {
                       globalAlertView("Your compliment has been shared successfully!", viewCont: self)
                }
                else
                {
                    let mediaT : Int = Int(mediaType)!
                    
                    switch (mediaT)
                    {
                    case 203:
                         globalAlertView("Your picture has been shared successfully!", viewCont: self)
                        break;
                    case 204:
                        globalAlertView("Your quote has been shared successfully!", viewCont: self)
                        break;
                    case 205:
                        globalAlertView("Your song has been shared successfully!", viewCont: self)
                        break;
                    case 206:
                        globalAlertView("Your joke has been shared successfully!", viewCont: self)
                        break;
                    case 207:
                        globalAlertView("Your video has been shared successfully!", viewCont: self)
                        break;
                    case 208:
                        globalAlertView("Your tip has been shared successfully!", viewCont: self)
                        break;
                    default :
                        break ;
                    }
                }
                arraySelFriends.removeAllObjects()
                
                selectedAll     = false
                btnSelectAllFriends.setImage(UIImage(named: "emptyCrcl.png"), forState: UIControlState.Normal )
                clView.reloadData()
             
                
            }
            else
            {
                globalAlertView("Something went wrong.", viewCont: self)
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
        globalAlertView("Please check your internet connection", viewCont: self)
        print(req.error)
    }

    
    
// MARK: - Get Happiness Score For User
    func getAllUser()
    {
        
        let strUrl : NSString = NSString(format: "%@user/friends/%@?page=%d",self.basicUrl() , strId!,pageNumber)
        
        let searchURL : NSURL = NSURL(string: strUrl as String)!
        let request = NSURLRequest(URL: searchURL)
        
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
        conn?.start()
        self.data.setData(NSData())
        
    }
    
    
func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        self.data.appendData(conData)
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Error")
        MBProgressHUD .hideHUDForView(self.view, animated: true)
    }
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        MBProgressHUD .hideHUDForView(self.view, animated: true)
        
        do
        {
        let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        let statusCode = jsonResult.objectForKey("status") as? NSString
        self.data.setData(NSData())
        if statusCode == "200"
        {
            self.arrayFriends.removeAllObjects()
            self.arrayInnerFriends.removeAllObjects()
            let array : NSArray = (jsonResult.objectForKey("details") as? NSArray)!
            if (array.count > 0)
            {
            for var i = 0 ; i < array.count ; i++
            {
                let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
                if dictTemp.objectForKey("status") as! String == "102"
                {
                     arrayInnerFriends.addObject(dictTemp)
                }
               arrayFriends.addObject(dictTemp)
               
              
            }
                
                 lastIndexOfCell = (pageNumber+1)*99
                
            }
            else
            {
                btnSelectAllFriends.hidden = true
            }
        self.clView .reloadData()
           
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
        
        if isInnerCircle == true
        {
            if (arrayInnerFriends.count == 0)
            {
                btnSelectAllFriends . hidden = true
            }
            else
            {
                 btnSelectAllFriends . hidden = false
            }
             return arrayInnerFriends.count
        }
        else
        {
            if (arrayFriends.count == 0)
            {
                btnSelectAllFriends . hidden = true
            }
            else
            {
                btnSelectAllFriends . hidden = false
            }
        return arrayFriends.count
        }
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ShareFriendsCell", forIndexPath: indexPath) as! FriendsCollectionViewCell
        cell.backgroundColor = UIColor.clearColor()
        
         var tempDict : NSDictionary!
        if isInnerCircle == true
        {
              tempDict  = arrayInnerFriends.objectAtIndex(indexPath.row) as! NSDictionary
        }
        else
        {
         tempDict  = arrayFriends.objectAtIndex(indexPath.row) as! NSDictionary
        }
        
        cell.lblUserName.text = tempDict.objectForKey("f_name") as? String
        
        if  (tempDict.objectForKey("thumb")as? String != nil)
        {
            let imgStr : String = String (format: "%@", tempDict.objectForKey("thumb")  as! String )
            let strUrl : NSURL = NSURL(string: imgStr)!
            cell.imgUser.image = UIImage(named: "userPlace")
            cell.imgUser.imageURL = strUrl
        
        }
        else
        {
            cell.imgUser.image = UIImage(named: "userPlace")
        }
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.height/2
        cell.imgUser.layer.masksToBounds = true
        let gesOnImage : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showUserProfile:")
        gesOnImage.numberOfTapsRequired = 1
        cell.imgUser.addGestureRecognizer(gesOnImage)
        cell.imgUser.tag = indexPath.row
        
        
        let longGesOnImage : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "FrindsAction:")
      //longGesOnImage.numberOfTouches() = 1
        cell.imgUser.addGestureRecognizer(longGesOnImage)
      
//        if arraySelFriends.count > 0
//        {
//         for (var i=0 ; i < arraySelFriends.count ; i++)
//         {
//            
//            if tempDict.objectForKey("friend_id") as! String  == arraySelFriends.objectAtIndex(i) as! String
//            {
//                hasSel = true
//            }
//            
//        }
//    }
//       
        let frndId  = tempDict.objectForKey("friend_id") as! String
        btnSelectAllFriends.hidden = false
        hasSel = arraySelFriends .containsObject(frndId) as Bool
            if hasSel == true
            {
                let img : UIImage = UIImage(named: "fillCrcl")!
                cell.btnCircle.setImage(img, forState: UIControlState.Normal)
                
            }
        else
            {
                let img : UIImage = UIImage(named: "emptyCrcl.png")!
                cell.btnCircle.setImage(img, forState: UIControlState.Normal)
                
        }
     
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
        var tempDict : NSDictionary!
        
        if isInnerCircle == true
        {
            tempDict = arrayInnerFriends.objectAtIndex(indexPath.row) as! NSDictionary
        }
        else
        {
             tempDict = arrayFriends.objectAtIndex(indexPath.row) as! NSDictionary
        }
     
        var selectedIndex : Int = indexPath.row
        let strObj : String = tempDict.objectForKey("friend_id") as! String
        let isIn : Bool = arraySelFriends.containsObject(strObj) as Bool
        if isIn == true
        {
                for (var i=0 ; i < arraySelFriends.count ; i++)
                {
                    if arraySelFriends.objectAtIndex(i) as! String == tempDict.objectForKey("friend_id") as! String
                    {
                       selectedIndex = i
                    }
                   
                    
                }
                arraySelFriends.removeObjectAtIndex(selectedIndex)
            selectedAll     = false
            btnSelectAllFriends.setImage(UIImage(named: "emptyCrcl.png"), forState: UIControlState.Normal )
          
            }
        else
          {
               arraySelFriends.addObject(tempDict.objectForKey("friend_id") as! String)
            
            if isInnerCircle == true
            {
                if arraySelFriends.count == arrayInnerFriends.count
                {
                    
                    btnSelectAllFriends.setImage(UIImage(named: "fillCrcl.png"), forState: UIControlState.Normal )
                    selectedAll     = true
                   
                }
                           }
            else
            {
                if arraySelFriends.count == arrayFriends.count
                {
                    btnSelectAllFriends.setImage(UIImage(named: "fillCrcl.png"), forState: UIControlState.Normal )
                    selectedAll     = true
                }
               
            }
            
            
            }
      
      
        self.clView.reloadItemsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)])
      
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(97, 140)
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        
        let lastIndexPath : NSIndexPath = NSIndexPath(forRow: lastIndexOfCell, inSection: 0)
                print(lastIndexPath.item)
                if indexPath.row == lastIndexPath.row
                {
                    pageNumber = pageNumber + 1
                    self.getAllUser()
                    
                }
        
    }

    
    // MARK: --------------- ACTIONSHEET DELEGATE
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        
        
        switch buttonIndex{
            
        case 1:
             MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            if actionSheet.tag == 1
            {
                if (arrayFriends.objectAtIndex(selectedTag).objectForKey("status") as! String == "102")
                {
                     friStatus.selected("101" , userId: arrayFriends.objectAtIndex(selectedTag).objectForKey("user_id") as! String , friendId: arrayFriends.objectAtIndex(selectedTag).objectForKey("friend_id") as! String  )
                    
                }
                else
                {
                
                 friStatus.selected("102" , userId: arrayFriends.objectAtIndex(selectedTag).objectForKey("user_id") as! String , friendId: arrayFriends.objectAtIndex(selectedTag).objectForKey("friend_id") as! String  )
                }
            }
            else
            {
                friStatus.selected("101" , userId: arrayInnerFriends.objectAtIndex(selectedTag).objectForKey("user_id") as! String , friendId: arrayInnerFriends.objectAtIndex(selectedTag).objectForKey("friend_id") as! String  )
            }
            break;
            
        case 2:
             MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            if actionSheet.tag == 1
            {
                friStatus.selected("105" , userId: arrayFriends.objectAtIndex(selectedTag).objectForKey("user_id") as! String , friendId: arrayFriends.objectAtIndex(selectedTag).objectForKey("friend_id") as! String  )
            }
            else
            {
                  friStatus.selected("105" , userId: arrayInnerFriends.objectAtIndex(selectedTag).objectForKey("user_id") as! String , friendId: arrayInnerFriends.objectAtIndex(selectedTag).objectForKey("friend_id") as! String  )
            }
           
            break;
            
        default:
            NSLog("Default");
            break;
            
        }
       
        
    }
// MARK: --------------- FRIENDSHIP STATUS DELEGATE
   func statusAfterSuccess(statusCode : Int)
    {
        
        switch (statusCode)
        {
       
        case 101:
            self.getAllUser()
            break;
        case 102:
             self.getAllUser()
            break;
        case 100 :
            MBProgressHUD.hideHUDForView(self.view, animated: true)

            if isInnerCircle == true
            {
                arrayInnerFriends.removeObjectAtIndex(selectedTag)
            }
            else
            {
                 arrayFriends.removeObjectAtIndex(selectedTag)
            }
            self.clView.reloadData()
//             self.getAllUser()
            break;
        default :
            MBProgressHUD.hideHUDForView(self.view, animated: true)

            globalAlertView("Please check your internet connection", viewCont: self)
            break;
        }
        
        
    }

}
