ptCount=$(pgrep -c ftcollector+)
echo $ptCount
if (( $ptCount > 1 )); then
  
  echo "More than one "$ptCount".. Killing all collectors..\n"
  pgrep ftcollector+ | xargs kill
  
  echo "Starting collectors again..\n"  
  cd /home/ft/ && ./runmiddles.sh
  
else

	if(( $ptCount == 0 )); 
		then
			echo 'No collector exist.. We must start a collector..\n'
			cd /home/ft/ && ./runmiddles.sh
		else
			echo "Nothing to do - "$ptCount" Collector already working..\n"
	fi
		
fi