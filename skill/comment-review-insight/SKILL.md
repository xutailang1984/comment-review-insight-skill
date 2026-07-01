---
name: comment-review-insight
description: Use for product-review or app-store-comment analysis where the goal is to turn large-scale user comments into product research, demand insights, competitor opportunity analysis, or a reusable evidence-backed report. Especially relevant when the user mentions Top100, review mining, comment value, high-value comments, product clustering, evidence tiers, pain points, wishes, advantages, lifecycle, or "产品价值 = 新体验 - 旧体验 - 替换成本".
---

# Comment Review Insight

This skill turns large comment/review datasets into product-research insight. It is designed for competitor review mining, app-store review analysis, game product opportunity research, and any task where product decisions depend on user comments.

## Operating Principle

Use the user's default method:

```text
重点关注 -> 分类提取 -> 分层处理
```

Anchor analysis on:

```text
产品价值 = 新体验 - 旧体验 - 替换成本
```

The goal is not to summarize comments. The goal is to identify user needs, pain points, validated strengths, unmet demand, and product opportunities.

## When To Use

Use this skill when the user asks to:

- analyze app/game/product reviews
- mine comments for user needs
- rank products by review evidence
- recluster products by review demand
- compare competitors through comments
- decide whether products deserve deep reading
- produce a product-research report from reviews
- audit whether prior review analysis was deep enough

## Inputs To Establish

Before generating a final report, identify:

- product universe: ranking list, candidate list, current sample scope
- required product filters: free/paid, IAP, multiplayer, platform, region
- product priority weights: ranking/activity, business model, category relevance
- review source: table/file/API and latest freshness
- comment fields: product id/name, rating, text, helpful count, timestamp
- output surface: HTML report, Markdown, JSON, spreadsheet, dashboard
- audience: product decision maker, research team, executive, design team

If the sample boundary is unsettled, produce a candidate pool and inclusion/exclusion rationale before writing the formal report.

## Required Workflow

### 1. Build Candidate Pool

Create a candidate table with:

- product name
- rank or activity proxy
- price and monetization state
- multiplayer or social evidence
- category and branch
- inclusion rationale
- boundary concern
- review count

Do not bury inclusion decisions inside the final narrative.

### 2. Read Reviews From Source

Use the current source data, not prior prose. For database-backed work, query the raw review table directly.

Record:

- source table/file
- run time
- products scanned
- reviews scanned
- invalid timestamp count
- excluded products and why

State clearly when any part reuses prior writeups. If the user asks for stricter evidence, rerun a uniform source-review pass.

### 3. Compute Comment Value

Each comment needs a value score before theme aggregation.

Default high-value comment rule:

```text
high_value =
  information_score >= 45
  OR (length >= 240 AND information_score >= 28)
  OR (helpful >= 20 AND information_score >= 16)
  OR (rating <= 2 AND length >= 120 AND information_score >= 28)
  OR (recent AND length >= 120 AND helpful >= 5 AND information_score >= 28)
```

Default value score:

```text
value =
  information_score * 1.8
  + min(length, 800) / 70
  + min(helpful, 300) * 2.4
  + length_bonus
  + helpful_bonus
  + recent_bonus
  + low_star_dense_bonus
```

Information score should measure how much uncertainty the comment removes, not how long it is. Prefer signals such as concrete product mechanisms, scenario detail, cause/effect, explicit ask, consequence, comparison, numbers/prices/resources, and useful vocabulary diversity. Penalize repeated low-information emotion.

Default bonuses:

- length >= 240: +10
- length >= 120: +4
- helpful >= 20: +28
- helpful >= 5: +10
- recent: +18
- rating <= 2 and length >= 120: +24

Adjust thresholds to dataset scale, but preserve the principle: do not let many short low-information comments dominate a few high-information comments.
Also do not let long low-information comments outrank shorter comments that clearly identify mechanisms, scenarios, and consequences.

### 4. Grade Product Evidence

Separate product eligibility from review evidence quality.

Default weak-evidence rule:

```text
weak_evidence =
  review_count < 500
  OR high_value_comments < 75
  OR high_information_comments < 50
```

Default strong-evidence rule:

```text
strong_evidence =
  review_count >= 1000
  AND high_value_comments >= 200
  AND high_information_comments >= 120
```

Everything else is medium evidence.

Handling:

- Strong: eligible for full single-product deep analysis.
- Medium: keep, but qualify conclusions.
- Weak: remove from formal deep analysis or keep only as branch supplement with explicit caveat.

### 5. Extract Themes

Use three primary buckets:

