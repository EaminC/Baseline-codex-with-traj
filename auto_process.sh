#!/bin/bash

# Dataset list generated from Excel file
repos=(
"RelTR|https://github.com/yrcong/RelTR"
"Lottory|https://github.com/rahulvigneswaran/Lottery-Ticket-Hypothesis-in-Pytorch"
"SEED-GNN|https://github.com/henryzhongsc/gnn_editing"
"TabPFN|https://github.com/PriorLabs/TabPFN"
"RSNN|https://github.com/fmi-basel/neural-decoding-RSNN"
"P4Ctl|https://github.com/peng-gao-lab/p4control"
"CrossPrefetch|https://github.com/RutgersCSSystems/crossprefetch-asplos24-artifacts"
"SymMC|https://github.com/wenxiwang/SymMC-Tool"
"Fairify|https://github.com/sumonbis/Fairify"
"exli|https://github.com/EngineeringSoftware/exli"
"sixthsense|https://github.com/uiuc-arc/sixthsense"
"probfuzz|https://github.com/uiuc-arc/probfuzz"
"gluetest|https://github.com/seal-research/gluetest"
"flex|https://github.com/uiuc-arc/flex"
"acto|https://github.com/xlab-uiuc/acto"
"Baleen|https://github.com/wonglkd/Baleen-FAST24"
"Silhouette|https://github.com/iaoing/Silhouette"
"anvil|https://github.com/anvil-verifier/anvil"
"ELECT|https://github.com/tinoryj/ELECT"
"rfuse|https://github.com/snu-csl/rfuse"
"Metis|https://github.com/sbu-fsl/Metis"
"facebook_zstd|https://github.com/facebook/zstd"
"jqlang_jq|https://github.com/jqlang/jq"
"ponylang_ponyc|https://github.com/ponylang/ponyc"
"catchorg_Catch2|https://github.com/catchorg/Catch2"
"fmtlib_fmt|https://github.com/fmtlib/fmt"
"nlohmann_json|https://github.com/nlohmann/json"
"simdjson_simdjson|https://github.com/simdjson/simdjson"
"yhirose_cpp-httplib|https://github.com/yhirose/cpp-httplib"
"cli_cli|https://github.com/cli/cli"
"grpc_grpc-go|https://github.com/grpc/grpc-go"
"zeromicro_go-zero|https://github.com/zeromicro/go-zero"
"alibaba_fastjson2|https://github.com/alibaba/fastjson2"
"elastic_logstash|https://github.com/elastic/logstash"
"mockito_mockito|https://github.com/mockito/mockito"
"anuraghazra_github-readme-stats|https://github.com/anuraghazra/github-readme-stats"
"axios_axios|https://github.com/axios/axios"
"expressjs_express|https://github.com/expressjs/express"
"iamkun_dayjs|https://github.com/iamkun/dayjs"
"Kong_insomnia|https://github.com/Kong/insomnia"
"sveltejs_svelte|https://github.com/sveltejs/svelte"
"BurntSushi_ripgrep|https://github.com/BurntSushi/ripgrep"
"clap-rs_clap|https://github.com/clap-rs/clap"
"nushell_nushell|https://github.com/nushell/nushell"
"serde-rs_serde|https://github.com/serde-rs/serde"
"sharkdp_bat|https://github.com/sharkdp/bat"
"sharkdp_fd|https://github.com/sharkdp/fd"
"rayon-rs_rayon|https://github.com/rayon-rs/rayon"
"tokio-rs_bytes|https://github.com/tokio-rs/bytes"
"tokio-rs_tokio|https://github.com/tokio-rs/tokio"
"tokio-rs_tracing|https://github.com/tokio-rs/tracing"
"darkreader_darkreader|https://github.com/darkreader/darkreader"
"mui_material-ui|https://github.com/mui/material-ui"
"vuejs_core|https://github.com/vuejs/core"
)

# Create output directory if it doesn't exist
mkdir -p output

# Get the script's directory (where we'll work)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Process each repository
for entry in "${repos[@]}"; do
  name=$(echo "$entry" | cut -d '|' -f 1)
  url=$(echo "$entry" | cut -d '|' -f 2)

  echo "=========================================="
  echo "Processing: $name"
  echo "=========================================="

  # Step 1: Clone repository if it doesn't exist
  if [ -d "$name" ]; then
    echo "[SKIP] $name already exists, using existing directory"
  else
    echo "[CLONE] Cloning $name ..."
    git clone "$url" "$name"
    if [ $? -ne 0 ]; then
      echo "[ERROR] Failed to clone $name, skipping..."
      continue
    fi
  fi

  # Step 2: cd into the repository
  cd "$name"
  if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to enter $name directory, skipping..."
    cd "$SCRIPT_DIR"
    continue
  fi

  # Step 3: Execute codex command and redirect output to traj.txt
  echo "[EXEC] Running codex command for $name ..."
  
  # Record start time
  EXEC_START_TIME=$(date +%s.%N)
  EXEC_START_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  
  codex -m gpt-4.1-mini exec --yolo "Please take a careful look at the current hardware and repo, and create a new Dockerfile named codex.dockerfile at the root of this repo that, when built, puts me in a /bin/bash CLI setting at the root of the repository, with the repository installed." > traj.txt 2>&1
  
  # Record end time
  EXEC_END_TIME=$(date +%s.%N)
  EXEC_END_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  
  # Calculate execution time
  EXEC_DURATION=$(echo "$EXEC_END_TIME - $EXEC_START_TIME" | bc)
  EXEC_DURATION_ROUNDED=$(printf "%.2f" "$EXEC_DURATION")

  # Step 4: Check if codex.dockerfile was created and set success flag
  CODEX_SUCCESS="false"
  if [ -f "codex.dockerfile" ]; then
    CODEX_SUCCESS="true"
  else
    echo "[WARNING] codex.dockerfile was not created for $name"
  fi

  # Step 5: Create output directory for this repo and move files
  OUTPUT_DIR="$SCRIPT_DIR/output/$name"
  mkdir -p "$OUTPUT_DIR"
  
  # Move codex.dockerfile if it exists
  if [ -f "codex.dockerfile" ]; then
    mv codex.dockerfile "$OUTPUT_DIR/"
    echo "[MOVE] Moved codex.dockerfile to $OUTPUT_DIR/"
  fi
  
  # Move traj.txt
  if [ -f "traj.txt" ]; then
    mv traj.txt "$OUTPUT_DIR/"
    echo "[MOVE] Moved traj.txt to $OUTPUT_DIR/"
  fi

  # Create JSON file with execution time
  JSON_FILE="$OUTPUT_DIR/execution_info.json"
  
  cat > "$JSON_FILE" <<EOF
{
  "repo_name": "$name",
  "repo_url": "$url",
  "execution_start_time": "$EXEC_START_ISO",
  "execution_end_time": "$EXEC_END_ISO",
  "execution_duration_seconds": $EXEC_DURATION_ROUNDED,
  "codex_command_success": $CODEX_SUCCESS
}
EOF
  echo "[INFO] Created execution_info.json with execution time: ${EXEC_DURATION_ROUNDED}s"

  # Step 6: Return to script directory and delete the repo
  cd "$SCRIPT_DIR"
  echo "[CLEAN] Removing $name directory..."
  rm -rf "$name"
  echo "[DONE] Completed processing $name"
  echo ""
done

echo "=========================================="
echo "All repositories processed successfully!"
echo "Results are in the output/ directory"
echo "=========================================="

