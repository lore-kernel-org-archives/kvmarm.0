From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 08/57] KVM: arm/arm64: Move timer IRQ map to latest
 possible time
Date: Thu, 19 May 2016 19:07:47 +0100
Message-ID: <1463681316-23039-9-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6E7B49B32
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:05:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tdqQXf6TwMRz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2016 14:05:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0445412ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:05:05 -0400 (EDT)
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

We are about to modify the VGIC to allocate all data structures
dynamically and store mapped IRQ information on a per-IRQ struct, which
is indeed allocated dynamically at init time.

Therefore, we cannot record the mapped IRQ info from the timer at timer
reset time like it's done now, because VCPU reset happens before timer
init.

A possible later time to do this is on the first run of a per VCPU, it
just requires us to move the enable state to be a per-VCPU state and do
the lookup of the physical IRQ number when we are about to run the VCPU.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/kvm/arm.c           |  6 ++--
 include/kvm/arm_arch_timer.h |  8 +++---
 virt/kvm/arm/arch_timer.c    | 66 +++++++++++++++++++++++++-------------------
 virt/kvm/arm/hyp/timer-sr.c  |  5 ++--
 4 files changed, 47 insertions(+), 38 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index be4b639..ceb9345 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -459,7 +459,7 @@ static void update_vttbr(struct kvm *kvm)
 static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	int ret;
+	int ret = 0;
 
 	if (likely(vcpu->arch.has_run_once))
 		return 0;
@@ -482,9 +482,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	 * interrupts from the virtual timer with a userspace gic.
 	 */
 	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
-		kvm_timer_enable(kvm);
+		ret = kvm_timer_enable(vcpu);
 
-	return 0;
+	return ret;
 }
 
 bool kvm_arch_intc_initialized(struct kvm *kvm)
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index a47b7de..dda39d8 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -24,9 +24,6 @@
 #include <linux/workqueue.h>
 
 struct arch_timer_kvm {
-	/* Is the timer enabled */
-	bool			enabled;
-
 	/* Virtual offset */
 	cycle_t			cntvoff;
 };
@@ -55,10 +52,13 @@ struct arch_timer_cpu {
 
 	/* Active IRQ state caching */
 	bool				active_cleared_last;
+
+	/* Is the timer enabled */
+	bool			enabled;
 };
 
 int kvm_timer_hyp_init(void);
-void kvm_timer_enable(struct kvm *kvm);
+int kvm_timer_enable(struct kvm_vcpu *vcpu);
 void kvm_timer_init(struct kvm *kvm);
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 			 const struct kvm_irq_level *irq);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 3232105..e2d5b6f 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -197,7 +197,7 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	 * because the guest would never see the interrupt.  Instead wait
 	 * until we call this function from kvm_timer_flush_hwstate.
 	 */
-	if (!vgic_initialized(vcpu->kvm))
+	if (!vgic_initialized(vcpu->kvm) || !timer->enabled)
 		return -ENODEV;
 
 	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
@@ -333,9 +333,6 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 			 const struct kvm_irq_level *irq)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	struct irq_desc *desc;
-	struct irq_data *data;
-	int phys_irq;
 
 	/*
 	 * The vcpu timer irq number cannot be determined in
@@ -354,26 +351,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	timer->cntv_ctl = 0;
 	kvm_timer_update_state(vcpu);
 
-	/*
-	 * Find the physical IRQ number corresponding to the host_vtimer_irq
-	 */
-	desc = irq_to_desc(host_vtimer_irq);
-	if (!desc) {
-		kvm_err("%s: no interrupt descriptor\n", __func__);
-		return -EINVAL;
-	}
-
-	data = irq_desc_get_irq_data(desc);
-	while (data->parent_data)
-		data = data->parent_data;
-
-	phys_irq = data->hwirq;
-
-	/*
-	 * Tell the VGIC that the virtual interrupt is tied to a
-	 * physical interrupt. We do that once per VCPU.
-	 */
-	return kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
+	return 0;
 }
 
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
@@ -501,10 +479,40 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	kvm_vgic_unmap_phys_irq(vcpu, timer->irq.irq);
 }
 
-void kvm_timer_enable(struct kvm *kvm)
+int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
-	if (kvm->arch.timer.enabled)
-		return;
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct irq_desc *desc;
+	struct irq_data *data;
+	int phys_irq;
+	int ret;
+
+	if (timer->enabled)
+		return 0;
+
+	/*
+	 * Find the physical IRQ number corresponding to the host_vtimer_irq
+	 */
+	desc = irq_to_desc(host_vtimer_irq);
+	if (!desc) {
+		kvm_err("%s: no interrupt descriptor\n", __func__);
+		return -EINVAL;
+	}
+
+	data = irq_desc_get_irq_data(desc);
+	while (data->parent_data)
+		data = data->parent_data;
+
+	phys_irq = data->hwirq;
+
+	/*
+	 * Tell the VGIC that the virtual interrupt is tied to a
+	 * physical interrupt. We do that once per VCPU.
+	 */
+	ret = kvm_vgic_map_phys_irq(vcpu, timer->irq.irq, phys_irq);
+	if (ret)
+		return ret;
+
 
 	/*
 	 * There is a potential race here between VCPUs starting for the first
@@ -515,7 +523,9 @@ void kvm_timer_enable(struct kvm *kvm)
 	 * the arch timers are enabled.
 	 */
 	if (timecounter && wqueue)
-		kvm->arch.timer.enabled = 1;
+		timer->enabled = 1;
+
+	return 0;
 }
 
 void kvm_timer_init(struct kvm *kvm)
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index ea00d69..798866a 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -24,11 +24,10 @@
 /* vcpu is already in the HYP VA space */
 void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	u64 val;
 
-	if (kvm->arch.timer.enabled) {
+	if (timer->enabled) {
 		timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
 		timer->cntv_cval = read_sysreg_el0(cntv_cval);
 	}
@@ -60,7 +59,7 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 	val |= CNTHCTL_EL1PCTEN;
 	write_sysreg(val, cnthctl_el2);
 
-	if (kvm->arch.timer.enabled) {
+	if (timer->enabled) {
 		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
 		write_sysreg_el0(timer->cntv_cval, cntv_cval);
 		isb();
-- 
2.8.2
