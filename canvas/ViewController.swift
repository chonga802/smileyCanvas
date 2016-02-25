//
//  ViewController.swift
//  canvas
//
//  Created by Christine Hong on 2/24/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var smileyOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trayOriginalCenter = trayView.center
        trayCenterWhenOpen = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y)
        trayCenterWhenClosed = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + 163)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let point = panGestureRecognizer.locationInView(self.view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            if (CGRectGetMaxY(self.view.frame) - 100 < point.y && point.y < CGRectGetMaxY(self.view.frame) - 37) {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: point.y + 100)
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            // print("Gesture ended at: \(point)")
            let velocity = panGestureRecognizer.velocityInView(trayView)
            if (velocity.y > 0) {
                // we're going down
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.trayView.center = self.trayCenterWhenClosed
                });
            } else {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.trayView.center = self.trayCenterWhenOpen
                });
            }
            
        }
    }

    @IBAction func newFaceGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.locationInView(trayView)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            
            // Gesture recognizers know the view they are attached to
            let imageView = panGestureRecognizer.view as! UIImageView
            
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            // create new gesture recognizer
            let newGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
            newlyCreatedFace.addGestureRecognizer(newGestureRecognizer)
            newlyCreatedFace.userInteractionEnabled = true
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            
            newlyCreatedFace.center.y = point.y + trayView.frame.origin.y
            newlyCreatedFace.center.x = point.x
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
        }
    }
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view
        let point = panGestureRecognizer.locationInView(self.view)
        
//        // Relative change in (x,y) coordinates from where gesture began.
//        let translation = panGestureRecognizer.translationInView(view)
//        let velocity = panGestureRecognizer.velocityInView(view)
        
        let imageView = panGestureRecognizer.view as! UIImageView
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("*** Gesture began at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("*** Gesture changed at: \(point)")
            
            imageView.center = point
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("*** Gesture ended at: \(point)")
        }
    }
    
    
}

