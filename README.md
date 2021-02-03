# docker-acme

This is a container to run [acme.sh](https://github.com/acmesh-official/acme.sh). The main selling points of this over the official container are:

- It doesn't run as root.
- It includes openssh and the Docker CLI so you can do things like restart containers or remote into other machines in your `reloadCmd`.

This is probably only really interesting to you if you're using the DNS challenge; since it doesn't run as root, binding to port 80 or 443 would require some trickery, and since I use the DNS challenge, I'm not invested enough to create the trickery.
