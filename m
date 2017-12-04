From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v6 7/8] KVM: arm/arm64: Provide a get_input_level for the arch
 timer
Date: Mon,  4 Dec 2017 21:05:05 +0100
Message-ID: <20171204200506.3224-8-cdall@kernel.org>
References: <20171204200506.3224-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F2A949D85
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 15:02:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IRqh8UYQuxmU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 15:02:13 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 387EB49D9C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 15:02:11 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id l141so8040188wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 12:05:19 -0800 (PST)
In-Reply-To: <20171204200506.3224-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

The VGIC can now support the life-cycle of mapped level-triggered
interrupts, and we no longer have to read back the timer state on every
exit from the VM if we had an asserted timer interrupt signal, because
the VGIC already knows if we hit the unlikely case where the guest
disables the timer without ACKing the virtual timer interrupt.

This means we rework a bit of the code to factor out the functionality
to snapshot the timer state from vtimer_save_state(), and we can reuse
this functionality in the sync path when we have an irqchip in
userspace, and also to support our implementation of the
get_input_level() function for the timer.

This change also means that we can no longer rely on the timer's view of
the interrupt line to set the active state, because we no longer
maintain this state for mapped interrupts when exiting from the guest.
Instead, we only set the active state if the virtual interrupt is
active, and otherwise we simply let the timer fire again and raise the
virtual interrupt from the ISR.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_arch_timer.h |  2 ++
 virt/kvm/arm/arch_timer.c    | 75 +++++++++++++++++++++-----------------------
 2 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 01ee473517e2..f57f795d704c 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -90,6 +90,8 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
 void kvm_timer_init_vhe(void);
 
+bool kvm_arch_timer_get_input_level(int vintid);
+
 #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
 #define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.ptimer)
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index e78ba5e20f74..82d4963f63b8 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -343,6 +343,12 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	phys_timer_emulate(vcpu);
 }
 
+static void __timer_snapshot_state(struct arch_timer_context *timer)
+{
+	timer->cnt_ctl = read_sysreg_el0(cntv_ctl);
+	timer->cnt_cval = read_sysreg_el0(cntv_cval);
+}
+
 static void vtimer_save_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
@@ -354,10 +360,8 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
 	if (!vtimer->loaded)
 		goto out;
 
-	if (timer->enabled) {
-		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
-		vtimer->cnt_cval = read_sysreg_el0(cntv_cval);
-	}
+	if (timer->enabled)
+		__timer_snapshot_state(vtimer);
 
 	/* Disable the virtual timer */
 	write_sysreg_el0(0, cntv_ctl);
@@ -454,8 +458,7 @@ static void kvm_timer_vcpu_load_vgic(struct kvm_vcpu *vcpu)
 	bool phys_active;
 	int ret;
 
-	phys_active = vtimer->irq.level ||
-		      kvm_vgic_map_is_active(vcpu, vtimer->irq.irq);
+	phys_active = kvm_vgic_map_is_active(vcpu, vtimer->irq.irq);
 
 	ret = irq_set_irqchip_state(host_vtimer_irq,
 				    IRQCHIP_STATE_ACTIVE,
@@ -541,27 +544,19 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	set_cntvoff(0);
 }
 
-static void unmask_vtimer_irq(struct kvm_vcpu *vcpu)
+/*
+ * With a userspace irqchip we have to check if the guest de-asserted the
+ * timer and if so, unmask the timer irq signal on the host interrupt
+ * controller to ensure that we see future timer signals.
+ */
+static void unmask_vtimer_irq_user(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
-		kvm_vtimer_update_mask_user(vcpu);
-		return;
-	}
-
-	/*
-	 * If the guest disabled the timer without acking the interrupt, then
-	 * we must make sure the physical and virtual active states are in
-	 * sync by deactivating the physical interrupt, because otherwise we
-	 * wouldn't see the next timer interrupt in the host.
-	 */
-	if (!kvm_vgic_map_is_active(vcpu, vtimer->irq.irq)) {
-		int ret;
-		ret = irq_set_irqchip_state(host_vtimer_irq,
-					    IRQCHIP_STATE_ACTIVE,
-					    false);
-		WARN_ON(ret);
+		__timer_snapshot_state(vtimer);
+		if (!kvm_timer_should_fire(vtimer))
+			kvm_vtimer_update_mask_user(vcpu);
 	}
 }
 
@@ -574,21 +569,7 @@ static void unmask_vtimer_irq(struct kvm_vcpu *vcpu)
  */
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-
-	/*
-	 * If we entered the guest with the vtimer output asserted we have to
-	 * check if the guest has modified the timer so that we should lower
-	 * the line at this point.
-	 */
-	if (vtimer->irq.level) {
-		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
-		vtimer->cnt_cval = read_sysreg_el0(cntv_cval);
-		if (!kvm_timer_should_fire(vtimer)) {
-			kvm_timer_update_irq(vcpu, false, vtimer);
-			unmask_vtimer_irq(vcpu);
-		}
-	}
+	unmask_vtimer_irq_user(vcpu);
 }
 
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -819,6 +800,22 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+bool kvm_arch_timer_get_input_level(int vintid)
+{
+	struct kvm_vcpu *vcpu = kvm_arm_get_running_vcpu();
+	struct arch_timer_context *timer;
+
+	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
+		timer = vcpu_vtimer(vcpu);
+	else
+		BUG(); /* We only map the vtimer so far */
+
+	if (timer->loaded)
+		__timer_snapshot_state(timer);
+
+	return kvm_timer_should_fire(timer);
+}
+
 int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
@@ -841,7 +838,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	}
 
 	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq, vtimer->irq.irq,
-				    NULL);
+				    kvm_arch_timer_get_input_level);
 	if (ret)
 		return ret;
 
-- 
2.14.2
