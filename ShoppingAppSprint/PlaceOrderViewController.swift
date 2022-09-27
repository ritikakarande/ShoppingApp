//
//  PlaceOrderViewController.swift
//  ShoppingAppSprint
//
//  Created by Capgemini-DA087 on 9/27/22.
//

import UIKit
import MapKit
import CoreLocation
class PlaceOrderViewController: UIViewController,  CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var orderNowButton: UIButton!
    @IBOutlet weak var addressMapView: MKMapView!
    var locationmanager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderNowButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        determineUserLocation()
    }
    // Location Manager Attributes
    func determineUserLocation() {
        locationmanager = CLLocationManager()
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationmanager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let mUserLoc: CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLoc.coordinate.latitude, longitude: mUserLoc.coordinate.longitude)
        
        // Setting coordinate boundary to be displayed in map
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLoc.coordinate.latitude, mUserLoc.coordinate.longitude)
        getAddress{(address) in
            mkAnnotation.title = address
        }
        
        //Setting region in map
        addressMapView.setRegion(mRegion, animated: true)
        
        // Adding annotation
        addressMapView.addAnnotation(mkAnnotation)
    
    // Function to drop pin and display address
    func getAddress(handler: @escaping (String) -> Void) {

        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: mUserLoc.coordinate.latitude, longitude: mUserLoc.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placemark: CLPlacemark?
            
            // Place details
            placemark = placemarks?[0]
                    
            // Address directory
            let address = "\(placemark?.subThoroughfare ?? ""), \(placemark?.thoroughfare ?? ""), \(placemark?.locality ?? ""), \(placemark?.subLocality ?? ""), \(placemark?.administrativeArea ?? ""), \(placemark?.postalCode ?? ""), \(placemark?.country ?? "")"
                    
            print("\(address)")
                
            handler(address)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }

    }

    // UIButton to call and send notification
    @IBAction func orderNowTapped(_ sender: Any) {
        let notificationCV = self.storyboard?.instantiateViewController(withIdentifier: "SendNotificationViewController") as! SendNotificationViewController
        self.navigationController?.pushViewController(notificationCV, animated: true)
    }
    

}
