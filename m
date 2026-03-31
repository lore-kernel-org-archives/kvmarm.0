Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428913E559E
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 19:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986147; cv=none; b=nMpPO0rPE+UppxIK2vKhIF7/gth/ER7kEGc6nsFQUTPoS06Qk3yevNXBiatTTT4xaQTWAFCC11b8Ydv0U5Bdvm9xTtw1wYv/5ELOsrPsMCbvBC8k91qsR8nY2bsPc3N/oxer9kk73E1JMqDz51DGV+jME8tzovIj/7YvHz0w0R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986147; c=relaxed/simple;
	bh=n4fhcjg0fQb/2J9WY6YgHfApmfQaurJyvDnXjYmfZLg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FtqfHQuDjyaA/Qw+q9nRD5F1MwPWsGvtPgRcGrltTN0qUOwC97b+haUjCWYc4T+8jLNren3gSnEKxFwUPOHyStYBQpsJ7BesmJQf0kjyoWlNC/JZnnD9J56yNk+qijhZcRiHHKpWowMgHGruKMH/2gYrBImZmOy0HT0n9ebZGDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PSry/MvY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PSry/MvY"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82a6906e35fso183206b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 12:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774986145; x=1775590945; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EDxS3RLGSrG2H/pkS7vidJMr8Di538wm6I+VqwzPhms=;
        b=PSry/MvYy8yIQvu2D09+YHsZQVmCerMm+D2D9gHALxF1GCgfQF0XjWbZZ8VK/xZyoO
         Dz67yqnHe9fIKwTbntCqP1Njc+2gBOnoganmhlDD9dMloHMxiZ+8eWvt8D0FZMXBuzox
         7m0f6sBGKWlaXjxATt54vvtCvMMt6Eg+97rW1BtLo5Ov1SzHCTxkQVaX5x1YQfS+DVaf
         VnEXhrR22XcSEKdFj3Rd2wzbnhH5QGDyT4CUzRbxnITZbHHrNydR2uITzoa+8pAaUuPJ
         YQmQCSivKlF/LuI/YGLZBwHBRMLlr0nhnWUFfEgVmukS/WBCB68rrObtjyo7uh9+TuXJ
         xQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986145; x=1775590945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EDxS3RLGSrG2H/pkS7vidJMr8Di538wm6I+VqwzPhms=;
        b=OYb7edhMzQqAwtc0G664mLk1OeJgE8LWQ2DNCrRNQnJ9TAIxo/vVep9Qq2kpQuPVMA
         bqowwP4H1vtc44EiBlGe5BNyMBt4bfw6eFNKMwB0BcEMJhrKjnKGoUvgaZC7+4JmCUeW
         yZONTJC7yCi3ej6+fFybpfL2o0401OfWQrNsVnimru16ssHo1n30nRJ3ESbwdeqLwL59
         4BQDZx+Lx2m72sK3VRvfqz+jhSt4lqEQ1EyhosOL0fnrhXHfE60m0hSPQyFMKJTzK8v7
         8QxxcJ2JWrvvJMH+oPnL/jBUmYmCJM3fV0U2LHx0y09B6uwa81MRNntIW3fztzHv8/OW
         dnPA==
X-Forwarded-Encrypted: i=1; AJvYcCV+aOGGN0Qv31LnA4PoVXoeQwlJ0OB9ZALYcjcBSekKaJ7BytDHQMIhNsMGANpGMIDmhl8r0aM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6+SZE0HPg0fSUq3EzDP6S9dmJp/P5uTaT90WwRh38RQFxfH9n
	ZXahl71T4wjsoHckwQY/du+mHnfr2TToLm5SwHN2MTQ/SfN2kGlP09jD1YN6LcFZELmaEc5X45e
	8l3BhQ2PQcA==
X-Received: from pfud21.prod.google.com ([2002:a05:6a00:10d5:b0:82a:1d94:6f65])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1ca8:b0:82a:15a1:14d
 with SMTP id d2e1a72fcca58-82ceaa5635emr441207b3a.14.1774986145378; Tue, 31
 Mar 2026 12:42:25 -0700 (PDT)
Date: Tue, 31 Mar 2026 12:42:00 -0700
In-Reply-To: <20260331194202.1722082-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com>
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260331194202.1722082-8-vipinsh@google.com>
Subject: [PATCH v4 7/9] KVM: selftests: Print sticky KVM selftests runner
 status at bottom
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Print current state of the KVM selftest runner during its execution.
Show it as the bottom most line, make it sticky and colored. Provide
the following information:
- Total number of tests selected for run.
- How many have executed.
- Total for each end state.

Example:

Total: 3/3 Passed: 1 Failed: 1 Skipped: 0 Timed Out: 0 No Run: 1

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/kvm/runner/test_runner.py       | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index e8e8fd91c1ad..66a3c3711a8a 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -15,6 +15,7 @@ logger = logging.getLogger("runner")
 class TestRunner:
     def __init__(self, testcases, args):
         self.tests = []
+        self.status = {x: 0 for x in SelftestStatus}
         self.output_dir = args.output
         self.jobs = args.jobs
         self.print_stds = {
@@ -33,9 +34,19 @@ class TestRunner:
         test.run()
         return test
 
+    def _sticky_update(self):
+        print(f"\r\033[1mTotal: {self.tests_ran}/{len(self.tests)}" \
+                f"\033[32;1m Passed: {self.status[SelftestStatus.PASSED]}" \
+                f"\033[31;1m Failed: {self.status[SelftestStatus.FAILED]}" \
+                f"\033[33;1m Skipped: {self.status[SelftestStatus.SKIPPED]}"\
+                f"\033[91;1m Timed Out: {self.status[SelftestStatus.TIMED_OUT]}"\
+                f"\033[34;1m No Run: {self.status[SelftestStatus.NO_RUN]}\033[0m",
+                end="\r", flush=True)
+
     def _log_result(self, test_result):
         print_level = self.print_stds.get(test_result.status, "full")
 
+        print("\033[2K", end="\r", flush=True)
         if (print_level == "full" or print_level == "stdout"):
             logger.info("*** stdout ***\n" + test_result.stdout)
         if (print_level == "full" or print_level == "stderr"):
@@ -43,8 +54,16 @@ class TestRunner:
         if (print_level != "off"):
             logger.log(test_result.status, f"[{test_result.status.name}] {test_result.test_path}")
 
+        self.status[test_result.status] += 1
+        # Sticky bottom line
+        self._sticky_update()
+
     def start(self):
         ret = 0
+        self.tests_ran = 0
+
+        # Show initial progress
+        self._sticky_update()
 
         with concurrent.futures.ProcessPoolExecutor(max_workers=self.jobs) as executor:
             all_futures = []
@@ -54,9 +73,11 @@ class TestRunner:
 
             for future in concurrent.futures.as_completed(all_futures):
                 test_result = future.result()
+                self.tests_ran += 1
                 self._log_result(test_result)
                 if (test_result.status not in [SelftestStatus.PASSED,
                                                SelftestStatus.NO_RUN,
                                                SelftestStatus.SKIPPED]):
                     ret = 1
+        print("\n")
         return ret
-- 
2.53.0.1118.gaef5881109-goog

