

dbstore = --defaults-file=~/.my.research.cnf -h analytics-store.eqiad.wmnet \
          -u research


datasets/tables/sampled_user.table: sql/tables/sampled_user.create.sql
	cat sql/tables/sampled_user.create.sql |\
	mysql $(dbstore) enwiki > \
	datasets/tables/sampled_user.table
