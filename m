Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462F351B178
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867822; cv=none; b=p76Zjg+Ao90HTLjfHgcVDBzyRhcjTjXpyMWCFe94EQr8isp/JTM6QtY2oijHARSbRDWV9CWmPPdUBRObYA4CPJKG5H7nxG67MugXNjrEAW4HYA1P5MpT4ia7IxlpUY/6RZzVVyi9/BciKjoWpiCaE66wylpwMFi+VUrbUyMHrFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867822; c=relaxed/simple;
	bh=RWqdslSHS8FZGziEaUrxYJayzttfucjAfuX6E+s9CC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HG/LOwqEEEPQXk6S9BsllSXn9BITf5WjIO9IDqrF3s+yrt5958W7CfBiJlyVR4nLQoq6U6AG5TBdytbCjFS36ZnvtC23KZmU4FIeZvlc06WIITa/q7nITUg5IlOnTXSjdAY7C5gbh3hOx3+3sFRgPnzrHtUhXrtzJ0i5xYDjhJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GZo2rTa2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GZo2rTa2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 232BF497;
	Thu,  1 Oct 2026 08:16:56 -0700 (PDT)
Received: from e143914.cambridge.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3CF903F86F;
	Thu,  1 Oct 2026 08:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790867819; bh=RWqdslSHS8FZGziEaUrxYJayzttfucjAfuX6E+s9CC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZo2rTa2WtH8AzKUB1lj1ED0nh0FimB3j94dhngPsfuqxlSnmpa/prjVTYMRA8wt6
	 TE4B9DlHjvxCb0HKeS614BT3TfrmeNJilsmr0lbQOwVPneup/rhGSaT01dZy1oUBZM
	 d5aPe07DVdPc/xH5dMi2Vw9RRjvWHHRUylnF1Oe8=
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	andrew.jones@linux.dev,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH v3 2/8] lib: arm64: Generalize exception vector definitions for EL2 support
Date: Thu,  1 Oct 2026 16:16:39 +0100
Message-ID: <20261001151645.2427065-3-joey.gouly@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001151645.2427065-1-joey.gouly@arm.com>
References: <20261001151645.2427065-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jing Zhang <jingzhangos@google.com>

Rename EL1-specific exception vector enumerations to ELx equivalents (e.g.,
EL1H to ELxH and EL0 to ELx_LOW) to make them level-agnostic. This allows
these identifiers to be reused when running at other exception levels, such
as EL2, supporting the upcoming guest management library.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/debug.c               |  6 +++---
 arm/gic.c                 |  2 +-
 arm/micro-bench.c         |  4 ++--
 arm/mte.c                 |  6 +++---
 arm/pl031.c               |  2 +-
 arm/pmu.c                 |  2 +-
 arm/psci.c                |  2 +-
 arm/selftest.c            |  6 +++---
 arm/timer.c               |  6 +++---
 lib/arm64/asm/processor.h | 32 ++++++++++++++++----------------
 lib/arm64/processor.c     |  8 ++++----
 11 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/arm/debug.c b/arm/debug.c
index 0299fd28..9ba93ac2 100644
--- a/arm/debug.c
+++ b/arm/debug.c
@@ -272,7 +272,7 @@ static noinline void test_hw_bp(bool migrate)
 		return;
 	}
 
-	install_exception_handler(EL1H_SYNC, ESR_EC_HW_BP_CURRENT, hw_bp_handler);
+	install_exception_handler(ELxH_SYNC, ESR_EC_HW_BP_CURRENT, hw_bp_handler);
 
 	reset_debug_state();
 
@@ -324,7 +324,7 @@ static noinline void test_wp(bool migrate)
 		return;
 	}
 
-	install_exception_handler(EL1H_SYNC, ESR_EC_WP_CURRENT, wp_handler);
+	install_exception_handler(ELxH_SYNC, ESR_EC_WP_CURRENT, wp_handler);
 
 	reset_debug_state();
 
@@ -365,7 +365,7 @@ static noinline void test_ss(bool migrate)
 	extern unsigned char ss_start;
 	uint32_t mdscr;
 
-	install_exception_handler(EL1H_SYNC, ESR_EC_SSTEP_CURRENT, ss_handler);
+	install_exception_handler(ELxH_SYNC, ESR_EC_SSTEP_CURRENT, ss_handler);
 
 	reset_debug_state();
 
