//
//  CocktailDetailViewController.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/20/21.
//

import UIKit

class CocktailDetailsViewController: UIViewController {
    
    @IBOutlet weak var cocktailNameLabel: UILabel!
    
    var cocktailName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cocktailNameLabel.text = cocktailName

        // Do any additional setup after loading the view.
    }
    
    class var identifier: String { return "CocktailDetailsViewController" }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
