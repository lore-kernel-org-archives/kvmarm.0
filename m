Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63583E8C5A
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986140; cv=none; b=UDLtsJ/JOkQODDoV4cgLeHElGeTn2T1ktDzXofG6zvkgAqyBEPakvcHFkSiQcpr02OZswEDypovDhuAUpIVnn3RgZlYbJbnbSGM6ntxgo0xGDr7NULvdXf5sbkIjFJJLcJ2Gf8eZiKzptLEFGaeMqsxDjf2Qf9STnn3yw075zx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986140; c=relaxed/simple;
	bh=sJLh7zQ+2xghMg+4TpGlwVkndrhStHgqixH3CSNZzgw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f4SMbnXgySv2i3lL2f+xai9ayaT5X8ApjOJJv8D8MNGdM+yjhSLsHwemt+QofiODGzKQRIisa3g6h3F9TG2doz1aE0zBz0wHlg9Hgf2UYM98MEyr4rwVS5AiRJsPq5CtKVRFuedkbUB23BVxil07HuAxB6Wv+s/RVjvtUQBlZDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W0Pn1SYX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W0Pn1SYX"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso7017665a91.2
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 12:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774986138; x=1775590938; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MqTZM8Atvognfn8r5xuaknIcSyhPV2VEo05zIHjpojQ=;
        b=W0Pn1SYXWr6pCixAZ31KI9QeE1PDxDlaNigXKdWv6sJEYjqLUVAKcJZ/yXbxDQq0Bf
         om1QFRxEi4kZL9v2WB5V9jTA3u9YQGDZKnS0bta+uBPPfm3+6Dnswkr3TEzcN1OS3kkm
         0rxAO8y4Nc3heLIRBDX75vIovK9/PuyL4tvBm7WfKKbCVD+19R2BZViYzUdR1W95jUaC
         4ahQtPFIzQUWxOgAdaNmr6dFzTE8MmAK3MYXMi3IoT2Ks0LWdxUY3/hOUewVQO6c9p4s
         +MD1HbAP3VOCGM0YJVli7FjJhWVj3klntw8lM8MHdJlBs0kF8G6dzqPp8parpirM8+vV
         LZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986138; x=1775590938;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MqTZM8Atvognfn8r5xuaknIcSyhPV2VEo05zIHjpojQ=;
        b=Qkq5kyQRZmJo2S29Q6YFXEvlJa+a8XxapjHidd6rUStwDdAnJx/uPqiCUPmtTXVHlb
         AV91WjnUeAsapagIvfKRr0MXyyXlZlQerc3lC78+XkhimEGS5//orl1H6RkOXfjK8cb6
         LTSF5K3RyQeBzP/rWsh3gTm6QjBYejMqRhbxJB449saUiB/ThYgH77XP6mzApEjf90B4
         lkARU0ZqBM6IpjrtOoYfiWRpjV6SRbCjzyMoX19Q245k8uhbVNjn9tQhRX2vDG7bp5Gj
         245TjrseEwwRkEfPBBBW1Wm9v9h90KVfSHArQ3RjyvXnGEnB8VBRwRhQIVEjiVcHCV/V
         kMtw==
X-Forwarded-Encrypted: i=1; AJvYcCV/DOYRs2Z3KQ17CO7bBfWkXJP+0B7YEuRIJBCUEqYLb2d0xZGahOyOmdBOByHG6KMfc2/rB1c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyq2sd2jzvQSrb8dnZ6V8p3zCNqhPyuzREg7VqFFxcEnCdGWcyb
	OlAyTA+QvklzDao1SuLv1tJ40e9r2jmlV2bCYUQRh1taPv1Xa6tCkDNufafmRF4spZVcSzJOOam
	QG1BPJfqirQ==
X-Received: from pjbqi4.prod.google.com ([2002:a17:90b:2744:b0:35b:993f:f936])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57c4:b0:35c:d37:6024
 with SMTP id 98e67ed59e1d1-35dc6edbfd0mr555200a91.11.1774986138004; Tue, 31
 Mar 2026 12:42:18 -0700 (PDT)
Date: Tue, 31 Mar 2026 12:41:56 -0700
In-Reply-To: <20260331194202.1722082-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com>
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260331194202.1722082-4-vipinsh@google.com>
Subject: [PATCH v4 3/9] KVM: selftests: Add timeout option in selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line argument in KVM selftest runner to limit amount of
time (seconds) given to a test for execution. Kill the test if it
exceeds the given timeout. Define a new SelftestStatus.TIMED_OUT to
denote a selftest final result. Add terminal color for status messages
of timed out tests.

