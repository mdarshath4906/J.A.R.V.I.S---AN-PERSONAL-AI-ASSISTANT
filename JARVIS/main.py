import argparse

def main():
    parser=argparse.ArgumentParser(description='JARVIS X Windows AI assistant')
    parser.add_argument('--gui',action='store_true',help='Open the native HUD')
    parser.add_argument('--voice',action='store_true',help='Enable microphone and spoken responses')
    parser.add_argument('--no-voice',action='store_true',help='Start with microphone paused')
    parser.add_argument('--background',action='store_true',help='Start the HUD in the background')
    parser.add_argument('--doctor',action='store_true',help='Check setup without launching hardware actions')
    args=parser.parse_args()
    if args.doctor:
        from core.doctor import run
        run();return
    if args.gui:
        from core.hud import launch
        launch(False if args.no_voice else True if args.voice else None,background=args.background)
    else:
        from core.assistant import Assistant
        Assistant(voice=args.voice).start()

if __name__=='__main__':main()
