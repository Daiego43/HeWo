module_name="modules/$1"
if [ ! -d "$module_name" ]; then
  echo "Module $module_name does not exist."
  exit 1
else
  echo "Running module $module_name..."
  cd "$module_name" || exit 1
  echo $(pwd)
  if [ -f "docker-compose.yaml" ]; then
    docker compose up
  else
    echo "compose found"
    exit 1
  fi
fi
