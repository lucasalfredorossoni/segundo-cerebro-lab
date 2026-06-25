#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT/.cerebro/neo4j.env"
LOG_FILE="$ROOT/.cerebro/neo4j-console.log"
PID_FILE="$ROOT/.cerebro/neo4j.pid"

usage() {
    cat <<'USAGE'
Uso:
  scripts/neo4j-local.sh start
  scripts/neo4j-local.sh stop
  scripts/neo4j-local.sh status
  scripts/neo4j-local.sh load
  scripts/neo4j-local.sh query <arquivo.cypher>
  scripts/neo4j-local.sh env

Requer .cerebro/neo4j.env com:
  NEO4J_USER
  NEO4J_PASSWORD
  NEO4J_URI
  NEO4J_HTTP
USAGE
}

require_env() {
    if [ ! -f "$ENV_FILE" ]; then
        echo "Arquivo nao encontrado: $ENV_FILE" >&2
        echo "Configure a instancia local antes de usar este script." >&2
        exit 2
    fi

    # shellcheck disable=SC1090
    . "$ENV_FILE"
}

wait_ready() {
    require_env
    for _ in $(seq 1 45); do
        if timeout 5s cypher-shell \
            -a "$NEO4J_URI" \
            -u "$NEO4J_USER" \
            -p "$NEO4J_PASSWORD" \
            "RETURN 1 AS ok;" >/tmp/neo4j-ready.log 2>&1; then
            return 0
        fi
        sleep 2
    done

    cat /tmp/neo4j-ready.log >&2 || true
    return 1
}

start() {
    mkdir -p "$ROOT/.cerebro"

    if neo4j status >/dev/null 2>&1; then
        neo4j status
        return 0
    fi

    setsid neo4j console >"$LOG_FILE" 2>&1 < /dev/null &
    echo "$!" >"$PID_FILE"
    wait_ready
    neo4j status
}

stop() {
    neo4j stop || true
    if [ -f "$PID_FILE" ]; then
        pid="$(cat "$PID_FILE")"
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null || true
        fi
        rm -f "$PID_FILE"
    fi
}

status() {
    require_env
    neo4j status || true
    if timeout 5s cypher-shell \
        -a "$NEO4J_URI" \
        -u "$NEO4J_USER" \
        -p "$NEO4J_PASSWORD" \
        "MATCH (n) RETURN count(n) AS nos;" 2>/dev/null; then
        return 0
    fi
    echo "Bolt ainda nao respondeu." >&2
}

load_graph() {
    require_env
    wait_ready
    cypher-shell -a "$NEO4J_URI" -u "$NEO4J_USER" -p "$NEO4J_PASSWORD" \
        -f "$ROOT/neo4j/schema/segundo-cerebro-schema.cypher"
    cypher-shell -a "$NEO4J_URI" -u "$NEO4J_USER" -p "$NEO4J_PASSWORD" \
        -f "$ROOT/neo4j/seeds/seed-mvp.cypher"
    cypher-shell -a "$NEO4J_URI" -u "$NEO4J_USER" -p "$NEO4J_PASSWORD" \
        "MATCH (n) RETURN labels(n) AS labels, count(*) AS total ORDER BY labels;"
}

query_file() {
    require_env
    file="${1:-}"
    if [ -z "$file" ]; then
        echo "Informe um arquivo .cypher." >&2
        exit 2
    fi
    cypher-shell -a "$NEO4J_URI" -u "$NEO4J_USER" -p "$NEO4J_PASSWORD" \
        -f "$file"
}

show_env() {
    require_env
    echo "NEO4J_USER=$NEO4J_USER"
    echo "NEO4J_PASSWORD=***redacted***"
    echo "NEO4J_URI=$NEO4J_URI"
    echo "NEO4J_HTTP=$NEO4J_HTTP"
}

case "${1:-}" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    load)
        load_graph
        ;;
    query)
        shift
        query_file "$@"
        ;;
    env)
        show_env
        ;;
    -h|--help|help|"")
        usage
        ;;
    *)
        usage >&2
        exit 2
        ;;
esac
