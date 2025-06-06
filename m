Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F8F241665
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 23:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254200; cv=none; b=GeNEza7Thf7nGqNLta3GXrKusboRVDw2zAlTcpODI0qzce1lxcAHMtEsmDnKGlHzhDwcZhsZumpXcmaxhA6ccmyYt8ohWht23drz30Pdm1kXGhBirrMiebPDxbDPwQmSPfTSG1mM3MixLoG6WmWfW4ehj/nsQVAQEALDh8FzRRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254200; c=relaxed/simple;
	bh=Ihob1sHphXHSWGKCbUN9DBpSn9m5Jbo7b0e4RSyKcQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uX4/y4o/JM16Litt6fid5M9EQhre1OcZH+LhA9WbDRBe5cEzopGZHzkT1+/INpqKxeNpsIUHNWsBXEMkHBSlgITd52nTPmSUtG/ecVZE8fyILxkSC91E2oKWtBc7nOBXKr85bl2h/YXSdkLJNIYeYJeKl/GDRCgR8wQmX72cfoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S8l8+9zN; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S8l8+9zN"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234a102faa3so17354645ad.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 16:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254198; x=1749858998; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A+5Bd7zkjIDO1H+lfyodM1++vUZ5mljRsfn//VOCKL0=;
        b=S8l8+9zNKBXqXU42v55yudKEAtscR3gaf3jc0QomCLS1S1ZVKsCM+RiGS5CQpFH7/j
         kOskkmiIGIxJFzKf0cGVTaT04fGM2+gFnzU2KtvbtxC7bR7NHsVX4rbItnQ9iaq+Pl1d
         WjHYO4DP02Id3cD8KI75E1gEoQUS8FCsaX0i14fAXHlTjYWrtIhDgfUqiA/iN8BJOVK4
         j5877p4GhBW7Y8XVQqH8rVeUgwcV9QEU3j08UZCXeLBSLMbtnccZNst+biCV+779T/43
         xAaLS4vkzCQm5vhr3ehtEmrfscGEaQdftdYlLPuMYOJPGPipfNPHAaki4OTfD5N+gDuU
         x8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254198; x=1749858998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A+5Bd7zkjIDO1H+lfyodM1++vUZ5mljRsfn//VOCKL0=;
        b=sNjhiW6X6T4bn4THMXMrPe2dnS6Z4AEdp/XUA7wqucLYCAU8zTodY79+WYESpJjkP0
         0WA4D9DZWV3eVlTv85ajHlpUZWT9sIjcnUA70L83R//I8zJeBxmIv/Gh9/brz9RfAwLe
         PXE1rSbGYlKuG4n6zC+HH1+YnrZ1HA0RVNGokvMfVeu/C0Q5TZ/be3fv4nzWT/3eRr2M
         uwW8CERyhZkx/D5hYSN715lfIN1/Dnz1sK+HpjFuhcaeza2Fx7FsUrkKA2DOtrPk1Ee2
         rXKxwVMFnfcPeztcSdGbtIyaBBtyuqIqSJ0JRw3j/Af7HzPlF9xCqvk3hU1Dzu0fjdxW
         kXsg==
X-Forwarded-Encrypted: i=1; AJvYcCW1NTRv/xos+QQzmFUv6ekuV2TvBMJEOAI8c91PqbiG0SHEcwsO5zbl2OEipQPpEWubj3RhjeU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1naW/YmOJa37dUKXP1VH2hSjyPMm2MQuBphEhEDwHPnHWJpjO
	WnAGrYH2my/Fv6nqnPrBnxDViSxz2DmbIKxt1bR1lIxCEe56PxgpOXBBqmonSgskOtvVdu9IxRJ
	QSPzxfjNrlg==
X-Google-Smtp-Source: AGHT+IHU/sU0ESGBwoHFbRLLuKr1fUnbJgHvmdDkRH8dhCDT6jHEHhlFqQcWVOeHKmjkrwzUfyxEHDaa/fs2
X-Received: from pjbsb7.prod.google.com ([2002:a17:90b:50c7:b0:312:391e:a230])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54c:b0:234:9066:c857
 with SMTP id d9443c01a7336-23601e50d77mr66571995ad.21.1749254198048; Fri, 06
 Jun 2025 16:56:38 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:08 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-5-vipinsh@google.com>
Subject: [PATCH v2 04/15] KVM: selftests: Add option to save selftest runner
 output to a directory
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line flag, --output/-o, to selftest runner which enables to
save individual tests output (stdout & stderr) stream to a directory in
a hierarchical way. Create folder hierarchy same as tests hieararcy
given by --test-files and --test-dirs.

