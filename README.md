https://github.com/ansible/receptor

## What's the main features?

- Allows the invoke process to be executed in a remote machine.
- The nodes in the mesh must be connected to each other, but they don't need to be directly connected.
- It's the communication layer between all Automation Controller components. Example:
    - It behaves like a VPN, incapsulating the data share across `control` node and `execution_node`
- It also works with a socket file.

## Knowledge to understand what Receptor can do

- How Linux file descriptors works
	- The differences between `stdin`, `stdout`, and `stderr`
- How Linux sockets work
	- Mainly how socket files works
- What's the OSI Model (https://en.wikipedia.org/wiki/OSI_model)
	- Layer 3+4+5: How UDP/TCP works?
	- Layer 7: Receptor exists here

## How the Receptor mesh works?

All the components in the Receptor mesh can exchange packages among themselves, even if the components are separated beyond multiple hops (indirect connection).

By default, all the communication is bi-directional.

- Example: https://github.com/ansible/receptor/tree/devel/tools/examples/simple-network

![diagram](https://github.com/ansible/receptor/raw/devel/tools/examples/simple-network/simple-network-diagram.png)

## Security features

Receptor has security features that allows:
- Node authentication, denying access from not knowing nodes
- Firewall-like rules, preventing packaging being forward to no allowed nodes
- Work signed, it restrict the execution of `works` to specific nodes

## How the workunit works?

The `work` is the work that can be invoked, locally or remotely. When invoked, it generates a `workunit`.

Use cases:
- One Receptor node can invoke a local `work`. In this case, it will also responsible for the `workunit` created, including the state handling.
- One Receptor node can invoke a remote `work`. In this case, it will send the request to the remote instance, that instance will be responsible for the execution, and it will report back the state and the output stream.

## The Receptor test suite

- receptor
	- https://github.com/ansible/receptor/tree/devel/tests
	- Written in Golang
	- It tests the receptor binary directly, importing it as a library for the most scenarios

- receptorctl
	- https://github.com/ansible/receptor/tree/devel/receptorctl/tests
	- Written in Python
	- It consumes the receptor as an external package, simulating the integration like we have between the Automation Controller and Receptor

## receptorctl

A Python library that interface with the Receptor mesh.

- It's a python library that can be imported AND it's also a CLI
- It connects to a Linux socket file or TCP socket (so far, we don't have any use case in the Automation Controller that uses the UDP protocol, but the source-code exists in the receptor code-base)

The test suite allows to:
- Test the CLI
- Test the mesh with multiples scenarios