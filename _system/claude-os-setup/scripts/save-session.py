#!/usr/bin/env python3
"""
save-session.py — dump the current Claude Code session to a verbatim markdown file.

Captures everything:
  - Full conversation transcript (user + assistant messages)
  - Thinking blocks
  - Every tool call with full input
  - Every tool result with full output
  - Files read, edited, created
  - Session metadata (title, model, duration, turn count)

Usage:
  python3 save-session.py [output_dir]

  output_dir defaults to <cwd>/session-snapshots/
"""

import json
import os
import sys
from datetime import datetime
from pathlib import Path


def encode_path(path: str) -> str:
    """Match Claude Code's project directory encoding."""
    return path.replace('/', '-')


def find_session_file(cwd: str) -> Path | None:
    encoded = encode_path(cwd)
    project_dir = Path.home() / '.claude' / 'projects' / encoded
    if not project_dir.exists():
        return None
    jsonl_files = sorted(
        project_dir.glob('*.jsonl'),
        key=lambda f: f.stat().st_mtime,
        reverse=True
    )
    return jsonl_files[0] if jsonl_files else None


def extract_text(content) -> str:
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        parts = []
        for item in content:
            if isinstance(item, dict):
                t = item.get('type', '')
                if t == 'text':
                    parts.append(item.get('text', ''))
                elif t == 'tool_result':
                    inner = item.get('content', '')
                    parts.append(f"[tool_result: {extract_text(inner)}]")
            elif isinstance(item, str):
                parts.append(item)
        return '\n'.join(p for p in parts if p.strip())
    if isinstance(content, dict):
        return content.get('text', json.dumps(content))
    return str(content) if content else ''


def fmt_json(obj, max_chars=4000) -> str:
    s = json.dumps(obj, indent=2, ensure_ascii=False)
    if len(s) > max_chars:
        s = s[:max_chars] + f'\n... [truncated — {len(s) - max_chars} chars omitted]'
    return s


def parse_events(path: Path) -> list:
    events = []
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                events.append(json.loads(line))
            except json.JSONDecodeError:
                continue
    return events


