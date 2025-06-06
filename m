Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01BC24292E
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 23:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254206; cv=none; b=KN5rhPNMPppPqPddIRh16VxJagzfe/9tcorha6pAcN0Rr+CPkAc6dsqRJjipj3vUmDUhoPeEttcNUvrcB/bC89qG0zuQpRqyxfVaDJeJOPrty5fcdSj8OcDNriZZK59ENSTuLKaEEZAOEgIAtZqcB+CB4sos/CeezA9L3KGq3bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254206; c=relaxed/simple;
	bh=f+eEB/iYNCpX8oI/VsUjK9SDKs311EQm6wKDEhFqTfI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KZQDOrgfa9AgxS3NeQ2wioz5KrAJ47jkMtFDkmM+CtEAy7Hnyjy/eQS8pYjf+FuQDFmzukM71g9/jfVyy+K6zb02CcxIluc7jgSFIx2EUTlrvZtVFoMcEPB5eXun7LPNVSRY6MR7fE2NYJ16iuLVfDTkEyUQwyNN9tbYLwit4Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sscV6zja; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sscV6zja"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234dbbc4899so42103965ad.2
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 16:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254204; x=1749859004; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Eryy+YJT09TinpK7TLn0VFQh3NTz7wAuAJ/KxptN2XM=;
        b=sscV6zjax8+X+0IOLMifxJHU6F7sBCRMKTjIraxkdkO/4VtKFgo+lozXxUm/wSpKEz
         ouxNHEVjmXwhBKyhdvkmwk7BaTDcbZFp++FR35ZfKAABxvT9Wdbzt/0JOQSKP91c4zfq
         shczE30UhwDCUGWkCDqBRMCxH9rPGHVUUV9IJ7obZTF7Y+A9uZhImvuvZmGjHdRDJYwT
         BO464mwbHZ75/5RE8BDgWJg5pmT/Xfs8Q9I//N5448vw90zC0vahwraPVrO2v3d4A1uv
         t0jzbk/94TSUdoxpep/AEqSLTwXbLouAGCtorMoWIszMVoV+cQAGwxVYVQ5uFu86C0TN
         tTOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254204; x=1749859004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eryy+YJT09TinpK7TLn0VFQh3NTz7wAuAJ/KxptN2XM=;
        b=vyixvJ/rL3prOwhrr6Z319XuqZ94QlEce73GOOwdA4TSe2zXLuBNBxKgytdjyePf8m
         WyZeKi4jV0QuhP0DCi+yr3D85DUQtjTSvr+9ZZqxazP4WrvSOJhAiN/UaVqFpwhsry1o
         LW/qUwTELoHLlEqWTGKozwLRkojR+/Tr/juk85CDUe5Hg6XAx+l5bVPxJIB3BbI+a7/Y
         7ZiueWV4rDqvoeSWsstToyy3lcwRNLZhdl+Y+iDOWOnv65gr5hB2pdFfWxhccj2CJA8i
         0zAPmwThjN3cG3heBGN2aXSwWyBQuM31VlKLF7YqOGsf4fHGfui4ojI6Vl1oUvu3iNpE
         JJ5w==
X-Forwarded-Encrypted: i=1; AJvYcCVCNpoJBcjaWo6ZlWiWa58pWaAcgEEJ1tO2qLPjwGtgmj5KjYnoBgODwTS9tO3+6F1CA8qmPrk=@lists.linux.dev
X-Gm-Message-State: AOJu0YziAqXywwc+VjH1tOnI4NN5e++gRky38Ug4t+hwaICVbmc/juoi
	aAAg9siBvUGRv0SOMpbk7FDC/CGFE9CaO5hWasAHB+oCHcYI/Z2GTcVtfMX0F5IC+NF8rdQxmYU
	MfPuBuMkUrA==
X-Google-Smtp-Source: AGHT+IHoWyMkTDRUV9FORNhwP9EK3SZsd3ZxOrapFYSdtobGvViIWq2t5Q6eVMf+UJBQjw9Zhem7ol5n6al1
X-Received: from pgww16.prod.google.com ([2002:a05:6a02:2c90:b0:b2c:3dd5:8139])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc86:b0:235:e9fe:83c0
 with SMTP id d9443c01a7336-23601d18723mr75766385ad.27.1749254204307; Fri, 06
 Jun 2025 16:56:44 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:12 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-9-vipinsh@google.com>
Subject: [PATCH v2 08/15] KVM: selftests: Print sticky KVM Selftests Runner
 status at bottom
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Print current state of the KVM Selftest Runner during its execution.
Show it as the bottom most line, make it sticky and colored. Provide
the following information:
- Total number of tests selected for run.
- How many have executed.
- Total for each end state.

Example:

Total: 3/3 Passed: 1 Failed: 1 Skipped: 0 Timed Out: 0 No Run: 1

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/kvm/runner/test_runner.py        | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 8f2372834104..e0da30d216a2 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -15,6 +15,7 @@ logger = logging.getLogger("runner")
 class TestRunner:
     def __init__(self, test_files, args):
         self.tests = []
+        self.status = {x: 0 for x in SelftestStatus}
         self.output_dir = args.output
         self.jobs = args.jobs
         self.print_status = args.print_status
@@ -34,7 +35,17 @@ class TestRunner:
         test.run()
         return test
 
+    def _sticky_update(self):
+        print(f"\r\033[1mTotal: {self.tests_ran}/{len(self.tests)}" \
+                f"\033[32;1m Passed: {self.status[SelftestStatus.PASSED]}" \
+                f"\033[31;1m Failed: {self.status[SelftestStatus.FAILED]}" \
+                f"\033[33;1m Skipped: {self.status[SelftestStatus.SKIPPED]}"\
+                f"\033[91;1m Timed Out: {self.status[SelftestStatus.TIMED_OUT]}"\
+                f"\033[34;1m No Run: {self.status[SelftestStatus.NO_RUN]}\033[0m", end="\r")
+
     def _log_result(self, test_result):
+        # Clear the status line
+        print("\033[2K", end="\r")
         logger.log(test_result.status,
                    f"[{test_result.status}] {test_result.test_path}")
         if (self.output_dir is None and self.print_status is False
@@ -46,8 +57,13 @@ class TestRunner:
             logger.info(test_result.stderr)
             logger.info("************** STDERR END **************")
 
+        self.status[test_result.status] += 1
+        # Sticky bottom line
+        self._sticky_update()
+
     def start(self):
         ret = 0
+        self.tests_ran = 0
 
         with concurrent.futures.ProcessPoolExecutor(max_workers=self.jobs) as executor:
             all_futures = []
@@ -57,9 +73,11 @@ class TestRunner:
 
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
2.50.0.rc0.604.gd4ff7b7c86-goog

