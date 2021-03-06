#!/bin/bash

script_dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
NNSVS_ROOT=~/nnsvs

# Directory
# **CHANGE** this to your database path
# db_root=$PWD/../../data

# voice bank name
spk="utau_ritsu"
# Max frequency:659.255 Hz (E5, estimated from UST)
f0_ceil=700
# Min frequency: 220 Hz (A3, estimated from UST)
f0_floor=200


# HTS-style question used for extracting musical/linguistic context from musicxml files
question_path=./conf/jp_qst001_nnsvs_simple_3.hed
# sample rate of WAV files (Hz)
sample_rate=44100
# frame period (ms)
frame_period=5

dumpdir=dump
# Pretrained model dir
# leave empty to disable
pretrained_expdir=

num_workers=16
batch_size=2

stage=0
stop_stage=7

# exp tag
tag="simple_qst_3_318dim" # tag for managing experiments.
timelag_in_dim=318
duration_in_dim=318
acoustic_in_dim=322


. $NNSVS_ROOT/utils/parse_options.sh || exit 1;

# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

function xrun () {
    set -x
    $@
    set +x
}

train_set="train_no_dev"
dev_set="dev"
eval_set="eval"
datasets=($train_set $dev_set $eval_set)
testsets=($dev_set $eval_set)

dump_org_dir=$dumpdir/$spk/org
dump_norm_dir=$dumpdir/$spk/norm

# exp name
if [ -z ${tag} ]; then
    expname=${spk}
else
    expname=${spk}_${tag}
fi
expdir=exp/$expname

if [ ${stage} -le -2 ] && [ ${stop_stage} -ge -2 ]; then
    echo "stage -2: Clean old files"
    rm -rf data dump outputs
fi

# if [ ${stage} -le -1 ] && [ ${stop_stage} -ge -1 ]; then
#     if [ ! -e $db_root ]; then
#         echo "stage -1: Downloading"
# 	echo "Please download utau-namineritsu-singing  from https://github.com/oatsu-gh/utau-namineritsu-singing and arrange directory paths as ofuton-p style."
#     fi
# fi

if [ ${stage} -le 0 ] && [ ${stop_stage} -ge 0 ]; then
    echo "stage 0: Data preparation"
    # echo "db_root = \"$db_root\"" >> config.py
    sh utils/data_prep.sh
    mkdir -p data/list
    ln -sfn $PWD/temp/timelag data/timelag
    ln -sfn $PWD/temp/duration data/duration
    ln -sfn $PWD/temp/acoustic data/acoustic

    echo "train/dev/eval split"
    find data/acoustic/ -type f -name "*.wav" -exec basename {} .wav \; \
        | sort > data/list/utt_list.txt
    grep haruga_kita_ data/list/utt_list.txt > data/list/$eval_set.list
    grep kagome_kagome_ data/list/utt_list.txt > data/list/$dev_set.list
    grep -v haruga_kita_ data/list/utt_list.txt | grep -v kagome_kagome_ > data/list/$train_set.list
fi

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
    echo "stage 1: Feature generation"

    for s in ${datasets[@]};
    do
	# utau-namineritsu-singing
	# Min frequency and Max frequency
      nnsvs-prepare-features \
      utt_list=data/list/$s.list \
      out_dir=$dump_org_dir/$s/  \
      frame_period=$frame_period \
        question_path=$question_path acoustic.f0_floor=$f0_floor acoustic.f0_ceil=$f0_ceil
    done

    # Compute normalization stats for each input/output
    mkdir -p $dump_norm_dir
    for inout in "in" "out"; do
        if [ $inout = "in" ]; then
            scaler_class="sklearn.preprocessing.MinMaxScaler"
        else
            scaler_class="sklearn.preprocessing.StandardScaler"
        fi
        for typ in timelag duration acoustic;
        do
            find $dump_org_dir/$train_set/${inout}_${typ} -name "*feats.npy" > train_list.txt
            scaler_path=$dump_org_dir/${inout}_${typ}_scaler.joblib
            nnsvs-fit-scaler list_path=train_list.txt scaler.class=$scaler_class \
                out_path=$scaler_path
            rm -f train_list.txt
            cp -v $scaler_path $dump_norm_dir/${inout}_${typ}_scaler.joblib
        done
    done

    # apply normalization
    for s in ${datasets[@]}; do
        for inout in "in" "out"; do
            for typ in timelag duration acoustic;
            do
                nnsvs-preprocess-normalize in_dir=$dump_org_dir/$s/${inout}_${typ}/ \
                    scaler_path=$dump_org_dir/${inout}_${typ}_scaler.joblib \
                    out_dir=$dump_norm_dir/$s/${inout}_${typ}/
            done
        done
    done
