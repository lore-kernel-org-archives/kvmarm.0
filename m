From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v5 03/20] arm64: Use physical counter for in-kernel reads when
 booted in EL2
Date: Fri, 27 Oct 2017 10:34:24 +0200
Message-ID: <1509093281-15225-4-git-send-email-cdall@linaro.org>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A6A041185
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:33:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZU-BDNvbpwgT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 04:33:54 -0400 (EDT)
Received: from mail-lf0-f65.google.com (mail-lf0-f65.google.com
 [209.85.215.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C15C140795
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:33:53 -0400 (EDT)
Received: by mail-lf0-f65.google.com with SMTP id a69so6544407lfe.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 01:35:18 -0700 (PDT)
In-Reply-To: <1509093281-15225-1-git-send-email-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Using the physical counter allows KVM to retain the offset between the
virtual and physical counter as long as it is actively running a VCPU.

As soon as a VCPU is released, another thread is scheduled or we start
running userspace applications, we reset the offset to 0, so that
userspace accessing the virtual timer can still read the virtual counter
and get the same view of time as the kernel.

This opens up potential improvements for KVM performance, but we have to
make a few adjustments to preserve system consistency.

Currently get_cycles() is hardwired to arch_counter_get_cntvct() on
arm64, but as we move to using the physical timer for the in-kernel
time-keeping on systems that boot in EL2, we should use the same counter
for get_cycles() as for other in-kernel timekeeping operations.

Similarly, implementations of arch_timer_set_next_event_phys() is
modified to use the counter specific to the timer being programmed.

VHE kernels or kernels continuing to use the virtual timer are
unaffected.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/include/asm/timex.h       |  2 +-
 drivers/clocksource/arm_arch_timer.c | 12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/timex.h b/arch/arm64/include/asm/timex.h
index 81a076e..9ad60ba 100644
--- a/arch/arm64/include/asm/timex.h
+++ b/arch/arm64/include/asm/timex.h
@@ -22,7 +22,7 @@
  * Use the current timer as a cycle counter since this is what we use for
  * the delay loop.
  */
-#define get_cycles()	arch_counter_get_cntvct()
+#define get_cycles()	arch_timer_read_counter()
 
 #include <asm-generic/timex.h>
 
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index ff8f8a1..061476e 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -158,6 +158,7 @@ u32 arch_timer_reg_read(int access, enum arch_timer_reg reg,
  * if we don't have the cp15 accessors we won't have a problem.
  */
 u64 (*arch_timer_read_counter)(void) = arch_counter_get_cntvct;
+EXPORT_SYMBOL_GPL(arch_timer_read_counter);
 
 static u64 arch_counter_read(struct clocksource *cs)
 {
@@ -329,16 +330,19 @@ static void erratum_set_next_event_tval_generic(const int access, unsigned long
 						struct clock_event_device *clk)
 {
 	unsigned long ctrl;
-	u64 cval = evt + arch_counter_get_cntvct();
+	u64 cval;
 
 	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL, clk);
 	ctrl |= ARCH_TIMER_CTRL_ENABLE;
 	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
 
-	if (access == ARCH_TIMER_PHYS_ACCESS)
+	if (access == ARCH_TIMER_PHYS_ACCESS) {
+		cval = evt + arch_counter_get_cntpct();
 		write_sysreg(cval, cntp_cval_el0);
-	else
+	} else {
+		cval = evt + arch_counter_get_cntvct();
 		write_sysreg(cval, cntv_cval_el0);
+	}
 
 	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, clk);
 }
@@ -913,7 +917,7 @@ static void __init arch_counter_register(unsigned type)
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_TIMER_TYPE_CP15) {
-		if (IS_ENABLED(CONFIG_ARM64) ||
+		if ((IS_ENABLED(CONFIG_ARM64) && !is_hyp_mode_available()) ||
 		    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
 			arch_timer_read_counter = arch_counter_get_cntvct;
 		else
-- 
2.7.4
