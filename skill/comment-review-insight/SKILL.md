---
name: comment-review-insight
description: Use for product-review or app-store-comment analysis where the goal is to turn large-scale user comments into product research, demand insights, competitor opportunity analysis, or a reusable evidence-backed report. Especially relevant when the user mentions Top100, review mining, comment value, high-value comments, product clustering, evidence tiers, pain points, wishes, advantages, lifecycle, or "产品价值 = 新体验 - 旧体验 - 替换成本".
---

# Comment Review Insight

This skill turns large comment/review datasets into product-research insight. It is designed for competitor review mining, app-store review analysis, game product opportunity research, and any task where product decisions depend on user comments.

Current methodology version: `1.0.0`.

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

Use the evidence chain:

```text
raw comment -> comment value -> structured insight -> theme -> product judgment -> product action
```

The report is only useful when this chain is auditable. A keyword hit or a copied quote is not enough.

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

When excluding products, keep two explicit pools:

- current-candidate weak evidence: products already considered for the active taxonomy, but removed because review volume, high-value comments, or high-information comments are insufficient
- high-review supplement pool: products from a wider ranking window with strong activity or review volume, but not included because they fail the current business-model, IAP, multiplayer, or category-boundary rules

The supplement pool is not part of the formal category statistics. It is a future review set for paid comparisons, multiplayer verification, monetization review, or category-boundary review.

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

Treat helpful votes as an amplifier, not standalone proof. High-helpful low-information text is mainly emotional spread; high-helpful high-information text can support product decisions.

Default bonuses:

- length >= 240: +10
- length >= 120: +4
- helpful >= 20: +28
- helpful >= 5: +10
- recent: +18
- rating <= 2 and length >= 120: +24

Adjust thresholds to dataset scale, but preserve the principle: do not let many short low-information comments dominate a few high-information comments.
Also do not let long low-information comments outrank shorter comments that clearly identify mechanisms, scenarios, and consequences.

Duplicate text control:

- Build a normalized text fingerprint per product: lowercase, remove punctuation, collapse whitespace, then hash.
- Exact normalized duplicates should only count once for theme weight, high-value comments, high-information comments, and representative samples.
- Later duplicate rows may remain in raw review totals and duplicate-review counts, but must not inflate evidence strength.
- In the rendered report, show the same original comment only once within the same product, even if it matches several themes.
- A highly helpful duplicated text is not multiple independent evidence items; treat it as one signal with possible copy/spread behavior.

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

For excluded or supplement products, record:

- rank or activity proxy
- scanned review count and storefront review count when available
- price, IAP/addon signal, multiplayer/network signal, and genre/category evidence
- exclusion reason
- next action, such as paid comparison, live multiplayer verification, monetization review, category-boundary review, or deferred second-stage research

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
- emotional value: identity, fandom/resource preference, excitement, fear, achievement, social recognition, creator/community belonging
- functional value: stability, fairness, onboarding, trading protection, economy clarity, asset recovery, moderation, matchmaking, room control
- core experience signal: the smallest repeatable fun moment
- loop experience signal: the resource, goal, social, progression, or economy system that makes players return
- product implication

Report excerpts can be shortened, but internal interpretation should be based on the full comment text when available.

When turning high-value comments into evidence, use this structured object:

```text
comment_insight =
  original_signal
  mechanism
  player_context
  emotional_value
  functional_value
  direct_need
  latent_need
  current_validity
  product_action
```

Major conclusions should be traceable to these structured insights, not only to theme keywords.

### 7. Add Lifecycle Analysis

Use time mainly to judge current validity, not to create mechanical period summaries. Splitting lifecycle by first and latest valid review timestamp is useful only as a support:

- early: first third
- middle: second third
- recent: final third

Also calculate natural recency, such as current-year comments.

Use lifecycle to avoid treating historical launch problems as current product truth. Exclude or flag invalid timestamps; never let `1970-01-01` style dates drive conclusions.

Classify high-value signals as:

- current: still supported by recent comments
- historical: strong in older comments but likely improved or no longer central
- needs verification: meaningful but sparse, ambiguous, or dependent on product-side version knowledge

### 8. Build Single-Product Analysis

Use this structure for formal deep analysis:

1. 产品概览
   - product outline, target audience, resource preference, differentiated positioning, direct evidence, positioning judgment
   - separate direct evidence from inference; do not turn ecosystem clues into hard demographic facts

2. 证据质量
   - review count, unique text count, duplicate count, high-value reviews, high-information reviews, information density, theme frequency, time validity

3. 体验模型
   - core action: the smallest repeatable experience
   - loop goal: the resource/progression/social/economy system that creates retention
   - resource system and social structure

4. 价值拆解
   - emotional value: why players want to come
   - functional value: why players can stay
   - switching cost: assets, friends, mastery, habits, identity, content memory
   - experience breakpoints: what breaks the value chain