fi

if [ ${stage} -le 2 ] && [ ${stop_stage} -ge 2 ]; then
    echo "stage 2: Training time-lag model"
    if [ ! -z "${pretrained_expdir}" ]; then
        resume_checkpoint=$pretrained_expdir/timelag/latest.pth
    else
        resume_checkpoint=
    fi
   xrun nnsvs-train data.train_no_dev.in_dir=$dump_norm_dir/$train_set/in_timelag/ \
        data.train_no_dev.out_dir=$dump_norm_dir/$train_set/out_timelag/ \
        data.dev.in_dir=$dump_norm_dir/$dev_set/in_timelag/ \
        data.dev.out_dir=$dump_norm_dir/$dev_set/out_timelag/ \
        model=timelag \
        train.out_dir=$expdir/timelag \
        model.netG.params.in_dim=$timelag_in_dim \
        data.num_workers=$num_workers \
        data.batch_size=$batch_size \
        resume.checkpoint=$resume_checkpoint
fi

if [ ${stage} -le 3 ] && [ ${stop_stage} -ge 3 ]; then
    echo "stage 3: Training phoneme duration model"
    if [ ! -z "${pretrained_expdir}" ]; then
        resume_checkpoint=$pretrained_expdir/duration/latest.pth
    else
        resume_checkpoint=
    fi
    xrun nnsvs-train data.train_no_dev.in_dir=$dump_norm_dir/$train_set/in_duration/ \
        data.train_no_dev.out_dir=$dump_norm_dir/$train_set/out_duration/ \
        data.dev.in_dir=$dump_norm_dir/$dev_set/in_duration/ \
        data.dev.out_dir=$dump_norm_dir/$dev_set/out_duration/ \
        model=duration train.out_dir=$expdir/duration \
        model.netG.params.in_dim=$duration_in_dim \
        data.num_workers=$num_workers \
        data.batch_size=$batch_size \
        resume.checkpoint=$resume_checkpoint
fi


if [ ${stage} -le 4 ] && [ ${stop_stage} -ge 4 ]; then
    echo "stage 4: Training acoustic model"
    if [ ! -z "${pretrained_expdir}" ]; then
        resume_checkpoint=$pretrained_expdir/acoustic/latest.pth
    else
        resume_checkpoint=
    fi
    xrun nnsvs-train data.train_no_dev.in_dir=$dump_norm_dir/$train_set/in_acoustic/ \
        data.train_no_dev.out_dir=$dump_norm_dir/$train_set/out_acoustic/ \
        data.dev.in_dir=$dump_norm_dir/$dev_set/in_acoustic/ \
        data.dev.out_dir=$dump_norm_dir/$dev_set/out_acoustic/ \
        model=acoustic train.out_dir=$expdir/acoustic \
        model.netG.params.in_dim=$acoustic_in_dim \
        data.num_workers=$num_workers \
        data.batch_size=$batch_size \
        resume.checkpoint=$resume_checkpoint
fi


