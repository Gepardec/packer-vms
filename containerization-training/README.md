# Containerization Training VM

## Building the VM

```
packer build -var 'version=1.2.0' -force box-config.json
```

## Running the VM with vagrant

```
vagrant up
```