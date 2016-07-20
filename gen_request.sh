DATA=$(cat $1)
LEN=$(printf "$DATA" | wc -c)

HEADERPART=$(printf "PUT /pub HTTP/1.1
Host: 127.0.0.1")

if [ $# -gt 1 ];then
    authpass=$(echo "$2" | base64)
    HEADERPART=$(printf "$HEADERPART\nAuthorization: Basic ${authpass}\n")
fi

printf "${HEADERPART}
Content-Length: $LEN

$DATA"
