#!/bin/bash
# ─────────────────────────────────────────────
#  Lancer Patrimoine — double-cliquez ce fichier
# ─────────────────────────────────────────────
cd "$(dirname "$0")"

PORT=8765
# Trouver un port libre
while lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; do
    PORT=$((PORT + 1))
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Patrimoine — démarrage sur le port $PORT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Démarrer le serveur HTTP Python
python3 -m http.server $PORT --bind 127.0.0.1 &
SERVER_PID=$!

sleep 0.8

URL="http://localhost:$PORT/index.html"

# Ouvrir dans Chrome (ou le navigateur par défaut si Chrome absent)
if [ -d "/Applications/Google Chrome.app" ]; then
    open -a "Google Chrome" "$URL"
elif [ -d "/Applications/Chromium.app" ]; then
    open -a "Chromium" "$URL"
else
    open "$URL"
fi

echo ""
echo "  ✓ App ouverte : $URL"
echo "  ✓ Vos données sont sauvegardées localement"
echo ""
echo "  Laissez cette fenêtre ouverte pendant l'utilisation."
echo "  Fermez-la (ou Ctrl+C) pour arrêter."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

trap "kill $SERVER_PID 2>/dev/null; echo 'Serveur arrêté.'" EXIT INT TERM
wait $SERVER_PID
