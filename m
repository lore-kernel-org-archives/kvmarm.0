Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D164F2522BA
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 16:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250217; cv=none; b=AZZwNU/DHjKhjW/HNxd0UtQxCIw6+WIz1FB0bsPkiO2in1mEMDNMMQV28yx6zPk2HVzTqaakjC/InqAfospsu0+p+CmKXgvxbkcpBUciKfW+YW3wwPnD+MYAjl7TFNxzYrnVkA5DMQI99RtuZac9eC35PS2Msj1Or/1/Nuaws4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250217; c=relaxed/simple;
	bh=e/8GekqR7lq1KIRfT3CYCh/IeXU0XhWbKZ6t240aQcg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g7gtZoQMwaptel9vu2lmZHGTKxRG2B9DVJzV85tIvdz6uEAMX6/ZQBwOOMrL3TKtwy1lPmljRwIZtiF1jnmzHlJL8nRoRO5qRNnRhgKOq3M0pVycO9HLmgm0x/mc5DlTvMMPA2ch3oKqR1pXB/uWcnP7YTbQG9D/lt03Fm+GsjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QsbD91MW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QsbD91MW"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befc08so11991743a91.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 09:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250215; x=1759855015; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i/QRF3FFgseL8D0g15ww2uGbub0UU/EJdFmqDVXw9oU=;
        b=QsbD91MWVAivtNgntb8ubdYyU0QFyMfrVD49fNZpkRjvyUJPFb+2WrR6iX9ZJbnF8F
         D+JpW0OniP/YyoczyyHH9kk84Zr94b13ZnhgsesOAKC10H1/lAvE9KowUWzXm3RzVWUr
         7XzzPOoTVf9O9a4wEW0/s6MzW3cm00ITTzwHPTbu1TSNGWPleRlqr0vNZgtrkxs1nIm+
         taBJN0VhH3szJRT4x6cnjYxCHI+hLOeLVkpfevl8MHd1kZtyeBQLI2YWXFGPeBo+x4fg
         pLayeQAd+zSTjL+cLcZrp41dsuJzEh0kOGk7KOOk666PTwbWyPetaQjaS0dPK4HUr/ry
         ylyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250215; x=1759855015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/QRF3FFgseL8D0g15ww2uGbub0UU/EJdFmqDVXw9oU=;
        b=gl15ztudRtoz4YSRcjbqlkNA/1zhp3IfVwsApxen5TAeFIXQm5XPKHQ80MNbhLGXa+
         NOg0ndCnyxfdXRlNyoe8Z2HsykL5/583+E+L8cKVd/NkXhUMUymcI2//5pePItKFOCLz
         ASxL++aKvOJWQPM9N8I/DsLEfjNARkTyHkXMyKjWRZI8QhTmEF17mAJUrIAYjib+fep8
         rI3dLkQaCHw7r1gA+WvxL2/8216/nNy67+JmiuNnex3wHpHnRtUlhzEvhlzhnlqPjqQo
         LiM1+DEl91y74wN8t9c86m+Eh8npreGwDPe0sSvxWv9JDdFyo7dBGRlgOrfXicdGCGX2
         BuCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBegYJ4pKCvj5u9mmN6XX69U+I9G/t1cI1I0IOFiITl5UJTzwdCLaiabuF1Abp1XfqzAqGsL0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQK+NN01ul/3rqXWCcHecv3LbGAOsGKxMMIKZhiTHeXD3F+CvD
	btRpTNB0C96bTY68HEW2BXWkq1ImENCtWHDLstdjufLWd40979HE0qju2JW9DRN06dlFaz2iJz8
	uIoEGV6jU7A==
X-Google-Smtp-Source: AGHT+IEdeV+S3AOsumfo+VA7YBUiHc/nL5ezOQx5Foo8J1Cq3HgpIz3y8FReXq936G/8G4+cCaSjSkfD+N8w
X-Received: from pjbpg12.prod.google.com ([2002:a17:90b:1e0c:b0:32b:50cb:b92f])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c83:b0:338:3221:9dc0
 with SMTP id 98e67ed59e1d1-339a6f69812mr102527a91.37.1759250215269; Tue, 30
 Sep 2025 09:36:55 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:30 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-5-vipinsh@google.com>
Subject: [PATCH v3 4/9] KVM: selftests: Add option to save selftest runner
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
 .../testing/selftests/kvm/runner/__main__.py  | 34 +++++++++++++--
 .../testing/selftests/kvm/runner/selftest.py  | 42 ++++++++++++++++---
 .../selftests/kvm/runner/test_runner.py       |  4 +-
 3 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 5cedc5098a54..b27a41e86271 100644
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
index 4783785ca230..1aedeaeb5e74 100644
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
-            self.stderr = "File doesn't exists."
-            return
-
+    def _run(self, output=None, error=None):
         run_args = {
             "universal_newlines": True,
             "shell": True,
@@ -59,7 +59,12 @@ class Selftest:
         try:
             proc = subprocess.run(self.command, **run_args)
             self.stdout = proc.stdout
+            if output is not None:
+                output.write(proc.stdout)
+
             self.stderr = proc.stderr
+            if error is not None:
+                error.write(proc.stderr)
 
             if proc.returncode == 0:
                 self.status = SelftestStatus.PASSED
@@ -71,5 +76,30 @@ class Selftest:
             self.status = SelftestStatus.TIMED_OUT
             if e.stdout is not None:
                 self.stdout = e.stdout
+                if output is not None:
+                    output.write(e.stdout)
             if e.stderr is not None:
                 self.stderr = e.stderr
+                if error is not None:
+                    error.write(e.stderr)
+
+    def run(self):
+        if not self.exists:
+            self.stderr = "File doesn't exists."
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
2.51.0.618.g983fd99d29-goog

