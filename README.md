## Solidity Project Bootstrap

Standardized project structure for Solidity projects.

## Features

- [ ] Standard directory structure for Dewiz Solidity projects.
- [ ] Default `.editorconfig` to avoid conflicting editor settings (see [editorconfig](https://editorconfig.org/)).
- [ ] Includes common dependencies (see [forge-std](https://github.com/makerdao/forge-std) and [dss-test](https://github.com/makerdao/dss-test)).

## Usage

Choose `solidity-project-bootstrap` template when creating a new repository through the GitHub UI.

### Update Dependencies

This template might have stale dependencies. To update them, run:

```
forge update forge-std
forge update dss-test
```

### Deployment Scripts

Simulate the deployment of a `Counter` contract on Mainnet, using the `CounterDeployScript` script.

```bash
FOUNDRY_ROOT_CHAINID=1 FOUNDRY_SCRIPT_CONFIG_TEXT="{}" \
    forge script CounterDeployScript --fork-url $ETH_RPC_URL --sender $ETH_FROM -vvv 
```

Add `--broadcast` to broadcast the transactions.

