health:
	ETCDCTL_API=3 etcdctl endpoint status --endpoints=$(shell hostname -i):2379 --cluster -w table

remove:
	ETCDCTL_API=3 etcdctl member remove $(member) --endpoints=$(shell hostname -i):2379

add:
	ETCDCTL_API=3 etcdctl member add $(member) --peer-urls=http://$(member):2380 --endpoints=$(shell hostname -i):2379

run:
	chmod +x /app/entrypoint.sh
	/app/entrypoint.sh

existing:
	chmod +x /app/entrypoint.sh
	/app/entrypoint.sh existing