import pandas as pd

# ----------------------------------------
# Load and prepare event data
# ----------------------------------------
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

# ----------------------------------------
# Build user-level funnel
# ----------------------------------------
user_order = ['visit', 'add_to_cart', 'purchase']

df_flag = (
    df.pivot_table(index='user_id', columns='event', aggfunc='size', fill_value=0)
    .reindex(columns=user_order, fill_value=0)
)

df_flag = df_flag > 0

# ----------------------------------------
# Segment users based on behavior
# ----------------------------------------
df_flag['segment'] = df_flag.apply(
    lambda x: 'Active' if x['add_to_cart'] else 'Passive' if x['visit'] else 'Other',
    axis=1
)

# ----------------------------------------
# Revenue calculation (aligned with SQL)
# ----------------------------------------
orders = pd.DataFrame([
    (1,101,500),(2,102,300),(3,101,700),
    (4,103,200),(5,104,1000),(6,102,400),
    (7,105,-50),(8,101,600),(9,106,800),(10,101,500)
], columns=['order_id','customer_id','amount'])

payments = pd.DataFrame([
    (1,'Success'),(2,'Failed'),(3,'Success'),
    (4,'Success'),(5,'Failed'),(6,'Success'),
    (7,'Success'),(8,'Failed'),(9,'Success'),(10,'Success')
], columns=['order_id','status'])

mapping = pd.DataFrame([
    (1,101),(2,102),(3,103),(4,104),
    (5,105),(6,106),(7,107),(8,108)
], columns=['user_id','customer_id'])

orders_clean = orders[orders['amount'] > 0]
payments_clean = payments[payments['status'] == 'Success']

revenue = (
    orders_clean.merge(payments_clean, on='order_id')
    .groupby('customer_id')['amount']
    .sum()
    .reset_index()
)

# ----------------------------------------
# Combine funnel + revenue
# ----------------------------------------
final = df_flag.reset_index().merge(mapping, on='user_id', how='left')
final = final.merge(revenue, on='customer_id', how='left').fillna(0)

# ----------------------------------------
# Final summary
# ----------------------------------------
result = final.groupby('segment').agg(
    users=('user_id','count'),
    total_revenue=('amount','sum')
)

print(result)
