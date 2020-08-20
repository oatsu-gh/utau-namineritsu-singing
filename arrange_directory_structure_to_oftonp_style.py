#!python
# coding: utf-8
# Copyright (c) oatsu
"""
めっちゃフォルダつくる
ファイルを整頓して、おふとんPの形式に合わせる。
あと .xml を .musicxml にする。
"""
import os
from glob import glob
from shutil import copy2


def main():
    path_dir_in = input('path_dir_in: ')
    path_dir_out = input('path_dir_out: ')
    l_lab_path = glob(f'{path_dir_in}/*.lab')
    l_musicname = [os.path.splitext(os.path.basename(path))[0] for path in l_lab_path]

    for musicname in l_musicname:
        os.makedirs(f'{path_dir_out}/{musicname}', exist_ok=True)
        target_files = glob(f'{path_dir_in}/{musicname}.*')
        for path in target_files:
            copy2(path, f'{path_dir_out}/{musicname}/{os.path.basename(path)}')

    for path_xml in glob(f'{path_dir_out}/**/*.xml', recursive=True):
        path_musicxml = path_xml.replace('.xml', '.musicxml')
        os.rename(path_xml, path_musicxml)


if __name__ == '__main__':
    main()
    input('Press Enter to exit')
