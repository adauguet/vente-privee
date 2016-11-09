//
//  ViewController.swift
//  VentePrivee
//
//  Created by Antoine DAUGUET on 31/10/2016.
//  Copyright © 2016 Antoine DAUGUET. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let dateComponents = DateComponents(year: 2016, month: 11, day: 8, hour: 18, minute: 18, second: 0)
    let operation = Operation(id: 60443, brand: "Calvin Klein")
    
    var result = (0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WebService.shared.send(route: Router.authenticate, completion: { [unowned self] in
            
            if let date = Calendar.current.date(from: self.dateComponents) {
                self.target(operation: self.operation, date: date)
            } else {
                self.add(operation: self.operation)
            }
            
        }) { error in print("Authentication error!", error) }
    }
    
    func loadOperations() {
        WebService.shared.load(resource: Operation.all, completion: { operations in
            if let operations = operations {
                for operation in operations {
                    print(operation.id, operation.brand)
                }
            }
        }) { error in print(error) }
    }
    
    func add(operation: Operation) {
        
        WebService.shared.load(resource: Universe.root(operation: operation), completion: { universe in
            
            guard let universe = universe else { return print("Empty universe") }
            
            WebService.shared.load(resource: Family.all(universe: universe), completion: { [unowned self] families in
                
                guard let families = families else { return print("Empty families") }
                
                let group = DispatchGroup()
                self.result = (0, 0)
                
                for family in families {
                    for product in family.products {
                        self.result.1 += 1
                        group.enter()
                        WebService.shared.send(route: Router.add(family: family, product: product, quantity: 1), completion: { [unowned self] in
                            self.result.0 += 1
                            group.leave()
                        }) { error in
                            print(error)
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    print("\(self.result.0) / \(self.result.1) successful requests")
                }
                
            }) { error in print(error) }
            
        }) { error in print(error) }
    }
    
    func target(operation: Operation, date: Date) {
        let timer = Timer(fire: date, interval: 0, repeats: false) { _ in
            self.add(operation: operation)
        }
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
    }
}
