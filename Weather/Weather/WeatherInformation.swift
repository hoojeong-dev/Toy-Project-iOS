//
//  WeatherInformation.swift
//  Weather
//
//  Created by 김후정 on 2022/03/31.
//

import Foundation

// https://openweathermap.org/current JSON 형식 참고

// Codable은 자신을 외부 표현(ex. Json)으로 변환할 수 있도록 함
// Decoding(Json -> struct)과 Encoding(struct -> Json) 모두 가능함
struct WeatherInformation: Codable {
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

// Json 파일의 키 값과 동일하도록 프로퍼티 정의
// weather 객체
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// main 객체
struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double

    // codingKeys를 사용해 키 값과 프로퍼티의 이름이 달라도 매핑될 수 있도록 함
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}

