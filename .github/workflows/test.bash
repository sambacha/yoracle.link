#!/usr/bin/env bash


#NETWORKS=("mainnet" "kovan" "rinkeby" "ropsten" "goerli" "testnet")
NETWORKS=("mainnet")

ETH_ADDR=(
    ""
)

YFI_ADDR=(
    ""
)

USDC_ADDR=(
    ""
)

function call {
    RET=$(seth storage $1 $2 --rpc-url=$3)
    DEC=$(seth --to-dec ${RET:34})
    LEN=${#DEC}
    IDX="$(($LEN - 18))"
    echo "${DEC::$IDX}.${DEC:$IDX:$LEN}"
}

function callCurrentPrice {
    echo $4

    case $4 in
        "USDC")
            call $1 2 $2
            ;;
        *)
            call $1 3 $2
            ;;
    esac
}

function printPrices {
    NET=${NETWORKS[$1]}
    ENDPOINT="https://$NET.infura.io/v3/${PROJECT_ID}"

    callCurrentPrice ${ETH_ADDR[$1]} $ENDPOINT $NET "ETH"
    callCurrentPrice ${BAT_ADDR[$1]} $ENDPOINT $NET "YFI"
    callCurrentPrice ${USDC_ADDR[$1]} $ENDPOINT $NET "USDC"
}

for idx in "${!NETWORKS[@]}"; do printPrices $idx; done
