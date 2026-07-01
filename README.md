# Comment Review Insight Skill

一个用于“大规模评论数据 -> 产品研究洞察”的 Codex 个人 skill。

它适合：

- 应用商店评论分析
- 游戏竞品评论研究
- Top 榜单样本重聚类
- 用户需求挖掘
- 痛点池、许愿墙、优势点提取
- 产品机会和新品方向判断

核心方法：

```text
重点关注 -> 分类提取 -> 分层处理
产品价值 = 新体验 - 旧体验 - 替换成本
```

## 内容

```text
skill/comment-review-insight/SKILL.md
docs/comment-review-insight-methodology.md
scripts/install.sh
```

- `SKILL.md`：Codex 可加载的个人 skill。
- `docs/comment-review-insight-methodology.md`：完整方法论说明。
- `scripts/install.sh`：安装到本机 `~/.codex/skills/`。

## 安装

```bash
git clone <repo-url>
cd comment-review-insight-skill
bash scripts/install.sh
```

安装后重开 Codex 会话，使用：

```text
$comment-review-insight
```

## 方法论摘要

这套方法把评论分析拆成 10 个阶段：

1. 建立候选样本池
2. 确认类目和分支
3. 从源数据全量读取评论
4. 清洗无效时间戳和空文本
5. 计算评论价值分
6. 计算产品证据等级
7. 剔除或降级弱证据样本
8. 提取优势点、许愿墙、痛点池
9. 逐条阅读高价值评论池
10. 生成单品画像、类目洞察和对抗审查结论

默认高价值评论规则：

```text
high_value =
  information_score >= 45
  OR (length >= 240 AND information_score >= 28)
  OR (helpful >= 20 AND information_score >= 16)
  OR (rating <= 2 AND length >= 120 AND information_score >= 28)
  OR (recent AND length >= 120 AND helpful >= 5 AND information_score >= 28)
```

默认弱证据产品规则：

```text
weak_evidence =
  review_count < 500
  OR high_value_comments < 75
  OR high_information_comments < 50
```

信息量权重高于信息长度。信息量优先看具体机制、场景、因果、后果、对比、数字/价格/资源和明确诉求；阈值可按行业、数据规模和评论质量调整。同一产品内规范化重复文本只作为一条证据计权，高赞重复文本不能被当成多条独立需求样本。

## 不包含

这个仓库只包含方法论和 skill，不包含：

- 原始评论数据
- 私有数据库连接信息
- 内部报告产物
- 公司或项目私有配置

## 使用建议

首次用于新项目时，先让 Codex 输出候选样本池和纳入/剔除理由，不要直接生成正式报告。样本边界确认后，再进入全量评论扫描和深描。

报告迭代时，把可复用反馈同步写回 `docs/comment-review-insight-methodology.md` 和 `skill/comment-review-insight/SKILL.md`，再提交更新。尤其要保留反模板化审查：类目推理、单品变现和新品机会不能只是替换产品名或类目名的重复句式。
