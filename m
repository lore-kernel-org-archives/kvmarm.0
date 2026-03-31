Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C113AA4E5
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 19:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986141; cv=none; b=l+4piH8HTj8W6eY3nqJ4tJFfWC1JzcfU+pX/L4ssyGFe01Ogqciy2OwHR+28TUXhw6VvaNqjDgft0Re/+lYi2vBJRtty28NXTRUtvIj4rtp82hZrZ8slmTpPFNhHhNIdYL9wV+qaK9fZ8YotxR9cJMQysEvzYI5CXUpYNNZZzUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986141; c=relaxed/simple;
	bh=HVF2ECQB8nP6NMFVzEQBCqJIYHs7RftQXMQpbNjFucA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JJk+/KTvJCZBm8P95dk+e0Iy0OpeKlXc1FtQW2xV6n3BIvTks7alOMh4plmGLSGalTdAnOkM4ilW/BaGjD9j5Ns+Ich6oOWLh5CgQCIdmZoYnEEdySPVEZbypP4xbGBQxpQsvoRsuDFKhxY/fRfMfNO6N4cEniahy0u84Lx4bl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VwpSW+Gr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VwpSW+Gr"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35dacc40f92so2441267a91.2
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 12:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774986140; x=1775590940; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ka0uEckvF83qn5GmvpHw9HtNOmToQnEieGf8Vdd2qVw=;
        b=VwpSW+GrA4SfDZFwb+X1DWE23hYD/CpAt1Wo/aOn9gjSHg99a7DCGNhDvqDn4kNQ5E
         bARtAYSuAso//SoO+f2kPqqHsj6tMB/eeFQJrCH+U9eyZGRoBiImK3b1J5r2he8rvyr5
         Kp3tI3cUGNGlpIlxhnMDSFT6BDWSXQEZGGQ5anIW1KFluUuF8x/XM+V5wgaf9YI/mf/K
         sFahxnANaZywBVCjWpXrO6lBJAdLUEWIdPxA+R0uVMjSDPVW2onIWF/QojKiLqTPM7BH
         jTheYzZNwziFULQt3CMfTHdM3J7DBYmukKpPzHvfr1IsF8EvT5D4SQ7hdEXOeHPDdmuR
         6FOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986140; x=1775590940;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ka0uEckvF83qn5GmvpHw9HtNOmToQnEieGf8Vdd2qVw=;
        b=VtoACS4eUTaKDzQSEIM/nlT3swTtVT8uwgOznjEGiMmA67MZFVIw5wf4dl43BaEH9V
         8nmH7rY3XE/3qLc7yS7RUMvt8WsMY3BlwLKJRpN7gTfTzQZ+gjAUoiHnSA8R+x3W9R2X
         BR6BX+VDbd4jvPnyYoXbrhAHhcE6zIXH1kacCiMden4m+y20pzeBblzpKQzytNsLd6U/
         Bx0SnexGa9ez7XczNvwvyiBF3nU8RlhOQ3JHNqTYto0XjZOSy2WbEm7PHnD10t/rgWSy
         3UmKEpv44kAsPqiUvgF5FmhCcH8ZC2KKr1eD8EaLuxF+/4v2vCOzobz0E5NeHmqxSQdP
         m2dw==
X-Forwarded-Encrypted: i=1; AJvYcCUM4OF7wSPcR/PlLm/KGXFtRHaKJdocC+k4E+7OmQ1tu3Q1EMSL3d61ysOXhXpSRxoZGTdnAaE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5yJd2LAt/flmZPG0YbmCdrQ14+/hUuGzhYWt5ICX4J3cu1Uua
	0cQpn2ws7YnHDmrx9YkN4Pv5JguAPWqzz+49eFOVCIftMxndGpdbx1bEbfMsYJSX61blRDyAaIr
	Z2Pglr6khQA==
X-Received: from pjblp17.prod.google.com ([2002:a17:90b:4a91:b0:35d:a80b:8d43])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cc2:b0:35b:e554:53a6
 with SMTP id 98e67ed59e1d1-35dc6ea1153mr570258a91.11.1774986139702; Tue, 31
 Mar 2026 12:42:19 -0700 (PDT)
Date: Tue, 31 Mar 2026 12:41:57 -0700
In-Reply-To: <20260331194202.1722082-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com>
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260331194202.1722082-5-vipinsh@google.com>
Subject: [PATCH v4 4/9] KVM: selftests: Add option to save selftest runner
 output to a directory
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line flag, -o/--output, to selftest runner which enables
it to save individual tests output (stdout & stderr) stream to a
directory in a hierarchical way. Create folder hierarchy same as tests
hieararcy given by --testcases and --dirs.

Also, add a command line flag, --append-output-time, which will append
timestamp (format YYYY.M.DD.HH.MM.SS) to the directory name given in
--output flag.

Example:
  python3 runner --dirs test -o test_result --append_output_time

This will create test_result.2025.06.06.08.45.57 directory.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  | 34 +++++++++++++++--
 .../testing/selftests/kvm/runner/selftest.py  | 38 ++++++++++++++++---
 .../selftests/kvm/runner/test_runner.py       |  4 +-
 3 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 82c543d11c34..5ea5ee8957c4 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -7,6 +7,8 @@ import argparse
 import logging
 import os
 import sys
