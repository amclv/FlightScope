//
//  FlightDestinationViewController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/26/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FloatingPanel

class DestinationViewController: UIViewController {
    
    let firestoreController = FirestoreController()
    
    // MARK: - Properties -
    let standardPadding: CGFloat = 20
    let cellCornerRadius: CGFloat = 20
    let standardSpacing: CGFloat = 8
    
    var panel: FloatingPanelController!
    
    // MARK: - Computer Properties -
    // Explore Section
    let travelCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DefaultCollectionViewCell.self, forCellWithReuseIdentifier: DefaultCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
        
        navigationItem.title = "Explore"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        firestoreController.fetchData {
            self.travelCollectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove the views managed by the `FloatingPanelController` object from self.view.
        panel.removeFromParent()
    }
    
    // MARK: - Functions -
    private func configUI() {
        constraints()
        delegates()
        setFloatingPanel()
    }
    
    private func delegates() {
        travelCollectionView.delegate = self
        travelCollectionView.dataSource = self
    }
    
    private func setFloatingPanel() {
        // Initialize a 'FloatingPanelController'
        panel = FloatingPanelController()
        // Assign self as the delegate of the controller
        panel.delegate = self
        // Setup PanelViewController
        let panelVC = PanelViewController()
        panel.set(contentViewController: panelVC)
        // Track a scroll view in the PanelViewController
        panel.track(scrollView: panelVC.scrollView)
        // Adds the views managed by the FloatingPanelController object to self
        panel.addPanel(toParent: self)
        // Adds a corner radius to the FloatingPanel view.
        panel.surfaceView.appearance.cornerRadius = cellCornerRadius
    }
    
    func addPanel() {
        // Add the floating panel view to the controller's view on top of other views.
        self.view.addSubview(panel.view)
        
        // REQUIRED. It makes the floating panel view have the same size as the controller's view.
        panel.view.frame = self.view.bounds
        
        // In addition, Auto Layout constraints are highly recommended.
        // Constraint the fpc.view to all four edges of your controller's view.
        // It makes the layout more robust on trait collection change.
        panel.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            panel.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
            panel.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
            panel.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
            panel.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        ])
        
        // Add the floating panel controller to the controller hierarchy.
        self.addChild(panel)
        
        // Show the floating panel at the initial position defined in your `FloatingPanelLayout` object.
        panel.show(animated: true) {
            // Inform the floating panel controller that the transition to the controller hierarchy has completed.
            self.panel.didMove(toParent: self)
        }
    }
    
    func removePanel() {
        // Inform the panel controller that it will be removed from the hierarchy.
        panel.willMove(toParent: nil)
        
        // Hide the floating panel.
        panel.hide(animated: true) { [self] in
            // Remove the floating panel view from your controller's view.
            panel.view.removeFromSuperview()
            // Remove the floating panel controller from the controller hierarchy.
            panel.removeFromParent()
        }
    }
    
    // MARK: - Actions -
}

// MARK: - DestinationViewController Extensions -
extension DestinationViewController {
    // MARK: - Constraints -
    private func constraints() {
        // Explore Constraints
        view.addSubview(travelCollectionView)
        travelCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                    bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                    leading: view.leadingAnchor,
                                    trailing: view.trailingAnchor,
                                    paddingTop: standardPadding,
                                    paddingBottom: standardSpacing + 50)
    }
}

// MARK: - DestinationViewController UICollectionView -
extension DestinationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return firestoreController.destinationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCollectionViewCell.identifier, for: indexPath) as! DefaultCollectionViewCell
        let destination = firestoreController.destinationArray[indexPath.item]
        
        guard let urlString = destination.downloadLink,
              let url = URL(string: urlString) else { return UICollectionViewCell() }
        
        cell.locationName.text = destination.locationCountry
        cell.locationImageView.loadImageWithUrl(url)
        cell.layer.cornerRadius = cellCornerRadius
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationArray = firestoreController.destinationArray[indexPath.item]
        let float = PanelViewController()
        
        float.destination = destinationArray
        panel.modalPresentationStyle = .popover
        panel.present(float, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: standardPadding, bottom: 0, right: standardPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: collectionView.frame.height)
    }
}

// MARK: - DestinationViewController FloatingPanelController Delegate -
extension DestinationViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelStocksLayout()
    }
    
    class FloatingPanelStocksLayout: FloatingPanelLayout {
        let position: FloatingPanelPosition = .bottom
        let initialState: FloatingPanelState = .tip
        
        let full: CGFloat = 0
        let half: CGFloat = 422
        let tip: CGFloat = 45.0
        
        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset: full, edge: .top, referenceGuide: .safeArea),
                .half: FloatingPanelLayoutAnchor(absoluteInset: half, edge: .bottom, referenceGuide: .superview),
                .tip: FloatingPanelLayoutAnchor(absoluteInset: tip, edge: .bottom, referenceGuide: .safeArea),
            ]
        }
        
        func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
            return 0.0
        }
    }
}
