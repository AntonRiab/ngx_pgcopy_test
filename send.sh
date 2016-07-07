DATA=$(cat data.csv)
LEN=$(printf "$DATA" | wc -c)

printf "PUT /pub HTTP/1.1
Host: 127.0.0.1
Content-Length: $LEN

$DATA"
