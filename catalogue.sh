source common.sh

echo -e "${hs}Installing Go, Git, and MySQL${he}" | tee -a ${log_file}
dnf install -y golang git mysql8.4  # Install Go, Git, and MySQL

echo -e "${hs}Copying Systemd Service File${he}" | tee -a ${log_file}
cp catalogue.service /etc/systemd/system/catalogue.service # Copy the systemd service file to the appropriate location

echo -e "${hs}Downloading Catalogue Code${he}" | tee -a ${log_file}
curl -L -o /tmp/catalogue.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/catalogue.zip
rm -rf /app
mkdir -p /app
cd /app
unzip /tmp/catalogue.zip

echo -e "${hs}Setting up MySQL Database${he}" | tee -a ${log_file}
mysql -h 10.0.0.4 -u root -pRoboShop@1 < db/schema.sql
mysql -h 10.0.0.4 -u root -pRoboShop@1 < db/app-user.sql
mysql -h 10.0.0.4 -u root -pRoboShop@1 catalogue < db/master-data.sql

echo -e "${hs}Creating Application User${he}" | tee -a ${log_file}
useradd -r -s /bin/false appuser # Create a system user for running the application
cd /app

echo -e "${hs}Building the Application${he}" | tee -a ${log_file}
go mod tidy
CGO_ENABLED=0 go build -o /app/catalogue .

echo -e "${hs}Setting Permissions${he}" | tee -a ${log_file}
chown -R appuser:appuser /app
chmod o-rwx /app -R

echo -e "${hs}Starting Catalogue Service${he}" | tee -a ${log_file}
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue