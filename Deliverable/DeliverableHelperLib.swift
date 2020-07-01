//
//  DeliverableHelperLib.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit
import CoreData



/*
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Note:
 These are the segments of a set of modules library(from Swift package) that
 I made and used for all my developments in the past years.

 Here only contains only the necessary components that fulfill the needs by this
 mock demo app, and only served as "helper" to REDUCE code redundancy and
 IMPROVE code readablilty.
 
 Therefore, instead of having them saperated in mutiple files, I've just grouped
 these segments into a signle "DeliverableHelperLib" for structual sake.
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/



/**
 HelperNetworkManager (Deliverable mock demo)
 
 - Note:
 Generic HTTP client that handle GET & POST request. As well as fetching request from RESTful server
 utilizing Swift Codable protocol.
 
 - Requires:
 
 - Author:
 EisenWolf Studio
 
 - Copyright: Copyright ©
 HelperNetworkManager
 by EisenWolf Studio
 */
final class HelperNetwork {
    /* ---------------------------- Initializer ----------------------------- */
    private init () { }
    /* -------------------------- Internal Access --------------------------- */
    /**
     Internal function to set / add header fields for the HTTP request.
     
     - Note:
     
     - Parameters:
        -   request: The reference of request URL, inputs for modification.
        -   headerPayloads: Optional payloads for HTTP header.
     */
    private func appendHTTPHeaders(_ request: inout URLRequest, _ headerPayloads: [HelperNetwork.HTTPField]?) {
        guard let payloads = headerPayloads else {
            return
        }
        
        for parameter in payloads {
            if request.value(forHTTPHeaderField: parameter.key) != nil {
                request.setValue(parameter.value, forHTTPHeaderField: parameter.key)
            } else {
                request.addValue(parameter.value, forHTTPHeaderField: parameter.key)
            }
        }
    }
    
    /**
     Internal function to set / add body fields for the HTTP request.
     
     - Note:
     Check CORS(Cross Origin Resource Sharing) pre-flight headers, set / update  before returns.
     
     - Parameters:
        -   request: The reference of request URL, inputs for modification.
        -   bodyPayloads: Optional payloads for HTTP header.
     */
    private func appendHTTPBody(_ request: inout URLRequest, _ bodyPayloads: [HelperNetwork.HTTPField]?) {
        guard let payloads = bodyPayloads else {
            return
        }
        
        var queriesContainer = [String]()
        for parameter in payloads {
            let query = "\(parameter.key)=\(parameter.value)"
            
            queriesContainer.append(query)
        }
        let payloadQueryString = queriesContainer.joined(separator: "&")
        
        let queryLength = payloadQueryString.lengthOfBytes(using: String.Encoding.utf8)

        if request.value(forHTTPHeaderField: "content-type") != nil {
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            request.setValue("\(queryLength)", forHTTPHeaderField: "content-length")
        } else {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            request.addValue("\(queryLength)", forHTTPHeaderField: "content-length")
        }
        
        request.httpBody = payloadQueryString.data(using: String.Encoding.utf8)
    }
    
    /* -------------------------- External Access --------------------------- */
    public static let manager = HelperNetwork()
    
    public struct HTTPField {
        let key: String
        let value: String
    }
    
    public enum HTTPMethod {
        case get, post
    }

    public enum RESTfulError {
        case request, nullResponse, codable, unknown
    }
    
    public struct HTTPError {
        let serverResponseCode: Int
        let serverRESTfulError: HelperNetwork.RESTfulError
    }
    
    /**
     External function to build HTTP request.
     
     - Note:
     
     - Parameters:
        -   with: The source of request URL.
        -   httpMethod: GET or POST HTTP method.
        -   timeout: Timeout value for the connection.
        -   cachePolicy: Swift URLRequest cache policy.
        -   httpHeaders: Optional header parameters.
        -   httpBody: Optional body parameters.
     */
    public func buildHTTPRequest(with requestURL: URL, httpMethod method: HelperNetwork.HTTPMethod, timeout time: Double, cachePolicy policy: URLRequest.CachePolicy?, httpHeaders headers: [HelperNetwork.HTTPField]?, httpBody body: [HelperNetwork.HTTPField]?) -> URLRequest {
        var mutableRequest = URLRequest(url: requestURL)
        mutableRequest.allHTTPHeaderFields?.removeAll()
        
        self.appendHTTPHeaders(&mutableRequest, headers)
        self.appendHTTPBody(&mutableRequest, body)
        
        mutableRequest.timeoutInterval = time
        
        if let policy = policy {
            mutableRequest.cachePolicy = policy
        }
        
        switch method {
        case HelperNetwork.HTTPMethod.get:
            mutableRequest.httpMethod = "GET"
        case HelperNetwork.HTTPMethod.post:
            mutableRequest.httpMethod = "POST"
        }
        
        return mutableRequest
    }
    
