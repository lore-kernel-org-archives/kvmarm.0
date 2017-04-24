From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH V9 1/3] irq: Allow to pass the IRQF_TIMER flag with percpu irq request
Date: Mon, 24 Apr 2017 16:01:31 +0200
Message-ID: <1493042494-14057-1-git-send-email-daniel.lezcano@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: Mark Rutland <mark.rutland@arm.com>, Vineet Gupta <vgupta@synopsys.com>, Marc Zyngier <marc.zyngier@arm.com>, Patrice Chotard <patrice.chotard@st.com>, Kukjin Kim <kgene@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Javier Martinez Canillas <javier@osg.samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, kernel@stlinux.com, linux-samsung-soc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

In the next changes, we track when the interrupts occur in order to
statistically compute when is supposed to happen the next interrupt.

In all the interruptions, it does not make sense to store the timer interrupt
occurences and try to predict the next interrupt as when know the expiration
time.

The request_irq() has a irq flags parameter and the timer drivers use it to
pass the IRQF_TIMER flag, letting us know the interrupt is coming from a timer.
Based on this flag, we can discard these interrupts when tracking them.

But, the API request_percpu_irq does not allow to pass a flag, hence specifying
if the interrupt type is a timer.

Add a function request_percpu_irq_flags() where we can specify the flags. The
request_percpu_irq() function is changed to be a wrapper to
request_percpu_irq_flags() passing a zero flag parameter.

Change the timers using request_percpu_irq() to use request_percpu_irq_flags()
instead with the IRQF_TIMER flag set.

For now, in order to prevent a misusage of this parameter, only the IRQF_TIMER
flag (or zero) is a valid parameter to be passed to the
request_percpu_irq_flags() function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>

---
Changelog:

   V9:
	- Clarified the patch description
	- Fixed EXPORT_SYMBOL_GPL(request_percpu_irq_flags)
---
 arch/arm/kernel/smp_twd.c                |  3 ++-
 drivers/clocksource/arc_timer.c          |  4 ++--
 drivers/clocksource/arm_arch_timer.c     | 20 ++++++++++++--------
 drivers/clocksource/arm_global_timer.c   |  4 ++--
 drivers/clocksource/exynos_mct.c         |  7 ++++---
 drivers/clocksource/qcom-timer.c         |  4 ++--
 drivers/clocksource/time-armada-370-xp.c |  9 +++++----
 drivers/clocksource/timer-nps.c          |  6 +++---
 include/linux/interrupt.h                | 11 ++++++++++-
 kernel/irq/manage.c                      | 15 ++++++++++-----
 virt/kvm/arm/arch_timer.c                |  5 +++--
 11 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 895ae51..ce9fdcf 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -332,7 +332,8 @@ static int __init twd_local_timer_common_register(struct device_node *np)
 		goto out_free;
 	}
 
-	err = request_percpu_irq(twd_ppi, twd_handler, "twd", twd_evt);
+	err = request_percpu_irq_flags(twd_ppi, twd_handler, IRQF_TIMER, "twd",
+				       twd_evt);
 	if (err) {
 		pr_err("twd: can't register interrupt %d (%d)\n", twd_ppi, err);
 		goto out_free;
diff --git a/drivers/clocksource/arc_timer.c b/drivers/clocksource/arc_timer.c
index 7517f95..993e6af 100644
--- a/drivers/clocksource/arc_timer.c
+++ b/drivers/clocksource/arc_timer.c
@@ -301,8 +301,8 @@ static int __init arc_clockevent_setup(struct device_node *node)
 	}
 
 	/* Needs apriori irq_set_percpu_devid() done in intc map function */
