document.getElementById('weather-form').addEventListener('submit', function(event) {
    event.preventDefault();

    // Get city name from the input field
    const city = document.getElementById('city').value.trim();

    if (city) {
        // Open a new window
        const resultWindow = window.open('result.html', '_blank');
        
        // Send the request to the Perl script
        fetch(`http://localhost/cgi-bin/weathers.pl?city=${encodeURIComponent(city)}`)
            .then(response => response.text())
            .then(data => {
                // Write the data directly to the new window's document
                resultWindow.document.open();
                resultWindow.document.write(`
                    <!DOCTYPE html>
                    <html lang="en">
                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Weather Results</title>
                        <link rel="stylesheet" href="styles.css">
                    </head>
                    <body>
                        <div class="result-container">
                            <div id="weather-result" class="weather-details">
                                ${data}
                            </div>
                        </div>
                    </body>
                    </html>
                `);
                resultWindow.document.close();
            })
            .catch(error => {
                resultWindow.document.open();
                resultWindow.document.write(`
                    <!DOCTYPE html>
                    <html lang="en">
                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Weather Error</title>
                        <link rel="stylesheet" href="styles.css">
                    </head>
                    <body>
                        <div class="result-container">
                            <div id="weather-result" class="weather-details">
                                <p class="error">Error: ${error.message}</p>
                            </div>
                        </div>
                    </body>
                    </html>
                `);
                resultWindow.document.close();
            });
    } else {
        alert('Please enter a valid city name.');
    }
});