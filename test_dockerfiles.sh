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

# Get the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Statistics
TOTAL=0
BUILD_SUCCESS=0
RUN_SUCCESS=0
NO_DOCKERFILE=0
BUILD_FAILED=0
RUN_FAILED=0

# Results log
RESULTS_FILE="docker_test_results.json"
RESULTS_LOG="docker_test_log.txt"

# Initialize results file
echo "[" > "$RESULTS_FILE"
FIRST_ENTRY=true

# Process each repository
for entry in "${repos[@]}"; do
  name=$(echo "$entry" | cut -d '|' -f 1)
  url=$(echo "$entry" | cut -d '|' -f 2)
  
  TOTAL=$((TOTAL + 1))
  
  echo "=========================================="
  echo "[$TOTAL/${#repos[@]}] Testing: $name"
  echo "=========================================="
  echo "[$TOTAL/${#repos[@]}] Testing: $name" >> "$RESULTS_LOG"
  
  # Check if codex.dockerfile exists in output directory
  DOCKERFILE_PATH="$SCRIPT_DIR/output/$name/codex.dockerfile"
  
  if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "[SKIP] No codex.dockerfile found for $name"
    echo "[SKIP] No codex.dockerfile found for $name" >> "$RESULTS_LOG"
    NO_DOCKERFILE=$((NO_DOCKERFILE + 1))
    
    # Add to results
    if [ "$FIRST_ENTRY" = false ]; then
      echo "," >> "$RESULTS_FILE"
    fi
    cat >> "$RESULTS_FILE" <<EOF
  {
    "repo_name": "$name",
    "repo_url": "$url",
    "status": "no_dockerfile",
    "build_success": false,
    "run_success": false
  }
EOF
    FIRST_ENTRY=false
    continue
  fi
  
  # Step 1: Clone repository
  echo "[CLONE] Cloning $name ..."
  echo "[CLONE] Cloning $name ..." >> "$RESULTS_LOG"
  
  if [ -d "$name" ]; then
    echo "[CLEAN] Removing existing $name directory..."
    rm -rf "$name"
  fi
  
  git clone "$url" "$name" > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to clone $name"
    echo "[ERROR] Failed to clone $name" >> "$RESULTS_LOG"
    BUILD_FAILED=$((BUILD_FAILED + 1))
    
    # Add to results
    if [ "$FIRST_ENTRY" = false ]; then
      echo "," >> "$RESULTS_FILE"
    fi
    cat >> "$RESULTS_FILE" <<EOF
  {
    "repo_name": "$name",
    "repo_url": "$url",
    "status": "clone_failed",
    "build_success": false,
    "run_success": false
  }
EOF
    FIRST_ENTRY=false
    continue
  fi
  
  # Step 2: Copy codex.dockerfile to repo root
  cd "$name"
  if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to enter $name directory"
    cd "$SCRIPT_DIR"
    rm -rf "$name"
    continue
  fi
  
  cp "$DOCKERFILE_PATH" ./codex.dockerfile
  echo "[COPY] Copied codex.dockerfile to repo root"
  echo "[COPY] Copied codex.dockerfile to repo root" >> "$SCRIPT_DIR/$RESULTS_LOG"
  
  # Step 3: Try to build Docker image
  echo "[BUILD] Building Docker image for $name ..."
  echo "[BUILD] Building Docker image for $name ..." >> "$SCRIPT_DIR/$RESULTS_LOG"
  
  # Convert name to lowercase for Docker image name (Docker requires lowercase)
  NAME_LOWER=$(echo "$name" | tr '[:upper:]' '[:lower:]')
  IMAGE_NAME="test-${NAME_LOWER}-$(date +%s)"
  
  # Build with output displayed in real-time and also saved
  # Use --no-cache to force a fresh build every time
  echo "----------------------------------------"
  echo "Docker Build Output for $name:"
  echo "----------------------------------------"
  docker build --no-cache -f codex.dockerfile -t "$IMAGE_NAME" . 2>&1 | tee -a "$SCRIPT_DIR/$RESULTS_LOG"
  BUILD_EXIT_CODE=${PIPESTATUS[0]}
  echo "----------------------------------------"
  
  # Initialize status variables
  BUILD_STATUS=false
  RUN_STATUS=false
  
  if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo "[BUILD] ✓ Build successful for $name"
    echo "[BUILD] ✓ Build successful for $name" >> "$SCRIPT_DIR/$RESULTS_LOG"
    BUILD_SUCCESS=$((BUILD_SUCCESS + 1))
    BUILD_STATUS=true
    
    # Step 4: Try to run Docker container
    echo "[RUN] Running Docker container for $name ..."
    echo "[RUN] Running Docker container for $name ..." >> "$SCRIPT_DIR/$RESULTS_LOG"
    echo "----------------------------------------"
    echo "Docker Run Output for $name:"
    echo "----------------------------------------"
    
    # Run with a timeout (10 seconds) and a simple command, display output in real-time
    timeout 10 docker run --rm "$IMAGE_NAME" /bin/bash -c "echo 'Container started successfully'" 2>&1 | tee -a "$SCRIPT_DIR/$RESULTS_LOG"
    RUN_EXIT_CODE=${PIPESTATUS[0]}
    echo "----------------------------------------"
    
    if [ $RUN_EXIT_CODE -eq 0 ]; then
      echo "[RUN] ✓ Run successful for $name"
      echo "[RUN] ✓ Run successful for $name" >> "$SCRIPT_DIR/$RESULTS_LOG"
      RUN_SUCCESS=$((RUN_SUCCESS + 1))
      RUN_STATUS=true
    else
      echo "[RUN] ✗ Run failed for $name (exit code: $RUN_EXIT_CODE)"
      echo "[RUN] ✗ Run failed for $name (exit code: $RUN_EXIT_CODE)" >> "$SCRIPT_DIR/$RESULTS_LOG"
      RUN_FAILED=$((RUN_FAILED + 1))
      RUN_STATUS=false
    fi
  else
    echo "[BUILD] ✗ Build failed for $name (exit code: $BUILD_EXIT_CODE)"
    echo "[BUILD] ✗ Build failed for $name (exit code: $BUILD_EXIT_CODE)" >> "$SCRIPT_DIR/$RESULTS_LOG"
    BUILD_FAILED=$((BUILD_FAILED + 1))
    BUILD_STATUS=false
    RUN_STATUS=false
  fi
  
  # Clean up image - always delete regardless of build/run success or failure
  echo "[CLEAN] Removing Docker image $IMAGE_NAME ..."
  echo "[CLEAN] Removing Docker image $IMAGE_NAME ..." >> "$SCRIPT_DIR/$RESULTS_LOG"
  docker rmi "$IMAGE_NAME" > /dev/null 2>&1 || true
  # Also try to remove by ID if name removal failed (for failed builds)
  docker images -q "$IMAGE_NAME" | xargs -r docker rmi > /dev/null 2>&1 || true
  
  # Step 5: Return to script directory and clean up
  cd "$SCRIPT_DIR"
  echo "[CLEAN] Removing $name directory..."
  rm -rf "$name"
  
  # Add to results
  if [ "$FIRST_ENTRY" = false ]; then
    echo "," >> "$RESULTS_FILE"
  fi
  
  # Convert boolean to lowercase string for JSON
  BUILD_JSON="false"
  RUN_JSON="false"
  if [ "$BUILD_STATUS" = true ]; then
    BUILD_JSON="true"
  fi
  if [ "$RUN_STATUS" = true ]; then
    RUN_JSON="true"
  fi
  
  cat >> "$RESULTS_FILE" <<EOF
  {
    "repo_name": "$name",
    "repo_url": "$url",
    "status": "tested",
    "build_success": $BUILD_JSON,
    "run_success": $RUN_JSON
  }
EOF
  FIRST_ENTRY=false
  
  echo ""
done

# Close JSON array
echo "" >> "$RESULTS_FILE"
echo "]" >> "$RESULTS_FILE"

# Print summary
echo "=========================================="
echo "Docker Test Summary"
echo "=========================================="
echo "Total repositories: $TOTAL"
echo "No Dockerfile found: $NO_DOCKERFILE"
echo "Build successful: $BUILD_SUCCESS"
echo "Build failed: $BUILD_FAILED"
echo "Run successful: $RUN_SUCCESS"
echo "Run failed: $RUN_FAILED"
# Calculate success rates
TESTED=$((TOTAL - NO_DOCKERFILE))
if [ $TESTED -gt 0 ]; then
  BUILD_RATE=$(( BUILD_SUCCESS * 100 / TESTED ))
  RUN_RATE=$(( RUN_SUCCESS * 100 / TESTED ))
else
  BUILD_RATE=0
  RUN_RATE=0
fi

echo "Success rate (Build): ${BUILD_RATE}%"
echo "Success rate (Run): ${RUN_RATE}%"
echo "=========================================="

# Append summary to log
echo "" >> "$RESULTS_LOG"
echo "==========================================" >> "$RESULTS_LOG"
echo "Docker Test Summary" >> "$RESULTS_LOG"
echo "==========================================" >> "$RESULTS_LOG"
echo "Total repositories: $TOTAL" >> "$RESULTS_LOG"
echo "No Dockerfile found: $NO_DOCKERFILE" >> "$RESULTS_LOG"
echo "Build successful: $BUILD_SUCCESS" >> "$RESULTS_LOG"
echo "Build failed: $BUILD_FAILED" >> "$RESULTS_LOG"
echo "Run successful: $RUN_SUCCESS" >> "$RESULTS_LOG"
echo "Run failed: $RUN_FAILED" >> "$RESULTS_LOG"
echo "Success rate (Build): ${BUILD_RATE}%" >> "$RESULTS_LOG"
echo "Success rate (Run): ${RUN_RATE}%" >> "$RESULTS_LOG"

echo ""
echo "Results saved to:"
echo "  - $RESULTS_FILE (JSON format)"
echo "  - $RESULTS_LOG (Text log)"

# Final cleanup: remove any dangling images and build cache from Docker
echo ""
echo "[CLEANUP] Removing dangling Docker images..."
echo "[CLEANUP] Removing dangling Docker images..." >> "$RESULTS_LOG"
docker image prune -f > /dev/null 2>&1 || true

echo "[CLEANUP] Removing Docker build cache..."
echo "[CLEANUP] Removing Docker build cache..." >> "$RESULTS_LOG"
docker builder prune -af > /dev/null 2>&1 || true

echo "[CLEANUP] Cleanup completed"
echo "[CLEANUP] Cleanup completed" >> "$RESULTS_LOG"

