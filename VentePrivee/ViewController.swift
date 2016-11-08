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

    var result = (0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dateComponents = DateComponents(year: 2016, month: 11, day: 8, hour: 18, minute: 18, second: 0)
        let operation = Operation(id: 60443, brand: "Calvin Klein")
        
        WebService.shared.send(route: Router.authenticate) { [unowned self] in
            
//            if let date = Calendar.current.date(from: dateComponents) {
//                let target = Target(operation: operation, date: date)
//                self.addAll(target: target)
//            }
            
//            WebService.shared.load(resource: Operation.all) { operations in
//                if let operations = operations {
//                    for operation in operations {
//                        print(operation.id, operation.brand)
//                    }
//                }
//            }
            
            self.addAll(operation: operation)
        }
    }
    
    func addAll(operation: Operation) {
        WebService.shared.load(resource: Universe.root(operation: operation)) { universe in
            if let universe = universe {
                WebService.shared.load(resource: Family.all(universe: universe)) { [unowned self] families in
                    if let families = families {
                        let group = DispatchGroup()
                        self.result = (0, 0)

                        for family in families {
                            for product in family.products {
                                self.result.1 += 1
                                group.enter()
                                WebService.shared.send(route: Router.add(family: family, product: product, quantity: 1)) { [unowned self] in
                                    self.result.0 += 1
                                    group.leave()
                                }
                            }
                        }
                        
                        group.notify(queue: DispatchQueue.main) {
                            print("\(self.result.0) / \(self.result.1) successful requests")
                        }
                    } else { print("Empty families") }
                }
            } else { print("Empty universe") }
        }
    }
    
    func addAll(target: Target) {
        let timer = Timer(fire: target.date, interval: 0, repeats: false) { _ in
            self.addAll(operation: target.operation)
        }
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
    }
}