    /**
     External function to fetch Swift Codable object from RESTful Server
     
     - Note:
     
     - Parameters:
        -   with: The source of request URL.
        -   over: A Swift URLSession.
        -   decodeInto: A Codable  object type.
        -   completion: The callback closure including the data object or the HTTP error, return upon fetch completion.
     */
    public func fetchRESTful<T: Codable>(with request: URLRequest, over session: URLSession, decodeInto dataType: T.Type, completion: @escaping (_ object: T?, _ error: HelperNetwork.HTTPError?) -> Void) {
        var decodedObject: T?

        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil, let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(nil, HelperNetwork.HTTPError(serverResponseCode: 500, serverRESTfulError: HelperNetwork.RESTfulError.request))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, HelperNetwork.HTTPError(serverResponseCode: response.statusCode, serverRESTfulError: HelperNetwork.RESTfulError.nullResponse))
                }
                return

            }
            
            do {
                decodedObject = try JSONDecoder().decode(dataType, from: data)
                
                DispatchQueue.main.async {
                    completion(decodedObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, HelperNetwork.HTTPError(serverResponseCode: response.statusCode, serverRESTfulError: HelperNetwork.RESTfulError.codable))
                }
                
                return
            }
        }
        task.resume()
    }
}

/**
 HelperUILayoutManager (Deliverable mock demo)
 
 - Note:
 Helper module for programatically layout UI components, and render atributes formatted text.
 
 - Requires:
 
 - Author:
 EisenWolf Studio
 
 - Copyright: Copyright ©
 HelperUILayoutManager
 by EisenWolf Studio
 */
final class HelperUILayout {
    /* ---------------------------- Initializer ----------------------------- */
    private init() { }
    /* -------------------------- Internal Access --------------------------- */
    private struct ConstraintsContainer {
        var top, left, bottom, right, width, height, x, y: NSLayoutConstraint?
    }
    
    /* -------------------------- External Access --------------------------- */
    public static let manager = HelperUILayout()
    
    public enum LayoutXAxis {
        case left, center, right
    }
    
    public enum LayoutYAxis {
        case top, center, bottom
    }
    
    public enum TextAlignment {
        case left, center, right
    }
    
    /**
     External function to setup application's render window. Eliminated the need of UI builder.
     
     - Note:
     Check for legacy targer build (piror iOS 13). Initialize app's render window in AppDelegate.swift instead of SceneDelegate.swift.
     
     - Parameters:
        -   deviceWindow: Device's render window from AppDelegate / SceneDelegate.
        -   appWindow: App's render window from initiation.
        -   rootController: The root ViewController for the navigation stack.
     */
    public func setupAppWindow(deviceWindow: inout UIWindow?, appWindow: UIWindow, rootController: UIViewController) {
        let appNavigationController = UINavigationController(rootViewController: rootController)
        
        /* Navigation bar settings */
        appNavigationController.navigationBar.barTintColor = DeliverableUI.Color.navigationUI
        appNavigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ]
        
        if #available(iOS 13, *) {
            DispatchQueue.main.async {
                appWindow.rootViewController = appNavigationController
            }
            
