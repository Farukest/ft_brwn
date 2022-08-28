crontab -r
{ crontab -l; echo "  * *   *   *   *    /bin/bash /home/ft/runall.sh
 * *   *   *   *    /bin/bash /home/ft/checkmiddles.sh
 */10  *   *   *   *    /bin/bash /root/activity_fix.sh
 0 3  */1  *   *    /bin/bash /home/ft/clearlogs.sh"; } | crontab -