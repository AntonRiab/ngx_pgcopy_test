CDIR:=$(shell pwd)

all: 
	@make 003k.diff; make 1k.diff; make 3k.diff; make priv.diff; make result

truncate:
	@su postgres -c "psql -d ngx_pgcopy_test_db -c 'TRUNCATE TABLE input_test;'" || su postgres -c "psql -d postgres -f psql.init" 2>/dev/null

nginx:
	@$(shell killall -9 nginx 2> /dev/null)
	@nginx -c ${CDIR}/nginx.conf

##############################
003k.data:
	@$(shell sh mk_data.sh)

1k.data:
	@$(shell sh mk_data.sh)

3k.data:
	@$(shell sh mk_data.sh)

##############################
put003k: truncate 003k.data
	@echo "Send $@"
	@$(shell sh gen_request.sh 003k.data | nc 127.0.0.1 8080)

put1k: truncate 1k.data
	@echo "Send $@"
	@$(shell sh gen_request.sh 1k.data | nc 127.0.0.1 8080)

put3k: truncate 3k.data
	@echo "Send $@"
	@$(shell sh gen_request.sh 3k.data | nc 127.0.0.1 8080)

putpriv: truncate 003k.data
	@echo "Send $@"
	@$(shell sh gen_request.sh 003k.data "ngx_pgcopy_test_usr:123" | nc 127.0.0.1 8080)

##############################
003k.out: put003k
	@curl -f "http://127.0.0.1:8080/pub" -o 003k.out 2> /dev/null; exit 0

1k.out: put1k
	@curl -f "http://127.0.0.1:8080/pub" -o 1k.out 2> /dev/null; exit 0

3k.out: put3k
	@curl -f "http://127.0.0.1:8080/pub" -o 3k.out 2> /dev/null; exit 0

priv.out: putpriv
	@curl -f "http://127.0.0.1:8080/pub" -o 3k.out 2> /dev/null; exit 0

##############################
003k.diff: 003k.out
	@diff 003k.data 003k.out > 003k.diff

1k.diff: 1k.out
	@diff 1k.data 1k.out > 1k.diff

3k.diff: 3k.out
	@diff 3k.data 3k.out > 3k.diff

priv.diff: priv.out
	@diff 003k.data priv.out > priv.diff
##############################
result:
	@ls -l | awk '/diff/{ if($$5 == "0")print "ok   ", $$9; else print "error", $$9}'

show:
	@su postgres -c "psql -d ngx_pgcopy_test_db -c 'SELECT * FROM input_test;'"

clean:
	rm *.data *.diff *.get *~ *.out

cleanall: clean
	@su postgres -c "psql -d postgres -f psql.clean"

debug: nginx
	@gdb -p `ps ax | awk '/nginx: worker/ && !/awk/{print $1}'`


#1k.data
#1k.put
#1k.get
#1k.test
