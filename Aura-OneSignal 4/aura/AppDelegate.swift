//
//  AppDelegate.swift
//  Aura
//
//  Created by necixy on 05/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate , NSURLConnectionDelegate{
    var strId: NSString!
    var data = NSMutableData()
    var hasSelectMood : Bool!
    var device_id : NSString!
    var isInLeft : Bool!
    var notiFyType : NSInteger!
    var window: UIWindow?
    var navController : UINavigationController?
    var arrHappiness : NSMutableArray = []
    var arraySelMoods : NSMutableArray =  NSMutableArray()
    var oneSignal : OneSignal!

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    
        return FBSDKApplicationDelegate.sharedInstance().application(application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
     
        
        //=====================================**************************************
        
        self.window = UIWindow(frame:  UIScreen.mainScreen().bounds)
        self.window?.backgroundColor=UIColor(white: 255.0, alpha: 1.0)
        isInLeft = false
      
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        UINavigationBar.appearance().barTintColor = UIColor(red: 88.0/255.0, green:185.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        
       //  TestFairy.begin("c8acfef4349f7f8b97e1e919f94bfb04617784a9")
        //----------- One signal push notifications
       
     
       self.oneSignal = OneSignal(launchOptions: launchOptions, appId: "8d888ade-f16d-4098-85a6-a57060b18530") { (message, additionalData, isActive) in
           NSLog("OneSignal Notification opened:\nMessage: %@", message)
           
           if additionalData != nil {
               NSLog("additionalData: %@", additionalData)
             
               application.applicationIconBadgeNumber = 0
               if application.applicationState == UIApplicationState.Inactive {
                   
                   let jsonResult = additionalData as? NSDictionary
                   
                   self.notiFyType = (jsonResult!["notify_type"] as? NSInteger)!
                   if self.notiFyType == 309
                       
                   {
                       let homeVC : FriendsViewController = FriendsViewController(nibName : "FriendsViewController" , bundle : nil)
                       self.navController = SlideNavigationController(rootViewController: homeVC)
                       
                       let leftVC : LeftMenuController = LeftMenuController(nibName : "LeftMenuController" , bundle : nil)
                       
                       SlideNavigationController.sharedInstance().leftMenu=leftVC
                       self.window?.rootViewController = self.navController
                       self.window?.makeKeyAndVisible()
                       let mmVC : FriendRequestsViewController = FriendRequestsViewController(nibName : "FriendRequestsViewController" , bundle : nil)
                       
                       self.navController?.pushViewController(mmVC, animated: true)
                   }
                   else
                   {
                       let homeVC : DashboardViewController = DashboardViewController(nibName : "DashboardViewController" , bundle : nil)
                       self.navController = SlideNavigationController(rootViewController: homeVC)
                       let leftVC : LeftMenuController = LeftMenuController(nibName : "LeftMenuController" , bundle : nil)
                       SlideNavigationController.sharedInstance().leftMenu=leftVC
                       self.window?.rootViewController = self.navController
                       self.window?.makeKeyAndVisible()
                   }
               }
               else
               {
                   let alert = UIAlertView()
                   alert.title = "Aura"
                   alert.message = message as String
                   alert.addButtonWithTitle("OK")
                   alert.show()
               }
               
               if let customKey = additionalData["customKey"] as! String? {
                   NSLog("customKey: %@", customKey)
               }
           }
       }
       
       oneSignal.IdsAvailable({ (userId, pushToken) in
           NSLog("UserId:%@", userId)
           self.device_id = userId
           if (pushToken != nil) {
               NSLog("pushToken:%@", pushToken)
           }
       })
        
        
     /*   let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()*/
        //=========
//    
//        if let launchOptions = launchOptions {
//            if let userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] {
//               self.application(application, didReceiveRemoteNotification: userInfo as! [NSObject : AnyObject])
//            }
//        }
//        else
//        {
            strId =  NSUserDefaults.standardUserDefaults().objectForKey("userId") as? NSString
            hasSelectMood = false
            
            if  strId == nil
            {
                self .logoutUser()
            }
            else
            {
                if strId  == "0"
                {
                    
                    self .logoutUser()
                }
                else
                {
                    self.sliderMenuController()
                }
            }
  
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
       //return true
        
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
           FBSDKAppEvents.activateApp()

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
//        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
//        loginManager.logOut()
        
    
    }
    
    func updateScoreValue()
    {
        if strId  == nil
        {
            //self .logoutUser()
        }
        else
        {
        let strUrl : NSString = NSString(format: "http://www.pairroxz.com/developer/aura/api/happiness/%@?page=0",strId!)
        
        let searchURL : NSURL = NSURL(string: strUrl as String)!
        let request = NSURLRequest(URL: searchURL)
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
        conn!.start()
        self.data.setData(NSData())
        }
     //   NSLog("Calling")
    }
    
     // MARK: - UserImage Store in Local Directory
    func storeUserImageInLocalDirectory ()
    {
        //var userImageView : UIImageView?
        
        let archivedData = NSUserDefaults.standardUserDefaults().objectForKey("userInfo") as! NSData

       let  dataDict = NSKeyedUnarchiver.unarchiveObjectWithData(archivedData) as? NSDictionary
        if  dataDict!.objectForKey("thumb") as? NSObject != NSNull()
        {
            //let imgStr : NSString = NSString(format: "%@.png",  (NSUserDefaults.standardUserDefaults().objectForKey("userId") as? NSString)!)
            
            
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)
           
                if paths.count > 0 {
                    
                   // strPath = paths[0]
                      }
           // let readPath = strPath.stringByAppendingPathComponent(imgStr as String)
         //   let image = UIImage(contentsOfFile: readPath)
            
                let strUrl : NSURL = NSURL(string: dataDict!.objectForKey("thumb")  as! String)!
            
            if let url = NSURL(string: dataDict!.objectForKey("thumb")  as! String)
            {
                if let data = NSData(contentsOfURL: url) {
                    print("Finished downloading \"\(strUrl.URLByDeletingPathExtension!.lastPathComponent!)\".")
                    // imageURL.image = UIImage(data: data)
                    let image = UIImage(data: data)
                    let imgStr : NSString = NSString(format: "%@.png", (NSUserDefaults.standardUserDefaults().objectForKey("userId") as? NSString)!)
                    let readPath =  self.documentDirectoryPath().stringByAppendingPathComponent(imgStr as String)
                    UIImageJPEGRepresentation(image!, 1.0)!.writeToFile(readPath, atomically: true)
                }
            }
    }
        else
        {
            
            var strPath : NSString!
            
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)
            
            if paths.count > 0 {
                
                strPath = paths[0]
            }
            let imgStr : NSString = NSString(format: "%@.png",  (NSUserDefaults.standardUserDefaults().objectForKey("userId") as? NSString)!)
            let readPath = strPath.stringByAppendingPathComponent(imgStr as String)
            let image = UIImage(contentsOfFile: readPath)
            if image == nil
            {
                let imageUser : UIImage = UIImage(named: "userPlace.png")!
                let dataImage = UIImagePNGRepresentation(imageUser)
            dataImage!.writeToFile(readPath, atomically: true)
            }
        }
       
}
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
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
    