5. 信号洞察
   - advantage signals, wish signals, pain signals, difference signals
   - value samples, low-star samples, helpful high-information samples

6. 机会推演
   - gameplay opportunity, monetization boundary, new-product direction, risk judgment

Every major claim should pair:

- quantified evidence
- direct user signal
- latent need
- product implication
- representative comment evidence

Hard anti-template rule:

```text
If the statement still works after replacing the product name with another product in the same category, rewrite it.
```

Strong differentiated statements should include product-specific entities, old-experience references, and loop breakpoints.

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

Each category inference must bind:

- one high-weight common theme
- one explicit branch difference
- one switching-cost barrier
- one actionable product direction

If a category inference does not include branch difference, it is likely a template.

### 10. Adversarial Review

Before handoff, challenge the report:

- Did it use the latest source data?
- Did it scan raw comments, not prior prose?
- Are candidate and exclusion rules explicit?
- Were weak-evidence products removed or caveated?
- Are comment value and product evidence metrics visible?
- Are high-value comments actually read and used?
- Are duplicate or copied review texts deduplicated so highly helpful repeated text does not inflate evidence?
- Are historical issues separated from current issues?
- Are invalid timestamps excluded?
- Are conclusions stronger than the evidence?
- Are major conclusions traceable to structured `comment_insight` objects instead of only keyword hits?
- Does each product separate core experience from loop experience?
- Does each product separate emotional value from functional value?
- Does each positioning judgment include product-specific entities, old-experience references, and loop breakpoints?
- Do positioning judgments, opportunity statements, and category inferences pass the "replace product/category name" anti-template test?
- Does the report explain product opportunities rather than only listing comments?
- Are category predictions, product monetization, and new-product opportunity statements product/category-specific instead of template text with only name substitution?
- Does each category inference bind at least one high-weight theme, one branch difference, and one replacement-cost barrier?
- Did you run duplicate-text checks on conclusion fields such as category prediction, product monetization, and new-product opportunity?
- Does the default served or shared report entry point show the latest final artifact?
- For long HTML reports, is there a left-side fine-grained reading index, and do all index anchors resolve?
- If the user gives reusable feedback about the report method, was it added back to the methodology and skill before publishing updates?

## Output Requirements

A reusable report should include:

- report version, such as `report_version: 1.0.0`
- sample description
- methodology and thresholds
- included products
- excluded products with reasons
- high-review supplement pool when a wider ranking window exists
- per-product evidence tier
- high-value comment metrics
- high-information comment metrics
- single-product analysis
- category insight
- left-side reading index with sample, product, and category-insight anchors for long HTML reports
- caveats and data-quality notes
- generated JSON or other structured output when possible
- frozen release copy of the confirmed version, so future iterations do not overwrite the only comparable milestone

Sample description should work as a reader map, not as a repeated process log. Once the sample boundary and filters are locked, mention them only once or in methodology; spend the overview on category differences, why the sample matters, what each category validates, and how the reader should interpret product opportunity. Avoid repeating phrases such as the same business-model filter in every category card.

For release handoff, verify:

- default/shared entry point opens the confirmed latest version
- versioned HTML and structured data were written
- formal samples, weak-evidence exclusions, and supplement pool counts are visible
- all reading-index anchors resolve
- anti-template and duplicate-text checks were run on product positioning, monetization, new-product opportunity, and category inference fields
- reusable report-method changes were synced back to the local skill and public methodology docs

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
- separate emotional value from functional value
- separate core experience from loop experience
- enforce the anti-template replacement test

## Common Failure Modes

- Treating full-table keyword scan as close reading.
- Letting short low-information comments dominate.
- Treating comment length as information amount.
- Letting duplicated or copied high-helpful text count as many independent evidence items.
- Deep-analyzing products with insufficient evidence.
- Reusing historical writeups without labeling reuse.
- Ignoring review time and current version drift.
- Mixing product eligibility with evidence strength.
- Reporting cross-category conclusions before all categories are analyzed.
- Using English source descriptions in a Chinese report except for original quotes.
- Generating category inference or monetization sections from repeated boilerplate.
- Writing a positioning judgment that would still fit another product after only replacing the name.
- Treating the product value formula as report copy instead of an internal decision compass.
- Letting the output framework force conclusions instead of letting comment content drive the analysis.
- Collapsing emotional value and functional value into one generic "user need".
- Describing only the first-session core action while missing the long-term loop.
- Letting sample overview repeat methodology or fixed filters instead of explaining category differences and research purpose.
- Leaving a local or public report entry point on an older report after producing a final version.
- Iterating the report format without updating the reusable methodology and skill.
- Treating excluded products as discarded noise instead of preserving them as a future supplement pool when they have strong ranking or review-volume evidence.
- Publishing a final report without a versioned frozen copy, making later comparisons impossible.
