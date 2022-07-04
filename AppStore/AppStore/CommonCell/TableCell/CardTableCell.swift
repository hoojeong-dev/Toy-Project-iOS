import UIKit

class CardTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = CardList().cardList
    var currentIndex: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "CardCell")
        
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if let collectionView = scrollView as? UICollectionView {
            let cellWidth = (UIScreen.main.bounds.width) - 22
            
            var offset = targetContentOffset.pointee
            let index = round((offset.x + collectionView.contentInset.left) / cellWidth)
            
            if index > currentIndex {
                currentIndex += 1
            } else if index < currentIndex {
                currentIndex -= 1
            }
            
            offset = CGPoint(x: currentIndex * cellWidth - collectionView.contentInset.left, y: 0)
            
            targetContentOffset.pointee = offset
        }
    }
}

extension CardTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else { return UICollectionViewCell() }
        
        cell.setCell(card: data[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) - 32, height: CardCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 18, right: 16)
    }
}
