Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DF7254B1F
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 16:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250221; cv=none; b=QDRq74fIw2gGAs6dRAo+rlG7PjrGqhgfFlsuIiFKjk9aYGmFW16sSKEG3mEpEoCEM6forP42QZlXI4AkW4wB34GvnkYLnWljNNfQauaywBFegaRllpggpL13pAaX+k1LP/QDYWGL1ByEdY8u23FChlNeZO69s9Adid0k3DTTkhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250221; c=relaxed/simple;
	bh=lineM6Le2PSJRtKyCQTtrPVbmPz4X5IqFEqNVYi1TPU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KtiLpYp+A/537B6ADohhOceQZ69F0eBvuYWUJ8yCkoauFRVziZ/PsnuucWvlOnGl9yWY2BYAOxxD0A0DyoF09VN3qhJrb7kz4w0bJYJRnj8Ws3jg60OW2L3o2i42Oyym46K5ENRpznbyRLRLJ3RqXJX6874yAwuMdNf8inSdEEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1w/0RldF; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1w/0RldF"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2e60221fso8488703b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 09:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250219; x=1759855019; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0GTsqnY4+saNzCy5mGyriIvmSp6eaE/vqi0JjCPWBoU=;
        b=1w/0RldF06pKA1QXBO0e9EwTgy+v7g+xLiamQSSNvUyvH4deL4njoY1YUWqfLo5APq
         XczDZIvgZjEsJ9o/kSZr+3PzOH+0o1RZbWv9Mi/gqEyeVE9Neqmf5KXaWoNutaAPJq1y
         /YolMfR5ieF7KEnxe+wQ+ZX1fo2HGlGiHpA7NWOFO9iLTvWQl1pjpxA1dmifb7PMDKQN
         egQU+Ng6FyP3t9Vc+CCSp6G8YIkwXOQ1U4S+Z7wBUqzgpIsejhZyHNZOUySM4fm1dnoZ
         NZnNXUptub6h6a8texWNCwwg3gbSRb6nx6VWTyEyE2URDE+VbUxcEa9bxAQqD1M7m25/
         NqIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250219; x=1759855019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0GTsqnY4+saNzCy5mGyriIvmSp6eaE/vqi0JjCPWBoU=;
        b=iVl6LpKeWChtmWe6G+uShR13rsWMH9PjgOulxCsemf3XzKguvIBV2bnz6CzTYgcsLf
         SLEEnaRY21czLdaAWLz2/llDk0yTWg3XF9BrSAF5+yNTbxVvuHzDIMmWhv2G9TxkXkIW
         bo2yhapTF0vPbo8744JV7p0MFROQTSRsBp/9qC+KrwJP9v85naFyuFOdLSWppgxDMxdB
         8NVN4u7HI82atICNWf4yI5VJ1slAYY+s7dXSk1OuUbzX3RyUJetBhZSYhMdn2U+gt202
         G/jLkNvadQK++dPNRQxsxvvOsSGoO8TPV/NY4a82R9ayxtwKGI7oSD7oEHkGd/65GtiN
         +R3A==
X-Forwarded-Encrypted: i=1; AJvYcCXIsf7hS4Mmn4PazsvTV+C77eOcMwojPCGKRiIAkmfgHF+OuM6qsti0GcLhzVTTLP0UWyxcGeQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLzdOuQQfdug+QRi6p+0SS3Cg0jIMHYf+pB+HRHNI5I1V4bOw/
	o9q39vgzC5xLj8O9muXJlvnNAhpscbaaQfJRBI42KMnFJK/eptRDNZffzxI+HPuKJBy0D6cm8ih
	d1C+WXqwcdw==
X-Google-Smtp-Source: AGHT+IGhAsgZwOMvoWdZcUEtVVfFvQe5AhCplay9erkcPQTqVQZCmBY4Dt3zYWPsYtiBB7sDVDiH7IVgr5gK
X-Received: from pfoh11.prod.google.com ([2002:aa7:86cb:0:b0:77f:138f:8b8f])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3cc4:b0:77b:5b58:34f7
 with SMTP id d2e1a72fcca58-78af4143e2amr69675b3a.9.1759250218647; Tue, 30 Sep
 2025 09:36:58 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:32 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-7-vipinsh@google.com>
