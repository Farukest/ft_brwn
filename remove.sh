i=0
while [ $i -ne 4 ]
do
		i=$(($i+1))
		cd /home/ft/hs_ft_pf_$i/ && make -f Makefile
		mv /home/ft/hs_ft_pf_$i/packet_forwarder/lora_pkt_fwd$i /tmp/
		rm -rf /home/ft/hs_ft_pf_$i
		mkdir -p /home/ft/hs_ft_pf_$i/packet_forwarder/
		mv /tmp/lora_pkt_fwd$i /home/ft/hs_ft_pf_$i/packet_forwarder/
		
done
