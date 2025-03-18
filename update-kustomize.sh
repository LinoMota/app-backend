#!/bin/bash

# esse cara seria executado pelo ci e criaria um commit atualizando a imagem e a tag conforme necessario
# o uso mais comum seria no proprio merge pra dev ou main onde ele criaria um commit nesses branchs e iria sobrescrever com a tag daquele ci executado
# a tag seria por enquanto provavelmente o hash reduzido do commit

# no caso aqui ficaria deploy/$ENV_NAME/kustomization.yaml nome_imagem nova_tag true

# essa ultima flag era simplesmente para indicar se precisa fazer o commit ou nao

ENV_NAME="dev"

KUSTOMIZATION_FILE="deploy/dev/kustomization.yaml"

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Uso: $0 <novo_image_name> <novo_tag> [commit_flag]"
    exit 1
fi

NEW_IMAGE_NAME=$1
NEW_TAG=$2
COMMIT_FLAG=${3:-0}

sed -i "s|newName: .*|newName: ${NEW_IMAGE_NAME}|" "$KUSTOMIZATION_FILE"
sed -i "s|newTag: .*|newTag: ${NEW_TAG}|" "$KUSTOMIZATION_FILE"

echo "Arquivo atualizado com sucesso!"
cat "$KUSTOMIZATION_FILE"

if [ "$COMMIT_FLAG" == "true" ]; then
    git add "$KUSTOMIZATION_FILE"
    git commit -m "chore: update kustomization.yaml image to ${NEW_IMAGE_NAME}:${NEW_TAG}"
    echo "Commit realizado."
fi
