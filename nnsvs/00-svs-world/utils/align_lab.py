#! /usr/bin/env python3
# coding: utf-8
"""
stage 0
step  2

Get rough alignment between
1) mono-phone labels of singing voice database and
2) generated labels by sinsy

"""

import os
import sys
from glob import glob
from os.path import basename, join, splitext

import config
from fastdtw import fastdtw
from nnmnkwii.io import hts
from util import fix_mono_lab_after_align, ph2numeric, prep_ph2num


def main():
    ph2num = prep_ph2num()
    sinsy_files = sorted(glob(join(config.out_dir, "sinsy_mono_round/*.lab")))
    mono_label_files = sorted(glob(join(config.out_dir, "mono_label_round/*.lab")))

    dst_dir = join(config.out_dir, "mono_dtw")
    os.makedirs(dst_dir, exist_ok=True)

    excludes = []

    for (path1, path2) in zip(sinsy_files, mono_label_files):
        name = basename(path1)
        print(f'  align_lab: {name}')  # progress
        lab_sinsy = hts.load(path1)
        lab_mono_label = hts.load(path2)

        if name in excludes:
            print("Skip!", name)
            continue

        # align two labels roughly based on the phoneme labels
        d, path = fastdtw(ph2numeric(lab_sinsy.contexts, ph2num),
                          ph2numeric(lab_mono_label.contexts, ph2num), radius=len(lab_mono_label))

        # Edit sinsy labels with hand-annontated aligments
        for x, y in path:
            lab_sinsy.start_times[x] = lab_mono_label.start_times[y]
            lab_sinsy.end_times[x] = lab_mono_label.end_times[y]

        lab_sinsy = fix_mono_lab_after_align(lab_sinsy)
        with open(join(dst_dir, name), "w") as of:
            of.write(str(lab_sinsy))
        # print(d)


if __name__ == '__main__':
    print('0-2 start : align_lab.py')
    main()
    print('0-2 finish: align_lab.py')
