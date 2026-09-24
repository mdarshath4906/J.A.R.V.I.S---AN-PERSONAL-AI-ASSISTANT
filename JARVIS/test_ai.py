"""Manual online AI smoke check."""
if __name__ == "__main__":
    from ai.provider import Provider
    print(Provider().ask("Say hello in one sentence."))
