#!/bin/sh
exec ssh -i "/home/commandant/RESONANTIA_MASTER/5_INFRA/Vault/SSH/resonantia_deploy_ed25519" -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new "$@"
