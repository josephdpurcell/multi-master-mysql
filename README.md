# Multi-Master MySQL

This demonstrates setting up multi-master MySQL using auto increment offset and auto increment increment configs.

## Gettings Started

```
vagrant up
```

## How conflicts are resolved?

### Left untouched

1. Make a unique key on node1:

```
ALTER TABLE `twitter`.`users` ADD UNIQUE INDEX `name` (`name`);
```

1. Bring down node2.
1. On node1:

```
INSERT INTO `twitter`.`users` (`active_at`, `created_at`, `name`) VALUES (null, null, 'Duplicate Guy');
```

1. Bring down node1.
1. Bring up node2.
1. On node2:

```
INSERT INTO `twitter`.`users` (`active_at`, `created_at`, `name`) VALUES (null, null, 'Duplicate Guy');
```

1. Bring up node1.

You will now see that both nodes have "Duplicate Guy" with different IDs. Running `SHOW SLAVE STATUS\G` on node1 will show an `Error 'Duplicate entry 'Duplicate Guy'`.


## TODOs

* Figure out how to handle adding nodes to existing cluster.
* Demonstrate how to handle high latency in replication.
* How to automatically copy schema to new node.
* How to update a node that is missing a record?
* Use ansible to allow switching from a 2-node to a 3-node and back.
