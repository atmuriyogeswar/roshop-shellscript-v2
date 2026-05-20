source common.sh
component_name=frontend

echo Log file Output : ${log_file}
echo -e "${hs}Installing Nginx${he}" | tee -a ${log_file}
dnf install -y nginx

echo -e "${hs}Configuring Nginx${he}" | tee -a ${log_file}
cp nginx.conf /etc/nginx/nginx.conf &>>${log_file}

nodejs  # Call the function to install Node.js

app_pre-req  # Call the function to set up application prerequisites

echo -e "${hs}Installing ${component_name} Dependencies and Building${he}" | tee -a ${log_file}
npm install
npm run build 
rm -rf /usr/share/nginx/html/* &>>${log_file}

echo -e "${hs}Deploying ${component_name}${he}" | tee -a ${log_file}
cp -r out/* /usr/share/nginx/html/ &>>${log_file}

systemd_service  # Call the function to set up the systemd service