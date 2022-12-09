

import UIKit

protocol CatsManagerDelegate {
    func didUpdateCatsInfo(catsInfo: Cats)
}

struct CatsInfo {
    
    let url = "https://api.thecatapi.com/v1/images/search?limit=20"
    let apikey = "live_VdvovbsTfiT7j4x7jWbieipSw093zArb8YqmDWkefwWhB3jm2zMS1muvFgp9FByt"
    
    var delegate: CatsManagerDelegate?
    
    let decoder = JSONDecoder()
    
    func getInfo(completionHandler: @escaping (Cats?) -> Void) {
        let url = URL(string: url)
        var request = URLRequest(url: url!)
        request.setValue(apikey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, responde, error in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let data = data {
                    let decodedCats = parseJSON(cats: data)
                    completionHandler(decodedCats)
                }
            }
   
        }.resume()
        
    }
    
    
    func parseJSON(cats: Data) -> Cats? {
        do {
            let decodedData = try decoder.decode([Cat].self, from: cats)
            let catsInfo = Cats(allCats: decodedData)
            return catsInfo

        } catch {
        
            print(error)
            return nil
        
        }
    }
    
    func parseJSONToImage(cats: Cats, completionHandler: @escaping (Cats?) -> Void) {
        var catsDecoded = cats
        for (index, cat) in cats.allCats.enumerated() {
            let url = URL(string: cat.url)
            let request = URLRequest(url: url!)
            
            URLSession.shared.dataTask(with: request) { data, responde, error in
                
                if error != nil {
                    print(error!)
                    return
                }
    
                if let data = data {
                   let catImage = UIImage(data: data)
                   catsDecoded.allImages.append(catImage)
                }

                if cats.allCats.count == index+1 {
                    completionHandler(catsDecoded)
                }
                
            }.resume()
        }
    }
}
