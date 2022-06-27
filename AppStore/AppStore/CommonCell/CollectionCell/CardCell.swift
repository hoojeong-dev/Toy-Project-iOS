import UIKit

class CardCell: UICollectionViewCell {

    @IBOutlet weak var tvTag: UILabel!
    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var tvDescription: UILabel!
    
    @IBOutlet weak var ivBack: UIImageView!
    
    @IBOutlet weak var appView: UIView!
    @IBOutlet weak var ivAppIcon: UIImageView!
    @IBOutlet weak var tvAppTitle: UILabel!
    @IBOutlet weak var tvAppProduce: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var tvDownloadDescription: UILabel!
    
    static var height: CGFloat { 310.0 }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        configureCell()
    }
    
    private func configureCell() {
        
        tvTag.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        tvTag.textColor = .systemBlue
        
        tvTitle.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        //tvTitle.textColor = .default
        
        tvDescription.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        tvDescription.textColor = .gray
        
        ivBack.backgroundColor = .green
        ivBack.layer.cornerRadius = 4
        
        appView.layer.cornerRadius = 4
        
        ivAppIcon.layer.cornerRadius = 8
        
        tvAppTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        //tvAppTitle.textColor = .black
        
        tvAppProduce.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        //tvAppProduce.textColor = .black
        
        btnDownload.layer.cornerRadius = 16
        btnDownload.backgroundColor = .systemGray
        btnDownload.layer.opacity = 0.8
        btnDownload.setTitle("받기", for: .normal)
        btnDownload.setTitleColor(.white, for: .normal)
        
        tvDownloadDescription.text = "앱 내 구입"
        tvDownloadDescription.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        //tvDownloadDescription.textColor = .black
        
        //if view?.backgroundColor == UIColor(named: .black)
    }

    func setCell(card: Card) {
        tvTag.text = card.tag
        tvTitle.text = card.title
        //tvDescription.text = card.description
        
        ivBack.image = UIImage(named: card.imageBack)
        
        ivAppIcon.image = UIImage(named: card.appIcon)
        tvAppTitle.text = card.appTitle
        tvAppProduce.text = card.appProduce
        
        if card.isPurchase{
            tvDownloadDescription.isHidden = false
        } else {
            tvDownloadDescription.isHidden = true
        }
    }
}
