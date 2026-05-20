source common.sh

echo -e "${hs}Installing MySQL${he}" | tee -a ${log_file}
dnf install -y mysql8.4-server
echo $?

echo -e "${hs}Starting MySQL${he}" | tee -a ${log_file}
systemctl enable mysqld
systemctl start mysqld
echo $?

echo -e "${hs}Configuring MySQL${he}" | tee -a ${log_file}
mysql -u root -e "
  CREATE USER 'root'@'%' IDENTIFIED BY 'RoboShop@1'; 
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
  ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';
  FLUSH PRIVILEGES;
"
echo $?