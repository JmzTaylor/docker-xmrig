# Xmrig - Monero minner in Docker

[Xmrig](https://xmrig.com/) is an opensource project to mine Monero cryptocurrency. It allow you to mine locally for a "pool", and to get back Monero for your effort.

Here, you can launch xmrig in a docker container to make it easy to launch it on Kubernetes, Swarm, or on local computer using standard docker command.

The image is based on Alpine to reduce size. It works, for now, only on Linux hosts.

- Note: To make the container mining for **your wallet**, you'll need to have a monero wallet (see https://mymonero.com/) and follow instructions. Then change options for the container as explained in the following section
- Note: The Xmrig API is set to port 3000, see documentation: https://github.com/xmrig/xmrig/blob/v3.2.0/doc/API.md
- Note: this is a CPU version of Xmrig, nvidia version will be proposed later, but that's a bit more complex

If you want to donate for that project, here is my Wallet address:

`49Vs6CVAntsQ61Y6ATLCphhbzdAah5mkqcWhx3ayAtsD6NKNMwvvyCpSJsTQtBuzMvXeFqac1NAXZ8NKmDgoN8qtQ1q56ao`
`44vjAVKLTFc7jxTv5ij1ifCv2YCFe3bpTgcRyR6uKg84iyFhrCesstmWNUppRCrxCsMorTP8QKxMrD3QfgQ41zsqMgPaXY5`

Or, use that docker container with default options to give me CPU time.


## Launch it

Simple as a pie:

```bash
docker run --rm -it jmzsoftware/docker-xmrig:latest
```

You can set up the container to **mine for your wallet** (see below), by default (withtout any option) you will mine for me.
That's a nice way to help me, and to pay me a beer **without any cost for you. So thanks ! 🍻** - it's like a donation, thanks if you do it.

To make Xmrig running **for you** (to let you win some XMR on **your** wallet), simply change following options using environment variables:

```bash
export POOL_URL="here, pool url"
export POOL_USER="Your public monero address"
export POOL_PASS="can be empty for some pool, other use that as miner id"

# launch docker container
docker run --name miner --rm -it \
    -e POOL_URL=$POOL_URL \
    -e POOL_USER=$POOL_USER \
    -e POOL_PASS=$POOL_PASS \
    jmzsoftware/docker-xmrig
```
Press CTRL+C to stop container, and it will be removed.

See below for complete environment variable list.

# Default

By default:

- pool server is `xmr.metal3d.org:8080` that is a proxy pool to `gulf.moneroocean.stream`
- user is mine
- password is "donator" + uuid

To not make your CPU burning, this container set:

- number of threads = number CPU / 2
- priority to CPU idle (0) - that makes mining process to be activated only when CPU is not used

Complete list of supported environment variable:

- `POOL_USER`: your wallet address, default to mine
- `POOL_URL`: the pool address, default to `xmr.metal3d.org:8080`
- `POOL_PASS`: the pool password, or worker id, following the pool documentation, default if you mine for me is "donator + uuid"
- `PRIORITY`: CPU priority. 0=idle, 1=normal, 2 to 5 for higher priority
- `THREADS`: number of thread to start, default to number CPU / 2
- `ACCESS_TOKEN`: Bearer access token to access to xmrig API (served on 3000 port), default is a generated token (uuid)
- `ALGO`: mining algorithm https://xmrig.com/docs/algorithms (default is empty)
- `COIN`: that is the coin option instead of algorithm (default is empty)


