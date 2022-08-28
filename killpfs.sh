fwCount=$(pgrep -c lora_pkt_fwd+)

if [[ $fwCount -gt 0 ]]; 
	then
	  echo "Killing all pktwds.."
	  pgrep lora_pkt_fwd+ | xargs kill
	else
	  echo "No current pktwd process"
fi
