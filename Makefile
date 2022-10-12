
# include .env file and export its env vars (-include to ignore error if it does not exist)
-include .env

deploy:
	forge create src/SimpleNameRegister.sol:SimpleNameRegister --private-key ${PRIVATE_KEY_EDGE} --rpc-url ${ETH_RPC_URL}

verify:
	forge verify-contract --chain-id ${KOVAN_CHAINID} --compiler-version v0.8.13+commit.abaa5c0e ${CONTRACT_ADDRESS} src/SimpleNameRegister.sol:SimpleNameRegister ${ETHERSCAN_API_KEY} --num-of-optimizations 200 --flatten

verify-check:
	forge verify-check --chain-id ${KOVAN_CHAINID} ${GUID} ${ETHERSCAN_API_KEY}
