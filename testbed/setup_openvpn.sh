# from https://community.openvpn.net/openvpn/wiki/OpenvpnSoftwareRepos

sudo -s
curl -fsSL https://swupdate.openvpn.net/repos/repo-public.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/openvpn-repo-public.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/openvpn-repo-public.gpg] https://build.openvpn.net/debian/openvpn/release/2.5 bionic main" > /etc/apt/sources.list.d/openvpn-aptrepo.list

apt-get update && apt-get install openvpn -y
exit

#Then connect with
#openvpn --config ./