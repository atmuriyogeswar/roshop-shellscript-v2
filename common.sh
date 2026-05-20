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
