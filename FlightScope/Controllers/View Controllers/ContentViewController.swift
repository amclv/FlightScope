//
//  ContentViewController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/28/21.
//

import UIKit
import MapKit

class ContentViewController: UIViewController {
    
    let destVC = DestinationViewController()
    
    // MARK: - Properties -
    var destination: Destination? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Computer Properties -
    let redView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    let greenView: UIView = {
        let v = UIView()
        v.backgroundColor = .green
        return v
    }()
    
    let blueView: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        return v
    }()
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        return v
    }()
    
    let contentView = UIView()
    
    lazy var panelLocation: UILabel = {
        let label = UILabel()
        label.textColor = .customColor(.black)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var panelImageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let cameraDetails: UITextView = {
        let camera = UITextView()
        camera.isEditable = false
        camera.backgroundColor = .customColor(.green)
        camera.font = .systemFont(ofSize: 16.0, weight: .light)
        camera.textColor = .customColor(.white)
        return camera
    }()
    
    lazy var mapView = MKMapView()
    
    let placesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Nearby Places", for: .normal)
        button.addTarget(self, action: #selector(placesButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customColor(.green)
        configUI()
        constraints()
        delegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let destination = destination,
              let lat = Double("\(destination.locationLatitude ?? "")"),
              let long = Double("\(destination.locationLongitude ?? "")"),
              let name = destination.locationName else { return }
        
        locationToMap(locationName: name, location: CLLocationCoordinate2D(latitude: lat, longitude: long))
    }
    
    func configUI() {
        configMapView()
    }
    
    func configMapView() {
        mapView.mapType = MKMapType.standard
        mapView.layer.cornerRadius = 10
    }
    
    // MARK: - Helper Functions -
    func delegates() {
        cameraDetails.delegate = self
        scrollView.delegate = self
        mapView.delegate = self
    }
    
    func updateUI() {
        guard let destination = destination,
              let urlString = destination.downloadLink,
              let url = URL(string: urlString) else { return }
        
        panelImageView.loadImageWithUrl(url)
        panelLocation.text = "\(destination.locationName ?? "Unknown Name")"
        cameraDetails.text =
            """
            Camera Details:

                Make: \(destination.exifMake ?? "No Camera")
                Model: \(destination.exifModel ?? "No Camera")
                ISO: \(destination.exifIso ?? "No ISO")
                Focal Length: \(destination.exifFocalLength ?? "No Focal")
                Exposure Time: \(destination.exifExposureTime ?? "No Exposure")
                Aperture: \(destination.exifAperture ?? "No Aperture")
            """
    }
    
    func locationToMap(locationName: String, location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = locationName
        annotation.subtitle = "SUBTITLE"
        let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
        
        //            let regionDistance: CLLocationDistance = 10000
        //            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        //            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        //            let options = [
        //                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
        //                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        //            ]
        //            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        //            var mapItem = MKMapItem(placemark: placemark)
        //            mapItem.name = "\(destination.locationName)"
    }
    
    @objc func placesButtonAction() {
        print("This is a test to me!")
    }
    
}

extension ContentViewController {
    func constraints() {
        self.view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor,
                          bottom: view.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
        // add three views to the scroll view
        scrollView.addSubview(panelImageView)
        panelImageView.anchor(top: scrollView.topAnchor,
                              leading: scrollView.leadingAnchor,
                              trailing: scrollView.trailingAnchor,
                              paddingTop: 0)
        panelImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        panelImageView.heightAnchor.constraint(equalToConstant: UIScreen.screenHeight / 2).isActive = true
        
        scrollView.addSubview(panelLocation)
        panelLocation.anchor(top: panelImageView.bottomAnchor,
                             leading: scrollView.leadingAnchor,
                             trailing: scrollView.trailingAnchor)
        
        scrollView.addSubview(cameraDetails)
        cameraDetails.anchor(top: panelLocation.bottomAnchor,
                             leading: scrollView.leadingAnchor,
                             trailing: scrollView.trailingAnchor)
        cameraDetails.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        cameraDetails.heightAnchor.constraint(equalToConstant: UIScreen.screenHeight / 2).isActive = true
        
        scrollView.addSubview(mapView)
        mapView.anchor(top: cameraDetails.bottomAnchor,
                       leading: scrollView.leadingAnchor,
                       trailing: scrollView.trailingAnchor)
        mapView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: UIScreen.screenHeight / 2).isActive = true
        
        scrollView.addSubview(greenView)
        greenView.anchor(top: mapView.bottomAnchor,
                         leading: scrollView.leadingAnchor,
                         trailing: scrollView.trailingAnchor,
                         paddingTop: 20.0)
        greenView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        greenView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        scrollView.addSubview(blueView)
        blueView.anchor(top: greenView.bottomAnchor,
                        bottom: scrollView.bottomAnchor,
                        leading: scrollView.leadingAnchor,
                        trailing: scrollView.trailingAnchor)
        blueView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        blueView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
}

extension ContentViewController: UITextViewDelegate {
    
}

extension ContentViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return panelImageView
    }
}

extension ContentViewController: MKMapViewDelegate {
    
}
