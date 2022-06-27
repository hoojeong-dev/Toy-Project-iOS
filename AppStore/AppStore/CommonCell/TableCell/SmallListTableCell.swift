import UIKit

class SmallListTableCell: UITableViewCell {

    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = GameList().gameList
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureHeader()
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureHeader() {
        tvTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        tvTitle.text = data[0].header
        
        btnAll.backgroundColor = .clear
        btnAll.setTitle("모두보기", for: .normal)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SmallListCell", bundle: nil), forCellWithReuseIdentifier: "SmallListCell")
        
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
}

extension SmallListTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallListCell", for: indexPath) as? SmallListCell else { return UICollectionViewCell() }
        
        cell.setCell(game: data[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width), height: SmallListCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
