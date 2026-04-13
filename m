Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4782237E30D
	for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 20:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113202; cv=none; b=uimk384zCHmqhYSViRWgq5wwaVJRin1LRXCBHmXklig4aNmGHhZCAgt+dgdED9KawqkF/jm7aO73i0rMQunQ33oULTJI7fcnS4LqWQx3dfs3Z6i/fnB0jmVdJag6UBbWWS88BYXa8ifBK7XF4IWXS98TMhpKEGB+sFQ27ZQdfPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113202; c=relaxed/simple;
	bh=dF8Pdh7fCGj7I5XOUTMFrg0tzRg/MLRCK+jmPyQdG/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QEPQpkrA5V+CUq+87QYgARsAqWsssfeWy/2CBeI+7Kgrv9yt34USSVZ/JdZI+d6JFvG8sik0x2qT+RRQJfygLJf257cUHBdhgdeR9MILSKj7TIyjj+iV5LiTRhwDdx5yHbzPRkWcMBeIkCiTCSDjnQ81f4mM+jKOO1ZUpMFTB1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GWaU7E0E; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GWaU7E0E"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b24a00d12cso49278045ad.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 13:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776113200; x=1776718000; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PBSTda45yCwt3ewgfFRP1zgs9tSny1IPA4LGkYxKz3c=;
        b=GWaU7E0EBS1xVjVZIgn32F36OktVUPleQt6ROsVxSyionR/ptlhwAmxiXHChoSaaWG
         eJilSMT1Z1y1cl/IvZ01racSyTUjcDEH9CLAWm6wXzVE3wDlNc74iHHfR2k31wmP7uvI
         1F40bsftoX1yBDOGanUAeYEWjF2S3sYIuRJXoOlsSSL9XtJF8r0S+bemZ3v9TLKz8sxD
         PHhpmxG5bOGwqluJ7Xwcl2RBBVCQ3yg/KG9aoVngHj+WywGixgxO04AgAz7r+EpAbvRN
         NyMk1bmXitJfG72xDlErxsBfd9ZEk06cwjedRryOqfNDNBKgfsdXvg1+ybOiq60221kU
         LyMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776113200; x=1776718000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PBSTda45yCwt3ewgfFRP1zgs9tSny1IPA4LGkYxKz3c=;
        b=lL9k4bqJUuk0QNTGHvrtmnvUzIzs1ecCRh07F3c8F3n7AEEyPG2HocaG4XhCL3xHqP
         fsvDqpt1eoyWVMkRyJUi8MoChvAvdKuTmj9yfRjaksDsryE9MDbNXaAK1qDG+qlpsOX7
         d13PRNkK3OArro2ssgPJr5dzhBe0IdSz3Pfh+hzR4exHw1cTUzZxgW1xJ9gOiy+ra97R
         AK7DMg6gEP1YXgmPmTyo1tzOVl5vHiOq1cC6HKS/50UODBtd9ztPSSJj7MGFTEouwqZI
         vC1uJ8TzGamid9cYyoDtR+ogS4EbGNU1z0z0v5u1k76G9lcLoACQgC5rOTpegCGRnVdE
         7tYg==
X-Forwarded-Encrypted: i=1; AFNElJ95q1DK76bEcheu1w7Nu82EPK4tHkKKPmiUQrKo53jXtoVYxyTaMfmHZeldEV5YDrVtQyRQ48k=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIASk8VVSVpMuQxiTaa37yI6ZWkBz24TLtXp1GGGHlyfKk7VqT
	Wu+EL33awFrxnZlYv2QaC36nVqMCOGnC/ViRdc4Ctb1NFRak6tLQz6w5FqZrNUnRxi78WYPZWV0
	47VIuLnQ4T+Wl32X3FBAO/Oi/cQ==
X-Received: from plpf16.prod.google.com ([2002:a17:903:3c50:b0:2b2:3f89:e9d2])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ee94:b0:2ae:cb0e:fd59 with SMTP id d9443c01a7336-2b2d591d25amr105342905ad.8.1776113200357;
 Mon, 13 Apr 2026 13:46:40 -0700 (PDT)
Date: Mon, 13 Apr 2026 13:46:26 -0700
In-Reply-To: <20260413204630.1149038-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260413204630.1149038-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
Message-ID: <20260413204630.1149038-4-jingzhangos@google.com>
Subject: [kvm-unit-tests PATCH v2 3/7] lib: arm64: Generalize exception vector
 definitions for EL2 support
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename EL1-specific exception vector enumerations to ELx equivalents
(e.g., EL1H to ELxH and EL0 to ELx_LOW) to make them level-agnostic.
This allows these identifiers to be reused when running at other
exception levels, such as EL2, supporting the upcoming guest
management library.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
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
index a1bed8a7..38940d7e 100644
--- a/arm/mte.c
+++ b/arm/mte.c
@@ -192,7 +192,7 @@ static void mte_sync_test(void)
 
 	mte_exception = false;
 
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
+	install_exception_handler(ELxH_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
 
 	mem_read(tagged(mem, 2), &val);
 
@@ -218,12 +218,12 @@ static void mte_asymm_test(void)
 	mte_set_tcf(MTE_TCF_ASYMM);
 	mte_exception = false;
 
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
+	install_exception_handler(ELxH_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
 
 	mem_read(tagged(mem, 3), &val);
 	report((val == 0) && mte_exception && (get_clear_tfsr() == 0), "read");
 
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
+	install_exception_handler(ELxH_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
 
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
index 55308c8f..a52a1701 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -36,7 +36,7 @@ static void install_invalid_function_handler(exception_fn handler)
 #ifdef __arm__
 	install_exception_handler(EXCPTN_UND, handler);
 #else
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, handler);
+	install_exception_handler(ELxH_SYNC, ESR_EL1_EC_UNKNOWN, handler);
 #endif
 }
 
diff --git a/arm/selftest.c b/arm/selftest.c
index 33f4cf42..7a626980 100644
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
-		install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_UNKNOWN,
+		install_exception_handler(ELx_LOW_SYNC_64, ESR_EL1_EC_UNKNOWN,
 					  user_psci_system_off);
 #endif
 	} else {
diff --git a/arm/timer.c b/arm/timer.c
index 43fb6d88..0f77f8d8 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -356,9 +356,9 @@ static void test_init(void)
 		vtimer_info.irq = TIMER_HVTIMER_IRQ;
 	}
 
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
+	install_exception_handler(ELxH_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
 	ptimer_info.read_ctl();
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
+	install_exception_handler(ELxH_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
 
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
index bde3caa5..98e26912 100644
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
2.53.0.1213.gd9a14994de-goog

