

dbstore = --defaults-file=~/.my.research.cnf -h analytics-store.eqiad.wmnet \
-u research


datasets/tables/sampled_user.loaded: sql/tables/sampled_user.create_load.sql
	cat sql/tables/sampled_user.create_load.sql |\
	mysql $(dbstore) enwiki > \
	datasets/tables/sampled_user.loaded

datasets/sampled_user.tsv: datasets/tables/sampled_user.loaded
	mysql $(dbstore) staging \
		-e "SELECT * FROM staging.events_sampled_user" > \
	datasets/sampled_user.tsv


########################### First sandbox edit #################################
datasets/sampled_first_sandbox_edit.tsv: \
		sql/sampled_first_sandbox_edit.sql \
		datasets/tables/sampled_user.loaded
	cat sql/sampled_first_sandbox_edit.sql |\
	mysql $(dbstore) enwiki >\
	datasets/sampled_first_sandbox_edit.tsv

############################ First namespace edit ##############################
datasets/sampled_first_namespace_edit.tsv: \
		sql/sampled_first_namespace_edit.sql \
		datasets/tables/sampled_user.loaded
	cat sql/sampled_first_namespace_edit.sql |\
	mysql $(dbstore) enwiki >\
	datasets/sampled_first_namespace_edit.tsv

############################ First wikiproject edit ############################
datasets/sampled_first_wikiproject_edit.tsv: \
		sql/sampled_first_wikiproject_edit.sql \
		datasets/tables/sampled_user.loaded
	cat sql/sampled_first_wikiproject_edit.sql |\
	mysql $(dbstore) enwiki >\
	datasets/sampled_first_wikiproject_edit.tsv

############################ First portal edit #################################
datasets/sampled_first_portal_edit.tsv: \
		sql/sampled_first_portal_edit.sql \
		datasets/tables/sampled_user.loaded
	cat sql/sampled_first_portal_edit.sql |\
	mysql $(dbstore) enwiki >\
	datasets/sampled_first_portal_edit.tsv
