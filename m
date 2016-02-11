From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 04/23] arm64: Allow the arch timer to use the HYP timer
Date: Thu, 11 Feb 2016 18:39:45 +0000
Message-ID: <1455216004-19499-5-git-send-email-marc.zyngier@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F12B49BF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wgM1JnZISIIA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 13:34:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A17049BF4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:20 -0500 (EST)
In-Reply-To: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

With the ARMv8.1 VHE, the kernel can run in HYP mode, and thus
use the HYP timer instead of the normal guest timer in a mostly
transparent way, except for the interrupt line.

This patch reworks the arch timer code to allow the selection of
the HYP PPI, possibly falling back to the guest timer if not
available.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/clocksource/arm_arch_timer.c | 96 ++++++++++++++++++++++--------------
 1 file changed, 59 insertions(+), 37 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index c64d543..ffe9d1c 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -67,7 +67,7 @@ static int arch_timer_ppi[MAX_TIMER_PPI];
 
 static struct clock_event_device __percpu *arch_timer_evt;
 
-static bool arch_timer_use_virtual = true;
+static enum ppi_nr arch_timer_uses_ppi = VIRT_PPI;
 static bool arch_timer_c3stop;
 static bool arch_timer_mem_use_virtual;
 
@@ -263,14 +263,20 @@ static void __arch_timer_setup(unsigned type,
 		clk->name = "arch_sys_timer";
 		clk->rating = 450;
 		clk->cpumask = cpumask_of(smp_processor_id());
-		if (arch_timer_use_virtual) {
-			clk->irq = arch_timer_ppi[VIRT_PPI];
+		clk->irq = arch_timer_ppi[arch_timer_uses_ppi];
+		switch (arch_timer_uses_ppi) {
+		case VIRT_PPI:
 			clk->set_state_shutdown = arch_timer_shutdown_virt;
 			clk->set_next_event = arch_timer_set_next_event_virt;
-		} else {
-			clk->irq = arch_timer_ppi[PHYS_SECURE_PPI];
+			break;
+		case PHYS_SECURE_PPI:
+		case PHYS_NONSECURE_PPI:
+		case HYP_PPI:
 			clk->set_state_shutdown = arch_timer_shutdown_phys;
 			clk->set_next_event = arch_timer_set_next_event_phys;
+			break;
+		default:
+			BUG();
 		}
 	} else {
 		clk->features |= CLOCK_EVT_FEAT_DYNIRQ;
@@ -338,17 +344,20 @@ static void arch_counter_set_user_access(void)
 	arch_timer_set_cntkctl(cntkctl);
 }
 
+static bool arch_timer_has_nonsecure_ppi(void)
+{
+	return (arch_timer_uses_ppi == PHYS_SECURE_PPI &&
+		arch_timer_ppi[PHYS_NONSECURE_PPI]);
+}
+
 static int arch_timer_setup(struct clock_event_device *clk)
 {
 	__arch_timer_setup(ARCH_CP15_TIMER, clk);
 
-	if (arch_timer_use_virtual)
-		enable_percpu_irq(arch_timer_ppi[VIRT_PPI], 0);
-	else {
-		enable_percpu_irq(arch_timer_ppi[PHYS_SECURE_PPI], 0);
-		if (arch_timer_ppi[PHYS_NONSECURE_PPI])
-			enable_percpu_irq(arch_timer_ppi[PHYS_NONSECURE_PPI], 0);
-	}
+	enable_percpu_irq(arch_timer_ppi[arch_timer_uses_ppi], 0);
+
+	if (arch_timer_has_nonsecure_ppi())
+		enable_percpu_irq(arch_timer_ppi[PHYS_NONSECURE_PPI], 0);
 
 	arch_counter_set_user_access();
 	if (IS_ENABLED(CONFIG_ARM_ARCH_TIMER_EVTSTREAM))
@@ -390,7 +399,7 @@ static void arch_timer_banner(unsigned type)
 		     (unsigned long)arch_timer_rate / 1000000,
 		     (unsigned long)(arch_timer_rate / 10000) % 100,
 		     type & ARCH_CP15_TIMER ?
-			arch_timer_use_virtual ? "virt" : "phys" :
+		     (arch_timer_uses_ppi == VIRT_PPI) ? "virt" : "phys" :
 			"",
 		     type == (ARCH_CP15_TIMER | ARCH_MEM_TIMER) ?  "/" : "",
 		     type & ARCH_MEM_TIMER ?
@@ -460,7 +469,7 @@ static void __init arch_counter_register(unsigned type)
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_CP15_TIMER) {
-		if (IS_ENABLED(CONFIG_ARM64) || arch_timer_use_virtual)
+		if (IS_ENABLED(CONFIG_ARM64) || arch_timer_uses_ppi == VIRT_PPI)
 			arch_timer_read_counter = arch_counter_get_cntvct;
 		else
 			arch_timer_read_counter = arch_counter_get_cntpct;
@@ -490,13 +499,9 @@ static void arch_timer_stop(struct clock_event_device *clk)
 	pr_debug("arch_timer_teardown disable IRQ%d cpu #%d\n",
 		 clk->irq, smp_processor_id());
 
-	if (arch_timer_use_virtual)
-		disable_percpu_irq(arch_timer_ppi[VIRT_PPI]);
-	else {
-		disable_percpu_irq(arch_timer_ppi[PHYS_SECURE_PPI]);
-		if (arch_timer_ppi[PHYS_NONSECURE_PPI])
-			disable_percpu_irq(arch_timer_ppi[PHYS_NONSECURE_PPI]);
-	}
+	disable_percpu_irq(arch_timer_ppi[arch_timer_uses_ppi]);
+	if (arch_timer_has_nonsecure_ppi())
+		disable_percpu_irq(arch_timer_ppi[PHYS_NONSECURE_PPI]);
 
 	clk->set_state_shutdown(clk);
 }
@@ -562,12 +567,14 @@ static int __init arch_timer_register(void)
 		goto out;
 	}
 