# NOTE: step 5 does not generate waveform. It just saves neural net's outputs.
if [ ${stage} -le 5 ] && [ ${stop_stage} -ge 5 ]; then
    echo "stage 5: Generation features from timelag/duration/acoustic models"
    for s in ${testsets[@]}; do
        for typ in timelag duration acoustic; do
            checkpoint=$expdir/$typ/latest.pth
            name=$(basename $checkpoint)
            xrun nnsvs-generate model.checkpoint=$checkpoint \
                model.model_yaml=$expdir/$typ/model.yaml \
                out_scaler_path=$dump_norm_dir/out_${typ}_scaler.joblib \
                in_dir=$dump_norm_dir/$s/in_${typ}/ \
                out_dir=$expdir/$typ/predicted/$s/${name%.*}/
        done
    done
fi


if [ ${stage} -le 6 ] && [ ${stop_stage} -ge 6 ]; then
    echo "stage 6: Synthesis waveforms"
    for s in ${testsets[@]}; do
        for input in label_phone_score label_phone_align; do
            if [ $input = label_phone_score ]; then
                ground_truth_duration=false
            else
                ground_truth_duration=true
            fi
            xrun nnsvs-synthesis \
            question_path=$question_path \
            frame_period=$frame_period \
            sample_rate=$sample_rate \
            timelag.checkpoint=$expdir/timelag/latest.pth \
            timelag.in_scaler_path=$dump_norm_dir/in_timelag_scaler.joblib \
            timelag.out_scaler_path=$dump_norm_dir/out_timelag_scaler.joblib \
            timelag.model_yaml=$expdir/timelag/model.yaml \
            duration.checkpoint=$expdir/duration/latest.pth \
            duration.in_scaler_path=$dump_norm_dir/in_duration_scaler.joblib \
            duration.out_scaler_path=$dump_norm_dir/out_duration_scaler.joblib \
            duration.model_yaml=$expdir/duration/model.yaml \
            acoustic.checkpoint=$expdir/acoustic/latest.pth \
            acoustic.in_scaler_path=$dump_norm_dir/in_acoustic_scaler.joblib \
            acoustic.out_scaler_path=$dump_norm_dir/out_acoustic_scaler.joblib \
            acoustic.model_yaml=$expdir/acoustic/model.yaml \
            utt_list=./data/list/$s.list \
            in_dir=data/acoustic/$input/ \
            out_dir=$expdir/synthesis/$s/latest/$input \
            ground_truth_duration=$ground_truth_duration
        done
    done
fi


# ここから追記
if [ ${stage} -le 7 ] && [ ${stop_stage} -ge 7 ]; then
    echo "stage 7: Synthesis waveforms, with any full-label"
    for s in ${testsets[@]}; do
        for input in label_phone_score label_phone_align; do
            if [ $input = label_phone_score ]; then
                ground_truth_duration=false
            else
                ground_truth_duration=true
            fi
            xrun nnsvs-synthesis \
            question_path=$question_path \
            frame_period=$frame_period \
            sample_rate=$sample_rate \
            timelag.checkpoint=$expdir/timelag/latest.pth \
            timelag.in_scaler_path=$dump_norm_dir/in_timelag_scaler.joblib \
            timelag.out_scaler_path=$dump_norm_dir/out_timelag_scaler.joblib \
            timelag.model_yaml=$expdir/timelag/model.yaml \
            duration.checkpoint=$expdir/duration/latest.pth \
            duration.in_scaler_path=$dump_norm_dir/in_duration_scaler.joblib \
            duration.out_scaler_path=$dump_norm_dir/out_duration_scaler.joblib \
            duration.model_yaml=$expdir/duration/model.yaml \
            acoustic.checkpoint=$expdir/acoustic/latest.pth \
            acoustic.in_scaler_path=$dump_norm_dir/in_acoustic_scaler.joblib \
            acoustic.out_scaler_path=$dump_norm_dir/out_acoustic_scaler.joblib \
            acoustic.model_yaml=$expdir/acoustic/model.yaml \
            utt_list=sample/my_song_list.txt \
            in_dir=sample \
            out_dir=sample \
            ground_truth_duration=$ground_truth_duration
        done
    done
fi
