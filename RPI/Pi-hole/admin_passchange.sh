#!/bin/bash
# PassGEN
# Random Password Generator
# https://www.redlever-solutions.com/blog/howto-generate-secure-passwords-with-openssl
LENGTH=8
setupVars="/etc/pihole/setupVars.conf"
hostname=$(hostname)
sender=""
recipient=""
function generatepass() {
    if [ ! -z "$1" ] && [ $1 -gt 1 ]; then
    LENGTH=$1
    fi
    NUMBYTES=`echo $LENGTH | awk '{print int($1*1.16)+1}'`
    password=$(openssl rand -base64 $NUMBYTES | tr -d "=+/" | cut -c1-$LENGTH)
}

function changepass() {
    HashPassword() {
        # Compute password hash twice to avoid rainbow table vulnerability
        return=$(echo -n ${1} | sha256sum | sed 's/\s.*$//')
        return=$(echo -n ${return} | sha256sum | sed 's/\s.*$//')
        echo ${return}
    }
    add_setting() {
        echo "${1}=${2}" >> "${setupVars}"
    }
    delete_setting() {
        sed -i "/${1}/d" "${setupVars}"
    }   
    change_setting() {
        delete_setting "${1}"
        add_setting "${1}" "${2}"
    }
    SetWebPassword() {
        hash=$(HashPassword "$password")
        change_setting "WEBPASSWORD" "${hash}"
    }

    SetWebPassword
    echo "Password Changed!"
}
function sendemail() {
    read -r -d '' body <<- EOM
        <html>
            <head>
                <style>
                    #password {
                        color: transparent;
                        text-shadow: 0 0 5px rgba(0,0,0,0.5);
                    }
                    #password:hover {
                        color: black;
                        font-weight: bold;
                        text-shadow: none;
                        transition-delay: 0s;
                    }
                </style>
            </head>
            <body>
                <p>Hi, Admin</p>
                <p>This is an automatically generated message to inform you of the current password for your Pi-hole, for which the details can be found below.</p>
                <p>Hostname: $hostname</p>
                <p>Password: <a id="password">$password</a></p>
                <p>Enjoy your day, with out ads ;)</p>
            </body>
        </html>
EOM
    (
    echo "From: $sender"
    echo "To: $recipient"
    echo "Subject: Pi-hole Admin Interface Password"
    echo "Content-Type: text/html"
    echo "MIME-Version: 1.0"
    echo $body;
    )| /usr/sbin/sendmail -t
}

function main() {
    generatepass
    changepass
    sendemail
}

main
