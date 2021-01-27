//
//  FlightDestinationViewController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/26/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class DestinationViewController: UIViewController {
    
    // MARK: - Properties -
    let standardPadding: CGFloat = 20
    let cellCornerRadius: CGFloat = 14
    
    private var destinationRef: CollectionReference!
    
    // MARK: - Computed Properties -
    let searchTextField = UITextField()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 250, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DefaultCollectionViewCell.self, forCellWithReuseIdentifier: DefaultCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
        
        navigationItem.title = "Destination"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func delegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configUI() {
        constraints()
        delegates()
    }
}

extension DestinationViewController {
    private func constraints() {
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 anchorLeading: standardPadding,
                                 anchorTrailing: -standardPadding)
        collectionView.setDimensions(width: view.frame.width, height: 248)
    }
}

extension DestinationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return network.destinationArray.count
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCollectionViewCell.identifier, for: indexPath) as! DefaultCollectionViewCell
//        let destination = network.destinationArray[indexPath.row]
        
//        cell.locationName.text = destination[0].locationCity
        
        cell.backgroundColor = .red
        cell.layer.cornerRadius = cellCornerRadius
        return cell
    }
}
