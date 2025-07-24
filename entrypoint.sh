#!/usr/bin/env bash

cat > eula.txt << EOF
eula=$EULA
EOF

exec "$@"
