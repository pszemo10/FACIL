#!/bin/bash

SRC_DIR=$1
GPU=$2
RESULTS_DIR=$3

if [ -z "$RESULTS_DIR" ]; then
    echo "No results dir is given. Default will be used."
    RESULTS_DIR="./results"
fi
echo "Results dir: $RESULTS_DIR"

for SEED in 0 1 2 3 4 5 6 7 8 9
do
  if [ "$3" = "base" ]; then
          PYTHONPATH=$SRC_DIR python3 -u $SRC_DIR/main_incremental.py --exp-name base_${SEED} \
                 --datasets cifar10 --num-tasks 5 --network resnet32 --seed $SEED \
                 --nepochs 200 --batch-size 128 --results-path $RESULTS_DIR \
                 --gridsearch-tasks 10 --gridsearch-config gridsearch_config \
                 --gridsearch-acc-drop-thr 0.2 --gridsearch-hparam-decay 0.5 \
                 --approach $1 --gpu $2
  elif [ "$3" = "fixd" ]; then
          PYTHONPATH=$SRC_DIR python3 -u $SRC_DIR/main_incremental.py --exp-name fixd_${SEED} \
                 --datasets cifar10 --num-tasks 5 --network resnet32 --seed $SEED \
                 --nepochs 200 --batch-size 128 --results-path $RESULTS_DIR \
                 --gridsearch-tasks 10 --gridsearch-config gridsearch_config \
                 --gridsearch-acc-drop-thr 0.2 --gridsearch-hparam-decay 0.5 \
                 --approach $1 --gpu $2 \
                 --num-exemplars 2000 --exemplar-selection herding
  elif [ "$3" = "grow" ]; then
          PYTHONPATH=$SRC_DIR python3 -u $SRC_DIR/main_incremental.py --exp-name grow_${SEED} \
                 --datasets cifar10 --num-tasks 5 --network resnet32 --seed $SEED \
                 --nepochs 200 --batch-size 128 --results-path $RESULTS_DIR \
                 --gridsearch-tasks 10 --gridsearch-config gridsearch_config \
                 --gridsearch-acc-drop-thr 0.2 --gridsearch-hparam-decay 0.5 \
                 --approach $1 --gpu $2 \
                 --num-exemplars-per-class 20 --exemplar-selection herding
  else
          echo "No scenario provided."
  fi
done
