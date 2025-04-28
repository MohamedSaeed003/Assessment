echo "==> 1. Check current DNS resolver settings"
cat /etc/resolv.conf

echo "==> 2. Test DNS resolution using system resolver"
dig internal.example.com || echo "Failed to resolve with system resolver."

echo "==> 3. Test DNS resolution using Google's DNS (8.8.8.8)"
dig @8.8.8.8 internal.example.com

echo "==> 4. If no nameserver, temporarily add Google's DNS"
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

echo "==> 5. Verify DNS resolution after adding nameserver"
dig internal.example.com

echo "==> 6. Resolve internal.example.com to IP"
resolved_ip=$(dig +short internal.example.com)
echo "Resolved IP: $resolved_ip"

if [ -z "$resolved_ip" ]; then
  echo "Failed to resolve domain. Exiting script."
  exit 1
fi

echo "==> 7. Ping the resolved IP"
ping -c 4 "$resolved_ip"

echo "==> 8. Check if ports 80 and 443 are reachable"
nc -vz "$resolved_ip" 80
nc -vz "$resolved_ip" 443

echo "==> 9. Try HTTP and HTTPS connection"
curl -I "http://$resolved_ip"
curl -I "https://$resolved_ip"

echo "==> 10. Check firewall rules (UFW and iptables)"
sudo ufw status
sudo iptables -L

echo "==> 11. Restart Web Server (Apache example)"
sudo systemctl restart apache2

echo "==> 12. Add static /etc/hosts entry"
echo "$resolved_ip internal.example.com" | sudo tee -a /etc/hosts

echo "==> 13. Verify hosts entry"
ping -c 4 internal.example.com

echo "==> Troubleshooting complete!"
