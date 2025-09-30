Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9F1254B1F
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 16:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250219; cv=none; b=ATP5k1jHq7uCXs8JWkRfqyBDxISPoCNfwL2zypAS0IGx4qLocSz0y/SKUdhfkLDI3utj32DgGFdOkISwjgInlZKeGy0JZbcDHWacd2EEkJN0OOre3hIpn9GDk2EAmA8vNkJTTYXgt5le6XT8AULlwm9ttHELdqF1QYBGq32Ck/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250219; c=relaxed/simple;
	bh=ruAd1QUl9SteirFgNfga6On/tTiMWyXsGfVXvanlDfI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WX1ZU5Fhy1UukY1InAMmf4FdDL86ka/jEvemlTUJOs8QxSHoSm1CfeKx6hoZB0GuUKQZT1VNGyQfCpvXDpnKUwegQVGNxME2Kuz5Cop33XHMvJidlSSM98v5yYuljCF1LqtQuU5eivyTFHfnGVl2fH7TzL9Xqu37EmERHEGmYTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GSSMfrzy; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GSSMfrzy"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b471737e673so7557157a12.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 09:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250217; x=1759855017; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/blTKaVRJ7ExwjOeSNjQIII5Nz+Rh7TdSzJjFSlh4/M=;
        b=GSSMfrzyZS9zhLSkUvOJnE+edIR0FoylE7NeLk6A68a2LGxgJScQU7m4iQCA40S2Xk
         0FQJ7fuCzuTR/aDGNPvHXTwe5/nysFkmZZXQVM8gVZVFJ1AUoB7pagRkk1hfewTckdSL
         Ct/4aJHeeS6OsuxhMcNn6Q9JAkK2a7aXLOw0doVQVQ4TzTb/9+0PqYpu99HTOM6eNBnC
         1hrXS/OrVBpoTqhesRQft4r7N0exvsduF/iS6IcbrY2j0Ud8y7GNlqMRg774eOZlr6Aj
         ViFRRhWDk0rSSvqx38ck1jWuwcwaUr43ApGDBiiojAu4PrtjMtYRr4QfJHQKqcEX8kOM
         ty6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250217; x=1759855017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/blTKaVRJ7ExwjOeSNjQIII5Nz+Rh7TdSzJjFSlh4/M=;
        b=gokBjR0wEfJ8wEtRQTnNnACS5EEKw8SyhCRgNxZRYhbH3SszfrFq07toSxuy/u4DLV
         NyLVg5E+WKB0fDwDfFFyQ8d8V3WqSpjJo/zJtorQ7mKDOJ6AJ+reCkZyRwsdIoRrEixM
         DoXgmUaNG1kmuWCi2hfz/yx4QZxM9zQBPk0dxMjnHVpGirSIV1Bryhi5guju6CGaibCM
         TnFpD4IBHcj+bJgMrq6FgNtQlJeRLQ4GST7DIpvtGiVL8pBKk6DnvNGJoGgENLMupzKd
         zRUKpEf/wiSlkwU8B5CCA6NWMKNelSElAu1N7wF/VmqqBWcl2bWtqfOnP+Z8oE4+4xYE
         GzrA==
X-Forwarded-Encrypted: i=1; AJvYcCVw+J7Nbykuus4dVkIEA+XuKK6KL6C/WPsi+dvbfYsHC2CE7X+kGd+EQ5G1MvgWmjjb7v40GDo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9w0ut5h4e5TxZ2bZkOACHxyddi+WCTs5HKESiEf1XWmvT2x9s
	Wwh2ZR7qUfRTGpZlC87kqY1C/kJVopCHidI27kuA7P+V9rMUH/dlYlViI4MMbWEllUPyHCfqbMO
	bp0nf7S5n1g==
X-Google-Smtp-Source: AGHT+IE7rnnLhXFO5s/R1gQ25mkbUuQhQ07CGMf/RRIqGNDBQAmFMCZUe6cqXMyhDeruvPI5USo/PgLLbGsF
X-Received: from pgdf22.prod.google.com ([2002:a05:6a02:5156:b0:b58:d933:1281])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1813:b0:301:daeb:589f
 with SMTP id adf61e73a8af0-321cf13ac4bmr518324637.8.1759250216877; Tue, 30
 Sep 2025 09:36:56 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:31 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-6-vipinsh@google.com>
Subject: [PATCH v3 5/9] KVM: selftests: Run tests concurrently in KVM
 selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line argument, --jobs, to specify how many tests can
execute concurrently. Set default to 1.

Example:
  python3 runner --test-dirs tests -j 10

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  |  6 ++++
 .../selftests/kvm/runner/test_runner.py       | 28 +++++++++++++------
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index b27a41e86271..b98f72c9f7ee 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -54,6 +54,12 @@ def cli():
                         default=False,
                         help="Appends timestamp to the output directory.")
 
+    parser.add_argument("-j",
+                        "--jobs",
+                        default=1,
+                        type=int,
+                        help="Maximum number of tests that can be run concurrently. (Default: 1)")
+
     return parser.parse_args()
 
 
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index b9101f0e0432..92eec18fe5c6 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -4,6 +4,8 @@
 # Author: vipinsh@google.com (Vipin Sharma)
 
 import logging
+import concurrent.futures
+
 from selftest import Selftest
 from selftest import SelftestStatus
 
@@ -14,11 +16,16 @@ class TestRunner:
     def __init__(self, testcases, args):
         self.tests = []
         self.output_dir = args.output
+        self.jobs = args.jobs
 
         for testcase in testcases:
             self.tests.append(Selftest(testcase, args.path, args.timeout,
                                        args.output))
 
+    def _run_test(self, test):
+        test.run()
+        return test
+
     def _log_result(self, test_result):
         logger.info("*** stdout ***\n" + test_result.stdout)
         logger.info("*** stderr ***\n" + test_result.stderr)
@@ -28,12 +35,17 @@ class TestRunner:
     def start(self):
         ret = 0
 
-        for test in self.tests:
-            test.run()
-            self._log_result(test)
-
-            if (test.status not in [SelftestStatus.PASSED,
-                                    SelftestStatus.NO_RUN,
-                                    SelftestStatus.SKIPPED]):
-                ret = 1
+        with concurrent.futures.ProcessPoolExecutor(max_workers=self.jobs) as executor:
+            all_futures = []
+            for test in self.tests:
+                future = executor.submit(self._run_test, test)
+                all_futures.append(future)
+
+            for future in concurrent.futures.as_completed(all_futures):
+                test_result = future.result()
+                self._log_result(test_result)
+                if (test_result.status not in [SelftestStatus.PASSED,
+                                               SelftestStatus.NO_RUN,
+                                               SelftestStatus.SKIPPED]):
+                    ret = 1
         return ret
-- 
2.51.0.618.g983fd99d29-goog

