if [ ! -f .myipaddr ]; then
  echo "CALLING API TO QUERY MY IP"
  ipinfo=`curl -s -u $TOKEN: ipinfo.io`
  echo $ipinfo > .myipaddr
else
  echo "IP READ FROM CACHE"
  ipinfo=`cat .myipaddr`
fi
loc=`echo $ipinfo | jq '.loc'`
lat=`echo $loc | cut -d'"' -f 2 | cut -d',' -f 1`
lon=`echo $loc | cut -d'"' -f 2 | cut -d',' -f 2`
apikey="c2c267acb1784fba805e9028f57a2385"
echo "Forecast for my lat=$lat°, lon=$lon°"
forecast=`curl -s -g "https://api.weatherbit.io/v2.0/forecast/daily?lat=$lat&lon=$lon&key=$apikey"`
#echo $forecast
wx=`echo $forecast | jq '.data'`
day=`echo $wx | jq .[0]`
#echo $day
x=0
until [ "$day" = "null" ]; do
  #hi=`echo $day | jq .app_max_temp`
  #low=`echo $day | jq .app_min_temp`
  hi=`echo $day | jq .max_temp`
  low=`echo $day | jq .min_temp`
  day=`echo $day | jq .valid_date`
  #echo $day
  day=${day//\"/}
  echo "Forecast for $day HI: ${hi}°c LOW: ${low}°c"
  ((x++))
  day=`echo $wx | jq .[$x]`
done


