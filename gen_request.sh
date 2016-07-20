DATA=$(cat $1)
LEN=$(printf "$DATA" | wc -c)

HEADERPART=$(printf "PUT /pub HTTP/1.1
Host: 127.0.0.1")

if [ $# -gt 1 ];then
    echo "Add part"
    exit
fi

printf "${HEADERPART}
Content-Length: $LEN

$DATA"
