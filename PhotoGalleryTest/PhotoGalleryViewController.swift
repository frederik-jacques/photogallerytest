//
//  PhotoGalleryViewController.swift
//  PhotoGalleryTest
//
//  Created by Frederik Jacques on 15/04/15.
//  Copyright (c) 2015 Touching. All rights reserved.
//

import UIKit

class PhotoGalleryViewController: UIViewController,
    UIScrollViewDelegate
 {

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint! // this one defines the contentsize of the scrollview
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Properties
    var images:[UIImage]
    
    var currentPhotoIndex:Int = 0 {
        
        didSet {
            
            pageControl.currentPage = currentPhotoIndex
            
        }
        
    }
    
    // MARK: - Initializers functions
    required init(coder aDecoder: NSCoder) {
     
        // add some dummy data
        images = [ UIImage(named: "image1")!, UIImage(named: "image2")!, UIImage(named: "image3")!,UIImage(named: "image1")!, UIImage(named: "image2")!, UIImage(named: "image3")! ]
        
        super.init(coder: aDecoder)
        
        
    }
    
    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Add images to the scrollview
        addImagesToScrollView()
        
        // Update page control, so the amount of dots reflect the amount of pictures in the gallery
        pageControl.numberOfPages = images.count
        
    }
    
    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()

    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        let currentWidth = view.bounds.size.width
        let currentHeight = view.bounds.size.height
        
        // Remove old constraints, except for the constraint which determines the width of the contentview
        for constraint in contentView.constraints() as! [NSLayoutConstraint] {
            
            if constraint !== contentViewWidthConstraint {
                
                contentView.removeConstraint(constraint)
                
            }
            
        }
        
        // Calculate the offset for every image in the contentview, so they get next to eachother
        var offsetX = CGFloat(0)
        
        for imageView in contentView.subviews as! [UIImageView] {
            
            let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-offset-[imageView(width)]",
                options: NSLayoutFormatOptions(0),
                metrics: [
                    "width":currentWidth,
                    "offset":offsetX
                ],
                views: ["imageView":imageView]
            )
            
            let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[imageView(height)]|",
                options: NSLayoutFormatOptions(0),
                metrics: ["height":currentHeight],
                views: ["imageView":imageView]
            )
            
            contentView.addConstraints(hConstraints)
            contentView.addConstraints(vConstraints)
            
            offsetX += currentWidth
            
        }
        
        // Update the constraint which defines the width of the contentsize of the scrollview
        contentViewWidthConstraint.constant = offsetX
        
        // When the devices gets rotated, we want to calculate the right offset, so the scrollview is at the same position after the rotation
        scrollView.contentOffset = calculateScrollViewOffset()
        
    }
    
    // MARK: - Private functions
    private func addImagesToScrollView(){
        
        // Loop over the array with UIImages and add them to the contentView inside the scrollview
        for image in images {
        
            let imageView = UIImageView(image: image)
            imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
            imageView.clipsToBounds = true
            imageView.contentMode = UIViewContentMode.Center
            contentView.addSubview(imageView)
        
        }
        
    }
    
    private func calculateScrollViewOffset() -> CGPoint{
    
        // This calculates the offset when we are rotating so the scrollview has the same offset as before the rotation (otherwise image gets cut off)
        return CGPoint(x: currentPhotoIndex * Int( view.bounds.width ), y: 0)
    
    }
    
    // MARK: - Public functions
    
    // MARK: - Getter & setter functions
    
    // MARK: - IBActions
    
    // MARK: - Target-Action functions

    // MARK: - Notification handler functions
    
    // MARK: - Datasource functions
    
    // MARK: - Delegate functions

    // MARK: UIScrollViewDelegate functions
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
                        
        // Calculate what the current photo index is so we can calculate the correct offset for the scrollview
        currentPhotoIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width);
    }

}
