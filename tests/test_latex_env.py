"""Exercise the read-only probe with controlled tools, without a TeX install."""

from pathlib import Path
import os
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "skills/latex-pdf/scripts/check_latex_env.sh"


class EnvironmentProbeTests(unittest.TestCase):
    def run_probe(self, tools):
        with tempfile.TemporaryDirectory(prefix="latex-probe-test-") as folder:
            root = Path(folder)
            log = root / "calls.log"
            for name, body in {"uname": "printf 'Linux\\n'\n", **tools}.items():
                program = root / name
                program.write_text(
                    '#!/bin/sh\nprintf "%s:%s\\n" "${0##*/}" "$*" >> "$PROBE_LOG"\n'
                    + body
                )
                program.chmod(0o700)
            for name in ["sudo", "brew", "pip3", "curl", "wget", "mpm"]:
                if name not in tools:
                    # Omit mpm: its presence is legitimately probed as a distribution.
                    if name == "mpm":
                        continue
                    program = root / name
                    program.write_text('#!/bin/sh\nprintf "MUTATION\\n" >> "$PROBE_LOG"\nexit 99\n')
                    program.chmod(0o700)
            result = subprocess.run(
                ["/bin/bash", str(SCRIPT)],
                cwd=root,
                env={**os.environ, "PATH": str(root), "PROBE_LOG": str(log)},
                capture_output=True,
                text=True,
                timeout=10,
            )
            calls = log.read_text() if log.exists() else ""
            self.assertNotIn("MUTATION", calls)
            self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
            self.assertIn("Summary", result.stdout)
            return result.stdout, calls

    def test_missing_tools_are_unchecked_not_missing_packages(self):
        output, calls = self.run_probe({})
        self.assertIn("packages not checked", output)
        self.assertIn("Engines found: none", output)
        self.assertNotIn("ctex: not found", output)
        self.assertEqual(calls.splitlines(), ["uname:-s"])

    def test_failed_tools_do_not_abort_or_claim_success(self):
        output, calls = self.run_probe({
            "tlmgr": "exit 2\n",
            "xelatex": "exit 2\n",
            "kpsewhich": "exit 2\n",
            "fc-list": "exit 2\n",
        })
        self.assertIn("xelatex: probe failed", output)
        self.assertIn("ctex: probe failed (exit 2)", output)
        self.assertIn("font availability unknown", output)
        self.assertNotIn("ctex: not found", output)
        self.assertNotIn("xelatex:", calls.replace("xelatex:--version", ""))

    def test_available_tools_only_receive_probe_arguments(self):
        output, calls = self.run_probe({
            "tlmgr": "printf 'TeX Live test\\n'\n",
            "xelatex": "printf 'XeTeX test\\n'\n",
            "kpsewhich": '''if [ "$1" = "-var-value" ]; then printf 'n\\n'; exit 0; fi
if [ "$1" = "minted.sty" ]; then exit 1; fi
printf '/synthetic/texmf/%s\\n' "$1"
''',
        })
        self.assertIn("minted: not found", output)
        self.assertIn("shell_escape = n (disabled", output)
        self.assertIn("xelatex:--version", calls)
        for line in calls.splitlines():
            name, argument = line.split(":", 1)
            if name in {"xelatex", "tlmgr"}:
                self.assertEqual(argument, "--version")
            if name == "kpsewhich":
                self.assertTrue(argument.endswith(".sty") or argument == "-var-value shell_escape")


if __name__ == "__main__":
    unittest.main()
