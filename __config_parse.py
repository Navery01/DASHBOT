import yaml

with open('configs.yml', 'r') as file:
    CONFIG = yaml.safe_load(file)

TOKEN = CONFIG['TOKEN']