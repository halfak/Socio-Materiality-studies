

dbstore = --defaults-file=~/.my.research.cnf -h analytics-store.eqiad.wmnet \
-u research


datasets/tables/sampled_user.loaded: sql/tables/sampled_user.create_load.sql
	cat sql/tables/sampled_user.create_load.sql |\
	mysql $(dbstore) enwiki > \
	datasets/tables/sampled_user.loaded


########################### First sandbox edit #################################
datasets/first_sandbox_edit.tsv: sql/first_sandbox_edit.sql
	cat sql/first_sandbox_edit.sql |\
	mysql $(dbstore) enwiki >\
	datasets/first_sandbox_edit.tsv

datasets/tables/first_sandbox_edit.created:\
		sql/tables/first_sandbox_edit.create.sql
	cat sql/tables/first_sandbox_edit.create.sql |\
	mysql $(dbstore) enwiki >\
	datasets/tables/first_sandbox_edit.created
	
datasets/tables/first_sandbox_edit.loaded: \
		datasets/tables/first_sandbox_edit.created \
		datasets/first_sandbox_edit.tsv
	ln -sf first_sandbox_edit.tsv datasets/events_first_sandbox_edit && \
	mysql $(dbstore) staging -e "TRUNCATE events_first_sandbox_edit" && \
	mysqlimport $(dbstore)\
		--ignore-lines=1\
		--local staging datasets/events_first_sandbox_edit && \
	rm -f datasets/events_first_sandbox_edit && \
	mysql $(dbstore) staging \
		-e "SELECT COUNT(*), NOW() FROM events_first_sandbox_edit" >\
	datasets/tables/first_sandbox_edit.loaded

datasets/sampled_first_sandbox_edit.tsv: \
		sql/sampled_first_sandbox_edit.sql \
		datasets/tables/first_sandbox_edit.loaded \
		datasets/tables/sampled_user.loaded
	cat sql/sampled_first_sandbox_edit.sql |\
	mysql $(dbstore) staging >\
	datasets/sampled_first_sandbox_edit.tsv

############################ First namespace edit ##############################
datasets/first_namespace_edit.tsv: sql/first_namespace_edit.sql
	cat sql/first_namespace_edit.sql |\
	mysql $(dbstore) enwiki >\
	datasets/first_namespace_edit.tsv

datasets/tables/first_namespace_edit.created:\
		sql/tables/first_namespace_edit.create.sql
	cat sql/tables/first_namespace_edit.create.sql |\
	mysql $(dbstore) enwiki >\
	datasets/tables/first_namespace_edit.created

datasets/tables/first_namespace_edit.loaded: \
		datasets/tables/first_namespace_edit.created \
		datasets/first_namespace_edit.tsv
	ln -sf first_namespace_edit.tsv datasets/events_first_namespace_edit && \
	mysql $(dbstore) staging -e "TRUNCATE events_first_namespace_edit" && \
	mysqlimport $(dbstore)\
		--ignore-lines=1\
		--local staging datasets/events_first_namespace_edit && \
	rm -f datasets/events_first_namespace_edit && \
	mysql $(dbstore) staging \
		-e "SELECT COUNT(*), NOW() FROM events_first_namespace_edit" >\
	datasets/tables/first_namespace_edit.loaded

datasets/sampled_first_namespace_edit.tsv: \
		sql/sampled_first_namespace_edit.sql \
		datasets/tables/first_namespace_edit.loaded \
		datasets/tables/sampled_user.loaded
	cat sql/sampled_first_namespace_edit.sql |\
	mysql $(dbstore) staging >\
	datasets/sampled_first_namespace_edit.tsv
