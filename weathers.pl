#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI qw(:standard);
use LWP::UserAgent;
use JSON;
use POSIX;

# Enable CORS
print "Access-Control-Allow-Origin: *\n";
print "Content-type: text/html\n\n";

# Get city parameter from URL
my $city = param('city');

# Check if city is provided
if (!$city) {
    print "<p class='error'>Error: No city parameter provided!</p>";
    exit;
}

my $api_key = "effe18d5d59792c6cf0e3370cbd0458f";  # Replace with your OpenWeatherMap API key
my $url = "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$api_key&units=metric";

my $ua = LWP::UserAgent->new;
my $response = $ua->get($url);

# If the request is successful
if ($response->is_success) {
    my $weather_data = decode_json($response->decoded_content);

    # Extracting relevant weather information
    my $temp = sprintf("%.1f", $weather_data->{main}->{temp});
    my $humidity = $weather_data->{main}->{humidity};
    my $weather_description = ucfirst($weather_data->{weather}->[0]->{description});
    my $wind_speed = sprintf("%.1f", $weather_data->{wind}->{speed});
    my $city_name = $weather_data->{name};

    # Display the weather data with improved formatting
    print "<div class='result-container'>";
    print "<h2>Weather for $city_name</h2>";
    print "<div class='weather-details'>";
    print "<p><strong>Temperature:</strong> $temp°C</p>";
    print "<p><strong>Humidity:</strong> $humidity%</p>";
    print "<p><strong>Weather:</strong> $weather_description</p>";
    print "<p><strong>Wind Speed:</strong> $wind_speed m/s</p>";
    print "</div>";
    print "</div>";
} else {
    print "<p class='error'>Error fetching weather data. " . $response->status_line . "</p>";
}