diff --git a/arm/gic.c b/arm/gic.c
index 256dd80d..cccc5ae1 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -180,7 +180,7 @@ static void setup_irq(irq_handler_fn handler)
 #ifdef __arm__
 	install_exception_handler(EXCPTN_IRQ, handler);
 #else
-	install_irq_handler(EL1H_IRQ, handler);
+	install_irq_handler(ELxH_IRQ, handler);
 #endif
 	local_irq_enable();
 }
diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index a6a78f20..6ca36c55 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -52,7 +52,7 @@ static void gic_irq_handler(struct pt_regs *regs)
 
 static void gic_secondary_entry(void *data)
 {
-	install_irq_handler(EL1H_IRQ, gic_irq_handler);
+	install_irq_handler(ELxH_IRQ, gic_irq_handler);
 	gic_enable_defaults();
 	local_irq_enable();
 	irq_ready = true;
@@ -212,7 +212,7 @@ static void lpi_exec(void)
 static bool timer_prep(void)
 {
 	gic_enable_defaults();
-	install_irq_handler(EL1H_IRQ, gic_irq_handler);
+	install_irq_handler(ELxH_IRQ, gic_irq_handler);
 	local_irq_enable();
 
 	if (current_level() == CurrentEL_EL1)
diff --git a/arm/mte.c b/arm/mte.c
index 35707fc6..ad71b104 100644
--- a/arm/mte.c
+++ b/arm/mte.c
@@ -192,7 +192,7 @@ static void mte_sync_test(void)
 
 	mte_exception = false;
 
-	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_DABT_CUR, mte_fault_handler);
+	install_exception_handler(ELxH_SYNC, ESR_ELx_EC_DABT_CUR, mte_fault_handler);
 
 	mem_read(tagged(mem, 2), &val);
 
@@ -218,12 +218,12 @@ static void mte_asymm_test(void)
 	mte_set_tcf(MTE_TCF_ASYMM);
 	mte_exception = false;
 
-	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_DABT_CUR, mte_fault_handler);
+	install_exception_handler(ELxH_SYNC, ESR_ELx_EC_DABT_CUR, mte_fault_handler);
 
 	mem_read(tagged(mem, 3), &val);
 	report((val == 0) && mte_exception && (get_clear_tfsr() == 0), "read");
 
-	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_DABT_CUR, NULL);
+	install_exception_handler(ELxH_SYNC, ESR_ELx_EC_DABT_CUR, NULL);
 
 	mem_write(tagged(mem, 4), 0xaaaaaaaa);
 	report((*mem == 0xaaaaaaaa) && (get_clear_tfsr() == TFSR_EL1_TF0), "write");
diff --git a/arm/pl031.c b/arm/pl031.c
index c56805e4..3c739d4d 100644
--- a/arm/pl031.c
+++ b/arm/pl031.c
@@ -162,7 +162,7 @@ static int check_rtc_irq(void)
 	writel(before + seconds_to_wait, &pl031->mr);
 
 #ifdef __aarch64__
-	install_irq_handler(EL1H_IRQ, irq_handler);
+	install_irq_handler(ELxH_IRQ, irq_handler);
 #else
 	install_exception_handler(EXCPTN_IRQ, irq_handler);
 #endif
diff --git a/arm/pmu.c b/arm/pmu.c
index 2fcec71a..90878641 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -968,7 +968,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 		return;
 
 	gic_enable_defaults();
-	install_irq_handler(EL1H_IRQ, irq_handler);
+	install_irq_handler(ELxH_IRQ, irq_handler);
 	local_irq_enable();
 	gic_enable_irq(23);
 
diff --git a/arm/psci.c b/arm/psci.c
index 5800c0ac..1f87736a 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -36,7 +36,7 @@ static void install_invalid_function_handler(exception_fn handler)
 #ifdef __arm__
 	install_exception_handler(EXCPTN_UND, handler);
 #else
-	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_UNKNOWN, handler);
+	install_exception_handler(ELxH_SYNC, ESR_ELx_EC_UNKNOWN, handler);
 #endif
 }
 
diff --git a/arm/selftest.c b/arm/selftest.c
index d9f41e8e..ba81d556 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -305,7 +305,7 @@ static enum vector check_vector_prep(void)
 	unsigned long daif;
 
 	if (is_user())
-		return EL0_SYNC_64;
+		return ELx_LOW_SYNC_64;
 
 	asm volatile("mrs %0, daif" : "=r" (daif) ::);
 	expected_regs.pstate = daif;
