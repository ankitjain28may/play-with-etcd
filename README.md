# Play with ETCD

In this, I am trying to create various ways in which an etcd can go down and how you can recover the etcd cluster.

## Usage

1. Run the `docker-compose up` to set up the three docker containers having installed `etcd` and `etcdctl` binary.
2. Now, exec all the 3 containers by running these commands in different shell.

    ```shell
        docker exec -it etcd-1 /bin/bash
    ```

    > Same for other 2 containers.

3. Now run the following command in all the 3 containers:

    ```shell
        make run
    ```

    This will run the etcd on all the 3 container listerning for peers and client traffic.

4. Open another shell and exec in one of the etcd container and check for the etcd cluster health by running this command.

    ```shell
        make health
    ```

    Output will be something like this-

    ```shell
        --------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
        |      ENDPOINT      |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
        +--------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
        | http://etcd-3:2379 | 1e738073e57b0810 |   3.4.7 |   20 kB |      true |      false |         8 |         14 |                 14 |        |
        | http://etcd-2:2379 | 1e738073e57b0810 |   3.4.7 |   20 kB |     false |      false |         8 |         14 |                 14 |        |
        | http://etcd-1:2379 | a3959071884acd0c |   3.4.7 |   20 kB |     false |      false |         8 |         14 |                 14 |        |
        +--------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
    ```

5. Now, kill the etcd process in one of the etcd container and run the above command again. You will see only 2 of the members in the cluster.

6. Let's suppose the data directory is also got corrupted so restarting service won't help it to join the cluster back.

7. Let's remove the member from the existing cluster by running this command on one of the containers on which etcd is running, check by running the `make health` cmd.

    ```shell
        make remove member=<MEMBER_ID>              # 1e738073e57b0810
    ```

8. Now, clear the data from the etcd data directory `/var/etcd`

    ```shell
        rm -rf /var/etcd/*
    ```

9. We will add the new member to our existing etcd cluster by running this command on one of the containers on which etcd is running.

    ```shell
        make add member=<MEMBER_NAME>               # etcd-2
    ```

    We will get an output something like this--

    ```shell

        ETCD_NAME="etcd-2"
        ETCD_INITIAL_CLUSTER="etcd-3=http://etcd-3:2380,etcd-2=http://etcd-2:2380,etcd-1=http://etcd-1:2380"
        ETCD_INITIAL_ADVERTISE_PEER_URLS="http://etcd-2:2380"
        ETCD_INITIAL_CLUSTER_STATE="existing"
    ```

10. Now we will start the etcd service on the container which is faulty by running the following command. As the cluster is existing, we need to pass the `--initial-cluster-state=existing` flag so that etcd member can join the existing etcd cluster.

    ```shell
        make existing
    ```

11. Now run the `make health` command again and you can see the member joined the existing etcd cluster.

**Note 1:** For Reference to command, check the `Makefile` and `entrypoint.sh` file.

**Note 2:** As we are not using TLS, so we haven't passed `--cert=/etc/ssl/etcd/server.crt --cacert=/etc/ssl/etcd/ca.crt --key=/etc/ssl/etcd/server.key` flags.