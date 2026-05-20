# SWE-bench Pro 评测环境部署指南

## 前置要求

- Linux (Ubuntu 推荐)
- Docker (>= 24.0)
- Conda (Miniconda / Anaconda)
- Git

## 1. 克隆仓库

```bash
git clone https://github.com/neverwinHao/SWE-bench_Pro-os.git
cd SWE-bench_Pro-os
```

## 2. 创建 Conda 环境

```bash
conda create -n sweagent-pipeline python=3.11 -y
conda activate sweagent-pipeline
pip install -r requirements.txt
```

## 3. 确保 Docker 可用

```bash
# 确认 Docker 已安装并运行
docker info

# 当前用户需要有 Docker 权限（无需 sudo）
sudo usermod -aG docker $USER
# 重新登录生效
```

## 4. Docker 镜像

评测依赖 DockerHub 上的预构建镜像（用户名 `jefzda`）。首次运行时会自动拉取，无需手动操作。

## 5. 仓库文件说明

| 文件/目录 | 说明 |
|---|---|
| `swe_bench_pro_eval.py` | 评测主脚本 |
| `run_scripts/` | 每个 instance 的测试脚本和 parser（共 1000 个） |
| `swebench_pro_python.csv` | Python 子集 GT 数据 |
| `swebench_pro_all.csv` | 全量 GT 数据（Python + JS） |
| `custom_instances.yaml` | 自定义 instance 列表 |
| `eval.sh` / `eval_opus_all.sh` | 评测启动脚本示例 |

## 6. 运行评测

### 准备预测文件

评测输入为 `preds_list.json`，格式：

```json
[
    {
        "instance_id": "unique_id",
        "patch": "git diff patch content",
        "prefix": "optional_prefix"
    }
]
```

### 执行评测

```bash
conda activate sweagent-pipeline

python3 swe_bench_pro_eval.py \
    --raw_sample_path=swebench_pro_all.csv \
    --patch_path=/path/to/your/preds_list.json \
    --output_dir=/path/to/output/ \
    --num_workers=4 \
    --use_local_docker \
    --dockerhub_username=jefzda \
    --scripts_dir=run_scripts \
    2>&1 | tee eval.log
```

参数说明：
- `--raw_sample_path`：GT 数据 CSV（python 用 `swebench_pro_python.csv`，全量用 `swebench_pro_all.csv`）
- `--patch_path`：模型生成的 patch 预测文件
- `--output_dir`：评测结果输出目录
- `--num_workers`：并行 Docker 容器数量（根据机器资源调整）
- `--use_local_docker`：使用本地 Docker 而非 Modal 云
- `--dockerhub_username`：DockerHub 用户名（镜像来源）
- `--scripts_dir`：测试脚本目录

## 7. 注意事项

- Docker 镜像较大，首次拉取需要时间和磁盘空间
- `num_workers` 建议根据 CPU 和内存调整，避免 OOM
- 评测过程中不要手动清理 Docker 镜像
