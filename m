Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1034C241CA8
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 23:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254201; cv=none; b=QfaSNeWa2SQuWLvKVI62uNTOr5WCEYiqbttnONJpxX2ww9xAAnk2fhV3Ne+DLkCRryeflFdxHNxq0h/VgZrgDveDcUFYsTtWs5lB01OQNkCsl/6mo5DJMjMZ0YDC8SfFHZw0vFPOMH16bmuGl/TtK2p2/71xo/fpS7DIlfOwODg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254201; c=relaxed/simple;
	bh=bf0CqANxm6Iu1VekbtrJ8l5NBJ7Y3WNqKwPOa6RcxR0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QZYxW9puQ8NuL8GoZNto3N7oviOT4pGjsboxESFU6jAoP2q59oYLK6kNeqe3dudItQhSpP0f7Gu/c4GZXPvOEfgRD4XteEMPm9+BCWAK0edQGC6EFjvjaa1mTnBuV10CAuFsVpNJJ9BtKeK+0ZhTnVT6SIaUiZPKXh6XaGigFIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jFyK0NTD; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jFyK0NTD"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74620e98ec8so2373231b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 16:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254199; x=1749858999; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=odBjuILvJ2GdKU4pLjfdkzpf7BXKuFiwJq3tj2s6sYU=;
        b=jFyK0NTDvoFsDB6PWyikJL2X4M01VmN+REof6MTZdBf687cWwLNsiREV2Cf187YU/K
         VZtvcjwq1MwQI3lwNePRILC2yX0aKThd0le5L7p5DSKjLGaBwGxd6d6EeqbCaOh88RGM
         Lz88zyRZO0yFlT35sGPktnVqITkLs3s1xAid7FuUfVOftk9krqVqiqSRFS+xSrd/S8RN
         pu21SihQVE3GX4oTeU8xKbYBpQI6DpPpu/cukc+N4MYs2u3a++utK8RthaQmx1Q0hmvb
         sGuse7PQXp2VBXhDGc7wWCsewLcretqBgVwsoJyB8zhpesYpH9Fj8/twzv+8qAyvu0g3
         Ob6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254199; x=1749858999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=odBjuILvJ2GdKU4pLjfdkzpf7BXKuFiwJq3tj2s6sYU=;
        b=Pl8axiYGfjjzY0KjMDmyYxTczKnlKax8dbj8mW5AwXf7lOQfPWrJilX7m1RnR0LWdj
         X1VcIsiG577/8TaNDegnylPh1urf5a7LjVptvdLPAFZtli6lSKp552vLx9+yWPEkkI25
         /uMcxrFHp/7z8cKreY8PEIEip5KEG1tQaAUgiKXQlUySkrEqVgVhHgt5WDXHJiTRD5sB
         9Rnc0UMR774IQB8cfs7haivzyAwPfwmfMo5XzjYmN0WlfDNH6hHpxXuNK+zk3ceHucaG
         fEBA0T3mHtrSOw5KI36SLLjIybVMInQQ/CWVkpG/PNpPquQzOmjXUAWlzcCXsYHZ8pwl
         cibQ==
X-Forwarded-Encrypted: i=1; AJvYcCUetCbO2Ua3D06OrHJfh3fCektDNX8gGg5iC7RuS1gdWrYdfRwgQpR7QRPVxEI9m+aJHMbjEyA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYt9w3mKlbhugEx8SyP+datar6DQUu+Ltj+Is9SWqpBMEhls5D
	tAuv7143/xpN7JiNTSDxrQ/fNHQDhNqKkR1NiXoeEWVynX1e77BYz+UMyREkKXKxlrQNNQb9uJi
	vtsVi86wOCg==
X-Google-Smtp-Source: AGHT+IGnW9KI2of5eZ8NHRy+qdCq1b5yQNAN8DIiVg4G8sw5Oy+cQExkg27C/Z3d87sRoL1HT8Zeqsd2ie1W
X-Received: from pfbca27.prod.google.com ([2002:a05:6a00:419b:b0:746:1bf8:e16])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:94a0:b0:746:2217:5863
 with SMTP id d2e1a72fcca58-74839af6c88mr624028b3a.6.1749254199608; Fri, 06
 Jun 2025 16:56:39 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:09 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-6-vipinsh@google.com>
Subject: [PATCH v2 05/15] KVM: selftests: Run tests concurrently in KVM
 selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
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
index 54bdc248b13f..48d7ce00a097 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -53,6 +53,12 @@ def cli():
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
index 0501d77a9912..0a6e5e0ca0f5 100644
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
     def __init__(self, test_files, args):
         self.tests = []
         self.output_dir = args.output
+        self.jobs = args.jobs
 
         for test_file in test_files:
             self.tests.append(Selftest(test_file, args.executable,
                                        args.timeout, args.output))
 
+    def _run_test(self, test):
+        test.run()
+        return test
+
     def _log_result(self, test_result):
         logger.log(test_result.status,
                    f"[{test_result.status}] {test_result.test_path}")
@@ -33,12 +40,17 @@ class TestRunner:
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
2.50.0.rc0.604.gd4ff7b7c86-goog

