Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B6212C814
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 23:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706917569; cv=none; b=hYEeQiiqLz3xu8/QD6s6m0y+ApYvd4z0ERLLWQine2DdHImeapPCpAdCfy2XLUSb0VE6HZ/Q2zpGGT1XZcpzfovO8ZBPYXHXAxuqaPmA60wNuj+6DjOQ70lPA6ss7SzQFCRx8O03BCFVnXu9JuJC6crhJ6JkOLYtPUj/5VUOw8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706917569; c=relaxed/simple;
	bh=tCKrGRW7WN608392SeATTvTDea2Xb4gjQNimEpRumEo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fhtmiLZ/k1xIbzL2nPmkf+W5iB17DhQKP5jDytbwXy9ILLnAbHh6jeLzpBv2RjF1q7KMsfo4YVC+EY3quWo01HlKEXWv2EnOF5OsXJKb8xkc/K+3gIMhdECOQvJE3T2g8Y2gn8aDMRnlgQjHGSPfOR1KKlX0p9kRNM4SXiW8QrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hid88D2s; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hid88D2s"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cfc2041cdfso2632475a12.2
        for <kvmarm@lists.linux.dev>; Fri, 02 Feb 2024 15:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706917566; x=1707522366; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CadysjImRodM1JigoHu7x5dfRmrUFHW93Rcy1yZ8LIM=;
        b=hid88D2sH5HTvjAi6422t9Z98ANlq6ROr1zjPu0M4tlJk7qJt6/ntCNHePlts5vfk5
         M/NXir/BKLHoPwCUq6Az3Hm93ipasFOGn0Fxur8TdqiptKAejja0EebSv/y+UMUiBHZn
         9isrOlm5w0Z5W9QG1NQWs0anaszWKNiWDRGD0HEFrQDb+CSeCmlfXBk4KVE23qkaro2m
         0uPf0BM14Ll++E9lNEX5nHQK3ghIxZsLBKNHKclfN3notipAp+af//KM7jFL1Zk3vgdD
         LHdumvAV45eVa4zNo4O38xkiy3jbWb4RUsHZhArv86mdMYhMLWf/2oV8NGNM6YM82+YC
         QSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706917566; x=1707522366;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CadysjImRodM1JigoHu7x5dfRmrUFHW93Rcy1yZ8LIM=;
        b=WFZ4lL3VQ0Htz2A2805jmIm8pOepgMI/F4vaxty4VYJFoo0KCT3giXm/W0injk9dlk
         egGm2qZpNS5wN3clE6hkfBsr6jgNxxeNzqNj8kD0qfcT4B648BvO1Q6cmb7LauJ+EeRA
         QUHGfgLIhgSkGw5A8+NSOXlVdVp67n5olBoabql27hzkWc2yWY9n0xNZJEVMj8htOY8K
         xVb05QA5fAgdYtugk4i20ypMufnqyq3sSmKQ79I+zB4U9Zs724KQQ2p/3Z4mxTwdbCb2
         8JW9j5qvkbCs7sT8OQuX7f50QeOeoz8OqYl4AUdgkvoGj1I4Z4i6lUvx0h/UAXnmFvI5
         6GdA==
X-Gm-Message-State: AOJu0YzIbkA/vJdUqbmuhbZ5h99YyKhrHq7fnOIYPFbh8fVsUw2h9yGL
	D9e3dLdYDeWPfO7QR40CrP7SBnkPDOuMAAtFa9npt1sq1RbC12tr74LKwfT6/kjPqxGWPPyk+gk
	v0w==
X-Google-Smtp-Source: AGHT+IHHsr4NU54NohTBduBzv4jpgrZuqG+/Ora3WvFzNYKUDGxh0aFGIwr7FvvMQVezeC1vmX7Awhvls+8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6e85:0:b0:5ca:439c:86ac with SMTP id
 bm5-20020a656e85000000b005ca439c86acmr132167pgb.8.1706917566148; Fri, 02 Feb
 2024 15:46:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 15:46:03 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240202234603.366925-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Fix GUEST_PRINTF() format warnings in ARM code
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a pile of -Wformat warnings in the KVM ARM selftests code, almost all
of which are benign "long" versus "long long" issues (selftests are 64-bit
only, and the guest printf code treats "ll" the same as "l").  The code
itself isn't problematic, but the warnings make it impossible to build ARM
selftests with -Werror, which does detect real issues from time to time.

