//
//  FirestoreController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/27/21.
//

import Foundation
import FirebaseFirestore

class FirestoreController {
    
    let db = Firestore.firestore()
    var destinationArray: [Destination] = []
    
    func fetchData(completion: @escaping () -> Void) {
        db.collection("destinations").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        guard let destination = Destination(dictionary: data) else { continue }
                        self.destinationArray.append(destination)
                        
                    }
                    // Once complete, puts me on the main thread when complete.
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }
    }
}