-	if (arch_timer_use_virtual) {
-		ppi = arch_timer_ppi[VIRT_PPI];
+	ppi = arch_timer_ppi[arch_timer_uses_ppi];
+	switch (arch_timer_uses_ppi) {
+	case VIRT_PPI:
 		err = request_percpu_irq(ppi, arch_timer_handler_virt,
 					 "arch_timer", arch_timer_evt);
-	} else {
-		ppi = arch_timer_ppi[PHYS_SECURE_PPI];
+		break;
+	case PHYS_SECURE_PPI:
+	case PHYS_NONSECURE_PPI:
 		err = request_percpu_irq(ppi, arch_timer_handler_phys,
 					 "arch_timer", arch_timer_evt);
 		if (!err && arch_timer_ppi[PHYS_NONSECURE_PPI]) {
@@ -578,6 +585,13 @@ static int __init arch_timer_register(void)
 				free_percpu_irq(arch_timer_ppi[PHYS_SECURE_PPI],
 						arch_timer_evt);
 		}
+		break;
+	case HYP_PPI:
+		err = request_percpu_irq(ppi, arch_timer_handler_phys,
+					 "arch_timer", arch_timer_evt);
+		break;
+	default:
+		BUG();
 	}
 
 	if (err) {
@@ -602,15 +616,10 @@ static int __init arch_timer_register(void)
 out_unreg_notify:
 	unregister_cpu_notifier(&arch_timer_cpu_nb);
 out_free_irq:
-	if (arch_timer_use_virtual)
-		free_percpu_irq(arch_timer_ppi[VIRT_PPI], arch_timer_evt);
-	else {
-		free_percpu_irq(arch_timer_ppi[PHYS_SECURE_PPI],
+	free_percpu_irq(arch_timer_ppi[arch_timer_uses_ppi], arch_timer_evt);
+	if (arch_timer_has_nonsecure_ppi())
+		free_percpu_irq(arch_timer_ppi[PHYS_NONSECURE_PPI],
 				arch_timer_evt);
-		if (arch_timer_ppi[PHYS_NONSECURE_PPI])
-			free_percpu_irq(arch_timer_ppi[PHYS_NONSECURE_PPI],
-					arch_timer_evt);
-	}
 
 out_free:
 	free_percpu(arch_timer_evt);
@@ -697,12 +706,25 @@ static void __init arch_timer_init(void)
 	 *
 	 * If no interrupt provided for virtual timer, we'll have to
 	 * stick to the physical timer. It'd better be accessible...
+	 *
+	 * On ARMv8.1 with VH extensions, the kernel runs in HYP. VHE
+	 * accesses to CNTP_*_EL1 registers are silently redirected to
+	 * their CNTHP_*_EL2 counterparts, and use a different PPI
+	 * number.
 	 */
 	if (is_hyp_mode_available() || !arch_timer_ppi[VIRT_PPI]) {
-		arch_timer_use_virtual = false;
+		bool has_ppi;
+
+		if (is_kernel_in_hyp_mode()) {
+			arch_timer_uses_ppi = HYP_PPI;
+			has_ppi = !!arch_timer_ppi[HYP_PPI];
+		} else {
+			arch_timer_uses_ppi = PHYS_SECURE_PPI;
+			has_ppi = (!!arch_timer_ppi[PHYS_SECURE_PPI] ||
+				   !!arch_timer_ppi[PHYS_NONSECURE_PPI]);
+		}
 
-		if (!arch_timer_ppi[PHYS_SECURE_PPI] ||
-		    !arch_timer_ppi[PHYS_NONSECURE_PPI]) {
+		if (!has_ppi) {
 			pr_warn("arch_timer: No interrupt available, giving up\n");
 			return;
 		}
@@ -735,7 +757,7 @@ static void __init arch_timer_of_init(struct device_node *np)
 	 */
 	if (IS_ENABLED(CONFIG_ARM) &&
 	    of_property_read_bool(np, "arm,cpu-registers-not-fw-configured"))
-			arch_timer_use_virtual = false;
+		arch_timer_uses_ppi = PHYS_SECURE_PPI;
 
 	arch_timer_init();
 }
-- 
2.1.4
