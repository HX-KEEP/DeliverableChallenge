//
//  DeliveryLogCell.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

class DeliveryLogCell: UITableViewCell {
    /* =================== Subviews & Sublayer Components =================== */
    /*
     - Order Image
     - Order Description
     - Favourite Indicator
     */
    private let orderImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = DeliverableUI.Color.navigationUI
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius  = 10
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let orderDescription: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 3
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private let favouriteIndicator: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Favorite")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        
        return imageView
    }()
    
    /* ====================================================================== */
    
    /* --------------------------- Initialization --------------------------- */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.initializeSubcomponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* -------------------------- External Access --------------------------- */
    public func updateReusableData(orderID: String, orderDescription: String, orderImageURL: String) {
        self.checkFavoriteStatus(orderID: orderID)
        
        DispatchQueue.main.async {
            self.orderImage.image = self.loadOrderImageFromCache(imageURL: orderImageURL)
            
            self.orderDescription.attributedText = HelperUILayout.manager.formattedText(rawText: orderDescription, alignment: HelperUILayout.TextAlignment.left, indentation: 0, textFont: UIFont.systemFont(ofSize: 16), textColor: UIColor.black)
        }
    }
    
    /* ---------------------------------------------------------------------- */
}

extension DeliveryLogCell {
    /* ----------------- Subcomponents & Reusable Subviews ------------------ */
    private func initializeSubcomponent() {
        self.backgroundColor = UIColor.clear
        
        /* Add Subviews & Sublayers */
        self.addSubview(self.orderImage)
        self.addSubview(self.orderDescription)
        self.addSubview(self.favouriteIndicator)
        
        self.reusableViewInitialLayout()
    }
    
    private func reusableViewInitialLayout() {
        /* order image */
        let imageSize = CGSize(width: 70, height: 70)
        HelperUILayout.manager.placeAxises(for: self.orderImage, viewSize: imageSize, x: HelperUILayout.LayoutXAxis.left, xAnchor: self.leftAnchor, xOffset: 10, y: HelperUILayout.LayoutYAxis.center, yAnchor: self.centerYAnchor, yOffset: 0)
        
        /* order description */
        let descriptionSize = CGSize(width: self.frame.size.width - 90, height: self.frame.size.height)
        HelperUILayout.manager.placeAxises(for: self.orderDescription, viewSize: descriptionSize, x: HelperUILayout.LayoutXAxis.left, xAnchor: self.orderImage.rightAnchor, xOffset: 10, y: HelperUILayout.LayoutYAxis.center, yAnchor: self.centerYAnchor, yOffset: 0)
        
        /* favorite indicator */
        let favoriteIndicatorSize = CGSize(width: 50, height: 50)
        HelperUILayout.manager.placeAxises(for: self.favouriteIndicator, viewSize: favoriteIndicatorSize, x: HelperUILayout.LayoutXAxis.right, xAnchor: self.rightAnchor, xOffset: -10, y: HelperUILayout.LayoutYAxis.center, yAnchor: self.centerYAnchor, yOffset: 0)
    }
    
    /* ------------------ Reusable View Internal Functions ------------------ */
    private func checkFavoriteStatus(orderID: String) {
        DispatchQueue.main.async {
            if DeliveryOrder.manager.checkFavorite(orderID: orderID) {
                self.favouriteIndicator.tintColor = DeliverableUI.Color.favorateActive
            } else {
                self.favouriteIndicator.tintColor = DeliverableUI.Color.favorateInactive
            }
        }
    }
    
    /**
     Internal function that utilize local cache to speed up  order image loading process.
     
     - Note:
     Implement to improve app's performance by storing the "frequent" use order image in cache, and load locally instead of fetching from server every time.
     
     The image cache variable is located at:
     ```
     DeliveryLogModel.swift
     ```
     
     - Parameters:
        -   imageURL: URL of the order image.
     */
    private func loadOrderImageFromCache(imageURL: String) -> UIImage? {
        var fetchedImage: UIImage?
        
        if let cachedImage = orderImageCache.object(forKey: imageURL as AnyObject) as? UIImage {
            
            fetchedImage = cachedImage
        } else {
            guard let fetchingURL = URL(string: imageURL) else {
                debugPrint("<LoadFromCache> URL Error")
                return nil
            }
            
            let tast = URLSession.shared.dataTask(with: fetchingURL) { (data, response, error) in
                guard error == nil else {
                    debugPrint("<LoadFromCache> Fetching Error")
                    return
                }
                
                DispatchQueue.main.async {
                    guard let fetchedData = data, let downloadedImage = UIImage(data: fetchedData) else {
                        debugPrint("<LoadFromCache> Data Error")
                        return
                    }
                    
                    orderImageCache.setObject(downloadedImage, forKey: imageURL as AnyObject)
                    
                    fetchedImage = downloadedImage
                }
            }
            tast.resume()
        }
        
        return fetchedImage
    }
    /* ---------------------------------------------------------------------- */
}