            deviceWindow = appWindow
        } else {
            deviceWindow = appWindow
            deviceWindow?.rootViewController = appNavigationController
        }
        
        deviceWindow?.makeKeyAndVisible()
    }

    /**
     External function to layout a view component to fill its predecessor view.
     
     - Note:
     Check for invalid / nil predecessor view.
     
     - Parameters:
        -   for: The view component to be set layout.
        -   padding: Optional spacing around the edges.
     */
    public func fillPredecessor(for targetView: UIView, padding: UIEdgeInsets = UIEdgeInsets.zero)  {
        guard let predecessorViewTopAnchor = targetView.superview?.topAnchor, let predecessorViewLeftAnchor = targetView.superview?.leftAnchor, let predecessorViewBottomAnchor = targetView.superview?.bottomAnchor, let predecessorViewRightAnchor = targetView.superview?.rightAnchor else {
                debugPrint("<HelperUILayout> PredecessorVIew Error")
            return
        }
        
        var layoutConstrains = HelperUILayout.ConstraintsContainer()
        
        targetView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutConstrains.top = targetView.topAnchor.constraint(equalTo: predecessorViewTopAnchor, constant: padding.top)
        layoutConstrains.left = targetView.leftAnchor.constraint(equalTo: predecessorViewLeftAnchor, constant: padding.left)
        layoutConstrains.bottom = targetView.bottomAnchor.constraint(equalTo: predecessorViewBottomAnchor, constant: (-padding.bottom))
        layoutConstrains.right = targetView.rightAnchor.constraint(equalTo: predecessorViewRightAnchor, constant: (-padding.right))
        
        [layoutConstrains.top, layoutConstrains.left, layoutConstrains.bottom, layoutConstrains.right].forEach {
            $0?.isActive = true
        }
    }

    /**
     External function to layout a view component by placing its axis.
     
     - Note:
     
     - Parameters:
        -   for: The view component to be set layout.
        -   viewSize: The size (width & height) of the view component.
        -   x: The relative X axis (left, center, right) for layout.
        -   xAnchor: The layout anchor on X axis.
        -   xOffset: The offset value of the X layout anchor.
        -   y: The relative y axis (top, center, bottom) for layout.
        -   yAnchor: The layout anchor on Y axis.
        -   yOffset: The offset value of the Y layout anchor.
     */
    public func placeAxises(for targetView: UIView, viewSize size: CGSize, x: HelperUILayout.LayoutXAxis, xAnchor: NSLayoutXAxisAnchor, xOffset: CGFloat, y: HelperUILayout.LayoutYAxis, yAnchor: NSLayoutYAxisAnchor, yOffset: CGFloat) {
        var layoutConstrains = HelperUILayout.ConstraintsContainer()
        
        targetView.translatesAutoresizingMaskIntoConstraints = false
        
        switch x {
        case HelperUILayout.LayoutXAxis.left:
            layoutConstrains.x = targetView.leftAnchor.constraint(equalTo: xAnchor, constant: xOffset)
        case HelperUILayout.LayoutXAxis.center:
            layoutConstrains.x = targetView.centerXAnchor.constraint(equalTo: xAnchor, constant: xOffset)
        case HelperUILayout.LayoutXAxis.right:
            layoutConstrains.x = targetView.rightAnchor.constraint(equalTo: xAnchor, constant: xOffset)
        }
        
        switch y {
        case HelperUILayout.LayoutYAxis.top:
            layoutConstrains.y = targetView.topAnchor.constraint(equalTo: yAnchor, constant: yOffset)
        case HelperUILayout.LayoutYAxis.center:
            layoutConstrains.y = targetView.centerYAnchor.constraint(equalTo: yAnchor, constant: yOffset)
        case HelperUILayout.LayoutYAxis.bottom:
            layoutConstrains.y = targetView.bottomAnchor.constraint(equalTo: yAnchor, constant: yOffset)
        }
        
        layoutConstrains.width = targetView.widthAnchor.constraint(equalToConstant: size.width)
        layoutConstrains.height = targetView.heightAnchor.constraint(equalToConstant: size.height)
        
        [layoutConstrains.x, layoutConstrains.y, layoutConstrains.width, layoutConstrains.height].forEach {
            $0?.isActive = true
        }
    }
    
    /**
     External function to layout a view component by placing its edges.
     
     - Note:
     
     - Parameters:
        -   for: The view component to be set layout.
        -   padding: Optional spacing around the edges.
        -   top: The layout anchor on the top edge.
        -   left: The layout anchor on the left edge.
        -   bottom: The layout anchor on the bottom edge.
        -   right: The layout anchor on the right edge.
     */
    public func placeEdges(for targetView: UIView, padding: UIEdgeInsets = UIEdgeInsets.zero, top: NSLayoutYAxisAnchor, left: NSLayoutXAxisAnchor, bottom: NSLayoutYAxisAnchor, right: NSLayoutXAxisAnchor) {
        var layoutConstrains = HelperUILayout.ConstraintsContainer()
        
        targetView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutConstrains.top = targetView.topAnchor.constraint(equalTo: top, constant: padding.top)
        layoutConstrains.left = targetView.leftAnchor.constraint(equalTo: left, constant: padding.left)
        layoutConstrains.bottom = targetView.bottomAnchor.constraint(equalTo: bottom, constant: (-padding.bottom))
        layoutConstrains.right = targetView.rightAnchor.constraint(equalTo: right, constant: (-padding.right))
        
        [layoutConstrains.top, layoutConstrains.left, layoutConstrains.bottom, layoutConstrains.right].forEach {
            $0?.isActive = true
        }
    }

    /**
     External function to retrieve the app's render window.
     
     - Note:
     Check for legacy targer build (piror iOS 13). Retrieve app's render window from AppDelegate.swift instead of SceneDelegate.swift.
     
     - Parameters:
     */
    public func retrieveAppWindow() -> UIWindow {
        let appWindow: UIWindow
        if #available(iOS 13.0, *) {
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let window = sceneDelegate.window else {
                return UIWindow(frame: CGRect.zero)
            }
            
            appWindow = window
        } else {
            /* Fallback on earlier versions */
            guard let appDel = UIApplication.shared.delegate as? AppDelegate, let window = appDel.window else {
                return UIWindow(frame: CGRect.zero)
            }

            appWindow = window
        }
        
        return appWindow
    }
    
    /**
     External function to contruct formatted (atributed) text with atributions.
     
     - Note:
     
     - Parameters:
        -   rawText: The unformmated raw text string.
        -   alignment: Text alignment.
        -   indentation: Indentation value for the begining of the text.
        -   textFont: Font of the text.
        -   textColor: Color of the text.
     */
    public func formattedText(rawText text: String, alignment: HelperUILayout.TextAlignment, indentation: CGFloat, textFont: UIFont, textColor: UIColor) -> NSAttributedString {
        
        let style = NSMutableParagraphStyle()
        
        switch alignment {
        case HelperUILayout.TextAlignment.left:
            style.alignment = NSTextAlignment.left
        case HelperUILayout.TextAlignment.center:
            style.alignment = NSTextAlignment.center
        case HelperUILayout.TextAlignment.right:
            style.alignment = NSTextAlignment.right
        }
        
        style.firstLineHeadIndent = indentation
        style.headIndent = indentation
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let textSettings: [NSAttributedString.Key: Any] = [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.font: textFont, NSAttributedString.Key.foregroundColor: textColor]
        
        let attributedString = NSAttributedString(string: text, attributes: textSettings)
        
        return attributedString
    }
    
    /**
     External function to estimate a view's size that suitable for rendering the given text.
     
     - Note:
     
     - Parameters:
        -   rawText: The raw text string.
        -   font: Font of the text.
        -   width: Optional width constrain, estimalte height for given width.
        -   height: Optional height constrain, estimalte width for given height.
     */
    public func estimateTextFrame(rawText text: String, font: UIFont, width: CGFloat?, height: CGFloat?) -> CGRect {
        let fittingLabel: UILabel
        
        if let width = width {
            fittingLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: CGFloat(MAXFLOAT))))
        } else if let height = height {
            fittingLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(MAXFLOAT), height: height)))
        } else {
            return CGRect.zero
        }
        
        fittingLabel.numberOfLines = 0
        fittingLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        fittingLabel.font = font
        fittingLabel.text = text
        fittingLabel.sizeToFit()
        
        fittingLabel.frame.size.width += 20
        fittingLabel.frame.size.height += 20
        
        return fittingLabel.frame
    }
}

