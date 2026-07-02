#!/bin/bash

cd ~/proyecto-ventas || exit

git add .

if git diff --cached --quiet; then
    MENSAJE="Alerta: No se han realizado commits ni hay modificaciones para subir en la semana de $(date +'%Y-%m-%d')."
    echo "$MENSAJE"
    echo "" >> README.md
    echo "- $MENSAJE" >> README.md
    git add README.md
    git commit -m "Alerta semanal: Sin cambios el $(date +'%Y-%m-%d')"
    git push origin develop
else
    ESTADISTICAS=$(git diff --cached --shortstat | xargs)
    MENSAJE="Actualización semanal ($(date +'%Y-%m-%d')): $ESTADISTICAS"
    echo "Se encontraron cambios. $MENSAJE"
    echo "" >> README.md
    echo "- $MENSAJE" >> README.md
    git add README.md
    git commit -m "Upload semanal: $(date +'%Y-%m-%d')"
    git push origin develop
fi