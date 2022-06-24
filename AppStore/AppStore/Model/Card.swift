import UIKit

struct Card{
    var tag: String
    var title: String
    var description: String
    var imageBack: String
    var appIcon: String
    var appTitle: String
    var appProduce: String
    var isPurchase: Bool
}

struct CardList {
    var cardList = [
        Card(tag: "지금 참여 가능", title: "쿠키런: 킹덤", description: "우아한 오이스터맛 쿠키 등장", imageBack: "icBack", appIcon: "icApp", appTitle: "쿠키런: 킹덤", appProduce: "귀족 중의 귀족, 오이스터맛 쿠키", isPurchase: true),
        Card(tag: "지금 참여 가능", title: "쿠키런: 킹덤", description: "우아한 오이스터맛 쿠키 등장", imageBack: "icBack", appIcon: "icApp", appTitle: "쿠키런: 킹덤", appProduce: "귀족 중의 귀족, 오이스터맛 쿠키", isPurchase: true),
        Card(tag: "지금 참여 가능", title: "쿠키런: 킹덤", description: "우아한 오이스터맛 쿠키 등장", imageBack: "icBack", appIcon: "icApp", appTitle: "쿠키런: 킹덤", appProduce: "귀족 중의 귀족, 오이스터맛 쿠키", isPurchase: true),
        Card(tag: "지금 참여 가능", title: "쿠키런: 킹덤", description: "우아한 오이스터맛 쿠키 등장", imageBack: "icBack", appIcon: "icApp", appTitle: "쿠키런: 킹덤", appProduce: "귀족 중의 귀족, 오이스터맛 쿠키", isPurchase: true),
        Card(tag: "지금 참여 가능", title: "쿠키런: 킹덤", description: "우아한 오이스터맛 쿠키 등장", imageBack: "icBack", appIcon: "icApp", appTitle: "쿠키런: 킹덤", appProduce: "귀족 중의 귀족, 오이스터맛 쿠키", isPurchase: true)
    ]
}
