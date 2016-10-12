//
//  MapVC.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 16/09/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, InventoryDelegate {
    
    var locManager = CLLocationManager()
    var visitedLocations = [CLLocationCoordinate2D]()
    var startLocation: CLLocation?
    var lastLocation: CLLocation?
    var currentQuest: QuestModel?
    
    var userInventory: [ShopItemModel] = []
    var itemCell = "itemCell"
    
    var additionalDamageByInventory = 0
    
    var userDistanceMeters: Double = 0.0 {
        didSet {
            let kilometersVersion = userDistanceMeters/1000
            let formattedVersion = String(format:"%.2f", kilometersVersion)
            distanceRanLabel.text = "Distance Ran: \(formattedVersion) kilometres"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        setupLocationManager()
    }
    
    func didSelectInventoryItem(item: ShopItemModel) {
        additionalDamageByInventory += item.damage!
    }
    
    // VIEW CREATION
    
    lazy var runningMap: MKMapView = {
        let runningMap = MKMapView()
        runningMap.delegate = self
        runningMap.translatesAutoresizingMaskIntoConstraints = false
        return runningMap
    }()
    
    let statusView: UIView = {
        let statusView = UIView()
        statusView.backgroundColor = .white
        statusView.translatesAutoresizingMaskIntoConstraints = false
        return statusView
    }()
    
    lazy var distanceRanLabel: UILabel = {
        let distanceRanLabel = UILabel()
        distanceRanLabel.textAlignment = .center
        distanceRanLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        distanceRanLabel.text = "Distance Ran: \(self.userDistanceMeters) kilometers"
        distanceRanLabel.translatesAutoresizingMaskIntoConstraints = false
        return distanceRanLabel
    }()
    
    lazy var endQuestButton: UIButton = {
        let startRunningButton = UIButton(type: .system)
        startRunningButton.setTitle("RETREAT", for: UIControlState())
        startRunningButton.backgroundColor = UIColor(red: 238/255, green: 81/255, blue: 81/255, alpha: 1)
        startRunningButton.setTitleColor(.black, for: UIControlState())
        startRunningButton.translatesAutoresizingMaskIntoConstraints = false
        startRunningButton.addTarget(self, action: #selector(handleEndQuest), for: .touchUpInside)
        startRunningButton.layer.cornerRadius = 5
        return startRunningButton
    }()
    
    lazy var openInventoryButton: UIButton = {
        let openInventoryButton = UIButton(type: .system)
        openInventoryButton.setTitle("OPEN INVENTORY", for: UIControlState())
        openInventoryButton.backgroundColor = .green
        openInventoryButton.setTitleColor(.black, for: UIControlState())
        openInventoryButton.translatesAutoresizingMaskIntoConstraints = false
        openInventoryButton.addTarget(self, action: #selector(openInventory), for: .touchUpInside)
        openInventoryButton.layer.cornerRadius = 5
        return openInventoryButton
    }()
    
    // LOCATION FUNCTIONS
    
    func setupLocationManager() {
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let centerCoord = CLLocationCoordinate2DMake((locations.last?.coordinate.latitude)!, (locations.last?.coordinate.longitude)!)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(centerCoord, span)
        runningMap.setRegion(region, animated: true)
        visitedLocations.append(centerCoord)
        
        if startLocation == nil {
            startLocation = locations.first
        }
        else {
            if let lastLocation = locations.last {
                if let distance = startLocation?.distance(from: lastLocation) {
                    userDistanceMeters = distance
                }
            }
        }
        lastLocation = locations.last
        updateRoute(visitedLocations)
    }
    
    func updateRoute(_ newCoordinates: [CLLocationCoordinate2D]) {
        var newCoordinates = newCoordinates
        runningMap.removeOverlays(runningMap.overlays)
        let route = MKPolyline(coordinates: &newCoordinates, count: visitedLocations.count)
        runningMap.add(route)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.blue
            pr.lineWidth = 10
            return pr
        }
        
        return MKOverlayRenderer()
    }
    
    // HANDLING END OF QUEST
    
    func handleEndQuest() {
        locManager.stopUpdatingLocation()
        visitedLocations.removeAll()
        startLocation = nil
        lastLocation = nil
        APIService.sharedInstance.performRegionAttack(region: (currentQuest?.region!)!, kms: Int(userDistanceMeters/1000)+additionalDamageByInventory) { (success) in
            if success == true {
                let vc = PopupVC()
                vc.modalPresentationStyle = .overCurrentContext
                vc.mapVCRef = self
                print("additionalDamageByInventory = \(self.additionalDamageByInventory)")
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func openInventory() {
        let vc = InventoryVC()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    // DISPLAY OTHER SCREENS FUNCTIONS
    
    func displayStatusPage() {
        let vc = StatusVC()
        vc.distanceTravelled = userDistanceMeters
        userDistanceMeters = 0.0
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // VIEW & CONSTRAINT SETUP
    
    func setupViews() {
        view.addSubview(runningMap)
        view.addSubview(statusView)
        statusView.addSubview(distanceRanLabel)
        view.addSubview(endQuestButton)
        view.addSubview(openInventoryButton)
    }
    
    func setupConstraints() {
        runningMap.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runningMap.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        runningMap.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        runningMap.bottomAnchor.constraint(equalTo: statusView.topAnchor).isActive = true
        
        statusView.bottomAnchor.constraint(equalTo: endQuestButton.topAnchor).isActive = true
        statusView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statusView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        distanceRanLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor).isActive = true
        distanceRanLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor).isActive = true
        distanceRanLabel.widthAnchor.constraint(equalTo: statusView.widthAnchor).isActive = true
        distanceRanLabel.heightAnchor.constraint(equalTo: statusView.heightAnchor).isActive = true
        
        endQuestButton.bottomAnchor.constraint(equalTo: openInventoryButton.topAnchor).isActive = true
        endQuestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        endQuestButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        endQuestButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        openInventoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        openInventoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openInventoryButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        openInventoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
}