Opportunistically have GUEST_ASSERT_BITMAP_REG() interpret set_expected,
which is a bool, as an unsigned decimal value, i.e. have it print '0' or
'1' instead of '0x0' or '0x1'.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Compile tested only, mainly because I'm rushing through things on Friday
afternoon, not because testing on ARM is actually problematic for me.

 tools/testing/selftests/kvm/aarch64/arch_timer.c     |  4 ++--
 .../testing/selftests/kvm/aarch64/debug-exceptions.c |  2 +-
 tools/testing/selftests/kvm/aarch64/hypercalls.c     |  4 ++--
 .../testing/selftests/kvm/aarch64/page_fault_test.c  |  2 +-
 .../selftests/kvm/aarch64/vpmu_counter_access.c      | 12 ++++++------
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 274b8465b42a..d5e8f365aa01 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -158,9 +158,9 @@ static void guest_validate_irq(unsigned int intid,
 
 	/* Basic 'timer condition met' check */
 	__GUEST_ASSERT(xcnt >= cval,
-		       "xcnt = 0x%llx, cval = 0x%llx, xcnt_diff_us = 0x%llx",
+		       "xcnt = 0x%lx, cval = 0x%lx, xcnt_diff_us = 0x%lx",
 		       xcnt, cval, xcnt_diff_us);
-	__GUEST_ASSERT(xctl & CTL_ISTATUS, "xcnt = 0x%llx", xcnt);
+	__GUEST_ASSERT(xctl & CTL_ISTATUS, "xcnt = 0x%lx", xcnt);
 
 	WRITE_ONCE(shared_data->nr_iter, shared_data->nr_iter + 1);
 }
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 866002917441..2582c49e525a 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -365,7 +365,7 @@ static void guest_wp_handler(struct ex_regs *regs)
 
 static void guest_ss_handler(struct ex_regs *regs)
 {
-	__GUEST_ASSERT(ss_idx < 4, "Expected index < 4, got '%u'", ss_idx);
+	__GUEST_ASSERT(ss_idx < 4, "Expected index < 4, got '%lu'", ss_idx);
 	ss_addr[ss_idx++] = regs->pc;
 	regs->pstate |= SPSR_SS;
 }
diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index 31f66ba97228..c62739d897d6 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -105,12 +105,12 @@ static void guest_test_hvc(const struct test_hvc_info *hc_info)
 		case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
 		case TEST_STAGE_HVC_IFACE_FALSE_INFO:
 			__GUEST_ASSERT(res.a0 == SMCCC_RET_NOT_SUPPORTED,
-				       "a0 = 0x%lx, func_id = 0x%x, arg1 = 0x%llx, stage = %u",
+				       "a0 = 0x%lx, func_id = 0x%x, arg1 = 0x%lx, stage = %u",
 					res.a0, hc_info->func_id, hc_info->arg1, stage);
 			break;
 		case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
 			__GUEST_ASSERT(res.a0 != SMCCC_RET_NOT_SUPPORTED,
-				       "a0 = 0x%lx, func_id = 0x%x, arg1 = 0x%llx, stage = %u",
+				       "a0 = 0x%lx, func_id = 0x%x, arg1 = 0x%lx, stage = %u",
 					res.a0, hc_info->func_id, hc_info->arg1, stage);
 			break;
 		default:
diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 08a5ca5bed56..7bbd9fb5c8d6 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -292,7 +292,7 @@ static void guest_code(struct test_desc *test)
 
 static void no_dabt_handler(struct ex_regs *regs)
 {
-	GUEST_FAIL("Unexpected dabt, far_el1 = 0x%llx", read_sysreg(far_el1));
+	GUEST_FAIL("Unexpected dabt, far_el1 = 0x%lx", read_sysreg(far_el1));
 }
 
 static void no_iabt_handler(struct ex_regs *regs)
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 9d51b5691349..f8f0c655c723 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -195,11 +195,11 @@ struct pmc_accessor pmc_accessors[] = {
 										 \
 	if (set_expected)							 \
 		__GUEST_ASSERT((_tval & mask),					 \
-				"tval: 0x%lx; mask: 0x%lx; set_expected: 0x%lx", \
+				"tval: 0x%lx; mask: 0x%lx; set_expected: %u",	 \
 				_tval, mask, set_expected);			 \
 	else									 \
 		__GUEST_ASSERT(!(_tval & mask),					 \
-				"tval: 0x%lx; mask: 0x%lx; set_expected: 0x%lx", \
+				"tval: 0x%lx; mask: 0x%lx; set_expected: %u",	 \
 				_tval, mask, set_expected);			 \
 }
 
@@ -286,7 +286,7 @@ static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 	acc->write_typer(pmc_idx, write_data);
 	read_data = acc->read_typer(pmc_idx);
 	__GUEST_ASSERT(read_data == write_data,
-		       "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx; write_data: 0x%lx",
+		       "pmc_idx: 0x%x; acc_idx: 0x%lx; read_data: 0x%lx; write_data: 0x%lx",
 		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
 
 	/*
@@ -297,14 +297,14 @@ static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 
 	/* The count value must be 0, as it is disabled and reset */
 	__GUEST_ASSERT(read_data == 0,
-		       "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx",
+		       "pmc_idx: 0x%x; acc_idx: 0x%lx; read_data: 0x%lx",
 		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data);
 
 	write_data = read_data + pmc_idx + 0x12345;
 	acc->write_cntr(pmc_idx, write_data);
 	read_data = acc->read_cntr(pmc_idx);
 	__GUEST_ASSERT(read_data == write_data,
-		       "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx; write_data: 0x%lx",
+		       "pmc_idx: 0x%x; acc_idx: 0x%lx; read_data: 0x%lx; write_data: 0x%lx",
 		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
 }
 
@@ -379,7 +379,7 @@ static void guest_code(uint64_t expected_pmcr_n)
 	int i, pmc;
 
 	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
-			"Expected PMCR.N: 0x%lx; ARMv8 general counters: 0x%lx",
+			"Expected PMCR.N: 0x%lx; ARMv8 general counters: 0x%x",
 			expected_pmcr_n, ARMV8_PMU_MAX_GENERAL_COUNTERS);
 
 	pmcr = read_sysreg(pmcr_el0);

base-commit: 41bccc98fb7931d63d03f326a746ac4d429c1dd3
-- 
2.43.0.594.gd9cf4e227d-goog