/**
 HelperPersistenceManager (Deliverable mock demo)
 
 - Note:
 Helper module for persistent storage with Swift's CoreData.
 
 - Requires:
 
 - Author:
 EisenWolf Studio
 
 - Copyright: Copyright ©
 HelperPersistenceManager
 by EisenWolf Studio
 */
final class HelperPersistence {
    /* ---------------------------- Initializer ----------------------------- */
    private init() { }
    
    /* -------------------------- Internal Access --------------------------- */
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DeliverableDatabase")
        container.loadPersistentStores(completionHandler: { (persistanceDescription, persistanceError) in
            if persistanceError != nil {
                assert(false, "<HelperPersistenceManager> Persistance error: \(persistanceError ?? "nil" as! Error)")
            }
        })
        
        return container
    }()
    
    /* -------------------------- External Access --------------------------- */
    public static let manager = HelperPersistence()
    
    /**
     External function to retrieve the viewContext from CoreData.
     
     - Note:
     
     - Parameters:
     */
    public func retreiveCoreDataContext() -> NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    /**
     External function to let persistence to save.
     
     - Note:
     CoreData saving error usually caused by mismatched xcdatamodel name.
     
     - Parameters:
     */
    public func saveCoreData() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let savingError {
                debugPrint("<HelperPersistenceManager> Saving error \(savingError)")
                return
            }
        }
        
        context.processPendingChanges()
    }
    
    /**
     External function to let persistence to fetch the given object.
     
     - Note:
     CoreData fetching error usually caused by mismatched xcdatamodel name.
     
     - Parameters:
        -   fetchRequest: The CoreData fetch request of the object.
     */
    public func fetchCoreData<T>(fetchRequest request: NSFetchRequest<T>) -> [T] {
        let fetchedData: [T]
        do {
            fetchedData = try self.persistentContainer.viewContext.fetch(request)
        } catch let fetchingError {
            assert(false, "<HelperPersistenceManager> No Data Found \(fetchingError)")
            fatalError()
        }
        
        return fetchedData
    }
    
    /**
     External function to let persistence to delete the given object.
     
     - Note:
     
     - Parameters:
        -   deletionEntry: The object that will be removed from CoreData persistence.
     */
    public func deleteCoreData(deletionEntry entry: NSManagedObject) {
        let context = persistentContainer.viewContext
        
        context.delete(entry)
        
        self.saveCoreData()
    }
}
