#!/bin/bash

USUARIOS="usuarios.txt"
PRODUCTOS="productos.txt"
LOGUEADO=""

touch "$USUARIOS" "$PRODUCTOS"

registro() {
    read -p "Nuevo usuario: " usr
    read -p "Contraseña: " pass
    echo "$usr:$pass" >> "$USUARIOS"
}

login() {
    read -p "Usuario: " usr
    read -p "Contraseña: " pass
    if grep -q "^$usr:$pass$" "$USUARIOS"; then
        LOGUEADO="$usr"
    else
        echo "Error de credenciales."
    fi
}

alta() {
    [[ -z "$LOGUEADO" ]] && return
    read -p "Nombre: " nom
    read -p "Descripción: " desc
    read -p "Precio: " precio
    read -p "Stock: " stock
    echo "$nom|$desc|$precio|$stock" >> "$PRODUCTOS"
}

venta() {
    [[ -z "$LOGUEADO" ]] && return
    read -p "Producto: " nom
    read -p "Cantidad: " cant
    if grep -q "^$nom|" "$PRODUCTOS"; then
        stock=$(awk -F'|' -v n="$nom" '$1==n {print $4}' "$PRODUCTOS")
        if [[ "$stock" -ge "$cant" ]]; then
            n_stock=$((stock - cant))
            awk -F'|' -v n="$nom" -v ns="$n_stock" 'OFS="|" {if($1==n) $4=ns; print $0}' "$PRODUCTOS" > tmp.txt && mv tmp.txt "$PRODUCTOS"
        else
            echo "Stock insuficiente."
        fi
    else
        echo "Producto no encontrado."
    fi
}

while true; do
    if [[ -z "$LOGUEADO" ]]; then
        echo "1) Registro 2) Login 3) Salir"
        read op
        case $op in
            1) registro ;;
            2) login ;;
            3) exit 0 ;;
        esac
    else
        echo "1) Alta Producto 2) Venta 3) Logout"
        read op
        case $op in
            1) alta ;;
            2) venta ;;
            3) LOGUEADO="" ;;
        esac
    fi
done