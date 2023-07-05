#! /usr/bin/python3
import os
import random

def load(path, name):
    with open('/'.join([path, name])) as f:
        data = [x[:-1] if x.endswith('\n') else x for x in f.readlines()]
        print(data)

if __name__ == '__main__':
    load('./', 'info')
