"""Manual screen/vision smoke check; sends a screenshot to Gemini."""
if __name__ == "__main__":
    from vision.screen import ScreenVision
    vision=ScreenVision()
    print(vision.analyze(vision.capture()))
