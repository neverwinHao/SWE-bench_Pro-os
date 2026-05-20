#!/bin/bash
source "$(conda info --base)/etc/profile.d/conda.sh"
cd /home/v-haoliu3/haoliu/SWE-bench_Pro-os && \
conda activate sweagent-pipeline && \
python3 swe_bench_pro_eval.py \
    --raw_sample_path=/home/v-haoliu3/haoliu/SWE-bench-Pro-Results/swebench_pro_all.csv \
    --patch_path=/home/v-haoliu3/haoliu/SWE-bench-Pro-Results/claude-opus-4.5/all_swebench_run1/preds_list.json \
    --output_dir=/home/v-haoliu3/haoliu/SWE-bench-Pro-Results/claude-opus-4.5/all_swebench_run1/verified \
    --num_workers=4 \
    --use_local_docker \
    --dockerhub_username=jefzda \
    --scripts_dir=run_scripts \
    2>&1 | tee /home/v-haoliu3/haoliu/SWE-bench-Pro-Results/claude-opus-4.5/all_swebench_run1/eval.log
