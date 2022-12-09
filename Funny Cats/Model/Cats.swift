
import UIKit

struct Cat: Decodable {
    let url: String
    let id: String
}

struct Cats {
    var allCats: [Cat]
    var allImages: [UIImage?] = []
}
