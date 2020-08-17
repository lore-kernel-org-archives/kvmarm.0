Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4A4C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 12:24:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0490E20658
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 12:24:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0490E20658
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF234C102;
	Mon, 17 Aug 2020 08:24:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id meP2+LvzfR0a; Mon, 17 Aug 2020 08:24:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 426F04C0ED;
	Mon, 17 Aug 2020 08:24:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE11B4C0EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 08:24:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EihJsgzYS4ea for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 08:24:33 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DF304C0EA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 08:24:33 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 6AFAA26378CE36048E93;
 Mon, 17 Aug 2020 20:24:25 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 20:24:19 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [PATCH 1/2] clocksource: arm_arch_timer: Simplify and fix count
 reader code logic
Date: Mon, 17 Aug 2020 20:24:14 +0800
Message-ID: <20200817122415.6568-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200817122415.6568-1-zhukeqian1@huawei.com>
References: <20200817122415.6568-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

In commit 0ea415390cd3 (clocksource/arm_arch_timer: Use arch_timer_read_counter
to access stable counters), we separate stable and normal count reader. Actually
the stable reader can correctly lead us to normal reader if we has no workaround.

Besides, in erratum_set_next_event_tval_generic(), we use normal reader, it is
obviously wrong, so just revert this commit to solve this problem by the way.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm/include/asm/arch_timer.h    | 14 ++----------
 arch/arm64/include/asm/arch_timer.h  | 24 ++------------------
 drivers/clocksource/arm_arch_timer.c | 43 ++----------------------------------
 3 files changed, 6 insertions(+), 75 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 9917581..d022614 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -84,7 +84,7 @@ static inline u32 arch_timer_get_cntfrq(void)
 	return val;
 }
 
-static inline u64 __arch_counter_get_cntpct(void)
+static inline u64 arch_counter_get_cntpct(void)
 {
 	u64 cval;
 
@@ -93,12 +93,7 @@ static inline u64 __arch_counter_get_cntpct(void)
 	return cval;
 }
 
-static inline u64 __arch_counter_get_cntpct_stable(void)
-{
-	return __arch_counter_get_cntpct();
-}
-
-static inline u64 __arch_counter_get_cntvct(void)
+static inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cval;
 
@@ -107,11 +102,6 @@ static inline u64 __arch_counter_get_cntvct(void)
 	return cval;
 }
 
-static inline u64 __arch_counter_get_cntvct_stable(void)
-{
-	return __arch_counter_get_cntvct();
-}
-
 static inline u32 arch_timer_get_cntkctl(void)
 {
 	u32 cntkctl;
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 9f0ec21..08f7b0a 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -184,7 +184,7 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 	: "=r" (tmp) : "r" (_val));					\
 } while (0)
 
-static __always_inline u64 __arch_counter_get_cntpct_stable(void)
+static __always_inline u64 arch_counter_get_cntpct(void)
 {
 	u64 cnt;
 
@@ -194,17 +194,7 @@ static __always_inline u64 __arch_counter_get_cntpct_stable(void)
 	return cnt;
 }
 
-static __always_inline u64 __arch_counter_get_cntpct(void)
-{
-	u64 cnt;
-
-	isb();
-	cnt = read_sysreg(cntpct_el0);
-	arch_counter_enforce_ordering(cnt);
-	return cnt;
-}
-
-static __always_inline u64 __arch_counter_get_cntvct_stable(void)
+static __always_inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cnt;
 
@@ -214,16 +204,6 @@ static __always_inline u64 __arch_counter_get_cntvct_stable(void)
 	return cnt;
 }
 
-static __always_inline u64 __arch_counter_get_cntvct(void)
-{
-	u64 cnt;
-
-	isb();
-	cnt = read_sysreg(cntvct_el0);
-	arch_counter_enforce_ordering(cnt);
-	return cnt;
-}
-
 #undef arch_counter_enforce_ordering
 
 static inline int arch_timer_arch_init(void)
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 6c3e841..6e11c60 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -150,26 +150,6 @@ u32 arch_timer_reg_read(int access, enum arch_timer_reg reg,
 	return val;
 }
 
-static notrace u64 arch_counter_get_cntpct_stable(void)
-{
-	return __arch_counter_get_cntpct_stable();
-}
-
-static notrace u64 arch_counter_get_cntpct(void)
-{
-	return __arch_counter_get_cntpct();
-}
-
-static notrace u64 arch_counter_get_cntvct_stable(void)
-{
-	return __arch_counter_get_cntvct_stable();
-}
-
-static notrace u64 arch_counter_get_cntvct(void)
-{
-	return __arch_counter_get_cntvct();
-}
-
 /*
  * Default to cp15 based access because arm64 uses this function for
  * sched_clock() before DT is probed and the cp15 method is guaranteed
@@ -383,8 +363,6 @@ static u32 notrace sun50i_a64_read_cntv_tval_el0(void)
 DEFINE_PER_CPU(const struct arch_timer_erratum_workaround *, timer_unstable_counter_workaround);
 EXPORT_SYMBOL_GPL(timer_unstable_counter_workaround);
 
-static atomic_t timer_unstable_counter_workaround_in_use = ATOMIC_INIT(0);
-
 static void erratum_set_next_event_tval_generic(const int access, unsigned long evt,
 						struct clock_event_device *clk)
 {
@@ -562,9 +540,6 @@ void arch_timer_enable_workaround(const struct arch_timer_erratum_workaround *wa
 			per_cpu(timer_unstable_counter_workaround, i) = wa;
 	}
 
-	if (wa->read_cntvct_el0 || wa->read_cntpct_el0)
-		atomic_set(&timer_unstable_counter_workaround_in_use, 1);
-
 	/*
 	 * Don't use the vdso fastpath if errata require using the
 	 * out-of-line counter accessor. We may change our mind pretty
@@ -625,14 +600,9 @@ static bool arch_timer_this_cpu_has_cntvct_wa(void)
 	return has_erratum_handler(read_cntvct_el0);
 }
 
-static bool arch_timer_counter_has_wa(void)
-{
-	return atomic_read(&timer_unstable_counter_workaround_in_use);
-}
 #else
 #define arch_timer_check_ool_workaround(t,a)		do { } while(0)
 #define arch_timer_this_cpu_has_cntvct_wa()		({false;})
-#define arch_timer_counter_has_wa()			({false;})
 #endif /* CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND */
 
 static __always_inline irqreturn_t timer_handler(const int access,
@@ -989,22 +959,13 @@ static void __init arch_counter_register(unsigned type)
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_TIMER_TYPE_CP15) {
-		u64 (*rd)(void);
-
 		if ((IS_ENABLED(CONFIG_ARM64) && !is_hyp_mode_available()) ||
 		    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI) {
-			if (arch_timer_counter_has_wa())
-				rd = arch_counter_get_cntvct_stable;
-			else
-				rd = arch_counter_get_cntvct;
+			arch_timer_read_counter = arch_counter_get_cntvct;
 		} else {
-			if (arch_timer_counter_has_wa())
-				rd = arch_counter_get_cntpct_stable;
-			else
-				rd = arch_counter_get_cntpct;
+			arch_timer_read_counter = arch_counter_get_cntpct;
 		}
 
-		arch_timer_read_counter = rd;
 		clocksource_counter.vdso_clock_mode = vdso_default;
 	} else {
 		arch_timer_read_counter = arch_counter_get_cntvct_mem;
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
