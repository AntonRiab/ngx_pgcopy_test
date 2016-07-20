v0=0

data=""

while [ $v0 -lt 300 ]; do
    data=$(printf "$data\n$v0;tt${v0}")
    if [ $v0 -eq 3 ];then
        printf "$data" | grep -vE '^$' > 003k.data
    fi

    if [ $v0 -eq 99 ];then
        printf "$data" | grep -vE '^$' > 1k.data
    fi
    v0=$(($v0+1))
done

printf "$data" | grep -vE '^$' > 3k.data
