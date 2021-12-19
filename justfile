set dotenv-load := true

list:
  just -l

load DAY:
  ./load_data.py {{DAY}}

run DAY: (load DAY)