Also, add a command line flag, --append-output-time, which will append
timestamp (format YYYY.M.DD.HH.MM.SS) to the directory name given in
--output flag.

Example:
  python3 runner --test-dirs test -o test_result --append_output_time

This will create test_result.2025.06.06.08.45.57 directory.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  | 30 ++++++++++++++++--
 tools/testing/selftests/kvm/runner/command.py | 31 +++++++++++++++++--
 .../testing/selftests/kvm/runner/selftest.py  |  8 +++--
 .../selftests/kvm/runner/test_runner.py       | 17 +++++-----
 4 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index f7f679be0e03..54bdc248b13f 100644
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
@@ -41,6 +43,16 @@ def cli():
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
 
 
@@ -71,12 +83,26 @@ def setup_logging(args):
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
 
 def fetch_tests_from_dirs(scan_dirs):
     test_files = []
diff --git a/tools/testing/selftests/kvm/runner/command.py b/tools/testing/selftests/kvm/runner/command.py
index 44c8e0875779..6f6b1811b490 100644
--- a/tools/testing/selftests/kvm/runner/command.py
+++ b/tools/testing/selftests/kvm/runner/command.py
@@ -4,6 +4,9 @@
 # Author: vipinsh@google.com (Vipin Sharma)
 
 import subprocess
+import pathlib
+import contextlib
+import os
 
 
 class Command:
@@ -12,17 +15,39 @@ class Command:
     Returns the exit code, std output and std error of the command.
     """
 
-    def __init__(self, command, timeout):
+    def __init__(self, command, timeout, output_dir):
         self.command = command
         self.timeout = timeout
+        self.output_dir = output_dir
 
-    def run(self):
+    def _run(self, output=None, error=None):
         run_args = {
             "universal_newlines": True,
             "shell": True,
-            "capture_output": True,
             "timeout": self.timeout,
         }
 
+        if output is None and error is None:
+            run_args.update({"capture_output": True})
+        else:
+            run_args.update({"stdout": output, "stderr": error})
+
         proc = subprocess.run(self.command, **run_args)
         return proc.returncode, proc.stdout, proc.stderr
+
+    def run(self):
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
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
index 4c72108c47de..664958c693e5 100644
--- a/tools/testing/selftests/kvm/runner/selftest.py
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -32,7 +32,7 @@ class Selftest:
     Extract the test execution command from test file and executes it.
     """
 
-    def __init__(self, test_path, executable_dir, timeout):
+    def __init__(self, test_path, executable_dir, timeout, output_dir):
         test_command = pathlib.Path(test_path).read_text().strip()
         if not test_command:
             raise ValueError("Empty test command in " + test_path)
@@ -40,7 +40,11 @@ class Selftest:
         test_command = os.path.join(executable_dir, test_command)
         self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
         self.test_path = test_path
-        self.command = command.Command(test_command, timeout)
+
+        if output_dir is not None:
+            output_dir = os.path.join(output_dir, test_path.lstrip("/"))
+        self.command = command.Command(test_command, timeout, output_dir)
+
         self.status = SelftestStatus.NO_RUN
         self.stdout = ""
         self.stderr = ""
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 1409e1cfe7d5..0501d77a9912 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -13,19 +13,22 @@ logger = logging.getLogger("runner")
 class TestRunner:
     def __init__(self, test_files, args):
         self.tests = []
+        self.output_dir = args.output
 
         for test_file in test_files:
-            self.tests.append(Selftest(test_file, args.executable, args.timeout))
+            self.tests.append(Selftest(test_file, args.executable,
+                                       args.timeout, args.output))
 
     def _log_result(self, test_result):
         logger.log(test_result.status,
                    f"[{test_result.status}] {test_result.test_path}")
-        logger.info("************** STDOUT BEGIN **************")
-        logger.info(test_result.stdout)
-        logger.info("************** STDOUT END **************")
-        logger.info("************** STDERR BEGIN **************")
-        logger.info(test_result.stderr)
-        logger.info("************** STDERR END **************")
+        if (self.output_dir is None):
+            logger.info("************** STDOUT BEGIN **************")
+            logger.info(test_result.stdout)
+            logger.info("************** STDOUT END **************")
+            logger.info("************** STDERR BEGIN **************")
+            logger.info(test_result.stderr)
+            logger.info("************** STDERR END **************")
 
     def start(self):
         ret = 0
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog

