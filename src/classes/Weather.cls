public class Weather {

    private static final String API_KEY = '1f81d97565a7021d5119e8df69ab9313';
    private static final String BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';

    public class WeatherData {
        @AuraEnabled public Double temperature { get; set; }
        @AuraEnabled public Double pressure { get; set; }
        @AuraEnabled public Double humidity { get; set; }
        @AuraEnabled public String cityName { get; set; }
        @AuraEnabled public String description { get; set; }
    }

    @AuraEnabled
    public static WeatherData getWeatherForCity(String city, String country) {
        WeatherModel wm = getWeather(city, country);
        return setData(wm);
    }

    @AuraEnabled
    public static WeatherData getWeatherForLocation(Double lat, Double lon) {
        WeatherModel wm = getWeather(lat, lon);
        return setData(wm);
    }

    private static WeatherData setData(WeatherModel wm) {
        WeatherData wd = new WeatherData();
        wd.temperature = wm.main.temp;
        wd.pressure = wm.main.pressure;
        wd.humidity = wm.main.humidity;
        wd.cityName = wm.name;
        wd.description = wm.weather[0].description;
        return wd;
    }

    private static WeatherModel getWeather(String city, String country) {
        String url = BASE_URL + '?q=' + city + ',' + country + '&units=metric&lang=PL&appid=' + API_KEY;
        return makeCallToApi(url);
    }

    private static WeatherModel getWeather(Double lat, Double lon) {
        String url = BASE_URL + '?lat=' + lat + '&lon=' + lon + '&units=metric&lang=PL&appid=' + API_KEY;
        System.debug('Api call -> ' + url.replace(API_KEY, 'APIKEY'));
        return makeCallToApi(url);
    }

    private static WeatherModel makeCallToApi(String url) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        WeatherModel result;
//        String Url = BASE_URL + '?q=' + city + ',' + country + '&units=metric&lang=PL&appid=' + API_KEY;
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            result = WeatherModel.parse(response.getBody());
            System.debug(response.getBody());
            //result = (WeatherModel) JSON.deserialize(response.getBody(), WeatherModel.class);
        } else {
            System.debug('Bad request!');
        }
        return result;
    }
}