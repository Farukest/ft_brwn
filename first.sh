chmod 777 /home/ft/allow.sh
./allow.sh
./killpfs.sh
./clearlogs.sh
./killmiddles.sh
./removeoriginalpf.sh
# rm -rf /home/ft/hs_ft_pf_*/packet_forwarder/lora_pkt_fwd*
# rm -rf /home/ft/hs_ft_pf_*/packet_forwarder/obj/lora_pkt_fwd*.o