

while true; do
  rand_wll="$(find ~/wallpapers/ -maxdepth 1 -type f | shuf -n 1)"
  echo $rand_wll
  swww  img $rand_wll
  sleep 10
done
