log_file=/tmp/roboshop.log
hs="\e[33m >>>>>>>>>>>>>"
he="<<<<<<<<<<<<<<< \e[0m"

nodejs() {
    echo -e "${hs}Installing Node.js${he}" | tee -a ${log_file}
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - >>${log_file}
    dnf install -y nodejs 
}
 
systemd_service() {
    echo -e "${hs}Copying Systemd Service File${he}" | tee -a ${log_file}
    cp ${component_name}.service /etc/systemd/system/${component_name}.service # Copy the systemd service file to the appropriate location
    systemctl daemon-reload
    systemctl enable ${component_name}
    systemctl start ${component_name}
}

go_app() {
    echo -e "${hs}Building the Application${he}" | tee -a ${log_file}
    go mod tidy
    CGO_ENABLED=0 go build -o /app/${component_name} .
}

app_pre-req() {
    echo -e "${hs}Downloading ${component_name} Code${he}" | tee -a ${log_file}
curl -L -o /tmp/${component_name}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component_name}.zip
rm -rf /tmp/${component_name} &>>${log_file}

echo -e "${hs}Setting up ${component_name}${he}" | tee -a ${log_file}
mkdir -p /tmp/${component_name} &>>${log_file}
cd /tmp/${component_name} &>>${log_file}

echo -e "${hs}Extracting ${component_name}  Code${he}" | tee -a ${log_file}   
unzip /tmp/${component_name}.zip
}