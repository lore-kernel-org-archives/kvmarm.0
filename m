Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACD524166B
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 23:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254205; cv=none; b=d9lhZQJVC8GQ+6BdOomPubWAzxvaSVGyoZxFDyCsaXO2CuM75X/xO4y9U1To76EVR3J8qc0E7m7+gS0/CZYqb1xiy1z+S2XurVCOfe829ACQYgsTneWpyAsjeR856D49AKtyDQSnuyxCS/U5eno5kGd8ls9lGyTYW1wGDzOpYwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254205; c=relaxed/simple;
	bh=VyCqfXOdfbOsRkoGkNU5UmQxiMZNF/Jl1QSi1q90LNs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SWFedaIECOCfCpYm0p06ccf7CLQuYrM8kEU9BYveC8UH7ovHVTIqRkka6u3lgGIKL9c1JkHmYbENBg8xSEa58FV7OaLU/JuxhanyzBbXo0QNV5S0meJdFcG0kckSjJKbVp+HqKTXm8NeXkWRaY0nduYyoID1SRsDuEm4J1VMtmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pou4BqCi; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pou4BqCi"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7377139d8b1so2154632b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 16:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254203; x=1749859003; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8z4WvBicEoN9caj+LocUILTDszd9KNhP2i6ClnV4SYQ=;
        b=Pou4BqCiNvzuq6FXbJLEPh1H2Qx039wHk7VGPIyjBmJ9Zhug6+LnRstHqgUqe8jt3S
         YAQXWbwOhdlo+dnVMgVmNJItf0cQuQSCCXkxqTlSNNDk0NSsL7JXw8/B74WATO27gT1f
         TpmHwCC6fL9XyoVWnq1xf/DXgON6lHvjVtFatG6Ft+sDrfM9rjpiVP1v2niwGWv/TmIP
         p6w3+9lyf07RmebsoZYBJobMtAB0UajNKkLUpmvi5mzEFRGKqEJUf2CZyp06LL06GOMV
         FvNPH8u8gbnALGczergy3DhbHvzEmNrb44Q7bYy9dGLlfYvB3NwWY5pD909wWzLe91ug
         wz6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254203; x=1749859003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8z4WvBicEoN9caj+LocUILTDszd9KNhP2i6ClnV4SYQ=;
        b=YJOPKuMCy7oK6hEKpRoj2TB1THWvMrb3tRWOaYvUhj3R6Lc98G1mskoOy90jEsL4gx
         jSjTVpnSZZjNQnqLROzkVxe8QhUjXm8VQJp9kUidutsXQPAMvPrbAUQDwmhwfSn4BuOx
         UxEl9mZfuTmKNiCY7XCjwNTKtuHQoAshCDlZ4ci7YI/Tqyx/zZEn5y090H/lJ2mEh0rB
         e08nhhhRA1qRnw9qEn8JXyzkSbsqzQ1X10YdsdT2MeO/PDWZM2MKSUEn3pFdBaI0/cT0
         VRcCqJm6WgK5aS2XEsHahoNXs6Q6p4ww9rkdf1aKfV6BRxOhl+zEIbarYGpmm9ebzulB
         e+8A==
X-Forwarded-Encrypted: i=1; AJvYcCUE4ND5qOce3KRNOdFCm0D+Vwzs4mWFN0dmsk+4gbXM9WJ+WiOpkWI2mckgnCe/xABpi7bIMf8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzyxRhHfRiaKXNf55HYt+hPH+M3paZqzKkIiOn9ere0tlDv4RjV
	ioGgABZ/WFzH6QuceBpGuyKcCOJUOA0pJVBWf3pzWoCy5TPYwjG/EhyZaYWgkeFDOTcuiXSITaB
	J79Vuf/tukg==
X-Google-Smtp-Source: AGHT+IHcrbHn9p0w2bYAvuft/4cgpIgfj6gM1mOsYQAwopTnS4Dm3TWFUPJLijBX/4q2FB3OKh1WxAvHIbCa
X-Received: from pfbdh10.prod.google.com ([2002:a05:6a00:478a:b0:747:aac7:7c2])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b4d:b0:748:3822:e8e0
 with SMTP id d2e1a72fcca58-7483822ef98mr1370463b3a.13.1749254202756; Fri, 06
 Jun 2025 16:56:42 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:11 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-8-vipinsh@google.com>
Subject: [PATCH v2 07/15] KVM: selftests: Add various print flags to KVM
 Selftest Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add various print flags to selectively print outputs on terminal based
on test execution status (passed, failed, timed out, skipped, no run).

Provide further options to print only particular execution status, like
print only status of failed tests.

Example: To print status, stdout and stderr for failed tests and only
print status of passed test:

   python3 runner --test-dirs tests  --print-failed \
   --print-passed-status

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  | 114 ++++++++++++++++++
 .../selftests/kvm/runner/test_runner.py       |  10 +-
 2 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 3f11a20e76a9..4406d8e4847a 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -64,9 +64,115 @@ def cli():
                         default=False,
                         help="Print only test's status and avoid printing stdout and stderr of the tests")
 
