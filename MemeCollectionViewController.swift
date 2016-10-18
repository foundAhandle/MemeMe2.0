import Foundation
import UIKit

// MARK: - MemeCollectionViewController: UICollectionViewController

class MemeCollectionViewController: UICollectionViewController {

//	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
	
    // MARK: Properties
    
	var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
	
    // MARK: Table View Data Source
    
    override func viewDidLoad() {
        super.viewDidLoad()
print("viewDidLoad: \(self.memes.count)")
/*
		let space: CGFloat = 3.0
		let dimension = (self.view.frame.size.width - (2 * space)) / 3.0


		flowLayout.minimumInteritemSpacing = space
		flowLayout.minimumLineSpacing = space
		flowLayout.itemSize = CGSizeMake(dimension, dimension)
*/    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
print("numberOfItemsInSection: \(self.memes.count)")
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath as IndexPath) as! MemeCollectionViewCell

        let meme = self.memes[indexPath.row]
print("cellForItemAtIndexPath: \(meme)")
        cell.memeImageView?.image = meme.composite
//    cell.setText(meme.top, bottomString: meme.bottom)        

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
/*
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController") as! VillainDetailViewController
        detailController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
*/        
    }
}
