ptCount=$(pgrep -c ftcollector+)
fwCount=$(pgrep -c lora_pkt_fwd+)

echo "ÇALIŞAN PAKET SAYISI - "$ptCount
echo "ÇALIŞAN TOPLAYICI SAYISI - "$fwCount
echo "\n"
echo "\n"
echo "\n"

pgrep lora_pkt_fwd+
echo "\n"
pgrep python3+
