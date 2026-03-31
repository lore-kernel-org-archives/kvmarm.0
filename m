Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99303DFC66
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 19:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986136; cv=none; b=qEpb/W/nC1/8RV/zCJwOJn+5fccXRz86awk7k00ufd22af3WNLyhrpT5eH8lehGnjtTsorW0hfY+0uvIHpJKDywTFNSPwbmAdjCHhLnSUkJ9VqbKk59tKJth1nqVN2z6RJuN3XTjVvUfUoX4lkTmPiwIytSRPRWcsWO4CoaJ+EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986136; c=relaxed/simple;
	bh=SjmMPJPg8zgmRPuaAUDFLRMs9R1KUDwxYctdwjAgvzA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cDEKtZ8w2J8iLFTX1Ld8yuP5WVur9oJxVqbusFtKLErgo7F5BdM6Qs05OesZG5MM5AA+XYAmFJKRvrwEJe6bvN8hIQT/axwFOStuehcIngqhXh5M46PoZjIfxa7M2D3TH+Azd7p6OJdFPqfLuXOC9p6WgpmD77xVb7MeFIGzKrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j5ATEqGd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j5ATEqGd"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354490889b6so12682442a91.3
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 12:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774986134; x=1775590934; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=77Z+jquwwk0zk6Vwhrc3psuAUoaKxjDwCdLNMqluKDo=;
        b=j5ATEqGdjz2ZP44TohsRir91X6B9IdGMng1cbDOodvSoivr2M0VojyTLX4hgR+6KHR
         /Z+vr65eLJEs0Dzi8RMACQO5jTFNaqzf/A++VaRgZNqqNWy2nEWjH6Fv1CTpugTdJEGR
         Kfq2DjEo9+4wpoOv8Qqpx3ZDOeu0q8z9dssG8CSYKJlFJ5Raj/kNyiR4eZ5m/jDNuIoE
         N3NXKQxZxdfSD3/3uwVCYb7cllKWg1HILJwib3gq5BpfyYsXmlJkxSgOedRf2pLmMA5k
         ta1Xii54w+JThcFvd8INbaM63xcQOvHSSmd79+4f7bZiG2VdGIhFiu8LGUZGDJpDa5K3
         8nnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986134; x=1775590934;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=77Z+jquwwk0zk6Vwhrc3psuAUoaKxjDwCdLNMqluKDo=;
        b=e9t2scFi6vg0cTtQGyynoqiKFWxczlGf8c+t6LWZR+0+d7K8U3ewoeidHaame9TwO9
         oC95T85R6ZbgrYhKEz+CAj0yLHJEaWifwOHFjSSs4T7neoPTPoE26Arjj53eMqEpOp85
         7NbdQMG+vzVMCPd4UTbhFtZh7CVFJOct6z9gOnKa/JkvcBubUeEu5ITgbkY2MyKnBD61
         u46WoEVq/aVlwM16WqEgruNJi0zaOBG0hn79I+ebPMTAygK2Jqkdts0XF1dlCZzOFUrb
         EdLPdoTUIzhHF3osr6P2yKZf4GC5ORXPue9t/3FqoDFWQTuWvHvmj3pxo/2dWkioX/ry
         fBBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMs9yaUHeZh8quIlYQA3wUezvl24nBpIPMuEhABOcVJ3bKU+clhnXPYLdI2/FTvTL6fv7SxjY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyul26hArz9tokXNrKnSkF7kryUYIqWy7qlguv45uBpWgNj9VS8
	5u8cEbnl8zo5PAuMnuLq2Jo70NZjPOalwftDZGvKCzBKxzMJa+uHlW1/CJR/e92vLxceHBd0Du/
	bTVyJ1ps2jQ==
X-Received: from pjbmz13.prod.google.com ([2002:a17:90b:378d:b0:35c:217b:ecd7])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ecb:b0:35b:ea35:c3ce
 with SMTP id 98e67ed59e1d1-35dc6f93abfmr482770a91.27.1774986134029; Tue, 31
 Mar 2026 12:42:14 -0700 (PDT)
Date: Tue, 31 Mar 2026 12:41:54 -0700
In-Reply-To: <20260331194202.1722082-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com>
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260331194202.1722082-2-vipinsh@google.com>
Subject: [PATCH v4 1/9] KVM: selftest: Create KVM selftest runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Implement a basic KVM selftest runner in Python to run selftests. Add
command line options to select individual testcase file or a
directory containing multiple testcase files.

