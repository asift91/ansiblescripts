#!/bin/bash

decotext=`echo ${2} | base64 --decode`
  
echo "User Name is : ${1}" >> /home/"${1}"/log.txt
echo "encoded text : ${2}" >> /home/"${1}"/log.txt
echo "decoded text : ${decotext}" >> /home/"${1}"/log.txt

#clonerepo ${1} >> /home/"${1}"/log.txt
#moodle_install ${decotext} >> /home/${1}/var.txt

  cat <<EOF > /home/"${1}"/run.sh
  #!/bin/bash
  #bash /home/${1}/moodleinstall.sh ${decotext}
  clonerepo(){
    cd /home/"${1}"/ 
    wget https://raw.githubusercontent.com/sayosh0512/ansiblescripts/master/ansibleserversetup.sh
    sudo chown -R "${1}":"${1}" /home/"${1}"/ansibleserversetup.sh
  }
  moodle_install() {
    cd /home/${1}
    git clone https://github.com/sayosh0512/moodle_playbook.git
    echo "VM IP : ${1}" >> /home/${3}/var.txt
    echo "VM Pass : ${2}" >> /home/${3}/var.txt
    echo "username is : ${3}" >> /home/${3}/var.txt
    echo "dbservername is : ${4}" >> /home/${3}/var.txt
    echo "dbusername is : ${5}" >> /home/${3}/var.txt
    echo "dbPassword is : ${6}" >> /home/${3}/var.txt
    echo "domain_name is : ${7}" >> /home/${3}/var.txt

    sudo sed -i "s~domain_name: domain~domain_name: ${7}~" /home/${3}/moodle_playbook/group_vars/all >> /home/${3}/var.txt
    sudo sed -i "s~user_name: azusername~user_name: ${3}~" /home/${3}/moodle_playbook/group_vars/all  >> /home/${3}/var.txt 
    ansible-playbook /home/${3}/moodle_playbook/playbook.yml -i /etc/ansible/hosts -u ${3}
  }
  clonerepo ${1} >> /home/"${1}"/log.txt
  bash /home/"${1}"/ansibleserversetup.sh ${decotext}
  moodle_install ${decotext} >> /home/${1}/var.txt
EOF
sudo chown -R "${1}":"${1}" /home/"${1}"/run.sh
