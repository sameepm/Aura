//
//  ImageViewController.swift
//  Aura
//
//  Created by Apple on 26/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    var image : UIImage!
    @IBOutlet weak var scrlView: UIScrollView!
    var rectToZoomInTo : CGRect!
    var rectToZoomOutTo : CGRect!
   //  var imageView: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.image = image
        //imgView.frame = CGRect(origin: CGPointMake(0.0, 0.0), size:image.size)
        
        // 2
        self.scrlView.addSubview(imgView)
        self.scrlView.contentSize = image.size
        
        // 3
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        self.scrlView.addGestureRecognizer(doubleTapRecognizer)
        
        // 4
        let scrollViewFrame = self.scrlView.frame
        let scaleWidth = scrollViewFrame.size.width / self.scrlView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / self.scrlView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        self.scrlView.minimumZoomScale = minScale;
        
        // 5
        self.scrlView.maximumZoomScale = 1.0
        self.scrlView.zoomScale = minScale;
        
        // 6
        centerScrollViewContents()
    }
    
    func centerScrollViewContents() {
        let boundsSize = self.scrlView.bounds.size
        var contentsFrame = imgView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imgView.frame = contentsFrame
        
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.locationInView(imgView)
        
        // 2
        var newZoomScale = self.scrlView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, self.scrlView.maximumZoomScale)
        
        // 3
        let scrollViewSize = self.scrlView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        self.scrlView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imgView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView!) {
        centerScrollViewContents()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hideViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
//        let touch = touches.anyObject()! as! UITouch
//        let location = touches.locationInView(self)
//    }
}
