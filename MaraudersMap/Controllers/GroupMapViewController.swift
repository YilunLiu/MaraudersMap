//
//  GroupMapViewController.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 1/6/16.
//  Copyright © 2016 Robocat. All rights reserved.
//

import UIKit
import MapKit
import CocoaLumberjackSwift

class GroupMapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    deinit{
        DDLogDebug("GroupMapViewController is being dealloced.")
    }
    
    var group: Group!
    var userLocationViewModels = [String: UserLocationViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabbarController = self.tabBarController as! GroupTabBarController
        self.group = tabbarController.group
        
        for member in group.members{
            userLocationViewModels[member.objectId!] = UserLocationViewModel(user: member)
        }
        self.tableView.reloadData()
        
        for (_, viewModel) in self.userLocationViewModels{
            if let annotation = viewModel.mapAnnotation.value{
                mapView.addAnnotation(annotation)
            } else {
                viewModel.mapAnnotation.producer.startWithNext{
                    [weak self] annotation in
                    if annotation != nil{
                        self?.mapView.addAnnotation(annotation!)
                    }
                }
            }
        }
        
        // Zoom to fit all annotations
        let mapEdgePadding = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        var zoomRect:MKMapRect = MKMapRectNull
        
        for annotation in mapView.annotations{
            let aPoint:MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
            let rect:MKMapRect = MKMapRectMake(aPoint.x, aPoint.y, 0.2, 0.2)
            
            if MKMapRectIsNull(zoomRect) {
                zoomRect = rect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect)
            }
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.group.members.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendLocationCell", forIndexPath: indexPath)
        let member = self.group.members[indexPath.row]
        cell.textLabel?.text = member.nickName
        cell.backgroundColor = userLocationViewModels[member.objectId!]!.color.value
        return cell
    }
    
    // MARK: - TableView Delegate
    
    
    // MARK: - MKMapVieDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = annotation as! UserLocationAnnotation
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("Annotation") as? MKPinAnnotationView
        if view == nil{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        }
        view?.pinTintColor = self.userLocationViewModels[annotation.userId]!.color.value
        return view
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Target & Action
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.tabBarController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
