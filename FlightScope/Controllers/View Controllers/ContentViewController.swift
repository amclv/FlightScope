//
//  ContentViewController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/28/21.
//

import UIKit
import MapKit

class ContentViewController: UIViewController, MKMapViewDelegate {
    
    let destVC = DestinationViewController()
    let networkManager = NetworkManager()
    
    // MARK: - Properties -
    var destination: Destination? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Computer Properties -
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = false
//        view.clipsToBounds = true
        return view
    }()
    
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
        imageView.setDimensions(width: UIScreen.screenWidth, height: UIScreen.screenWidth / 1.50)
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
    
    var mapView = MKMapView()
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customColor(.green)
        configUI()
        scrollView.fitSizeOfContent()
    }
    
    func configUI() {
        constraints()
        delegates()
        getPlaces()
        configMapView()
    }
    
    func configMapView() {
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: 300))
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

    }
    
    // MARK: - Helper Functions -
    func delegates() {
        cameraDetails.delegate = self
        scrollView.delegate = self
        mapView.delegate = self
    }
    
    func getPlaces() {
        guard let destinationCity = destination?.locationCity else { return }
        networkManager.fetchData(cityName: "\(destinationCity)") {
            return
        }
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
    
    func locationToMap() {
        guard let lat = Double("\(destination?.locationLatitude ?? "")"),
              let long = Double("\(destination?.locationLongitude ?? "")") else { return }
        
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Place Name"
        mapItem.openInMaps(launchOptions: options)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
}

extension ContentViewController {
    private func constraints() {
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor,
                          bottom: view.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
        scrollView.addSubview(panelImageView)
        panelImageView.anchor(top: scrollView.topAnchor,
                              leading: scrollView.leadingAnchor,
                              trailing: scrollView.trailingAnchor)
        
        scrollView.addSubview(panelLocation)
        panelLocation.anchor(top: panelImageView.bottomAnchor,
                             leading: scrollView.leadingAnchor,
                             trailing: scrollView.trailingAnchor,
                             paddingTop: standardPadding,
                             paddingLeading: standardPadding,
                             paddingTrailing: -standardPadding)
        
        scrollView.addSubview(cameraDetails)
        cameraDetails.anchor(top: panelLocation.bottomAnchor,
                             leading: scrollView.leadingAnchor,
                             trailing: scrollView.trailingAnchor,
                             paddingTop: standardPadding,
                             paddingLeading: standardPadding,
                             paddingTrailing: -standardPadding)
        cameraDetails.setDimensions(width: view.frame.width, height: 1000)
        
        scrollView.addSubview(mapView)
        mapView.anchor(top: cameraDetails.bottomAnchor,
                        leading: scrollView.leadingAnchor,
                        trailing: scrollView.trailingAnchor,
                        paddingLeading: standardPadding,
                        paddingTrailing: -standardPadding)
    }
}

extension ContentViewController: UITextViewDelegate {
    
}

extension ContentViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return panelImageView
    }
}