Set the default value of 120 seconds for all tests.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  |  9 +++++-
 .../testing/selftests/kvm/runner/selftest.py  | 29 ++++++++++++-------
 .../selftests/kvm/runner/test_runner.py       |  2 +-
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 9b6c78e69c64..82c543d11c34 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -37,6 +37,11 @@ def cli():
                         default=".",
                         help="Finds the test executables in the given path. Default is the current directory.")
 
+    parser.add_argument("--timeout",
+                        default=120,
+                        type=int,
+                        help="Timeout, in seconds, before runner kills the running test. (Default: 120 seconds)")
+
     return parser.parse_args()
 
 
@@ -44,6 +49,7 @@ def setup_logging():
     class TerminalColorFormatter(logging.Formatter):
         reset = "\033[0m"
         red_bold = "\033[31;1m"
+        red = "\033[31;1m"
         green = "\033[32m"
         yellow = "\033[33m"
         blue = "\033[34m"
@@ -52,7 +58,8 @@ def setup_logging():
             SelftestStatus.PASSED: green,
             SelftestStatus.NO_RUN: blue,
             SelftestStatus.SKIPPED: yellow,
-            SelftestStatus.FAILED: red_bold
+            SelftestStatus.FAILED: red_bold,
+            SelftestStatus.TIMED_OUT: red
         }
 
         def __init__(self, fmt=None, datefmt=None):
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
index c1720897c629..e3924ee40ab3 100644
--- a/tools/testing/selftests/kvm/runner/selftest.py
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -17,6 +17,7 @@ class SelftestStatus(enum.IntEnum):
     NO_RUN = 22
     SKIPPED = 23
     FAILED = 24
+    TIMED_OUT = 25
 
     def __str__(self):
         return str.__str__(self.name)
@@ -28,7 +29,7 @@ class Selftest:
     Extract the test execution command from test file and executes it.
     """
 
-    def __init__(self, test_path, path):
+    def __init__(self, test_path, path, timeout):
         test_command = pathlib.Path(test_path).read_text().strip()
         if not test_command:
             raise ValueError("Empty test command in " + test_path)
@@ -37,6 +38,7 @@ class Selftest:
         self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
         self.test_path = test_path
         self.command = test_command
+        self.timeout = timeout
         self.status = SelftestStatus.NO_RUN
         self.stdout = ""
         self.stderr = ""
@@ -50,17 +52,22 @@ class Selftest:
             "universal_newlines": True,
             "shell": True,
             "stdout": subprocess.PIPE,
-            "stderr": subprocess.PIPE
+            "stderr": subprocess.PIPE,
+            "timeout": self.timeout,
         }
-        proc = subprocess.run(self.command, **run_args)
+        try:
+            proc = subprocess.run(self.command, **run_args)
+            out, err = proc.stdout, proc.stderr
+
+            if proc.returncode == 0:
+                self.status = SelftestStatus.PASSED
+            elif proc.returncode == 4:
+                self.status = SelftestStatus.SKIPPED
+            else:
+                self.status = SelftestStatus.FAILED
+        except subprocess.TimeoutExpired as e:
+            self.status = SelftestStatus.TIMED_OUT
+            out, err = e.stdout, e.stderr
 
-        out, err = proc.stdout, proc.stderr
         self.stdout = out.decode("utf-8", "replace") if isinstance(out, bytes) else (out or "")
         self.stderr = err.decode("utf-8", "replace") if isinstance(err, bytes) else (err or "")
-
-        if proc.returncode == 0:
-            self.status = SelftestStatus.PASSED
-        elif proc.returncode == 4:
-            self.status = SelftestStatus.SKIPPED
-        else:
-            self.status = SelftestStatus.FAILED
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index acc9fb3dabde..bea82c6239cd 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -15,7 +15,7 @@ class TestRunner:
         self.tests = []
 
         for testcase in testcases:
-            self.tests.append(Selftest(testcase, args.path))
+            self.tests.append(Selftest(testcase, args.path, args.timeout))
 
     def _log_result(self, test_result):
         logger.info("*** stdout ***\n" + test_result.stdout)
-- 
2.53.0.1118.gaef5881109-goog

