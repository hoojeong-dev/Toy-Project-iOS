import UIKit

class SmallListCell: UICollectionViewCell {

    @IBOutlet weak var ivAppIcon: UIImageView!
    @IBOutlet weak var tvAppRank: UILabel!
    @IBOutlet weak var tvAppTitle: UILabel!
    @IBOutlet weak var tvAppDescription: UILabel!
    @IBOutlet weak var tvDownloadDescription: UILabel!
    
    @IBOutlet weak var btnDownload: UIButton!
    
    static var height: CGFloat { 70.0 }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCell()
    }

    private func configureCell() {
        
        ivAppIcon.layer.cornerRadius = 12
        
        tvAppRank.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        //tvAppRank.textColor = .black
        
        tvAppTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        //tvAppTitle.textColor = .black
        
        tvAppDescription.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        tvAppDescription.textColor = .lightGray
        
        btnDownload.layer.cornerRadius = 12
        btnDownload.backgroundColor = .lightGray
        btnDownload.layer.opacity = 0.8
        btnDownload.setTitle("받기", for: .normal)
        btnDownload.setTitleColor(.systemBlue, for: .normal)
        
        tvDownloadDescription.text = "앱 내 구입"
        tvDownloadDescription.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        tvDownloadDescription.textColor = .lightGray
    }
    
    func setCell(game: Game) {
        ivAppIcon.image = UIImage(named: game.appIcon)
        tvAppRank.text = game.appRank
        tvAppTitle.text = game.appTitle
        tvAppDescription.text = game.appDescription
        
        if game.isPurchase{
            tvDownloadDescription.isHidden = false
        } else {
            tvDownloadDescription.isHidden = true
        }
    }
}
