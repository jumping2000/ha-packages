#! /usr/bin/python
###########################################################
#                                                         #
#                       AUTO_CONFIG                       #
#          Copyright @ 2023 github.com/jumping2000        #
#                   All rights reserved                   #
#  Do not copy, distribute, or modify without permission  #
#                                                         #
###########################################################
## version 1.2
import yaml
import argparse

def read_keys(file_path):
    try:
        with open(file_path, 'r') as file:
            parameters = [line.strip() for line in file]
        return parameters
    except IOError:
        print("Error occurred while reading keys file.")

def parse_yaml_file(file_path):
    with open(file_path, 'r') as file:
        try:
            data = yaml.safe_load(file)
        except yaml.YAMLError as ex:
            print(ex)
    return data

def search_replace_tags(file_path, tags_dict):
    print("\nReplacing...")
    try:
        with open(file_path, 'r') as file:
            text = file.read()
        count = 0
        for tag, replacement in tags_dict.items():
            text, num_replacements = text.replace(tag, replacement), text.count(tag)
            count += num_replacements
        with open(file_path, 'w') as file:
            file.write(text)
        if count == 0:
            print(f"Nothing to do with {file_path}")
        else:
            print(f"Tags replaced successfully with {file_path}.\nTotal replacements: {count}")
    except IOError:
        print("Error occurred while reading or writing the file.")

def to_list(obj):
    if isinstance(obj, dict):
        return [obj]
    else:
        return obj
#################################################
parser = argparse.ArgumentParser(description="Automatic personalization of packages and cards v1.2 - Copyright @ 2023 github.com/jumping2000. All rights reserved",formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("-v", "--verbose", action="store_true", help="increase verbosity")
parser.add_argument("-a", "--automation_path",help="automation path/file.yaml location")
parser.add_argument("-p", "--package_path", help="package path/file.yaml location")
parser.add_argument("-c", "--card_path", help="card path/file.yaml location")
parser.add_argument("-k", "--keys_path", help="keys path/keys.txt location")
args = parser.parse_args()
config = vars(args)
print(config)

if args.automation_path:
    file_read_path = args.automation_path
else:
   file_read_path = '/config/automations.yaml'

if args.keys_path:
    keys_path = args.keys_path
else:
    keys_path = '/config/packages/keys.txt'
#################################################
parsed_data = to_list(parse_yaml_file(file_read_path))
key_list = read_keys(keys_path)
parsed_data.reverse()
list_entities = []

if (".yaml" in key_list[0] and ".yaml" in key_list[1]):
    package_write_path = key_list[0]
    card_write_path = key_list[1]
print(f"\n")
for k in key_list:
    if k in parsed_data[0]['use_blueprint']['input']:
        value = parsed_data[0]['use_blueprint']['input'][k]
        if args.verbose:
            print(f"Key '{k}' found in blueprint dict. Value: {value}")
        list_entities.append(value)
    elif '/config' not in k:
        list_entities.append("ENTITA' NON NEL BLUEPRINT")
        print(f"Key '{k}' not found in the blueprint dict.")
#################################################
if args.verbose:
    print(f"\nList of entities: {list_entities}")
if args.package_path:
    package_write_path = args.package_path
if args.card_path:
    card_write_path = args.card_path
tags_to_replace = {}
for index, element in enumerate(list_entities):
    if index < 10:
        str_index = '0' + str(index)
    else:
        str_index = str(index)
    tags_to_replace["TAG_"+ str_index] = element
if args.verbose:
    print(f"Tags to replace with entities: {tags_to_replace}")
## PACKAGES
search_replace_tags(package_write_path, tags_to_replace)
## CARDS
search_replace_tags(card_write_path, tags_to_replace)
###########################################################
#                                                         #
#                          END                            #
#                                                         #
###########################################################