- 优势点: what players praise and what the product does right
- 许愿墙: direct asks, feature requests, desired content
- 痛点池: bugs, friction, unfairness, toxic community, monetization pain

Sort themes by:

1. total comment value score
2. high-value comment count
3. total theme count
4. recent theme count
5. helpful count

Never sort only by raw keyword hits.

### 6. Read High-Value Comments

Full scanning is not equal to close reading.

For each formal product, inspect high-value comments from:

- top value comments
- recent low-star dense comments
- full-period helpful dense comments
- recent helpful dense comments
- representative comments within top themes

For each useful comment, extract:

- direct statement
- concrete scenario
- emotional intensity
- product mechanism involved
- whether the issue is current or historical
- explicit need
- latent need
- product implication

Report excerpts can be shortened, but internal interpretation should be based on the full comment text when available.

### 7. Add Lifecycle Analysis

Split lifecycle by first and latest valid review timestamp:

- early: first third
- middle: second third
- recent: final third

Also calculate natural recency, such as current-year comments.

Use lifecycle to avoid treating historical launch problems as current product truth. Exclude or flag invalid timestamps; never let `1970-01-01` style dates drive conclusions.

### 8. Build Single-Product Analysis

Use this structure:

1. 总体概述
   - product outline
   - target audience
   - ranking/activity
   - rating and review evidence
   - evidence tier
   - review count
   - high-value comment count
   - long review count
   - median length
   - low-star share
   - helpful count
   - recent review share
   - lifecycle table

2. 特点分析
   - 表征提取: 优势点, 许愿墙, 痛点池
   - 深入挖掘: 定位复盘, 痛点归因, 需求洞察, 优势放大
   - high-value original comment samples

3. 预测推理
   - gameplay inference
   - monetization inference
   - new-product opportunity
   - replacement-cost judgment

Every major claim should pair:

- quantified evidence
- direct user signal
- latent need
- product implication
- representative comment evidence

### 9. Build Category Insight

Category analysis should not merely aggregate products. It must compare common structures and branch differences.

Use:

- 类目概述
- 共同结构
- 分支差异
- 深入挖掘
- 类目推理

Answer:

- what is common across the category
- what differs by branch
- what pain is structural
- what strength is market-validated
- where a new product can differentiate
- what replacement costs are hardest to overcome

### 10. Adversarial Review

Before handoff, challenge the report:

- Did it use the latest source data?
- Did it scan raw comments, not prior prose?
- Are candidate and exclusion rules explicit?
- Were weak-evidence products removed or caveated?
- Are comment value and product evidence metrics visible?
- Are high-value comments actually read and used?
- Are historical issues separated from current issues?
- Are invalid timestamps excluded?
- Are conclusions stronger than the evidence?
- Does the report explain product opportunities rather than only listing comments?
- Are category predictions, product monetization, and new-product opportunity statements product/category-specific instead of template text with only name substitution?
- Does each category inference bind at least one high-weight theme, one branch difference, and one replacement-cost barrier?
- Did you run duplicate-text checks on conclusion fields such as category prediction, product monetization, and new-product opportunity?
- Does the default served or shared report entry point show the latest final artifact?
- If the user gives reusable feedback about the report method, was it added back to the methodology and skill before publishing updates?

## Output Requirements

A reusable report should include:

- sample description
- methodology and thresholds
- included products
- excluded products with reasons
- per-product evidence tier
- high-value comment metrics
- high-information comment metrics
- single-product analysis
- category insight
- caveats and data-quality notes
- generated JSON or other structured output when possible

## Portability Notes

Adjust these by domain:

- review length thresholds
- information-score thresholds and signal dictionary
- helpful thresholds
- recent window
- weak-evidence thresholds
- theme dictionary
- category taxonomy
- source schema
- translation policy

Keep these invariant:

- confirm candidate pool before formal report when boundaries are uncertain
- rank comments by value before theme aggregation
- grade products by evidence quality
- remove or caveat weak-evidence samples
- use full source comments for close reading
- distinguish direct need, latent need, and product opportunity

## Common Failure Modes

- Treating full-table keyword scan as close reading.
- Letting short low-information comments dominate.
- Treating comment length as information amount.
- Deep-analyzing products with insufficient evidence.
- Reusing historical writeups without labeling reuse.
- Ignoring review time and current version drift.
- Mixing product eligibility with evidence strength.
- Reporting cross-category conclusions before all categories are analyzed.
- Using English source descriptions in a Chinese report except for original quotes.
- Generating category inference or monetization sections from repeated boilerplate.
- Leaving a local or public report entry point on an older report after producing a final version.
- Iterating the report format without updating the reusable methodology and skill.
