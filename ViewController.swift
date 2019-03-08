//
//  ViewController.swift
//  Pen Drop
//
//  Created by Minh Hieu Vo on 3/7/19.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    var pins: [Pin] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func LongPress(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        addPin(at: coordinate)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        loadPins()
    }
    func addPin(at coordinate: CLLocationCoordinate2D) {
        let alert = UIAlertController(title: "New Pin", message: nil, preferredStyle: .alert )
        
        alert.addTextField { textField in
            textField.placeholder  = "Name"
    }
        alert.addTextField { textField in
            textField.placeholder = "Caption"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let textFields = alert.textFields else { return }
            let name = textFields[0].text ?? ""
            let caption = textFields[1].text ?? ""
            
            let pin = Pin(name: name, caption: caption, latitude: coordinate.latitude, longtitude: coordinate.longitude)
            
            self.add(pin: pin)
            self .mapView.addAnnotations(self.pins)
        }
        alert.addAction(saveAction)
        
        self.present(alert, animated: true)
    }

    func add(pin: Pin) {
        pins.append(pin)
        Pin.save(pins: pins)
}
    func loadPins() {
        if let pins = Pin.loadPins() {
            self.pins = pins
            mapView.addAnnotations((pins as! MKAnnotation) as! [MKAnnotation])
        }
    }
}

extension ViewController: MKMapViewDelegate {
   func mapView(_ mapView:MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       let identifier = "pins"
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView.annotation = annotation
            return annotationView
        }
        return nil 
    }
}
