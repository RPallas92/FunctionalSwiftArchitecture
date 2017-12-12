//
//  DetailViewController.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/4/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import UIKit

class JokeDetailVC: UIViewController, JokeDetailView {
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var context:GetRandomJokeContext?
    var categoryName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDependencyGraph()
        configureView()
    }
    
    func setUpDependencyGraph() {
        if(self.context == nil) {
            self.context = GetRandomJokeContext(view: self)
        }
    }

    func configureView() {
        if let name = categoryName {
            getRandomJoke(categoryName: name).runT(context!, {_ in})
        }
    }
    
    func drawJoke(joke: JokeViewModel) {
        if let label = detailDescriptionLabel {
            label.text = joke.value
        }
    }
    
    func showGenericError() {
        //TODO
    }







}

