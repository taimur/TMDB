# Uncomment the next line to define a global platform for your project

platform :ios, '9.0'

target 'TMDB' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TMDB
   pod "Alamofire", "~> 4.7"
   pod "AlamofireObjectMapper", "~> 5.0" # Mapping Response into Objects
   pod "SDWebImage", "~>3.8" # Asynchronus Image loading
   pod "MBProgressHUD", "~> 1.0.0" # Showing Loader view
   pod "SwiftyJSON" # Converting response into swift type
   pod "SwiftLint" # Linter used to maintain coding style and patterns
   pod "MarqueeLabel" # Scrolling wide labels
   
  target 'TMDBTests' do
    inherit! :search_paths
    # Pods for testing
    pod "Alamofire", "~> 4.7"
    pod "OHHTTPStubs/Swift"
  end

  target 'TMDBUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
