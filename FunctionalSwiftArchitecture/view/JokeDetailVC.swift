//
//  DetailViewController.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/4/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import UIKit
import ArchitectureKit

class JokeDetailVC: UIViewController, JokeDetailView {
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var randomJokeButton: UIButton!
    
    var context:GetRandomJokeContext?
    var categoryName: String?
    
    //System Actions
    let loadJokeSystemAction = JokeCustomAction(trigger: JokeEvent.loadJoke)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDependencyGraph()
        configureView()
        self.loadJokeSystemAction.execute()
    }
    
    func setUpDependencyGraph() {
        if self.context == nil {
            self.context = GetRandomJokeContext(view: self)
        }
    }

   func configureView() {
        if let name = categoryName {
            onJokeViewLoaded(context: self.context!, withCategoryName: name, withActions: getUserActions() + getSystemActions())
        }
    }
    
    func getUserActions() -> [JokeAction] {
        return [
            JokeUIButtonAction.onTap(in: randomJokeButton, trigger: JokeEvent.loadJoke)
        ]
    }
    
    func getSystemActions() -> [JokeAction] {
        return [
            self.loadJokeSystemAction
        ]
    }
    
    func drawJoke(joke: JokeViewModel) {
        if let label = detailDescriptionLabel {
            label.text = joke.value
        }
    }
    
    func showGenericError() {
        let alert = UIAlertController(title: "Error", message: "Error, please try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

