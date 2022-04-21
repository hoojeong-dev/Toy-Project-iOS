# Weather 앱

## *Introduce*

입력한 도시의 날씨 데이터를 받아와 나타냅니다.

주요 기능은 다음과 같습니다.
- API 호출
- 도시에 따른 날씨 정보 표기
- 로컬 저장소에 데이터 저장

</br>

날씨 데이터를 받아오기 위해 다음 <a herf="https://openweathermap.org" target="_blank">Open Weather API</a>를 사용합니다.

도시 이름과 API 키 값을 통해 API를 호출합니다.
```
https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
```

```
{
    "coord":
        {
            "lon":126.9778,
            "lat":37.5683
        },
    "weather":
        [
            {
                "id":802,
                "main":"Clouds",
                "description":"scattered clouds",
                "icon":"03d"
            }
        ],
    "base":"stations",
    "main":
        {
            "temp":298.81,
            "feels_like":297.74,
            "temp_min":295.84,
            "temp_max":298.81,
            "pressure":1014,
            "humidity":12,
            "sea_level":1014,
            "grnd_level":1008
        },
    "visibility":10000,
    "wind":
        {
            "speed":3.48,
            "deg":156,
            "gust":4.04
        },
    "clouds":
        {
            "all":38
        },
    "dt":1652166794,
    "sys":
        {
            "type":1,
            "id":5509,
            "country":"KR",
            "sunrise":1652128067,
            "sunset":1652178556
        },
    "timezone":32400,
    "id":1835848,
    "name":"Seoul",
    "cod":200
}
```

</br>


다음은 API 호츌 예제입니다.
```swift
guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            let successRange = (200..<300)
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            
            // response의 statusCode 값이 200일 경우
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode){
                // 앞서, 데이터를 저장할 구조체를 Codable로 선언하여 인/디코딩이 가능하도록 함
                // 전달받은 데이터를 JSON에서 구조체 형태로 변환하는 코드 작성
            }

            // response의 statusCode 값이 404일 경우
            else {
                // error alert 코드 작성
            }
```

</br>

## *Demo*

<p align="center"><img src="./asset/weather.GIF" height="500px" width="250px"><p>
