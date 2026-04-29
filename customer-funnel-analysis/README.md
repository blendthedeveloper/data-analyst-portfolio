# Customer Funnel & Revenue Analysis

## Business Problem
Analyze user behavior across the funnel stages: visited, product viewed, added to cart, and purchased. The goal is to identify drop-offs, understand revenue impact, and suggest business actions to improve conversion.

## Metrics Defined
- Visited Users
- Product View Users
- Cart Users
- Purchase Users
- Conversion Rate
- Drop-off Rate
- Total Revenue

## Data Grain
Each row represents one user event at a specific funnel stage.

## Tools Used
- SQL
- Python
- Power BI

## Approach
- Cleaned user event and revenue data
- Built funnel-stage logic
- Calculated user counts at each stage
- Identified drop-offs between stages
- Built Power BI dashboard for KPI tracking and business insights

## Key Insights
- Users dropped after product view, suggesting possible product visibility, pricing, or interest issues.
- Users who added products to cart showed stronger purchase intent.
- Revenue was mainly driven by high-intent users who reached cart and purchase stages.

## Edge Cases
- Users with missing or null funnel stages
- Duplicate user events affecting user counts

## Validation Checks
- Verified distinct user counts across funnel stages
- Reconciled Power BI revenue with source data totals

## Risks / Limitations
- Small dataset may make percentages unstable
- Missing events can affect funnel accuracy

## Dashboard Preview
Dashboard screenshot will be added in the screenshots folder.