@@ -313,7 +313,7 @@ static enum vector check_vector_prep(void)
 		expected_regs.pstate |= PSR_MODE_EL1h;
 	else
 		expected_regs.pstate |= PSR_MODE_EL2h;
-	return EL1H_SYNC;
+	return ELxH_SYNC;
 }
 
 static void unknown_handler(struct pt_regs *regs, unsigned int esr __unused)
@@ -400,7 +400,7 @@ static void check_vectors(void *arg __unused)
 #ifdef __arm__
 		install_exception_handler(EXCPTN_UND, user_psci_system_off);
 #else
-		install_exception_handler(EL0_SYNC_64, ESR_ELx_EC_UNKNOWN,
+		install_exception_handler(ELx_LOW_SYNC_64, ESR_ELx_EC_UNKNOWN,
 					  user_psci_system_off);
 #endif
 	} else {
diff --git a/arm/timer.c b/arm/timer.c
index 898043f0..ed332b93 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -356,9 +356,9 @@ static void test_init(void)
 		vtimer_info.irq = TIMER_HVTIMER_IRQ;
 	}
 
-	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_UNKNOWN, ptimer_unsupported_handler);
+	install_exception_handler(ELxH_SYNC, ESR_ELx_EC_UNKNOWN, ptimer_unsupported_handler);
 	ptimer_info.read_ctl();
-	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_UNKNOWN, NULL);
+	install_exception_handler(ELxH_SYNC, ESR_ELx_EC_UNKNOWN, NULL);
 
 	if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
 		report_skip("Skipping ptimer tests. Set ERRATA_7b6b46311a85=y to enable.");
@@ -369,7 +369,7 @@ static void test_init(void)
 
 	gic_enable_defaults();
 
-	install_irq_handler(EL1H_IRQ, irq_handler);
+	install_irq_handler(ELxH_IRQ, irq_handler);
 	set_timer_irq_enabled(&ptimer_info, true);
 	set_timer_irq_enabled(&vtimer_info, true);
 	local_irq_enable();
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 32ddc1b3..c20dd599 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -13,22 +13,22 @@
 #include <asm/barrier.h>
 
 enum vector {
-	EL1T_SYNC,
-	EL1T_IRQ,
-	EL1T_FIQ,
-	EL1T_ERROR,
-	EL1H_SYNC,
-	EL1H_IRQ,
-	EL1H_FIQ,
-	EL1H_ERROR,
-	EL0_SYNC_64,
-	EL0_IRQ_64,
-	EL0_FIQ_64,
-	EL0_ERROR_64,
-	EL0_SYNC_32,
-	EL0_IRQ_32,
-	EL0_FIQ_32,
-	EL0_ERROR_32,
+	ELxT_SYNC,
+	ELxT_IRQ,
+	ELxT_FIQ,
+	ELxT_ERROR,
+	ELxH_SYNC,
+	ELxH_IRQ,
+	ELxH_FIQ,
+	ELxH_ERROR,
+	ELx_LOW_SYNC_64,
+	ELx_LOW_IRQ_64,
+	ELx_LOW_FIQ_64,
+	ELx_LOW_ERROR_64,
+	ELx_LOW_SYNC_32,
+	ELx_LOW_IRQ_32,
+	ELx_LOW_FIQ_32,
+	ELx_LOW_ERROR_32,
 	VECTOR_MAX,
 };
 
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 86328c01..5e5cdc77 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -198,10 +198,10 @@ void default_vector_irq_handler(enum vector v, struct pt_regs *regs,
 
 void vector_handlers_default_init(vector_fn *handlers)
 {
-	handlers[EL1H_SYNC]	= default_vector_sync_handler;
-	handlers[EL1H_IRQ]	= default_vector_irq_handler;
-	handlers[EL0_SYNC_64]	= default_vector_sync_handler;
-	handlers[EL0_IRQ_64]	= default_vector_irq_handler;
+	handlers[ELxH_SYNC]	= default_vector_sync_handler;
+	handlers[ELxH_IRQ]	= default_vector_irq_handler;
+	handlers[ELx_LOW_SYNC_64]	= default_vector_sync_handler;
+	handlers[ELx_LOW_IRQ_64]	= default_vector_irq_handler;
 }
 
 /* Needed to compile with -Wmissing-prototypes */
-- 
2.43.0

