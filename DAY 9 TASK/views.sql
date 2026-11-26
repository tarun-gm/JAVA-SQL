USE telecom_db;

CREATE OR REPLACE VIEW vw_prepaid_subscribers AS
SELECT sub_id, full_name, phone, plan_id, balance, last_recharge_date
FROM subscribers
WHERE sub_type = 'PREPAID';

CREATE OR REPLACE VIEW vw_recharge_summary AS
SELECT s.sub_id,
       s.full_name,
       COUNT(r.recharge_id) AS total_recharges,
       COALESCE(SUM(r.amount), 0) AS total_spent,
       MAX(r.recharged_at) AS last_recharged_at
FROM vw_prepaid_subscribers s
LEFT JOIN recharge_history r ON r.sub_id = s.sub_id
GROUP BY s.sub_id, s.full_name;
