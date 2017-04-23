From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 73/79] KVM: arm/arm64: Report PMU overflow interrupts to
 userspace irqchip
Date: Sun, 23 Apr 2017 19:09:23 +0200
Message-ID: <20170423170929.27334-74-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93F2749DB2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KYwSaANd093x for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:08:06 -0400 (EDT)
Received: from mail-wr0-f171.google.com (mail-wr0-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 016F440064
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:03 -0400 (EDT)
Received: by mail-wr0-f171.google.com with SMTP id w50so55839619wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:50 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

When not using an in-kernel VGIC, but instead emulating an interrupt
controller in userspace, we should report the PMU overflow status to
that userspace interrupt controller using the KVM_CAP_ARM_USER_IRQ
feature.

Reviewed-by: Alexander Graf <agraf@suse.de>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c        | 13 +++++++++----
 include/kvm/arm_pmu.h     |  7 +++++++
 virt/kvm/arm/arch_timer.c |  3 ---
 virt/kvm/arm/pmu.c        | 39 +++++++++++++++++++++++++++++++++++----
 4 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index ac6e57b..9eda293 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -635,11 +635,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		/*
 		 * If we have a singal pending, or need to notify a userspace
-		 * irqchip about timer level changes, then we exit (and update
-		 * the timer level state in kvm_timer_update_run below).
+		 * irqchip about timer or PMU level changes, then we exit (and
+		 * update the timer level state in kvm_timer_update_run
+		 * below).
 		 */
 		if (signal_pending(current) ||
-		    kvm_timer_should_notify_user(vcpu)) {
+		    kvm_timer_should_notify_user(vcpu) ||
+		    kvm_pmu_should_notify_user(vcpu)) {
 			ret = -EINTR;
 			run->exit_reason = KVM_EXIT_INTR;
 		}
@@ -712,7 +714,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	}
 
 	/* Tell userspace about in-kernel device output levels */
-	kvm_timer_update_run(vcpu);
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
+		kvm_timer_update_run(vcpu);
+		kvm_pmu_update_run(vcpu);
+	}
 
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 92e7e97..1ab4633 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -50,6 +50,8 @@ void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
+bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu);
+void kvm_pmu_update_run(struct kvm_vcpu *vcpu);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
@@ -85,6 +87,11 @@ static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
+static inline bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+static inline void kvm_pmu_update_run(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 5dc2167..5976609 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -193,9 +193,6 @@ void kvm_timer_update_run(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
 
-	if (likely(irqchip_in_kernel(vcpu->kvm)))
-		return;
-
 	/* Populate the device bitmap with the timer states */
 	regs->device_irq_level &= ~(KVM_ARM_DEV_EL1_VTIMER |
 				    KVM_ARM_DEV_EL1_PTIMER);
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 69ccce3..4b43e7f 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -230,13 +230,44 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 		return;
 
 	overflow = !!kvm_pmu_overflow_status(vcpu);
-	if (pmu->irq_level != overflow) {
-		pmu->irq_level = overflow;
-		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
-				    pmu->irq_num, overflow);
+	if (pmu->irq_level == overflow)
+		return;
+
+	pmu->irq_level = overflow;
+
+	if (likely(irqchip_in_kernel(vcpu->kvm))) {
+		int ret;
+		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
+					  pmu->irq_num, overflow);
+		WARN_ON(ret);
 	}
 }
 
+bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_sync_regs *sregs = &vcpu->run->s.regs;
+	bool run_level = sregs->device_irq_level & KVM_ARM_DEV_PMU;
+
+	if (likely(irqchip_in_kernel(vcpu->kvm)))
+		return false;
+
+	return pmu->irq_level != run_level;
+}
+
+/*
+ * Reflect the PMU overflow interrupt output level into the kvm_run structure
+ */
+void kvm_pmu_update_run(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
+
+	/* Populate the timer bitmap for user space */
+	regs->device_irq_level &= ~KVM_ARM_DEV_PMU;
+	if (vcpu->arch.pmu.irq_level)
+		regs->device_irq_level |= KVM_ARM_DEV_PMU;
+}
+
 /**
  * kvm_pmu_flush_hwstate - flush pmu state to cpu
  * @vcpu: The vcpu pointer
-- 
2.9.0
