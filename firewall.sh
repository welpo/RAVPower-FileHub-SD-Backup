# Stops external network access to the device, increases security.

# Delete existing modification from file, if it exists
sed -i '/#START_MOD/,/#END_MOD/d' /etc/rc.local

cat <<'EOF' >> /etc/rc.local
#START_MOD

#END_MOD
EOF