Subject: [PATCH v3 6/9] KVM: selftests: Add various print flags to KVM
 selftest runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add various print flags to selectively print outputs on terminal based
on test execution status (passed, failed, timed out, skipped, no run).

For each status provide further options (off, full, stderr, stdout,
status) to choose verbosity of their prints. Make "full" the default
choice.

Example: To print stderr for the failed tests and only status for the
passed test:

   python3 runner --test-dirs tests  --print-failed stderr \
   --print-passed status

Above command with disable print off skipped, timed out, and no run
tests.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  | 45 +++++++++++++++++++
 .../selftests/kvm/runner/test_runner.py       | 19 ++++++--
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index b98f72c9f7ee..4867e89c30f2 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -9,6 +9,7 @@ import os
 import sys
 import datetime
 import pathlib
+import textwrap
 
 from test_runner import TestRunner
 from selftest import SelftestStatus
@@ -60,6 +61,50 @@ def cli():
                         type=int,
                         help="Maximum number of tests that can be run concurrently. (Default: 1)")
 
+    status_choices = ["off", "full", "stdout", "stderr", "status"]
+    status_help_text = textwrap.dedent('''\
+                        Control output of the {} test.
+                        off   : dont print anything.
+                        full  : print stdout, stderr, and status of the test.
+                        stdout: print stdout and status of the test.
+                        stderr: print stderr and status of the test.
+                        status: only print the status of test execution and no other output.''');
+
+    parser.add_argument("--print-passed",
+                        default="full",
+                        const="full",
+                        nargs='?',
+                        choices=status_choices,
+                        help = status_help_text.format("passed"))
+
+    parser.add_argument("--print-failed",
+                        default="full",
+                        const="full",
+                        nargs='?',
+                        choices=status_choices,
+                        help = status_help_text.format("failed"))
+
+    parser.add_argument("--print-skipped",
+                        default="full",
+                        const="full",
+                        nargs='?',
+                        choices=status_choices,
+                        help = status_help_text.format("skipped"))
+
+    parser.add_argument("--print-timed-out",
+                        default="full",
+                        const="full",
+                        nargs='?',
+                        choices=status_choices,
+                        help = status_help_text.format("timed-out"))
+
+    parser.add_argument("--print-no-run",
+                        default="full",
+                        const="full",
+                        nargs='?',
+                        choices=status_choices,
+                        help = status_help_text.format("no-run"))
+
     return parser.parse_args()
 
 
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 92eec18fe5c6..e8e8fd91c1ad 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -17,6 +17,13 @@ class TestRunner:
         self.tests = []
         self.output_dir = args.output
         self.jobs = args.jobs
+        self.print_stds = {
+            SelftestStatus.PASSED: args.print_passed,
+            SelftestStatus.FAILED: args.print_failed,
+            SelftestStatus.SKIPPED: args.print_skipped,
+            SelftestStatus.TIMED_OUT: args.print_timed_out,
+            SelftestStatus.NO_RUN: args.print_no_run
+        }
 
         for testcase in testcases:
             self.tests.append(Selftest(testcase, args.path, args.timeout,
@@ -27,10 +34,14 @@ class TestRunner:
         return test
 
     def _log_result(self, test_result):
-        logger.info("*** stdout ***\n" + test_result.stdout)
-        logger.info("*** stderr ***\n" + test_result.stderr)
-        logger.log(test_result.status,
-                   f"[{test_result.status.name}] {test_result.test_path}")
+        print_level = self.print_stds.get(test_result.status, "full")
+
+        if (print_level == "full" or print_level == "stdout"):
+            logger.info("*** stdout ***\n" + test_result.stdout)
+        if (print_level == "full" or print_level == "stderr"):
+            logger.info("*** stderr ***\n" + test_result.stderr)
+        if (print_level != "off"):
+            logger.log(test_result.status, f"[{test_result.status.name}] {test_result.test_path}")
 
     def start(self):
         ret = 0
-- 
2.51.0.618.g983fd99d29-goog

