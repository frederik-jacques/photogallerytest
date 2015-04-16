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
        
		// not needed since the contentView is created in the storyboard
//        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Add images to the scrollview
        addImagesToScrollView()
		// We can do this in viewDidLoad since the number of images is fixed. Put this in an accessor method if the images are dynamic.
		setupConstraints()
        
        // Update page control, so the amount of dots reflect the amount of pictures in the gallery
        pageControl.numberOfPages = images.count
        
    }
	
	
    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()

    }
	
    
    // MARK: - Private functions
    private func addImagesToScrollView(){
        
        // Loop over the array with UIImages and add them to the contentView inside the scrollview
        for image in images {
        
            let imageView = UIImageView(image: image)
            imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
            imageView.clipsToBounds = true
            imageView.contentMode = UIViewContentMode.Center
            scrollView.addSubview(imageView)
        
        }
        
    }
	
	
	private func setupConstraints() {
		
		let currentWidth = scrollView.bounds.size.width
		let currentHeight = scrollView.bounds.size.height
		
		var offsetX = CGFloat(0)
		
		var previousImageView: UIImageView!
		
		// remark: subviews might not be in the order you expect, so this is not a reliable way to do this!
		let subviews = scrollView.subviews
		
		for (index, imageView) in enumerate(subviews) {
			
			var hConstraints: NSArray
			var vConstraints: NSArray
			
			if previousImageView == nil {
				hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
					"H:|-offset-[imageView(width)]",
					options: NSLayoutFormatOptions(0),
					metrics: [
						"width":currentWidth,
						"offset":offsetX
					],
					views: ["imageView":imageView]
				)
			} else {
				hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
					"H:[previousImageView]-offset-[imageView(width)]",
					options: NSLayoutFormatOptions(0),
					metrics: [
						"width":currentWidth,
						"offset":offsetX
					],
					views: ["imageView":imageView, "previousImageView": previousImageView]
				)
			}
			
			previousImageView = imageView as! UIImageView
			
			scrollView.addConstraints(hConstraints as [AnyObject])
			
			// last imageView
			if index == subviews.count - 1 {
				hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
					"H:[imageView]-offset-|",
					options: NSLayoutFormatOptions(0),
					metrics: [
						"offset":offsetX
					],
					views: ["imageView":imageView]
				)
				scrollView.addConstraints(hConstraints as [AnyObject])
			}
			
			
			// vertical
			vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
				"V:|-0-[imageView(height)]-0-|",
				options: NSLayoutFormatOptions(0),
				metrics: [
					"height":currentHeight,
				],
				views: ["imageView": imageView]
			)
			
			scrollView.addConstraints(vConstraints as [AnyObject])
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
