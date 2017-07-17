From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH v2 01/19] arm64: Use physical counter for in-kernel reads
Date: Mon, 17 Jul 2017 16:27:00 +0200
Message-ID: <20170717142718.13853-2-cdall@linaro.org>
References: <20170717142718.13853-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170717142718.13853-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Using the physical counter allows KVM to retain the offset between the
virtual and physical counter as long as it is actively running a VCPU.

As soon as a VCPU is released, another thread is scheduled or we start
running userspace applications, we reset the offset to 0, so that
userspace accessing the virtual timer can still read the cirtual counter
and get the same view of time as the kernel.

This opens up potential improvements for KVM performance.

VHE kernels or kernels continuing to use the virtual timer should be
unaffected.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/include/asm/arch_timer.h  | 6 ++++--
 drivers/clocksource/arm_arch_timer.c | 3 +--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 74d08e4..ee5619b 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -148,11 +148,13 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 
 static inline u64 arch_counter_get_cntpct(void)
 {
+	u64 cval;
 	/*
 	 * AArch64 kernel and user space mandate the use of CNTVCT.
 	 */
-	BUG();
-	return 0;
+	isb();
+	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
+	return cval;
 }
 
 static inline u64 arch_counter_get_cntvct(void)
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index aae87c4..c24327c 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -886,8 +886,7 @@ static void __init arch_counter_register(unsigned type)
 
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
