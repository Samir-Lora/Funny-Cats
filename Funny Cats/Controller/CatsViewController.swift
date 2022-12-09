//
//  CatsViewController.swift
//  Funny Cats
//
//  Created by Samir on 7/12/22.
//

import UIKit

class CatsViewController: UIViewController {

    @IBOutlet weak var catsTable: UITableView!
    
    var allCats: Cats? = Cats(allCats: [Cat(url: "", id: "")])
    var catsInfo = CatsInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        catsInfo.delegate = self
        catsInfo.getInfo(completionHandler: catsInfoHandler)
        self.catsTable.dataSource = self
        self.catsTable.delegate = self
    
    }
    
    func catsInfoHandler(cats: Cats?) {
        print("All cats are:", cats!.allCats.count)
        self.catsInfo.parseJSONToImage(cats: cats!, completionHandler: self.catsImageHandler)
    }
    
    func catsImageHandler(cats: Cats?) {
        DispatchQueue.main.async {
            
            print("Cats amount of images are:", cats!.allImages.count)
            self.allCats?.allImages = cats!.allImages
            self.allCats?.allCats = cats!.allCats
            self.catsTable.reloadData()
        }
    }
    

}

extension CatsViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print((allCats?.allImages.count)!)
        return (allCats?.allImages.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatsCell") as! CatsTableViewCell
        cell.catsImage.image = allCats?.allImages[indexPath.row]
        cell.catsLabel.text = "Cat ID is: \(allCats?.allCats[indexPath.row].id ?? "No ID")"
        return cell

    }
    
}

extension CatsViewController: CatsManagerDelegate {
    func didUpdateCatsInfo(catsInfo: Cats) {
        DispatchQueue.main.async {
            let cell = self.catsTable.dequeueReusableCell(withIdentifier: "CatsCell") as! CatsTableViewCell
            cell.catsLabel.text = catsInfo.allCats[0].url
            self.catsTable.reloadData()
        }
    }

}


