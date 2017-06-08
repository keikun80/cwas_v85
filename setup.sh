#!/bin/bash  


currentDir=`pwd`;


#temp_java_home=${JAVA_HOME}
temp_java_home="/etc/alternatives";

#echo ${temp_java_home}
#echo ${CLASSPATH}  

_RET=0 

function _com_chk_install() 
{ 
	if [ -f ./cwas ]; then  
		whiptail --msgbox "Already installed Chlux Web Application Server"  8 50
	else 
		_RET=1
	fi 
}
function _tui_front()
{
    TITLE="CHLUX WEB APPLICATION SERVER INSTALLER"
    clear
    eval printf %.0s\# '{1..'${COLUMNS:-$(tput cols)}'}'; echo    
    echo -e "" 
    printf "%*s\n" $(((${#TITLE}+$(tput cols))/2)) "$TITLE"
    echo -e "\t Version : 1.0.1c" 
    echo -e "\t Package : APACHE TOMCAT 7.0"
    echo -e "\t Require : Root Permission (Installation)"
    echo -e ""
    eval printf %.0s\# '{1..'${COLUMNS:-$(tput cols)}'}'; echo  

}
function _com_chk_eula()
{  

	if (whiptail --scrolltext --title "End user license agreement" --textbox engine/LICENSE 40 90 ) then 
		if (whiptail --title "Question" --yes-button "Agree" --no-button "Not Agree" --yesno "Are you agree?" 10 60) then    
			_RET=$?
		fi 
	fi
} 

function _tui_install()
{   
	_com_chk_install  
	if [ $_RET == 0 ]; then   
		exit
	else
		_com_chk_eula
	fi

	WASUSER=`whoami` 

	WASUSER=$(whiptail --inputbox "Enter Web Application  owner (default : [$WASUSER])" 8 78 $WASUSER --title "Owner"  3>&1 1>&2 2>&3) 
	#WASGROUP=$(whiptail --inputbox "Enter Web Application  group (default : [$WAGROUP])" 8 78 $WASUSER --title "Owner"  3>&1 1>&2 2>&3)  

	_RET=$? 

	if [ $_RET != 0 ]; then  
		exit
	fi  
	#echo ${WASUSER}
	if [ "root" == "${WASUSER}" ]; then  
		whiptail --msgbox "root cannot be owner of Chlux Web Application Server" 10 90
		exit
	fi  

	if [ $_RET = 0 ]; then
		WASGROUP=$(whiptail --inputbox "Enter Web Application  group (default : [$WASUSER])" 8 78 $WASUSER --title "Owner"  3>&1 1>&2 2>&3)  
		_RET=$?
	else 
		echo "user select cancel"
	fi 

	if [ $_RET != 0 ]; then  
		exit
	fi  
	#echo $WASUSER
	#echo $WASGROUP 

    ret=false
    getent passwd ${WASUSER} >/dev/null 2&>1 && ret=true 

    if ${ret}; then 
		whiptail --msgbox "Already exists ["${WASUSER}" / "$WASGROUP"] Chlux Web Application Server"  10 90 
    else  
        #groupadd ${APACHE_GROUP} > /dev/null 2&>1  
        if [ ! $(getent group ${WASGROUP}) ]; then  
            groupadd ${WASGROUP}
        fi
        GROUP_SW="-g ${WASGROUP}"
        useradd ${GROUP_SW} -M -r -d ${currentDir} ${WASUSER} -s /bin/bash > /dev/null 
        whiptail --msgbox "Create ["${WASUSER}"/"${WASGROUP}"] for WAS" 10 90
    fi 
    rm -f 1 

	#echo "(Exit status was $exitstatus)"	
}
function _checkuser()
{
    # Setup User / group for Apache
    echo -e -n "Enter WAS user (default : \e[2m`whoami`\e[22m):" 
    read WAS_USER 
    APACHE_GROUP=${WAS_USER}
    echo -e -n "Enter WAS group (default : \e[2m${APACHE_GROUP}\e[22m):"
    read WAS_GROUP

    if [ -z ${WAS_USER}  ]; then 
	    WAS_USER=`whoami`
    fi 

    if [ -z ${WAS_GROUP} ]; then
        WAS_GROUP=`whoami`
    fi

    #check user
    ret=false
    getent passwd ${WAS_USER} >/dev/null 2&>1 && ret=true
    #echo ${ret}

    if ${ret}; then 
        echo -e "\e[33m\e[1m -- Entered UID/GID (${WAS_USER}/${WAS_GROUP}) is already exists, Will use this UID.\e[0m"
    else  
        #groupadd ${APACHE_GROUP} > /dev/null 2&>1  
        if [ ! $(getent group ${APACHE_GROUP}) ]; then  
            groupadd ${APACHE_GROUP}
        fi
        GROUP_SW="-g ${APACHE_GROUP}"
        useradd ${GROUP_SW} -M -r -d ${currentDir} ${WAS_USER} -s /bin/bash > /dev/null 
        echo -e "\e[32m --Create USER/GROUP for Apache (${WAS_USER}/${WAS_GROUP})\e[0m"
    fi 
    rm -f 1
}


function _front()
{
    TITLE="CHLUX TOMCAT MULII INSTANCE PACK INSTALLER"
    clear
    eval printf %.0s\# '{1..'${COLUMNS:-$(tput cols)}'}'; echo    
    echo -e "" 
    printf "%*s\n" $(((${#TITLE}+$(tput cols))/2)) "$TITLE"
    echo -e "\t Version : 1.0" 
    echo -e "\t Author  : Chlux Co,Ltd."
    echo -e "\t Release : 25. Dec. 2016" 
    echo -e "\t Package : APACHE TOMCAT 7.0"
    echo -e "\t Require : Root Permission (Installation)"
    echo -e ""
    eval printf %.0s\# '{1..'${COLUMNS:-$(tput cols)}'}'; echo  

}


# check JAVA_OPT  
function _setjavahome()
{ 
    if [[ ! ${temp_java_home} ]]; then 
        echo -n -e "\e[32mEnter JAVA_HOME for tomcat (default : \\e[2m${temp_java_home} ) : \e[0m"
        read a 
        if [[ $a ]]; then
            temp_java_home=${a}     
        else  
            echo -e "\e[91mYou should enter JAVA_HOME\e[0m"   
            exit;
            #_setjavahome;
        fi  
    else
        echo -e "\e[32mTomcat will use this JAVA_HOME : \e[2m${temp_java_home}\e[0m" 
        read -r -p "Continue[Y/n] : " response 
        case ${response} in
            [yY][eE][sS]|[yY])  
                echo -e "\e[32mTomcat installing ...\e[0m" 
                ;; 
            [nN][oO]|[nN]) 
                temp_java_home=""
                _setjavahome
                ;;
            *) 
                echo -n -e "\e[32mEnter JAVA_HOME for tomcat (default : \\e[2m${temp_java_home} ) : \e[0m"
                ;;
        esac  
    fi
} 

function _getjavaversion() 
{ 
    #echo -e -n "\e[32mChecking JAVA Version (java : ${temp_java_home}/bin/java -version ):"
    echo -e -n "\e[32mChecking JAVA Version (java : ${temp_java_home}/java -version ):"
    #javav=`${temp_java_home}/bin/java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}'`  
    javav=`${temp_java_home}/java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}'`  
    echo -e ${javav}"\e[0m" 

    if [ -z ${javav} ]; then 
        echo -e "\e[31mWrong JAVA_HOME path, Please check again JAVA_HOME\e[0m"  
        exit; 
    fi 
} 

function _setjavaopt()
{  
    echo -e "\e[32msetup JAVA_OPTS for ${javav} \e[0m"
   jdk6=$(echo $javav | sed -n '/1.6.0/p')
   jdk7=$(echo $javav | sed -n '/1.7.0/p')
   jdk8=$(echo $javav | sed -n '/1.8.0/p')
   
    if [ ! -z ${jdk6} ]; then    
        #SET JAVA_OPT 
        #echo ${jdk6} 
        OPT="export \"JAVA_OPTS=\$JAVA_OPTS -Xms128m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=1024m\""
    fi  

    if [ ! -z ${jdk7} ]; then  
        #SET JAVA_OPT
        #echo ${jdk7} 
        OPT="export \"JAVA_OPTS=\$JAVA_OPTS -server -Xms128m -Xmx512m\""
    fi  

    if [ ! -z ${jdk8} ]; then  
        #SET JAVA_OPT
        #echo ${jdk8}
        OPT="export \"JAVA_OPTS=\$JAVA_OPTS -server -Xms128m -Xmx512m\""
        #OPT="export \"JAVA_OPTS=\$JAVA_OPTS -Xms128m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=1024m\""
    fi  
    echo -e ${OPT} > .javaopts
}

function _tui_setlauncher()
{  
	#echo ${WASUSER}
   	cp ./share/dist/cwas.sh.dist ./cwas 
 	sed -i -e "s:WAS_USER_SHOULD_CHANGE_HERE:${WASUSER}:g" ./cwas
 	sed -i -e "s:WAS_GROUP_SHOULD_CHANGE_HERE:${WASGROUP}:g" ./cwas
 	sed -i -e "s:WAS_USER_SHOULD_CHANGE_HERE:${WASUSER}:g" ./instmanager
 	sed -i -e "s:WAS_GROUP_SHOULD_CHANGE_HERE:${WASGROUP}:g" ./instmanager

	{ 
		chmod 700 ./instmanager
		for ((i = 0 ; i<=100 ; i+=5)); do 
			sleep 0.01
			echo $i
		done
    	chmod 700 ./cwas
    	if [ ! -d instnace ]; then 
        	mkdir -p instance
    	fi
    	chown -R ${WASUSER}:${WASGROUP} ${currentDir} 
	} | whiptail --gauge "Please wait .." 8 50 0 
	whiptail --msgbox "Finish Installation" 8 50 
}
function _setlauncher() 
{
    echo -e "\e[32mCreate launcher ... \e[0m"
    cp share/dist/cwas.sh.dist ./cwas
    #sed -i -e "s:CHANGE_JAVA_HOME:${temp_java_home}:g" launcher.sh 

    chmod 700 ./cwas
    if [ ! -d instnace ]; then 
        mkdir -p instance
    fi
    chown -R ${WAS_USER}. ${currentDir}
}

function _footer() 
{ 
    echo -e "\e[32m -- Please  run addinst.sh before run launcher \e[0m"  
    echo -e "\e[96m #[sudo] sh addinst.sh INSTANCE_NAME [add | remove]\e[0m"
}
JAVA_OPTS="" 



#_tui_front 
#_front 
_tui_install
#_checkuser 

##########################################################
# Disable Set javahome and opts , it moved to addinst.sh # 
##########################################################
#_setjavahome 
#_getjavaversion  
#_setjavaopt   

_tui_setlauncher
#_setlauncher 
#_footer
