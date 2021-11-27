//
//  LocationManager.swift
//  GrownStrong
//
//  Created by Aman on 08/09/21.
//

import Foundation
import CoreLocation
import UIKit

@objc protocol LocationServiceDelegate {
  @objc optional
  func getAddressForLocation(locationAddress: String, currentAddress: [String:Any])
  @objc optional
  func tracingLocation(currentLocation: CLLocation)
  @objc optional
  func tracingLocationDidFailWithError(error: NSError)
}

class LocationService: NSObject, CLLocationManagerDelegate {
  
  static let sharedInstance : LocationService = {
    let instance = LocationService()
    return instance
  }()
  
  
  var locationManager: CLLocationManager?
  var currentLocation: CLLocation?
  var delegate: LocationServiceDelegate?
  var addressStr: String?
  var isLocateSuccess = false
  var current: CLLocationCoordinate2D?

  override init() {
    super.init()
    
    self.locationManager = CLLocationManager()
    guard let locationManager = self.locationManager else {
      return
    }
    locationManager.requestAlwaysAuthorization()
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
    locationManager.delegate = self
    
  }
  
  func startUpdatingLocation() {
    isLocateSuccess = false
    
    if CLLocationManager.locationServicesEnabled() {
      switch CLLocationManager.authorizationStatus() {
      case .notDetermined, .restricted, .denied:
        print("No access")
//        displayALertWithTitles(title: AppDefaultNames.name, message: "Need location", ["Cancel","Settings"]) { (index) in
//            if index == 1{
//                guard let appSettingURl = URL(string: UIApplication.openSettingsURLString) else { return }
//                   if UIApplication.shared.canOpenURL(appSettingURl) {
//                       UIApplication.shared.open(appSettingURl, options: [:], completionHandler: nil)
//                   }
//            }
//        }
        
      case .authorizedAlways, .authorizedWhenInUse:
        print("Access")
        print("Starting Location Updates")

        self.locationManager?.startUpdatingLocation()
      
        
       // fatalError()
      @unknown default:
        //
        break
        
        }
    } else {
      self.locationManager?.requestAlwaysAuthorization()

      print("Location services are not enabled")
    }
  }
  
  func stopUpdatingLocation() {
    print("Stop Location Updates")
    self.locationManager?.stopUpdatingLocation()
  }
  
  
  // CLLocationManagerDelegate
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("Location: didUpdate")
    
    guard let location = locations.last else {
      return
    }
    print("Location: didUpdate 2")
    if isLocateSuccess == false{
      self.currentLocation = location
        getAdressName(coords: location)
        stopUpdatingLocation()
        print ("Location: didUpdate is ",location)
      isLocateSuccess = true
    }
  }
  
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // do on error
    print("Location: didFailWithError")
    updateLocationDidFailWithError(error: error as NSError)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == CLAuthorizationStatus.authorizedAlways{
      print("access")
      locationManager?.startUpdatingLocation()
      
    }else if status == CLAuthorizationStatus.denied {
     print("denied")

    }
    else if status == CLAuthorizationStatus.authorizedWhenInUse{
      locationManager?.startUpdatingLocation()
      print("access")
    }else{
        print("need authorization")
      locationManager?.requestAlwaysAuthorization()
    }
    
  }
  
  func getAdressName(coords: CLLocation) {
    
    self.current = coords.coordinate
    
    CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
      if error != nil {
        print("Hay un error")
      } else {
        //                self.stopUpdatingLocation()
        var currentAddress = [String: Any]()
        let place = placemark! as [CLPlacemark]
        if place.count > 0 {
          let place = placemark![0]
          var adressString : String = ""
          
          if place.thoroughfare != nil {
            adressString = adressString + place.thoroughfare! + ", "
            currentAddress["street"] = place.thoroughfare!
          }
          if place.subThoroughfare != nil {
            adressString = adressString + place.subThoroughfare! + "\n"
            currentAddress["street_number"] = place.subThoroughfare!
          }
          if place.locality != nil {
            adressString = adressString + place.locality! + " - "
            currentAddress["region"] = place.locality!
          }
          if place.postalCode != nil {
            adressString = adressString + place.postalCode! + "\n"
            currentAddress["tk"] = place.postalCode!
          }
          if place.subAdministrativeArea != nil {
            adressString = adressString + place.subAdministrativeArea! + " - "
          }
          if place.country != nil {
            adressString = adressString + place.country!
            currentAddress["country"] = place.country!
            
          }
          if place.location?.coordinate != nil {
            let lat = place.location!.coordinate.latitude
            print(lat)
            currentAddress["lat"] = String(describing: place.location!.coordinate.latitude)
            currentAddress["long"] = String(describing: place.location!.coordinate.longitude)
          }
          
          self.stopUpdatingLocation()
          self.delegate?.getAddressForLocation!(locationAddress: adressString, currentAddress: currentAddress)
          self.addressStr = adressString
        }
      }
    }
  }
  
  // Private function
  private func updateLocation(currentLocation: CLLocation){
    print("Location: updateLocation")
    
    guard let delegate = self.delegate else {
      return
    }
    print("Location: updateLocation 2")
    print ("Location: updateLocation is ",currentLocation)
//     delegate.tracingLocation!(currentLocation: currentLocation)
  }
  
  private func updateLocationDidFailWithError(error: NSError) {
    print("Location: updateLocationDidFailWithError")
    
    guard let delegate = self.delegate else {
      return
    }
    print("Location: updateLocationDidFailWithError 2")

    delegate.tracingLocationDidFailWithError!(error: error)
  }
}