+    parser.add_argument("--print-passed",
+                        action="store_true",
+                        default=False,
+                        help="Print passed test's stdout, stderr and status."
+                        )
+
+    parser.add_argument("--print-passed-status",
+                        action="store_true",
+                        default=False,
+                        help="Print only passed test's status."
+                        )
+
+    parser.add_argument("--print-failed",
+                        action="store_true",
+                        default=False,
+                        help="Print failed test's stdout, stderr and status."
+                        )
+
+    parser.add_argument("--print-failed-status",
+                        action="store_true",
+                        default=False,
+                        help="Print only failed test's status."
+                        )
+
+    parser.add_argument("--print-skipped",
+                        action="store_true",
+                        default=False,
+                        help="Print skipped test's stdout, stderr and status."
+                        )
+
+    parser.add_argument("--print-skipped-status",
+                        action="store_true",
+                        default=False,
+                        help="Print only skipped test's status."
+                        )
+
+    parser.add_argument("--print-timed-out",
+                        action="store_true",
+                        default=False,
+                        help="Print timed out test's stdout, stderr and status."
+                        )
+
+    parser.add_argument("--print-timed-out-status",
+                        action="store_true",
+                        default=False,
+                        help="Print only timed out test's status."
+                        )
+
+    parser.add_argument("--print-no-runs",
+                        action="store_true",
+                        default=False,
+                        help="Print stdout, stderr and status for tests which didn't run."
+                        )
+
+    parser.add_argument("--print-no-runs-status",
+                        action="store_true",
+                        default=False,
+                        help="Print only tests which didn't run."
+                        )
+
     return parser.parse_args()
 
 
+def level_filters(args):
+    # Levels added here will be printed by logger.
+    levels = set()
+
+    if args.print_passed or args.print_passed_status or args.print_status:
+        levels.add(SelftestStatus.PASSED)
+
+    if args.print_failed or args.print_failed_status or args.print_status:
+        levels.add(SelftestStatus.FAILED)
+
+    if args.print_skipped or args.print_skipped_status or args.print_status:
+        levels.add(SelftestStatus.SKIPPED)
+
+    if args.print_timed_out or args.print_timed_out_status or args.print_status:
+        levels.add(SelftestStatus.TIMED_OUT)
+
+    if args.print_no_runs or args.print_no_runs_status or args.print_status:
+        levels.add(SelftestStatus.NO_RUN)
+
+    # Nothing set explicitly, enable all.
+    if not levels:
+        args.print_passed = True
+        levels.add(SelftestStatus.PASSED)
+
+        args.print_failed = True
+        levels.add(SelftestStatus.FAILED)
+
+        args.print_skipped = True
+        levels.add(SelftestStatus.SKIPPED)
+
+        args.print_timed_out = True
+        levels.add(SelftestStatus.TIMED_OUT)
+
+        args.print_no_runs = True
+        levels.add(SelftestStatus.NO_RUN)
+
+    levels.add(logging.NOTSET)
+    levels.add(logging.DEBUG)
+    levels.add(logging.INFO)
+    levels.add(logging.WARN)
+    levels.add(logging.ERROR)
+    levels.add(logging.CRITICAL)
+
+    return levels
+
+
 def setup_logging(args):
     class TerminalColorFormatter(logging.Formatter):
         reset = "\033[0m"
@@ -91,6 +197,13 @@ def setup_logging(args):
             return (self.COLORS.get(record.levelno, "") +
                     super().format(record) + self.reset)
 
+    class LevelFilter:
+        def __init__(self, levels):
+            self.levels = levels
+
+        def filter(self, record):
+            return record.levelno in self.levels
+
     logger = logging.getLogger("runner")
     logger.setLevel(logging.INFO)
 
@@ -102,6 +215,7 @@ def setup_logging(args):
     ch = logging.StreamHandler()
     ch_formatter = TerminalColorFormatter(**formatter_args)
     ch.setFormatter(ch_formatter)
+    ch.addFilter(LevelFilter(level_filters(args)))
     logger.addHandler(ch)
 
     if args.output != None:
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 474408fcab51..8f2372834104 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -18,6 +18,13 @@ class TestRunner:
         self.output_dir = args.output
         self.jobs = args.jobs
         self.print_status = args.print_status
+        self.print_stds = {
+            SelftestStatus.PASSED: args.print_passed,
+            SelftestStatus.FAILED: args.print_failed,
+            SelftestStatus.SKIPPED: args.print_skipped,
+            SelftestStatus.TIMED_OUT: args.print_timed_out,
+            SelftestStatus.NO_RUN: args.print_no_runs
+        }
 
         for test_file in test_files:
             self.tests.append(Selftest(test_file, args.executable,
@@ -30,7 +37,8 @@ class TestRunner:
     def _log_result(self, test_result):
         logger.log(test_result.status,
                    f"[{test_result.status}] {test_result.test_path}")
-        if (self.output_dir is None and self.print_status is False):
+        if (self.output_dir is None and self.print_status is False
+                and self.print_stds.get(test_result.status, True)):
             logger.info("************** STDOUT BEGIN **************")
             logger.info(test_result.stdout)
             logger.info("************** STDOUT END **************")
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog

