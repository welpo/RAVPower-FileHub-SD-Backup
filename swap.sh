# Add a swapfile on the data store drive 
# (rsync needs this for large file copies)

sed -i 's/SWAP=noswap/SWAP=swap/' /etc/firmware

cat <<'EOF' > /etc/init.d/swap
STORE_DIR=/sdcopies
CONFIG_DIR="$STORE_DIR"/config
#rm -f "$STORE_DIR"/log/swapinfo

while read device mountpoint fstype remainder; do
    if [ ${device:0:7} == "/dev/sd" -a -e "$mountpoint$CONFIG_DIR" ];then
            swapfile="$mountpoint$CONFIG_DIR"/swapfile
            if [ ! -e "$swapfile" ]; then
                dd if=/dev/zero of="$swapfile" bs=1024 count=131072
                echo "$(date): Creating swapfile $swapfile" >> "$STORE_DIR"/log/swapinfo
            fi
            swapon "$swapfile" >> /tmp/swapinfo 2>&1
            if [ $? -eq 0 ]; then
                echo "$(date): Turned on swap for $swapfile" >> "$STORE_DIR"/log/swapinfo
            else
                echo "$(date): There was an error turning on swap" >> "$STORE_DIR"/log/swapinfo
            fi
            exit 0
    fi
done < /proc/mounts
exit 0
EOF
