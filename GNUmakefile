CDIR:=$(shell pwd)

all: truncate nginx send
	@echo "DEFAULT OK"

truncate:
	@su postgres -c "psql -d ngx_pgcopy_test_db -c 'TRUNCATE TABLE input_test;'" || \
		su postgres -c "psql -d postgres -f psql.init" 2>/dev/null

nginx:
	@$(shell killall -9 nginx 2> /dev/null)
	@nginx -c ${CDIR}/nginx.conf

send: nginx
	@sh send.sh | nc 127.0.0.1 8080

show:
	@su postgres -c "psql -d ngx_pgcopy_test_db -c 'SELECT * FROM input_test;'"

cleanall:
	@su postgres -c "psql -d postgres -f psql.clean"