From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC v3 02/10] KVM: arm/arm64: Move cntvoff to each timer context
Date: Wed,  1 Feb 2017 12:43:02 -0500
Message-ID: <1485970990-13775-3-git-send-email-jintack@cs.columbia.edu>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BA9740C1C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:42:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZAJywdI1Q3Ch for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 12:42:55 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0447B40BAC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:42:54 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v11He857001125
 for <kvmarm@lists.cs.columbia.edu>; Wed, 1 Feb 2017 12:43:16 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 6D8EB80
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:16 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 52BA99A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:16 -0500 (EST)
Received: from mail-qt0-f200.google.com (mail-qt0-f200.google.com
 [209.85.216.200])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v11HhG5x048074
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 1 Feb 2017 12:43:16 -0500
Received: by mail-qt0-f200.google.com with SMTP id x49so398060894qtc.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Feb 2017 09:43:16 -0800 (PST)
In-Reply-To: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Make cntvoff per each timer context. This is helpful to abstract kvm
timer functions to work with timer context without considering timer
types (e.g. physical timer or virtual timer).

This also would pave the way for ever doing adjustments of the cntvoff
on a per-CPU basis if that should ever make sense.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_host.h   |  3 ---
 arch/arm/kvm/arm.c                |  1 -
 arch/arm64/include/asm/kvm_host.h |  3 ---
 include/kvm/arm_arch_timer.h      |  9 +++------
 virt/kvm/arm/arch_timer.c         | 31 +++++++++++++++++++++----------
 virt/kvm/arm/hyp/timer-sr.c       |  3 +--
 6 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d5423ab..cc495d79 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -60,9 +60,6 @@ struct kvm_arch {
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
-	/* Timer */
-	struct arch_timer_kvm	timer;
-
 	/*
 	 * Anything that is not used directly from assembly code goes
 	 * here.
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9d74464..f93f2171 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -135,7 +135,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		goto out_free_stage2_pgd;
 
 	kvm_vgic_early_init(kvm);
-	kvm_timer_init(kvm);
 
 	/* Mark the initial VMID generation invalid */
 	kvm->arch.vmid_gen = 0;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e505038..4a758cb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -70,9 +70,6 @@ struct kvm_arch {
 
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
-
-	/* Timer */
-	struct arch_timer_kvm	timer;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index daad3c1..2c8560b 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -23,11 +23,6 @@
 #include <linux/hrtimer.h>
 #include <linux/workqueue.h>
 
-struct arch_timer_kvm {
-	/* Virtual offset */
-	u64			cntvoff;
-};
-
 struct arch_timer_context {
 	/* Registers: control register, timer value */
 	u32				cnt_ctl;
@@ -38,6 +33,9 @@ struct arch_timer_context {
 
 	/* Active IRQ state caching */
 	bool				active_cleared_last;
+
+	/* Virtual offset */
+	u64			cntvoff;
 };
 
 struct arch_timer_cpu {
@@ -58,7 +56,6 @@ struct arch_timer_cpu {
 
 int kvm_timer_hyp_init(void);
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
-void kvm_timer_init(struct kvm *kvm);
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 			 const struct kvm_irq_level *irq);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index d3556b3..19fbaaf 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -101,9 +101,10 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
 static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu)
 {
 	u64 cval, now;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
-	cval = vcpu_vtimer(vcpu)->cnt_cval;
-	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
+	cval = vtimer->cnt_cval;
+	now = kvm_phys_timer_read() - vtimer->cntvoff;
 
 	if (now < cval) {
 		u64 ns;
@@ -159,7 +160,7 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
 		return false;
 
 	cval = vtimer->cnt_cval;
-	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
+	now = kvm_phys_timer_read() - vtimer->cntvoff;
 
 	return cval <= now;
 }
@@ -354,10 +355,25 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/* Make the updates of cntvoff for all vtimer contexts atomic */
+static void update_vtimer_cntvoff(struct kvm *kvm, u64 cntvoff)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	mutex_lock(&kvm->lock);
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		vcpu_vtimer(vcpu)->cntvoff = cntvoff;
+	mutex_unlock(&kvm->lock);
+}
+
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
+	/* Synchronize cntvoff across all vtimers of a VM. */
+	update_vtimer_cntvoff(vcpu->kvm, kvm_phys_timer_read());
+
 	INIT_WORK(&timer->expired, kvm_timer_inject_irq_work);
 	hrtimer_init(&timer->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	timer->timer.function = kvm_timer_expire;
@@ -377,7 +393,7 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 		vtimer->cnt_ctl = value;
 		break;
 	case KVM_REG_ARM_TIMER_CNT:
-		vcpu->kvm->arch.timer.cntvoff = kvm_phys_timer_read() - value;
+		update_vtimer_cntvoff(vcpu->kvm, kvm_phys_timer_read() - value);
 		break;
 	case KVM_REG_ARM_TIMER_CVAL:
 		vtimer->cnt_cval = value;
@@ -398,7 +414,7 @@ u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
 	case KVM_REG_ARM_TIMER_CTL:
 		return vtimer->cnt_ctl;
 	case KVM_REG_ARM_TIMER_CNT:
-		return kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
+		return kvm_phys_timer_read() - vtimer->cntvoff;
 	case KVM_REG_ARM_TIMER_CVAL:
 		return vtimer->cnt_cval;
 	}
@@ -510,11 +526,6 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kvm_timer_init(struct kvm *kvm)
-{
-	kvm->arch.timer.cntvoff = kvm_phys_timer_read();
-}
-
 /*
  * On VHE system, we only need to configure trap on physical timer and counter
  * accesses in EL0 and EL1 once, not for every world switch.
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index 0cf0895..4734915 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -53,7 +53,6 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 
 void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	u64 val;
@@ -71,7 +70,7 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 	}
 
 	if (timer->enabled) {
-		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
+		write_sysreg(vtimer->cntvoff, cntvoff_el2);
 		write_sysreg_el0(vtimer->cnt_cval, cntv_cval);
 		isb();
 		write_sysreg_el0(vtimer->cnt_ctl, cntv_ctl);
-- 
1.9.1
