# JARVIS X

Latest: see `docs/HANDS_FREE_UPDATE.md`. The current updater enables Windows login startup, launches in the background, and reveals the HUD when the wake word is recognized.

This update connects the existing assistant foundation and adds implementations for the remaining features in your Features and Roadmap document. It includes a native HUD, persistent context, desktop automation, browser and coding agents, reviewed plans, startup integration, and proactive system alerts.

75 automated tests pass in the build environment. This is a development release: Windows hardware, GUI appearance, speech recognition, live browser automation and live AI responses still require verification on your laptop. The broad “full computer control” and “personal AI operating system” goals are supported through the tools described below; they are not guarantees that every application or arbitrary task can be automated.

## Apply the interactive update

For your existing installation, follow `docs/INTERACTIVE_UPDATE.md` and the updater package's `READ_FIRST.txt`. Run APPLY_UPDATE.bat from the extracted update folder, then open START.bat from your existing project. Your E: paths, .env, Python environment and memory are preserved.

The redesigned HUD provides Overview, PC controls, Workspace and Voice settings. Say “Jarvis” to activate it, use Listen now, or type in the composer. Closing the HUD keeps it running in the tray (or minimized if no tray is available); use Quit JARVIS to exit. Pause mic stops all voice capture until resumed.

For a new installation, SETUP.bat reuses an existing environment or creates one with Python 3.13/3.12. START.bat enables voice by default unless you previously paused it; START_VOICE.bat explicitly enables voice. `main.py --gui --no-voice` starts with the microphone paused.

## Configuration

- **Ollama:** `OLLAMA_MODEL=qwen2.5:1.5b` by default. It handles local text conversation and planning. You can select a more capable installed model for complex coding tasks.
- **Gemini:** set `GEMINI_API_KEY` for screen vision and cloud fallback. `GEMINI_MODEL` is configurable; the default is `gemini-3.8-flash`. Availability depends on your account. Local commands do not require a Gemini key.
- **Project files:** by default, file tools work inside the `workspace` folder beside `main.py`. Set `JARVIS_WORKSPACE` to the project folder you want JARVIS to work on. Restart after changing it.
- **Speech:** default STT language is `en-IN`; `JARVIS_STT_LANGUAGE=ta-IN` selects Tamil recognition. Common Tanglish commands are normalized automatically, and the AI is prompted to match the user's language. Arbitrary Tamil/Tanglish speech recognition accuracy is not guaranteed.
- **Voice:** Google speech recognition and edge-tts require internet. Local Ollama text conversation works without internet after the model is downloaded. This is not an offline wake-word/STT engine.
- **Microphone:** set `JARVIS_MICROPHONE_INDEX` if the default device is incorrect. Headphones help prevent the assistant from hearing its own speech.

## Commands to try

| Purpose | Command |
| --- | --- |
| Open app | `Chrome open pannu` or `open notepad` |
| Brightness | `brightness konjam kammi pannu` |
| Facts | `remember my project is JarvisX` then `recall project` |
| Project state | `project context We are building the JarvisX Python assistant` |
| Conversation recall | `recall conversation Ollama` |
| Screen analysis | `analyze my screen`, followed by `explain this code` |
| Screen action | `vision act click the search box` |
| Desktop | `type Hello World`, `press ctrl+s`, `click 300 400` |
| Drag | `drag 100 100 to 500 500` |
| Window navigation | `list windows`, then `focus window Notepad` |
| Create code file | `create file Demo/main.py :: print("Hello")` |
| File operations | `read file Demo/main.py`, `copy file A.txt to B.txt` |
| Organize | `organize files Demo` |
| Code edit | `code Demo/main.py :: Add a calculator function and input validation` |
| Apply a reviewed diff | `apply proposal PROPOSAL_ID`, then `confirm` |
| Execute and test | `run command ["python", "Demo/main.py"]` |
| Browser | `browser open https://example.com`, then `browser read` |
| Inspect form controls | `browser controls` |
| Fill a field | `browser fill input[name="q"] :: Python tutorials` |
| Select an option | `browser select select[name="country"] :: IN` |
| Click a browser element | `browser click button[type="submit"]` |
| Multi-step command | `open notepad then type Hello World` |
| AI planning | `plan create a folder called Demo and inspect it` |
| Iterative agent | `agent inspect Demo, fix its Python error, and test the result` |
| Continue an agent | `confirm`, then `continue task` to propose the next action |
| Reusable workflow | `save workflow greeting :: open notepad then type Hello` |
| Run workflow | `run workflow greeting` |
| Startup | `enable startup` or `disable startup`, then `confirm` |
| Plugin | `load plugin example`, then `confirm` |
| Stop | `stop`, the HUD Stop button, or Escape in the HUD |

