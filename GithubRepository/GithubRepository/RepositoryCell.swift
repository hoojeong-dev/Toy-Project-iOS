import UIKit
import SnapKit


class RepositoryCell: UITableViewCell {
    
    var repository: String!
    
    /** Ropository */
    let tvTitle = UILabel()/** 타이틀 */
    let tvDescription = UILabel()/** 설명 */
    let ivStar = UIImageView()/** star 이미지 */
    let tvStar = UILabel()/** star 수 */
    let tvLanguage = UILabel()/** 언어 */
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /** view에 components 추가 */
        [
            tvTitle, tvDescription,
            ivStar, tvStar, tvLanguage
        ].forEach {
            contentView.addSubview($0)
        }
    }
}
