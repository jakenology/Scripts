#!/bin/bash
# PassGEN
# Random Password Generator
# https://www.redlever-solutions.com/blog/howto-generate-secure-passwords-with-openssl
LENGTH=8
setupVars="/etc/pihole/setupVars.conf"
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
                    body {color: red;}
                </style>
            </head>
            <body>
                <p>Hello, admin! Here's your Pi-hole admin password for today:</p>
                <p>$password</p>
            </body>
        </html>
EOM
    (
    echo "From: jaykepeters@gmail.com"
    echo "To: support@jpits.us"
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
