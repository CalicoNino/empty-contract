# Contract optiimization
docker run --rm -v "$(pwd)":/code --mount type=volume,source="$(basename "$(pwd)")_cache",target=/target --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry cosmwasm/optimizer:0.15.0

# chain config
nibid config chain-id nibiru-testnet-2
nibid config broadcast-mode sync
nibid config node "https://rpc.testnet-2.nibiru.fi:443"
nibid config keyring-backend os
nibid config output json

FROM=nibi1hqg0mtw8we609tqtpyjxjrnhq6fl73ns8c2h5m

TXHASH="$(nibid tx wasm store artifacts/contract.wasm \
    --from $FROM \
    --gas auto \
    --gas-adjustment 1.5 \
    --gas-prices 0.025unibi \
    --yes | jq -rcs '.[0].txhash')"
echo 'TXHASH:'
echo $TXHASH
sleep 6
nibid q tx $TXHASH >txhash.json
CODE_ID="$(cat txhash.json | jq -r '.logs[0].events[1].attributes[1].value')"
echo 'CODE_ID:'
echo $CODE_ID

echo "{\"admins\": [\"$FROM\"]}" | jq . | tee example_instantiate_args.json

sleep 10

TXHASH_INIT="$(nibid tx wasm instantiate $CODE_ID \
    "$(cat example_instantiate_args.json)" \
    --admin "$FROM" \
    --label "contract" \
    --from $FROM \
    --gas auto \
    --gas-adjustment 1.5 \
    --gas-prices 0.025unibi \
    --yes | jq -rcs '.[0].txhash')"

echo 'TXHASH_INIT:'
echo $TXHASH_INIT
sleep 6
nibid q tx $TXHASH_INIT >txhash.init.json

CONTRACT_ADDRESS="$(cat txhash.init.json | jq -r '.logs[0].events[1].attributes[0].value')"
echo 'CONTRACT_ADDRESS:'
echo $CONTRACT_ADDRESS

nibid query wasm contract-state smart $CONTRACT_ADDRESS '{"Greet": {}}'

nibid query wasm contract-state smart $CONTRACT_ADDRESS '{"GetPrice": { "pair": "ueth:uusd" }}'