After selecting the tests to run, start their execution and print their
final execution status (passed, failed, skipped, no run), stdout and
stderr on terminal.

Print execution status in colors on the terminals where it is supported
to easily distinguish different statuses of the tests execution.

If a test fails or times out, then return with a non-zero exit code
after all of the tests execution have completed. If none of the tests
fails or times out then exit with status 0

Provide some sample test configuration files to demonstrate the
execution of the runner.

Runner can be started from tools/testing/selftests/kvm directory as:

  python3 runner --dirs tests
OR
  python3 runner --testcases \
  tests/dirty_log_perf_test/no_dirty_log_protect.test

This is a very basic implementation of the runner. Next patches will
enhance the runner by adding more features like parallelization, dumping
output to file system, time limit, out-of-tree builds run, etc.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  4 +-
 .../testing/selftests/kvm/runner/__main__.py  | 99 +++++++++++++++++++
 .../testing/selftests/kvm/runner/selftest.py  | 66 +++++++++++++
 .../selftests/kvm/runner/test_runner.py       | 37 +++++++
 .../2slot_5vcpu_10iter.test                   |  1 +
 .../no_dirty_log_protect.test                 |  1 +
 6 files changed, 207 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/runner/__main__.py
 create mode 100644 tools/testing/selftests/kvm/runner/selftest.py
 create mode 100644 tools/testing/selftests/kvm/runner/test_runner.py
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 1d41a046a7bf..95af97b1ff9e 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -3,10 +3,12 @@
 !/**/
 !*.c
 !*.h
+!*.py
 !*.S
 !*.sh
+!*.test
 !.gitignore
 !config
 !settings
 !Makefile
