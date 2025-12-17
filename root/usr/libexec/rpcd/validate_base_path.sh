#!/bin/sh
# Validação e preparação do base_path do Podman
# Seguro para OpenWrt / sysupgrade

BASE="$1"

[ -z "$BASE" ] && exit 1

# Bloqueios críticos
case "$BASE" in
    "/"|"/overlay"|"/overlay/"*)
        echo "Caminho inválido: não use / ou /overlay"
        exit 2
    ;;
esac

# Criar diretório base se não existir
mkdir -p "$BASE" 2>/dev/null || {
    echo "Não foi possível criar o diretório base"
    exit 3
}

# Testar escrita
touch "$BASE/.podman_test" 2>/dev/null || {
    echo "Diretório não é gravável"
    exit 4
}
rm -f "$BASE/.podman_test"

# Estrutura fixa do Podman
PODMAN_BASE="$BASE/podman"

for dir in runtime containers compose backup tmp; do
    mkdir -p "$PODMAN_BASE/$dir" || {
        echo "Falha ao criar $PODMAN_BASE/$dir"
        exit 5
    }
done

exit 0
