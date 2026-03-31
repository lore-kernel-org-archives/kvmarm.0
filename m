Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BC43DFC66
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 19:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986145; cv=none; b=lwWce5PQmuHkfNErOyrHwxn6Q94p7rXhvxXBB/W8u5BlZiTZ38NTSlLxFT1wQSDCczT/IpFvxF7nP3XhHQtEiM7S2jtRZaZdrG3c9gm1X2OrmthXtvRAs/UFi5JYT9de7ZJ4Lx6offvRvNGNJ8035VaplhX5iC5Vi7snL/Nco8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986145; c=relaxed/simple;
	bh=xdX3vBGoe37S0Rnd2Z3ik/g1FT0bPLF7gcwO6eoaLdQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XJZyfMGZO0hEOU7BExeeexLEsc+BBdI5zm3cr/KmP1TOKYj8yX9dLq2TgYxFZKjGGcMup1oTvLolI91ZztbPMAAry8Lc1hKf5ojwxVgmnRTV1Etu0miIdqii2R1kYarUs426QnpRPu7RPtodd6NJzSO3CFNzMAZyAZOl0nYLPGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ityUTrh6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ityUTrh6"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3568090851aso19113923a91.1
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 12:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774986144; x=1775590944; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SmS1uHrhcJAkZ/77nv6KxNChDlZ5TAlHKr2qEzAIUF0=;
        b=ityUTrh6x2NOdc+yTHjc/A7nsZKKp9EDsS3ojHHHKyjPw9YKekcoSUNXLhLvf6vh5W
         9NcYivGktZUGer7kgv5+jYypVV7RGYBlSzeaXvxwO9WBsT2HEBANIXhd3M8JDpXskfzu
         56eq9dnmf0YoZiXvHg62fm/LJvql15YjzbDAfaOD+uEgenZPPscHqNWXYSezZDdvHyxi
         SM7eK5R5xiAeNpenc/QTMyIxRF6bCkwDCeF5xn8JJbaFFAnQFGfLeU3imiNp0R58m5mD
         SqHCz+tXcjE4cHCV0Mgce12ygOWzL1tivImvBw+4xs06bZzep4x4mZldLPhNPlivxS+N
         uwsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986144; x=1775590944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SmS1uHrhcJAkZ/77nv6KxNChDlZ5TAlHKr2qEzAIUF0=;
        b=RkwMgJYGRWl1+KeTnxtcgInCdJZLwjYhRsUpmvi9fIHR77H7JX5DXvpfyFqL7vWsdw
         AXrEz3N4JZHzyJOKSAhFwD+9m40XLoFxpJlyqvVBMiURm60K4lHPWp9NTQvjVOBOrwy7
         9mCMtzJebMvkOLoxwrt+/CPBJYzO+YbNJvlXSSWdF9H2KgQRTUym32Ey0UM6d33GS8UZ
         UW7mXHrYCf2Mveh3qWFPYSIUCToFfwqVCln0Xm9OA0vI8k78OeNRcZngQj3NXwDz0JZB
         wwI/IZmQU9D15RWMrVFTewOFOa0Z+4W/PqrUoVjb7sjkSctBi0uN2RddAobFhEPiyXS0
         v1AQ==
X-Forwarded-Encrypted: i=1; AJvYcCVm4AEkO2mojXVjg2FE5uCZL1LypSJsmcMSktBenZAlUi8/XU2opUciESI+i21Beu0SBAEr9cc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzaTQIaddWFLp1RLDpKKBX8gminzvAfYf/A2aqBkTO8VD29TjRJ
	bwfTVNblDk5FMOpQN91YdEl0cngerOIdewA7cwJYj+U+RSMpp75cd1a2VsuGnXXYJ1hnR2IqTYG
	w96uRoxcP1A==
X-Received: from pjbng13.prod.google.com ([2002:a17:90b:1a8d:b0:35c:23cf:b494])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ec4:b0:34c:904a:d92
 with SMTP id 98e67ed59e1d1-35dc6fdd803mr478428a91.26.1774986143568; Tue, 31
 Mar 2026 12:42:23 -0700 (PDT)
Date: Tue, 31 Mar 2026 12:41:59 -0700
In-Reply-To: <20260331194202.1722082-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com>
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260331194202.1722082-7-vipinsh@google.com>
Subject: [PATCH v4 6/9] KVM: selftests: Add various print flags to KVM
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
index 96402c89aea9..13f4cbea1fa7 100644
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
+                        Control output of the {} test (default is full).
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
2.53.0.1118.gaef5881109-goog