def build_markdown(events: list, session_path: Path, cwd: str) -> str:
    out = []

    # ── Metadata pass ──────────────────────────────────────────────────────────
    session_title = ''
    session_id = ''
    model_used = ''
    total_duration_ms = 0
    turn_count = 0
    files_read = []
    files_written = []

    for ev in events:
        t = ev.get('type', '')
        if t == 'ai-title':
            session_title = ev.get('aiTitle', '')
            session_id = ev.get('sessionId', '')
        if t == 'system' and ev.get('subtype') == 'turn_duration':
            total_duration_ms += ev.get('durationMs', 0)
            turn_count += ev.get('messageCount', 0)
        if t == 'assistant':
            msg = ev.get('message', {})
            if not model_used:
                model_used = msg.get('model', '')
            for block in msg.get('content', []):
                if not isinstance(block, dict):
                    continue
                if block.get('type') == 'tool_use':
                    name = block.get('name', '')
                    inp = block.get('input', {})
                    fp = inp.get('file_path', '')
                    if fp:
                        if name in ('Read',):
                            files_read.append(fp)
                        elif name in ('Edit', 'Write', 'NotebookEdit'):
                            files_written.append(fp)

    # ── Header ─────────────────────────────────────────────────────────────────
    out.append(f"# Session Snapshot{': ' + session_title if session_title else ''}")
    out.append('')
    out.append(f"| Field | Value |")
    out.append(f"|---|---|")
    out.append(f"| Date | {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} |")
    out.append(f"| Session ID | `{session_id}` |")
    out.append(f"| Model | {model_used} |")
    out.append(f"| Working directory | `{cwd}` |")
    if total_duration_ms:
        out.append(f"| Total AI time | {total_duration_ms / 1000:.1f}s |")
    out.append(f"| Source file | `{session_path}` |")
    out.append('')

    if files_written:
        out.append('## Files Written / Edited')
        out.append('')
        for f in dict.fromkeys(files_written):  # dedupe, preserve order
            out.append(f'- `{f}`')
        out.append('')

    if files_read:
        out.append('## Files Read')
        out.append('')
        for f in dict.fromkeys(files_read):
            out.append(f'- `{f}`')
        out.append('')

    out.append('---')
    out.append('')
    out.append('## Full Transcript')
    out.append('')

    # ── Transcript pass ────────────────────────────────────────────────────────
    msg_index = 0

    for ev in events:
        t = ev.get('type', '')

        # ── User message ───────────────────────────────────────────────────────
        if t == 'user':
            content = ev.get('message', {}).get('content', '')

            # Could be plain string or array (which may include tool_results)
            if isinstance(content, list):
                for block in content:
                    if not isinstance(block, dict):
                        continue
                    bt = block.get('type', '')

                    if bt == 'text':
                        text = block.get('text', '').strip()
                        if text:
                            msg_index += 1
                            out.append(f'### [{msg_index}] User')
                            out.append('')
                            out.append(text)
                            out.append('')

                    elif bt == 'tool_result':
                        tool_id = block.get('tool_use_id', '')
                        inner = block.get('content', '')
                        result_text = extract_text(inner).strip()
                        if result_text:
                            out.append(f'#### Tool Result (`{tool_id}`)')
                            out.append('')
                            out.append('```')
                            if len(result_text) > 8000:
                                result_text = result_text[:8000] + f'\n... [truncated — {len(result_text)-8000} chars omitted]'
                            out.append(result_text)
                            out.append('```')
                            out.append('')

            elif isinstance(content, str) and content.strip():
                msg_index += 1
                out.append(f'### [{msg_index}] User')
                out.append('')
                out.append(content.strip())
                out.append('')

        # ── Assistant message ──────────────────────────────────────────────────
        elif t == 'assistant':
            content = ev.get('message', {}).get('content', [])
            if not isinstance(content, list):
                content = []

            has_text = any(
                b.get('type') == 'text' and b.get('text', '').strip()
                for b in content if isinstance(b, dict)
            )
            if has_text:
                msg_index += 1
                out.append(f'### [{msg_index}] Claude')
                out.append('')

            for block in content:
                if not isinstance(block, dict):
                    continue
                bt = block.get('type', '')

                if bt == 'thinking':
                    thinking = block.get('thinking', '').strip()
                    if thinking:
                        out.append('<details>')
                        out.append('<summary>Thinking</summary>')
                        out.append('')
                        out.append(thinking)
                        out.append('')
                        out.append('</details>')
                        out.append('')

                elif bt == 'text':
                    text = block.get('text', '').strip()
                    if text:
                        out.append(text)
                        out.append('')

                elif bt == 'tool_use':
                    tool_name = block.get('name', 'unknown')
                    tool_id = block.get('id', '')
                    tool_input = block.get('input', {})
                    out.append(f'#### Tool Call: `{tool_name}` (`{tool_id}`)')
                    out.append('')
                    out.append('```json')
                    out.append(fmt_json(tool_input))
                    out.append('```')
                    out.append('')

        # ── Hook / attachment output ───────────────────────────────────────────
        elif t == 'attachment':
            att = ev.get('attachment', {})
            att_type = att.get('type', '')
            if att_type == 'hook_success':
                hook_name = att.get('hookName', '')
                hook_content = att.get('content', '')
                out.append(f'#### Hook: `{hook_name}`')
                out.append('')
                out.append('```')
                out.append(str(hook_content)[:1000])
                out.append('```')
                out.append('')

    return '\n'.join(out)


def main():
    cwd = os.getcwd()
    output_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(cwd) / 'session-snapshots'
    output_dir.mkdir(parents=True, exist_ok=True)

    session_file = find_session_file(cwd)
    if not session_file:
        print(f'ERROR: No session transcript found for {cwd}', file=sys.stderr)
        print(f'Looked in: {Path.home() / ".claude" / "projects" / encode_path(cwd)}', file=sys.stderr)
        sys.exit(1)

    events = parse_events(session_file)
    markdown = build_markdown(events, session_file, cwd)

    timestamp = datetime.now().strftime('%Y%m%d-%H%M%S')
    output_file = output_dir / f'session-{timestamp}.md'
    output_file.write_text(markdown, encoding='utf-8')

    print(str(output_file))


if __name__ == '__main__':
    main()
