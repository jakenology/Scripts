#!/Users/os/anaconda3/bin/python3

# Tried https://api.sunrise-sunset.org/json?&lat=45.6216319&lng=-94.2069365&formatted=1
from datetime import datetime
import pytz
import tzlocal
import dateutil.parser
import geocoder
import requests

# Get the latitude and longitude
coordinates = geocoder.location('Sartell, MN')
lat, lng = coordinates.latlng

# Get the sunset and sunrise data
url = "http://api.sunrise-sunset.org/json?lat="+str(lat)+"&lng="+str(lng)+"&formatted=1"
sun_rise_set = url
api_data = requests.get(sun_rise_set)
json_data = api_data.json()['results']

# Time converter function
def convert_time(time):
    date = dateutil.parser.parse(time)
    time = date.strftime('%H:%M:%S')
    return(time)

# Store the desired data
utc_sunrise = convert_time(json_data['sunrise'])
utc_sunset = convert_time(json_data['sunset'])

print(utc_sunrise, utc_sunset)

def convert_to_local(utc_time):
    local_timezone = tzlocal.get_localzone() # get pytz tzinfo
    utc_time = datetime.strptime(utc_time, "%H:%M:%S")
    local_time = utc_time.replace(tzinfo=pytz.utc).astimezone(local_timezone)

    # Convert it to HH:MM:SS format
    time = local_time.strftime('%H:%M:%S')
    return time

def main():
    print(convert_to_local(utc_sunrise))
    print(convert_to_local(utc_sunset))

if __name__ == '__main__':
    main()
