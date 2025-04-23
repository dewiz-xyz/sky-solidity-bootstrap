## Sky Solidity Bootstrap

Standardized project structure for Solidity projects following the Sky Protocol's standards.

## Features

- [x] Standard directory structure
- [x] Default `.gitignore`
- [x] Default `.editorconfig` to avoid conflicting editor settings (see [editorconfig](https://editorconfig.org/))
- [x] Includes common dependencies (see [forge-std](https://github.com/makerdao/forge-std) and [dss-test](https://github.com/makerdao/dss-test))
- [x] Includes common script niceties from [dss-test](https://github.com/makerdao/dss-test)
- [x] Includes basic formal verification rules and config for Certora

## Usage

Choose `sky-solidity-bootstrap` template when creating a new repository through the GitHub UI.

### Update Dependencies

This template might have stale dependencies. To update them, run:

```bash
forge update forge-std
forge update dss-test
```

### Deployment Scripts

Simulate the deployment of a `Counter` contract on Mainnet, using the `CounterDeployScript` script.

1. Copy `script/input/1/template-counter-deploy.json` to `script/input/1/counter-deploy.json`.
2. Change the `initial` value in `counter-deploy.json`.
3. Run the deployment script:

```bash
FOUNDRY_EXPORTS_OVERWRITE_LATEST=true FOUNDRY_ROOT_CHAINID=1 FOUNDRY_SCRIPT_CONFIG='counter-deploy' \
    forge script CounterDeployScript --fork-url $ETH_RPC_URL --sender $ETH_FROM -vvv
```

Alternatively, pass the script config as text:

```bash
FOUNDRY_EXPORTS_OVERWRITE_LATEST=true FOUNDRY_ROOT_CHAINID=1 FOUNDRY_SCRIPT_CONFIG_TEXT='{"initial": 42}' \
    forge script CounterDeployScript --fork-url $ETH_RPC_URL --sender $ETH_FROM -vvv
```

Add `--broadcast` to broadcast the transactions.

> [!TIP]
> Notice that `.env` is supported. Check [`.env.example`](./.env.example) for more details.
