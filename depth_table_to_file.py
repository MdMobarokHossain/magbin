#!/usr/bin/env python3

import sys
import os
import errno
import argparse
import hashlib
import subprocess
import shutil
import re

parser = argparse.ArgumentParser()
parser.add_argument("-i", help="[STRING] Input depth file", dest="input", required=True)
parser.add_argument("-p", help="[STRING] Output prefix", dest="prefix", default = ".")
args = parser.parse_args()

dat = dict()
with open(args.input, 'r') as lines:
    first = True
    for line in lines:
        stripline = line.strip()
        splitline = stripline.split('\t')
        if (first):
            headers = splitline
            for i,e in enumerate(headers):
                if headers[i] == "contigName":
                    dat[headers[i]] = []
                elif headers[i] in ["contigLen", "totalAvgDepth"]:
                    next
                elif headers[i].endswith("-var"):
                    next
                else:
                    dat[headers[i]] = []

            first = False
        else:
            line_array = splitline
            for i,e in enumerate(line_array):
                if headers[i] == "contigName":
                    dat[headers[i]].append(line_array[i])
                elif headers[i] in ["contigLen", "totalAvgDepth"]:
                    next
                elif headers[i].endswith("-var"):
                    next
                else:
                    dat[headers[i]].append(line_array[i])

print(dat.keys())

# output_list = open(args.prefix + "/" + re.sub('\.depth', '', os.path.basename(args.input)) + ".depth_list", 'w')
with open(f'{args.input}_list', 'w') as output_list:
    for key in dat:
        if key != "contigName":
            base = re.sub('_nodup\.bam', '', key)
            outfile = args.prefix.rstrip('/') + "/" + base + ".depth"
            output = open(outfile, 'w')
            for i,e in enumerate(dat[key]):
                output.write("{}\t{}\n".format(dat["contigName"][i], dat[key][i]))
            output.close()
            output_list.write("{}\n".format(outfile))