Use `tool TOOL_NAME {"argument":"value"}` for the full structured tool interface. Tool signatures are defined by the registry in `core/brain.py` and the individual skills. For example, `tool run_command {"argv":["python","-m","unittest"],"cwd":"Demo","timeout":60}`.

## How reviewed automation works

JARVIS shows the exact action and arguments before desktop input, power operations, file writes/deletions, terminal execution, browser form actions, startup changes and plugin loading. Say or type `confirm` to run that pending action list. Confirmation expires after 90 seconds and can be used only once. A different command cancels the pending list; repeat the new command to execute it. All AI-generated plans require review.

The GUI minimizes for supported screen capture and confirmed desktop-input commands so it does not type into itself. Keep the intended application in the foreground and do not move windows between reviewing a vision suggestion and confirming it. Coordinate automation supports the primary monitor. Mouse fail-safe is enabled: moving the pointer to the top-left corner stops PyAutoGUI operations. Browser actions control a separate Chromium session rather than your existing Chrome tabs. Login and password entry are manual.

A multi-step plan stops on exceptions or nonzero terminal exit codes. The iterative agent proposes one action at a time, incorporates the confirmed result, and stops after eight proposals. It needs `continue task` after each step. It does not silently run an unbounded autonomous loop. Code proposals are displayed as diffs; applying a proposal checks that the file has not changed since review and saves a backup.

File tools enforce the configured workspace boundary and exclude credential files. Terminal commands and local Python plugins are trusted local code and are **not sandboxed** by that file boundary. Review them before confirming. A Stop request cancels pending actions, stops further plan steps and terminates managed terminal process trees. In-flight network/browser calls may finish or time out before their worker returns; completed external actions cannot be undone by Stop.

## Data and memory

New state lives in `data/jarvis.db`. The original `jarvis_memory.db` is imported once without modifying it. Facts, project context, workflows and recent conversations survive restart. Conversation history is limited to 500 turns, with the latest eight passed into conversation prompts. Related facts use keyword relevance; this is not semantic vector retrieval. `clear context` clears conversations, screen context and the current project context while keeping saved facts. `forget KEY` removes an explicit fact after confirmation.

Backups are in `data/backups`; screenshots are in `data/screenshots`. The audit table records action previews and results. Local history can contain text you type and command output. Cloud fallback may send relevant conversation/project context to Gemini, while screen vision sends the captured screenshot.

## Verify the installation

Run these from the project folder:

```text
.venv\Scripts\python.exe main.py --doctor
.venv\Scripts\python.exe -m unittest discover -s tests -v
```

Then follow `docs/WINDOWS_CHECKLIST.md`. The detailed mapping of all 42 document items is in `docs/FEATURE_COVERAGE.md`, and the build test evidence is in `docs/VALIDATION.md`.

## Architecture

`main.py` launches a CLI or Tk HUD. `core/assistant.py` owns the command worker, voice lifecycle and alerts. `core/brain.py` combines memory, screen context, deterministic routing, AI planning and confirmations. `core/actions.py` holds the shared registry; `skills/files.py`, `skills/desktop.py`, and `agents/*` supply implementations. Optional hardware and cloud libraries are imported when needed so text commands remain usable without them.

Voice settings and microphone selection persist in data/preferences.json. The GUI runs on the main thread, and microphone, speech and command workers send queued events. Original helper modules are retained for continuity. The running application routes through the new shared registry; standalone legacy helpers are not an alternative execution path for agents or the HUD. New plugins expose `register(registry)` and are explicitly loaded after confirmation. Plugin tools always require confirmation.

## API references

Implementation references: [Ollama](https://docs.ollama.com/), [Google Gen AI Python SDK](https://github.com/googleapis/python-genai), and [Playwright Python locators](https://playwright.dev/python/docs/locators).
