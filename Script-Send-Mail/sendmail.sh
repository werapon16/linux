#Email send to
(echo "To: werapon_jar@freewillcomserv.com"
#(echo "To: pisit_tun@freewillsolutions.com,chawanon_cha@freewillsolutions.com"
#name server sender
 echo "From: itadmin-sbaproduction@freewillsolutions.com"
 echo "Subject: [SBA-Production] IP:xxx.xxx.xxx : Check Disk Space"
 echo "MIME-Version: 1.0"
 echo "Content-Type: multipart/mixed; boundary=BOUNDARY"
 echo
 echo "--BOUNDARY"
 echo "Content-Type: text/plain"

 echo 
 echo "To Macq Team"
 echo
 echo "    The system send file diskspace.txt and diskspace2.txt"
 echo 
 echo 
 echo "remark : This script run at path /home/itadmin/checkspace.sh"
 echo 
 echo
 #cat show text on page
 #cat Log.txt
 echo "---------- Disk Space ----------"
 echo
 cat diskspace.txt
 echo
 echo "---------- Disk Space2 ----------"
 echo
 cat diskspace2.txt
 echo
 echo
 echo "Thank you"

 echo
 echo "--BOUNDARY"
 #tag name file attachment
 echo "Content-Type: application/octet-stream; name=diskspace.txt"
 echo "Content-Disposition: attachment; filename=diskspace.txt"
 echo "Content-Transfer-Encoding: base64"
 echo
 base64 diskspace.txt
 #tag name file attachment
 
 echo "--BOUNDARY"
 echo "Content-Type: application/octet-stream; name=diskspace2.txt"
 echo "Content-Disposition: attachment; filename=diskspace2.txt"
 echo "Content-Transfer-Encoding: base64"
 echo
 #name file to send
 base64 diskspace2.txt

 echo "--BOUNDARY"
 echo "Content-Type: application/octet-stream; name=listfile.txt"
 echo "Content-Disposition: attachment; filename=listfile.txt"
 echo "Content-Transfer-Encoding: base64"
 echo
 #name file to send
 base64 listfile.txt
 echo "--BOUNDARY--") | sendmail -t
