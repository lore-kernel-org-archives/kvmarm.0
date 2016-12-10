From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 1/7] arm64: Use physical counter for in-kernel reads
Date: Sat, 10 Dec 2016 21:47:06 +0100
Message-ID: <20161210204712.21830-2-christoffer.dall@linaro.org>
References: <20161210204712.21830-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161210204712.21830-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Using the physical counter allows KVM to retain the offset between the
virtual and physical counter as long as it is actively running a VCPU.

As soon as a VCPU is released, another thread is scheduled or we start
running userspace applications, we reset the offset to 0, so that VDSO
operations can still read the virtual counter and get the same view of
time as the kernel.

This opens up potential improvements for KVM performance.

VHE kernels or kernels using the virtual timer are unaffected by this.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/arch_timer.h  | 6 ++++--
 drivers/clocksource/arm_arch_timer.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index eaa5bbe..cec2549 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -139,11 +139,13 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 
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
index 73c487d..a5b0789 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -597,7 +597,7 @@ static void __init arch_counter_register(unsigned type)
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_CP15_TIMER) {
-		if (IS_ENABLED(CONFIG_ARM64) || arch_timer_uses_ppi == VIRT_PPI)
+		if (arch_timer_uses_ppi == VIRT_PPI || is_kernel_in_hyp_mode())
 			arch_timer_read_counter = arch_counter_get_cntvct;
 		else
 			arch_timer_read_counter = arch_counter_get_cntpct;
-- 
2.9.0

