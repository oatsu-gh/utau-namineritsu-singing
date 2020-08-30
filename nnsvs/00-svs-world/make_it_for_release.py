#! /usr/bin/env python3
# coding: utf-8
# Copyright (c) oatsu
"""
配布用フォルダを準備する
"""

from glob import glob
from os import makedirs
from shutil import copy2

from tqdm import tqdm

SINGER = 'utau_ritsu'
PATH_QUESTION = 'conf/jp_qst001_nnsvs_simple_3.hed'
NAME_EXPERIMENT = 'utau_ritsu_simple_qst_3'


def copy_question(path_question):
    """
    hedファイル(question)をコピー
    """
    makedirs('release/conf', exist_ok=True)
    print('copying question')
    copy2(path_question, f'release/{path_question}')


def copy_scaler(singer):
    """
    dumpフォルダにあるファイルをコピー
    """
    makedirs(f'release/dump/{singer}/norm', exist_ok=True)
    list_path_scaler = glob(f'dump/{singer}/norm/*_scaler.joblib')

    print('copying scaler')
    for path_scaler in tqdm(list_path_scaler):
        copy2(path_scaler, f'release/{path_scaler}')


def copy_model(name_exp):
    """
    name_exp: 試験のID
    """
    makedirs(f'release/exp/{name_exp}/acoustic', exist_ok=True)
    makedirs(f'release/exp/{name_exp}/duration', exist_ok=True)
    makedirs(f'release/exp/{name_exp}/timelag', exist_ok=True)
    list_path_model = glob(f'exp/{name_exp}/*/latest.pth')
    list_path_model += glob(f'exp/{name_exp}/*/model.yaml')

    print('copying model')
    for path_model in tqdm(list_path_model):
        copy2(path_model, f'release/{path_model}')


def main():
    """
    各種ファイルをコピーする
    """
    copy_question(PATH_QUESTION)
    copy_scaler(SINGER)
    copy_model(NAME_EXPERIMENT)


if __name__ == '__main__':
    main()
