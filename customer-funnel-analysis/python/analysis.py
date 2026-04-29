import pandas as pd

# ============================================
# BUSINESS PROBLEM
# ============================================
# Analyze user funnel behavior and segment users
# into Active (cart users) and Passive (visit only)

# ============================================
# DATA
# ============================================
data = [
    (1, 'visit'), (1, 'add_to_cart'), (1, 'purchase'),
    (2, 'visit'), (2, 'add_to_cart'),
    (3, 'visit'),
    (4, 'purchase'),
    (5, 'visit'), (5, 'add_to_cart'), (5, 'purchase'),
    (6, 'visit'),
    (7, 'add_to_cart'),
    (8, 'visit'), (8, 'purchase')
]

df = pd.DataFrame(data, columns=['user_id', 'event'])

# ============================================
# FUNNEL CREATION (USER LEVEL)
# ============================================
user_order = ['visit', 'add_to_cart', 'purchase']

df_flag = (
    df.pivot_table(index='user_id', columns='event', aggfunc='size', fill_value=0)
    .reindex(columns=user_order, fill_value=0)
)

# Convert to boolean (did event happen)
df_flag = df_flag > 0

# ============================================
# SEGMENTATION
# ============================================
df_flag['segment'] = df_flag.apply(
    lambda x: 'Active' if x['add_to_cart'] else 'Passive' if x['visit'] else 'Other',
    axis=1
)

# ============================================
# METRICS CALCULATION
# ============================================
summary = df_flag.groupby('segment').agg(
    users=('visit', 'count'),
    visit_users=('visit', 'sum'),
    cart_users=('add_to_cart', 'sum'),
    purchase_users=('purchase', 'sum')
)

# Conversion Rates
summary['visit_to_cart_rate'] = summary['cart_users'] / summary['visit_users']
summary['cart_to_purchase_rate'] = summary['purchase_users'] / summary['cart_users']

print(summary)