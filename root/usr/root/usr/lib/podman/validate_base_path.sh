#!/bin/sh
# Validação e preparação do base_path do Podman
# Seguro para OpenWrt / sysupgrade

BASE="$1"

[ -z "$BASE" ] && exit 1

case "$BASE" in
    "/"|"/overlay"|"/overlay/"*)
        echo "Caminho inválido: não use / ou /overlay"
        exit 2
    ;;
esac

mkdir -p "$BASE" 2>/dev/null || {
    echo "Não foi possível criar o diretório base"
    exit 3
}

touch "$BASE/.podman_test" 2>/dev/null || {
    echo "Diretório não é gravável"
    exit 4
}
rm -f "$BASE/.podman_test"

PODMAN_BASE="$BASE/podman"

for dir in runtime containers compose backup tmp; do
    mkdir -p "$PODMAN_BASE/$dir" || {
        echo "Falha ao criar $PODMAN_BASE/$dir"
        exit 5
    }
done

exit 0
