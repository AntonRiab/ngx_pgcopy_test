CDIR:=$(shell pwd)

all: 
	@make 003k.diff && make 1k.diff && make 3k.diff && make priv.diff && make result

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
	@curl -X PUT -T $(word 2,$^) http://127.0.0.1:8080/pub

put1k: truncate 1k.data
	@echo "Send $@"
	@curl -X PUT -T $(word 2,$^) http://127.0.0.1:8080/pub

put3k: truncate 3k.data
	@echo "Send $@"
	@curl -X PUT -T $(word 2,$^) http://127.0.0.1:8080/pub

putpriv: truncate 003k.data
	@echo "Send $@"
	@curl -u ngx_pgcopy_test_usr:123 -f -X PUT -T 003k.data "http://127.0.0.1:8080/prv"

##############################
003k.out: put003k
	@curl -f "http://127.0.0.1:8080/pub" -o $@ 2> /dev/null

1k.out: put1k
	@curl -f "http://127.0.0.1:8080/pub" -o 1k.out 2> /dev/null

3k.out: put3k
	@curl -f "http://127.0.0.1:8080/pub" -o 3k.out 2> /dev/null

priv.out: putpriv
	@curl -u ngx_pgcopy_test_usr:123 -f "http://127.0.0.1:8080/prv" -o priv.out 2> /dev/null

putbad: 003k.data
	cat 003k.data | sed 's/3;tt3/3;t;t/' | curl -X PUT -T - http://127.0.0.1:8080/pub

##############################
003k.diff: 003k.out
	@echo "Make diff $@"
	@test -s $(word 2,$^)
	@cat $< | grep -vE '^$$' | diff $(@:.diff=).data - > $@

1k.diff: 1k.out
	@echo "Make diff $@"
	@test -s $(word 2,$^)
	@cat $< | grep -vE '^$$' | diff $(@:.diff=).data - > $@

3k.diff: 3k.out
	@echo "Make diff $@"
	@test -s $(word 2,$^)
	@cat $< | grep -vE '^$$' | diff $(@:.diff=).data - > $@

priv.diff: priv.out
	@echo "Make diff $@"
	@test -s $(word 2,$^)
	@cat $< | grep -vE '^$$' | diff 003k.data - > $@
##############################
result:
	@ls -l | awk '/diff/{ if($$5 == "0")print "ok   ", $$9; else print "error", $$9}'

showtable:
	@su postgres -c "psql -d ngx_pgcopy_test_db -c 'SELECT * FROM input_test;'"

showput: 003k.data
	@sh gen_request.sh 003k.data | nc 127.0.0.1 8080

showget:
	@printf "GET /pub HTTP/1.1\nHost: 127.0.0.1\n\n" | nc 127.0.0.1 8080

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
