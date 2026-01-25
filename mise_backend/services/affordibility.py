import math

def when_can_i_afford(
    item_cost: float,
    monthly_income: float,
    fixed_expenses: float,
    current_savings: float,
    safe_savings_rate: float = 0.3
):
    disposable = monthly_income - fixed_expenses

    if disposable <= 0:
        return {
            "status": "Not affordable",
            "reason": "No disposable income"
        }

    monthly_saving = disposable * safe_savings_rate
    remaining = max(0, item_cost - current_savings)

    months_needed = math.ceil(remaining / monthly_saving)

    return {
        "monthly_saving": round(monthly_saving, 2),
        "months_needed": months_needed,
        "message": f"You can afford this in ~{months_needed} month(s)"
    }
