//
//  UWMapViewController.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-06.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class UWMapViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView = UIImageView(image: UIImage(named: "map_colour300.png"))
        scrollView = UIScrollView(frame: view.bounds)
        
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        scrollView.contentOffset = CGPoint(x: 2500, y: 1100)
       
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        scrollView.delegate = self
        
        setZoomScale()
        setupGestureRecognizer()
    }
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    private func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = max(heightScale, widthScale)
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = 0.8
    }
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }

}

extension UWMapViewController: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