// Mark: - Slider Menu Contorller
    func sliderMenuController()
    {
        
        let scoreHpns: String? = userDefault.objectForKey("happinesScore") as? String
        if scoreHpns == "11"
        {
            let homeVC : MoodsViewController = MoodsViewController(nibName : "MoodsViewController" , bundle : nil)
            self.navController = SlideNavigationController(rootViewController: homeVC)
            
            let leftVC : LeftMenuController = LeftMenuController(nibName : "LeftMenuController" , bundle : nil)
            
            SlideNavigationController.sharedInstance().leftMenu=leftVC
        }
        else
        {
            let homeVC : MoodsViewController = MoodsViewController(nibName : "MoodsViewController" , bundle : nil)
            self.navController = SlideNavigationController(rootViewController: homeVC)
            
            let leftVC : LeftMenuController = LeftMenuController(nibName : "LeftMenuController" , bundle : nil)
            
            SlideNavigationController.sharedInstance().leftMenu=leftVC
        }
  

        self.storeUserImageInLocalDirectory()
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()

        
        
    }
     // MARK: - On Logout
    func logoutUser()
    {

        let loginVC: LoginViewController = LoginViewController(nibName:"LoginViewController", bundle: nil)
        self.navController = UINavigationController(rootViewController: loginVC)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    // MARK: - 
    func getScoreOfHappiness (score : Int) -> String
    {
        var mood : String!
        switch score
        {
        case 10 :
            mood = "1"
            break;
        case 9 :
            mood = "2"
            break;
        case 7 :
            mood = "3"
            break;
        case 6 :
            mood = "4"
            break;
        case 5 :
            mood = "5"
            break;
        case 3 :
            mood = "6"
            break;
        case 2 :
            mood = "7"
            break;
        case 1 :
            mood = "8"
            break;
        case 0 :
            mood = "9"
            break;
        case -5 :
            mood = "10"
            break;
        default :
            mood = "10"
            break;
        }
    return mood
}
    
  // MARK: - Get Happiness Image According HappinessScore
   func moodAccordinghappinesScore(happinessScore : Int ) -> String
{
       var happinesImage : String!
      
    switch happinessScore
    {
        case -5:
            happinesImage = "Suicidal"
            break;
        case 0 :
            happinesImage = "Bullied"
            break;
        case 1 :
            happinesImage = "Upset"
            break;
        case 2 :
            happinesImage = "Insecure"
            break;
        case 3 :
            happinesImage = "Stressed"
            break;
        case 5 :
            happinesImage = "Bored"
            break;
        case 6 :
            happinesImage = "Mysterious"
            break;
        case 7 :
            happinesImage = "Silly"
            break;
        case 9 :
            happinesImage = "Upbeat"
            break;
        case 10 :
            happinesImage = "Fabulous"
            break;
        default :
             happinesImage = "Suicidal"
        break;

    }
    return happinesImage
}
    // MARK: - Get Happiness Image According HappinessScore
    func moodAccordingNumber(numb : String ) -> String
    {
        var happinesImage : String!
        
        if numb .isEmpty
        {
            happinesImage = ""
            return happinesImage
        }
        else
        {
        let number : Int = Int(numb)!
        
        switch number
        {
        case 10:
            happinesImage = "Suicidal"
            break;
        case 9:
            happinesImage = "Bullied"
            break;
        case 8 :
            happinesImage = "Upset"
            break;
        case 7 :
            happinesImage = "Insecure"
            break;
        case 6 :
            happinesImage = "Stressed"
            break;
        case 5 :
            happinesImage = "Bored"
            break;
        case 4 :
            happinesImage = "Mysterious"
            break;
        case 3 :
            happinesImage = "Silly"
            break;
        case 2 :
            happinesImage = "Upbeat"
            break;
        case 1 :
            happinesImage = "Fabulous"
            break;
        default :
            happinesImage = "Suicidal"
            break;
            
        }
             return happinesImage
        }
    
       
    }
    // MARK: - Check String Contain Url 
    func checkTextContainLink ( stng : String) -> Bool
    {
        
        let text = stng
        let types: NSTextCheckingType = .Link
        
        var  detector : NSDataDetector!
        
        do
        {
            detector = try NSDataDetector(types: types.rawValue)
        }
        catch
        {
            print(error)
        }
        
        let matches = detector.matchesInString(text, options: [], range: NSMakeRange(0, text.characters.count))
        var counter : Int = 0
        for match in matches {
            print(match)
            counter++
        }
        if counter > 1
        {
           
            return false
        }
        else  if counter == 1
        {
            return true
        }
        else
        {
            return false
        }
        
        
    }

    // MARK: - OneSignal Notification
    func setOneSignalNotification()
    {
        
    }
    
    // MARK: - Register Notification

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
       }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
            }
    
 // Mark: - NSURL Connection Delegate
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // println("didReceiveResponse")
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        self.data.appendData(conData)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
              do{
        let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        let statusCode = jsonResult.objectForKey("status") as? NSString
        if statusCode == "200"
        {
            // appDel.arrHappiness!.removeAllObjects()
             if  jsonResult.objectForKey("details") as? NSObject != NSNull()
             {
            arrHappiness = (jsonResult.objectForKey("details") as? NSMutableArray)!;
                if arrHappiness.count > 0
                {
                let  tempDict : NSDictionary = self.arrHappiness.objectAtIndex(0) as! NSDictionary
                var mood  : String =  String (format: "%@", (tempDict.objectForKey("scale") as! NSString))
                
            
                let moodScal : Int  = Int(mood)!
                mood = self.getScoreOfHappiness(moodScal)
            
            
                userDefault.setObject(mood, forKey: "moodValue")
                mood = self.moodAccordinghappinesScore(moodScal)
                userDefault.setObject(mood, forKey:"mymood")
                }
            }
                }
        }
        catch
        {
            print(error)
        }
    }
 
   

    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.anil.demo.demo" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Aura", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Aura.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