-	ret = request_percpu_irq(arc_timer_irq, timer_irq_handler,
-				 "Timer0 (per-cpu-tick)", evt);
+	ret = request_percpu_irq_flags(arc_timer_irq, timer_irq_handler, IRQF_TIMER,
+				       "Timer0 (per-cpu-tick)", evt);
 	if (ret) {
 		pr_err("clockevent: unable to request irq\n");
 		return ret;
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 7a8a411..d9d00b0 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -768,25 +768,29 @@ static int __init arch_timer_register(void)
 	ppi = arch_timer_ppi[arch_timer_uses_ppi];
 	switch (arch_timer_uses_ppi) {
 	case VIRT_PPI:
-		err = request_percpu_irq(ppi, arch_timer_handler_virt,
-					 "arch_timer", arch_timer_evt);
+		err = request_percpu_irq_flags(ppi, arch_timer_handler_virt,
+					       IRQF_TIMER, "arch_timer",
+					       arch_timer_evt);
 		break;
 	case PHYS_SECURE_PPI:
 	case PHYS_NONSECURE_PPI:
-		err = request_percpu_irq(ppi, arch_timer_handler_phys,
-					 "arch_timer", arch_timer_evt);
+		err = request_percpu_irq_flags(ppi, arch_timer_handler_phys,
+					       IRQF_TIMER, "arch_timer",
+					       arch_timer_evt);
 		if (!err && arch_timer_ppi[PHYS_NONSECURE_PPI]) {
 			ppi = arch_timer_ppi[PHYS_NONSECURE_PPI];
-			err = request_percpu_irq(ppi, arch_timer_handler_phys,
-						 "arch_timer", arch_timer_evt);
+			err = request_percpu_irq_flags(ppi, arch_timer_handler_phys,
+						       IRQF_TIMER, "arch_timer",
+						       arch_timer_evt);
 			if (err)
 				free_percpu_irq(arch_timer_ppi[PHYS_SECURE_PPI],
 						arch_timer_evt);
 		}
 		break;
 	case HYP_PPI:
-		err = request_percpu_irq(ppi, arch_timer_handler_phys,
-					 "arch_timer", arch_timer_evt);
+		err = request_percpu_irq_flags(ppi, arch_timer_handler_phys,
+					       IRQF_TIMER, "arch_timer",
+					       arch_timer_evt);
 		break;
 	default:
 		BUG();
diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
index 123ed20..5a72ec1 100644
--- a/drivers/clocksource/arm_global_timer.c
+++ b/drivers/clocksource/arm_global_timer.c
@@ -302,8 +302,8 @@ static int __init global_timer_of_register(struct device_node *np)
 		goto out_clk;
 	}
 
-	err = request_percpu_irq(gt_ppi, gt_clockevent_interrupt,
-				 "gt", gt_evt);
+	err = request_percpu_irq_flags(gt_ppi, gt_clockevent_interrupt,
+				       IRQF_TIMER, "gt", gt_evt);
 	if (err) {
 		pr_warn("global-timer: can't register interrupt %d (%d)\n",
 			gt_ppi, err);
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 670ff0f..a48ca0f 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -524,9 +524,10 @@ static int __init exynos4_timer_resources(struct device_node *np, void __iomem *
 
 	if (mct_int_type == MCT_INT_PPI) {
 
-		err = request_percpu_irq(mct_irqs[MCT_L0_IRQ],
-					 exynos4_mct_tick_isr, "MCT",
-					 &percpu_mct_tick);
+		err = request_percpu_irq_flags(mct_irqs[MCT_L0_IRQ],
+					       exynos4_mct_tick_isr,
+					       IRQF_TIMER, "MCT",
+					       &percpu_mct_tick);
 		WARN(err, "MCT: can't request IRQ %d (%d)\n",
 		     mct_irqs[MCT_L0_IRQ], err);
 	} else {
diff --git a/drivers/clocksource/qcom-timer.c b/drivers/clocksource/qcom-timer.c
index ee358cd..8e876fc 100644
--- a/drivers/clocksource/qcom-timer.c
+++ b/drivers/clocksource/qcom-timer.c
@@ -174,8 +174,8 @@ static int __init msm_timer_init(u32 dgt_hz, int sched_bits, int irq,
 	}
 
 	if (percpu)
-		res = request_percpu_irq(irq, msm_timer_interrupt,
-					 "gp_timer", msm_evt);
+		res = request_percpu_irq_flags(irq, msm_timer_interrupt,
+					       IRQF_TIMER, "gp_timer", msm_evt);
 
 	if (res) {
 		pr_err("request_percpu_irq failed\n");
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 4440aef..7405e14 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -309,10 +309,11 @@ static int __init armada_370_xp_timer_common_init(struct device_node *np)
 	/*
 	 * Setup clockevent timer (interrupt-driven).
 	 */
-	res = request_percpu_irq(armada_370_xp_clkevt_irq,
-				armada_370_xp_timer_interrupt,
-				"armada_370_xp_per_cpu_tick",
-				armada_370_xp_evt);
+	res = request_percpu_irq_flags(armada_370_xp_clkevt_irq,
+				       armada_370_xp_timer_interrupt,
+				       IRQF_TIMER,
+				       "armada_370_xp_per_cpu_tick",
+				       armada_370_xp_evt);
 	/* Immediately configure the timer on the boot CPU */
 	if (res) {
 		pr_err("Failed to request percpu irq");
diff --git a/drivers/clocksource/timer-nps.c b/drivers/clocksource/timer-nps.c
index da1f798..195f039 100644
--- a/drivers/clocksource/timer-nps.c
+++ b/drivers/clocksource/timer-nps.c
@@ -256,9 +256,9 @@ static int __init nps_setup_clockevent(struct device_node *node)
 		return ret;
 
 	/* Needs apriori irq_set_percpu_devid() done in intc map function */
-	ret = request_percpu_irq(nps_timer0_irq, timer_irq_handler,
-				 "Timer0 (per-cpu-tick)",
-				 &nps_clockevent_device);
+	ret = request_percpu_irq_flags(nps_timer0_irq, timer_irq_handler,
+				       IRQF_TIMER, "Timer0 (per-cpu-tick)",
+				       &nps_clockevent_device);
 	if (ret) {
 		pr_err("Couldn't request irq\n");
 		clk_disable_unprepare(clk);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 53144e7..8f44f23 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -152,8 +152,17 @@ struct irqaction {
 			unsigned long flags, const char *name, void *dev_id);
 
 extern int __must_check
+request_percpu_irq_flags(unsigned int irq, irq_handler_t handler,
+			 unsigned long flags, const char *devname,
+			 void __percpu *percpu_dev_id);
+
+static inline int __must_check
 request_percpu_irq(unsigned int irq, irq_handler_t handler,
-		   const char *devname, void __percpu *percpu_dev_id);
+		   const char *devname, void __percpu *percpu_dev_id)
+{
+	return request_percpu_irq_flags(irq, handler, 0,
+					devname, percpu_dev_id);
+}
 
 extern void free_irq(unsigned int, void *);
 extern void free_percpu_irq(unsigned int, void __percpu *);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index ae1c90f..1ba7734 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1951,9 +1951,10 @@ int setup_percpu_irq(unsigned int irq, struct irqaction *act)
 }
 
 /**
- *	request_percpu_irq - allocate a percpu interrupt line
+ *	request_percpu_irq_flags - allocate a percpu interrupt line
  *	@irq: Interrupt line to allocate
  *	@handler: Function to be called when the IRQ occurs.
+ *	@flags: Interrupt type flags (IRQF_TIMER only)
  *	@devname: An ascii name for the claiming device
  *	@dev_id: A percpu cookie passed back to the handler function
  *
@@ -1966,8 +1967,9 @@ int setup_percpu_irq(unsigned int irq, struct irqaction *act)
  *	the handler gets called with the interrupted CPU's instance of
  *	that variable.
  */
-int request_percpu_irq(unsigned int irq, irq_handler_t handler,
-		       const char *devname, void __percpu *dev_id)
+int request_percpu_irq_flags(unsigned int irq, irq_handler_t handler,
+			     unsigned long flags, const char *devname,
+			     void __percpu *dev_id)
 {
 	struct irqaction *action;
 	struct irq_desc *desc;
@@ -1981,12 +1983,15 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 	    !irq_settings_is_per_cpu_devid(desc))
 		return -EINVAL;
 
+	if (flags && flags != IRQF_TIMER)
+		return -EINVAL;
+
 	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
 	if (!action)
 		return -ENOMEM;
 
 	action->handler = handler;
-	action->flags = IRQF_PERCPU | IRQF_NO_SUSPEND;
+	action->flags = flags | IRQF_PERCPU | IRQF_NO_SUSPEND;
 	action->name = devname;
 	action->percpu_dev_id = dev_id;
 
@@ -2007,7 +2012,7 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 
 	return retval;
 }
-EXPORT_SYMBOL_GPL(request_percpu_irq);
+EXPORT_SYMBOL_GPL(request_percpu_irq_flags);
 
 /**
  *	irq_get_irqchip_state - returns the irqchip state of a interrupt.
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 35d7100..602e0a8 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -523,8 +523,9 @@ int kvm_timer_hyp_init(void)
 		host_vtimer_irq_flags = IRQF_TRIGGER_LOW;
 	}
 
-	err = request_percpu_irq(host_vtimer_irq, kvm_arch_timer_handler,
-				 "kvm guest timer", kvm_get_running_vcpus());
+	err = request_percpu_irq_flags(host_vtimer_irq, kvm_arch_timer_handler,
+				       IRQF_TIMER, "kvm guest timer",
+				       kvm_get_running_vcpus());
 	if (err) {
 		kvm_err("kvm_arch_timer: can't request interrupt %d (%d)\n",
 			host_vtimer_irq, err);
-- 
1.9.1
