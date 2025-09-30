Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F60E246796
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 16:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250216; cv=none; b=JmUfEFYCed6CMD2jHeghhcZ1zdrUKoRPn6ckKnHDQxDPA7b8376GRCGDBSJoLZQBhz1Y1g4kOFc26+Enp3KmzU+Fg5aBLRC4WKiy6r5ECgTHunZe//VI7aNPtwkXsrSS9a7FB7FHi0ZE+IqyudXZPJyIMIL2iDe7kehoQagK7Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250216; c=relaxed/simple;
	bh=G97mnyJq28cSBFHDJuK3hFRlCkJ5T2LdJshTRF5pGPo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OJBR4hJEBKqquw2mYUwkZhUOIfPCyYegUlN4Gzfkj/S4eO+xAg6W2kb9iNfqOeMGRAYTrhZEsKVgyLTTGV5DA43RPkmM5XfNcgHy8NnsaTRaKsV+WIyY5ccqJvNCTQvN62NmJierpxw4JxkswJyARaaBjII0GnkjYlZ4wgFKXmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DcX98FYb; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DcX98FYb"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b522037281bso3991306a12.3
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 09:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250214; x=1759855014; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j2Euv6clQfNxoRLfSL+cWKcybU5R4aSAzjQ7Pxx9veA=;
        b=DcX98FYbnWrr3gGgvEiHjMcgqmFLFEUeMW9s1Mnkvaf0AxgNzL88/1XI4D0F7/kQ3V
         lEmv+v8OzvUpQNWBcILggZ2xbQc5syl/QoWmaKlBBvUonLhWsEU82HcT9pdA3lg/DoG9
         lBSK/0Ki5D+vSxQN8JmgRSWDf3roCEvXWHtq6piajAjGN/OJzvzX1SXX3uTHDOo9DGEr
         zlniumwoQinDTvJmQX6c7jqO2HzTpSKrMG7N1gDLIRYd1RysXaTb81W29Ju6pqmmGyH7
         A0R1D+Q2dLuk4eiYkQO0uO2ZN6l2FgNcHYsD/MfMsBOc3Ly8EAQnAKoEGndq7t3lPT15
         od4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250214; x=1759855014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j2Euv6clQfNxoRLfSL+cWKcybU5R4aSAzjQ7Pxx9veA=;
        b=KVrztDooVbXS0pEW6dk1TME9RzbgzaRii4UXGvn53VEKNpobvOrniZQmCzS8+PibkE
         jnfRzVba5kUg4LXMRq3MxJjJ3ze1dfVJgS75ZchtscMbrbIx0E4zZBc+G6y43dsq1n2Z
         Ef/3yI5mnX2srHZ7cefMsqiH14yC02AdGoeLgXrnv+RH8pMXe/L9B/SwBSikoGThnrc9
         3G7sOH7rVRmwWto4Z9kF4blnaLyyfu1pyvuhY42E6VLpndXb5Dib6us0xX1CmyZr0aOv
         Rk2fLLisLcKukPXcQr5NGH5AzWlLis9lrNDdqw4HBwl4cBeoTaKjKwkJ+ZVbgPWop9t4
         VZyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvRKfTrunuHccgHztF2friiloyjAZ2P3iLrJakcjiFsKPGO3IOjI9B0P8wwNIhMv+zgocuLgE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQRRxszHbkkKRmDlEpF8tbLQBqrF2TwwnBTdL1nPs63gzjSEkx
	V8f3Sg6Kok3tRLnVed8jILNN2HHzI/hiNqsOwZ0lhkDohNXdBmapNHGscJKnqTIAz2908FbkyC+
	NzVemR1qFJQ==
X-Google-Smtp-Source: AGHT+IEUJogWYHXsmsuG3UsFdIVcKizfFNq9vULrceDQMPraAU5EEavtCr8SZ2YcitzUBBX0I97qyMqtVbSV
X-Received: from plpl2.prod.google.com ([2002:a17:903:3dc2:b0:27d:1f18:78ab])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b46:b0:252:1743:de67
 with SMTP id d9443c01a7336-28e7f318717mr3857185ad.44.1759250213581; Tue, 30
 Sep 2025 09:36:53 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:29 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-4-vipinsh@google.com>
Subject: [PATCH v3 3/9] KVM: selftests: Add timeout option in selftests runner
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
 .../testing/selftests/kvm/runner/__main__.py  |  9 ++++-
 .../testing/selftests/kvm/runner/selftest.py  | 33 ++++++++++++-------
 .../selftests/kvm/runner/test_runner.py       |  2 +-
 3 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 943c3bfe2eb6..5cedc5098a54 100644
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
index a94b6d4cda05..4783785ca230 100644
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
@@ -50,15 +52,24 @@ class Selftest:
             "universal_newlines": True,
             "shell": True,
             "stdout": subprocess.PIPE,
-            "stderr": subprocess.PIPE
+            "stderr": subprocess.PIPE,
+            "timeout": self.timeout,
         }
-        proc = subprocess.run(self.command, **run_args)
-        self.stdout = proc.stdout
-        self.stderr = proc.stderr
 
-        if proc.returncode == 0:
-            self.status = SelftestStatus.PASSED
-        elif proc.returncode == 4:
-            self.status = SelftestStatus.SKIPPED
-        else:
-            self.status = SelftestStatus.FAILED
+        try:
+            proc = subprocess.run(self.command, **run_args)
+            self.stdout = proc.stdout
+            self.stderr = proc.stderr
+
+            if proc.returncode == 0:
+                self.status = SelftestStatus.PASSED
+            elif proc.returncode == 4:
+                self.status = SelftestStatus.SKIPPED
+            else:
+                self.status = SelftestStatus.FAILED
+        except subprocess.TimeoutExpired as e:
+            self.status = SelftestStatus.TIMED_OUT
+            if e.stdout is not None:
+                self.stdout = e.stdout
+            if e.stderr is not None:
+                self.stderr = e.stderr
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
2.51.0.618.g983fd99d29-goog