+import datetime
+import pathlib
 
 from test_runner import TestRunner
 from selftest import SelftestStatus
@@ -42,10 +44,20 @@ def cli():
                         type=int,
                         help="Timeout, in seconds, before runner kills the running test. (Default: 120 seconds)")
 
+    parser.add_argument("-o",
+                        "--output",
+                        nargs='?',
+                        help="Dumps test runner output which includes each test execution result, their stdouts and stderrs hierarchically in the given directory.")
+
+    parser.add_argument("--append-output-time",
+                        action="store_true",
+                        default=False,
+                        help="Appends timestamp to the output directory.")
+
     return parser.parse_args()
 
 
-def setup_logging():
+def setup_logging(args):
     class TerminalColorFormatter(logging.Formatter):
         reset = "\033[0m"
         red_bold = "\033[31;1m"
@@ -72,12 +84,26 @@ def setup_logging():
     logger = logging.getLogger("runner")
     logger.setLevel(logging.INFO)
 
+    formatter_args = {
+        "fmt": "%(asctime)s | %(message)s",
+        "datefmt": "%H:%M:%S"
+    }
+
     ch = logging.StreamHandler()
-    ch_formatter = TerminalColorFormatter(fmt="%(asctime)s | %(message)s",
-                                          datefmt="%H:%M:%S")
+    ch_formatter = TerminalColorFormatter(**formatter_args)
     ch.setFormatter(ch_formatter)
     logger.addHandler(ch)
 
+    if args.output != None:
+        if (args.append_output_time):
+            args.output += datetime.datetime.now().strftime(".%Y.%m.%d.%H.%M.%S")
+        pathlib.Path(args.output).mkdir(parents=True, exist_ok=True)
+        logging_file = os.path.join(args.output, "log")
+        fh = logging.FileHandler(logging_file)
+        fh_formatter = logging.Formatter(**formatter_args)
+        fh.setFormatter(fh_formatter)
+        logger.addHandler(fh)
+
 
 def fetch_testcases_in_dirs(dirs):
     testcases = []
@@ -98,7 +124,7 @@ def fetch_testcases(args):
 
 def main():
     args = cli()
-    setup_logging()
+    setup_logging(args)
     testcases = fetch_testcases(args)
     return TestRunner(testcases, args).start()
 
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
index e3924ee40ab3..76c3e6d463ee 100644
--- a/tools/testing/selftests/kvm/runner/selftest.py
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -7,6 +7,7 @@ import pathlib
 import enum
 import os
 import subprocess
+import contextlib
 
 class SelftestStatus(enum.IntEnum):
     """
@@ -29,7 +30,7 @@ class Selftest:
     Extract the test execution command from test file and executes it.
     """
 
-    def __init__(self, test_path, path, timeout):
+    def __init__(self, test_path, path, timeout, output_dir):
         test_command = pathlib.Path(test_path).read_text().strip()
         if not test_command:
             raise ValueError("Empty test command in " + test_path)
@@ -39,15 +40,14 @@ class Selftest:
         self.test_path = test_path
         self.command = test_command
         self.timeout = timeout
+        if output_dir is not None:
+            output_dir = os.path.join(output_dir, test_path.lstrip("./"))
+        self.output_dir = output_dir
         self.status = SelftestStatus.NO_RUN
         self.stdout = ""
         self.stderr = ""
 
-    def run(self):
-        if not self.exists:
-            self.stderr = "File doesn't exist."
-            return
-
+    def _run(self, output=None, error=None):
         run_args = {
             "universal_newlines": True,
             "shell": True,
@@ -70,4 +70,30 @@ class Selftest:
             out, err = e.stdout, e.stderr
 
         self.stdout = out.decode("utf-8", "replace") if isinstance(out, bytes) else (out or "")
+        if output is not None:
+            output.write(self.stdout)
+
         self.stderr = err.decode("utf-8", "replace") if isinstance(err, bytes) else (err or "")
+        if error is not None:
+            error.write(self.stderr)
+
+    def run(self):
+        if not self.exists:
+            self.stderr = "File doesn't exist."
+            return
+
+        if self.output_dir is not None:
+            pathlib.Path(self.output_dir).mkdir(parents=True, exist_ok=True)
+
+        output = None
+        error = None
+        with contextlib.ExitStack() as stack:
+            if self.output_dir is not None:
+                output_path = os.path.join(self.output_dir, "stdout")
+                output = stack.enter_context(
+                    open(output_path, encoding="utf-8", mode="w"))
+
+                error_path = os.path.join(self.output_dir, "stderr")
+                error = stack.enter_context(
+                    open(error_path, encoding="utf-8", mode="w"))
+            return self._run(output, error)
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index bea82c6239cd..b9101f0e0432 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -13,9 +13,11 @@ logger = logging.getLogger("runner")
 class TestRunner:
     def __init__(self, testcases, args):
         self.tests = []
+        self.output_dir = args.output
 
         for testcase in testcases:
-            self.tests.append(Selftest(testcase, args.path, args.timeout))
+            self.tests.append(Selftest(testcase, args.path, args.timeout,
+                                       args.output))
 
     def _log_result(self, test_result):
         logger.info("*** stdout ***\n" + test_result.stdout)
-- 
2.53.0.1118.gaef5881109-goog

