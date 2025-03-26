import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    @State private var animateCloud: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            // Animated background gradient based on the weather condition
            animatedBackground(for: weather.weather.first?.main ?? "Clear")
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2)) {
                        animateCloud.toggle()  // Trigger cloud animation on appear
                    }
                }
            
            VStack {
                // City name and current date
                VStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            // Building icon next to the city name with a smooth scale effect
                            Image(systemName: "building.2.crop.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .scaleEffect(1.2) // Slightly larger
                            
                            Text(weather.name)
                                .bold()
                                .font(.title)
                                .foregroundColor(.white)
                                .transition(.slide) // Smooth transition for text
                        }
                        Spacer().frame(height: 10)
                        
                        Text("Aujourd'hui, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .transition(.opacity) // Text fades in smoothly
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(height: 30)
                    
                    // Weather Information VStack
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Weather now")
                            .bold()
                            .padding(.bottom)
                        
                        HStack {
                            WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundDouble() + ("°")))
                            Spacer()
                            WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundDouble() + "°"))
                        }
                        
                        HStack {
                            WeatherRow(logo: "wind", name: "Wind speed", value: (weather.wind.speed.roundDouble() + " m/s"))
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.7)) // Slight opacity for a lighter feel
                    .cornerRadius(20)
                    .foregroundColor(Color(hue: 0.650, saturation: 0.5, brightness: 0.75))
                    .scaleEffect(1.05) // Slightly enlarges the weather data
                    .shadow(radius: 10) // Adds some depth with shadow
                    
                    Spacer()
                    
                    // Main weather display (cloud, feels like, image)
                    VStack {
                        HStack {
                            VStack(spacing: 20) {
                                // Cloud Icon with a smooth scaling effect
                                Image(systemName: weather.main.feelsLike > 25 ? "sun.max.fill" : weather.main.feelsLike < 0 ? "snow" : "cloud.fill")
                                      .font(.system(size: 40))
                                      .foregroundColor(.white)
                                      .scaleEffect(animateCloud ? 1.3 : 1.1) // Dynamic scale based on condition with state
                                      .animation(.easeInOut(duration: 1), value: animateCloud) // Triggered by state change
                                  
                                Text(weather.main.feelsLike > 25 ? "Sunny" : weather.main.feelsLike < 0 ? "Snowy" : "\(weather.weather[0].main)")
                                      .foregroundColor(.white)
                                      .font(.title3)
                              }
                            .frame(width: 150, alignment: .leading)
                            
                            Spacer()
                            
                            // Temperature with dynamic color and animation
                            Text(weather.main.feelsLike.roundDouble() + "°")
                                .font(.system(size: 100))
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(weather.main.feelsLike > 25 ? .orange : .white) // Warmer colors for higher temps
                                .scaleEffect(1.1) // Larger size for emphasis
                                .animation(.spring(), value: weather.main.feelsLike) // Smooth spring animation based on temperature
                        }
                        
                        Spacer()
                            .frame(height: 80)
                        
                        AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350)
                                .transition(.scale) // Smooth transition for image
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    // Animated background based on weather condition
    @ViewBuilder
    func animatedBackground(for weatherCondition: String) -> some View {
        switch weatherCondition {
        case "Clear":
            LinearGradient(gradient: Gradient(colors: [.blue, .yellow]), startPoint: .top, endPoint: .bottom)
        case "Clouds":
            LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .top, endPoint: .bottom)
        case "Rain":
            LinearGradient(gradient: Gradient(colors: [.blue, .gray]), startPoint: .top, endPoint: .bottom)
        case "Snow":
            LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .top, endPoint: .bottom)
        default:
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}
