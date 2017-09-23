From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 02/20] arm64: Use physical counter for in-kernel reads
Date: Sat, 23 Sep 2017 02:41:49 +0200
Message-ID: <20170923004207.22356-3-cdall@linaro.org>
References: <20170923004207.22356-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Using the physical counter allows KVM to retain the offset between the
virtual and physical counter as long as it is actively running a VCPU.

As soon as a VCPU is released, another thread is scheduled or we start
running userspace applications, we reset the offset to 0, so that
userspace accessing the virtual timer can still read the cirtual counter
and get the same view of time as the kernel.

This opens up potential improvements for KVM performance.

VHE kernels or kernels continuing to use the virtual timer are
unaffected.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/include/asm/arch_timer.h  | 9 ++++-----
 drivers/clocksource/arm_arch_timer.c | 3 +--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index a652ce0..1859a1c 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -148,11 +148,10 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 
 static inline u64 arch_counter_get_cntpct(void)
 {
-	/*
-	 * AArch64 kernel and user space mandate the use of CNTVCT.
-	 */
-	BUG();
-	return 0;
+	u64 cval;
+	isb();
+	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
+	return cval;
 }
 
 static inline u64 arch_counter_get_cntvct(void)
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index fd4b7f6..9b3322a 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -890,8 +890,7 @@ static void __init arch_counter_register(unsigned type)
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_TIMER_TYPE_CP15) {
-		if (IS_ENABLED(CONFIG_ARM64) ||
-		    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
+		if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
 			arch_timer_read_counter = arch_counter_get_cntvct;
 		else
 			arch_timer_read_counter = arch_counter_get_cntpct;
-- 
2.9.0