-!Makefile.kvm
\ No newline at end of file
+!Makefile.kvm
diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
new file mode 100644
index 000000000000..db87f426331d
--- /dev/null
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -0,0 +1,99 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2025 Google LLC
+#
+# Author: vipinsh@google.com (Vipin Sharma)
+
+import argparse
+import logging
+import os
+import sys
+
+from test_runner import TestRunner
+from selftest import SelftestStatus
+
+
+def cli():
+    parser = argparse.ArgumentParser(
+        prog="KVM Selftests Runner",
+        formatter_class=argparse.RawTextHelpFormatter,
+        allow_abbrev=False
+    )
+
+    parser.add_argument("-t",
+                        "--testcases",
+                        nargs="*",
+                        default=[],
+                        help="Testcases to run. Provide the space separated testcases paths")
+
+    parser.add_argument("-d",
+                        "--dirs",
+                        nargs="*",
+                        default=[],
+                        help="Run the testcases present in the given directory and all of its sub directories. Provide the space separated paths to add multiple directories.")
+
+    return parser.parse_args()
+
+
+def setup_logging():
+    class TerminalColorFormatter(logging.Formatter):
+        reset = "\033[0m"
+        red_bold = "\033[31;1m"
+        green = "\033[32m"
+        yellow = "\033[33m"
+        blue = "\033[34m"
+
+        COLORS = {
+            SelftestStatus.PASSED: green,
+            SelftestStatus.NO_RUN: blue,
+            SelftestStatus.SKIPPED: yellow,
+            SelftestStatus.FAILED: red_bold
+        }
+
+        def __init__(self, fmt=None, datefmt=None):
+            super().__init__(fmt, datefmt)
+
+        def format(self, record):
+            return (self.COLORS.get(record.levelno, "") +
+                    super().format(record) + self.reset)
+
+    logger = logging.getLogger("runner")
+    logger.setLevel(logging.INFO)
+
+    ch = logging.StreamHandler()
+    ch_formatter = TerminalColorFormatter(fmt="%(asctime)s | %(message)s",
+                                          datefmt="%H:%M:%S")
+    ch.setFormatter(ch_formatter)
+    logger.addHandler(ch)
+
+
+def fetch_testcases_in_dirs(dirs):
+    testcases = []
+    for dir in dirs:
+        for root, child_dirs, files in os.walk(dir):
+            for file in files:
+                testcases.append(os.path.join(root, file))
+    return testcases
+
+
+def fetch_testcases(args):
+    testcases = args.testcases
+    testcases.extend(fetch_testcases_in_dirs(args.dirs))
+    # Remove duplicates
+    testcases = list(dict.fromkeys(testcases))
+    return testcases
+
+
+def main():
+    args = cli()
+    setup_logging()
+    testcases = fetch_testcases(args)
+    return TestRunner(testcases).start()
+
+
+if __name__ == "__main__":
+    PYTHON_VERSION = (3, 6)
+    if sys.version_info < PYTHON_VERSION:
+        print(f"Minimum required python version {PYTHON_VERSION}, found {sys.version}")
+        sys.exit(1)
+
+    sys.exit(main())
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
new file mode 100644
index 000000000000..5a86f9ceedd4
--- /dev/null
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -0,0 +1,66 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2025 Google LLC
+#
+# Author: vipinsh@google.com (Vipin Sharma)
+
+import pathlib
+import enum
+import os
+import subprocess
+
+class SelftestStatus(enum.IntEnum):
+    """
+    Selftest Status. Integer values are just +1 to the logging.INFO level.
+    """
+
+    PASSED = 21
+    NO_RUN = 22
+    SKIPPED = 23
+    FAILED = 24
+
+    def __str__(self):
+        return str.__str__(self.name)
+
+class Selftest:
+    """
+    Represents a single selftest.
+
+    Extract the test execution command from test file and executes it.
+    """
+
+    def __init__(self, test_path):
+        test_command = pathlib.Path(test_path).read_text().strip()
+        if not test_command:
+            raise ValueError("Empty test command in " + test_path)
+
+        test_command = os.path.join(".", test_command)
+        self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
+        self.test_path = test_path
+        self.command = test_command
+        self.status = SelftestStatus.NO_RUN
+        self.stdout = ""
+        self.stderr = ""
+
+    def run(self):
+        if not self.exists:
+            self.stderr = "File doesn't exist."
+            return
+
+        run_args = {
+            "universal_newlines": True,
+            "shell": True,
+            "stdout": subprocess.PIPE,
+            "stderr": subprocess.PIPE
+        }
+        proc = subprocess.run(self.command, **run_args)
+
+        out, err = proc.stdout, proc.stderr
+        self.stdout = out.decode("utf-8", "replace") if isinstance(out, bytes) else (out or "")
+        self.stderr = err.decode("utf-8", "replace") if isinstance(err, bytes) else (err or "")
+
+        if proc.returncode == 0:
+            self.status = SelftestStatus.PASSED
+        elif proc.returncode == 4:
+            self.status = SelftestStatus.SKIPPED
+        else:
+            self.status = SelftestStatus.FAILED
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
new file mode 100644
index 000000000000..4418777d75e3
--- /dev/null
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -0,0 +1,37 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2025 Google LLC
+#
+# Author: vipinsh@google.com (Vipin Sharma)
+
+import logging
+from selftest import Selftest
+from selftest import SelftestStatus
+
+logger = logging.getLogger("runner")
+
+
+class TestRunner:
+    def __init__(self, testcases):
+        self.tests = []
+
+        for testcase in testcases:
+            self.tests.append(Selftest(testcase))
+
+    def _log_result(self, test_result):
+        logger.info("*** stdout ***\n" + test_result.stdout)
+        logger.info("*** stderr ***\n" + test_result.stderr)
+        logger.log(test_result.status,
+                   f"[{test_result.status.name}] {test_result.test_path}")
+
+    def start(self):
+        ret = 0
+
+        for test in self.tests:
+            test.run()
+            self._log_result(test)
+
+            if (test.status not in [SelftestStatus.PASSED,
+                                    SelftestStatus.NO_RUN,
+                                    SelftestStatus.SKIPPED]):
+                ret = 1
+        return ret
diff --git a/tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test b/tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
new file mode 100644
index 000000000000..5b8d56b44a75
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
@@ -0,0 +1 @@
+dirty_log_perf_test -x 2 -v 5 -i 10
diff --git a/tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test b/tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test
new file mode 100644
index 000000000000..ed3490b1d1a1
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test
@@ -0,0 +1 @@
+dirty_log_perf_test -g
-- 
2.53.0.1118.gaef5881109-goog

