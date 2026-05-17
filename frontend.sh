source common.sh
component_name=frontend

echo Log file Output : ${log_file}
echo -e "${hs}Installing Nginx${he}" | tee -a ${log_file}
dnf install -y nginx

echo -e "${hs}Configuring Nginx${he}" | tee -a ${log_file}
cp nginx.conf /etc/nginx/nginx.conf &>>${log_file}

echo -e "${hs}Installing Node.js${he}" | tee -a ${log_file}
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - >>${log_file}
dnf install -y nodejs

echo -e "${hs}Downloading ${component_name} Code${he}" | tee -a ${log_file}
curl -L -o /tmp/${component_name}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component_name}.zip
rm -rf /tmp/${component_name} &>>${log_file}

echo -e "${hs}Setting up ${component_name}${he}" | tee -a ${log_file}
mkdir -p /tmp/${component_name} &>>${log_file}
cd /tmp/${component_name} &>>${log_file}

echo -e "${hs}Extracting ${component_name}  Code${he}" | tee -a ${log_file}   
unzip /tmp/${component_name}.zip
echo -e "${hs}Installing ${component_name} Dependencies and Building${he}" | tee -a ${log_file}
npm install
npm run build 
rm -rf /usr/share/nginx/html/* &>>${log_file}

echo -e "${hs}Deploying ${component_name}${he}" | tee -a ${log_file}
cp -r out/* /usr/share/nginx/html/ &>>${log_file}

echo -e "${hs}Starting Nginx${he}" | tee -a ${log_file}
systemctl restart nginx
systemctl enable nginx