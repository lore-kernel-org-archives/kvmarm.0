From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 4/5] KVM: arm/arm64: Report PMU overflow interrupts to
 userspace irqchip
Date: Fri,  3 Feb 2017 15:56:54 +0100
Message-ID: <20170203145655.15007-5-cdall@linaro.org>
References: <20170203145655.15007-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4C2540A7C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 09:56:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XUMalVxI8qxv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Feb 2017 09:56:42 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26B6440A3C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 09:56:40 -0500 (EST)
Received: by mail-wm0-f52.google.com with SMTP id r141so31152855wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Feb 2017 06:57:05 -0800 (PST)
In-Reply-To: <20170203145655.15007-1-cdall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Pekka Enberg <penberg@iki.fi>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

When not using an in-kernel VGIC, but instead emulating an interrupt
controller in userspace, we should report the PMU overflow status to
that userspace interrupt controller using the KVM_CAP_ARM_USER_IRQ
feature.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c    |  9 ++++++---
 include/kvm/arm_pmu.h |  7 +++++++
 virt/kvm/arm/pmu.c    | 42 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 505f928..92f38f6 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -628,11 +628,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
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
@@ -706,6 +708,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	/* Tell userspace about in-kernel device output levels */
 	kvm_timer_update_run(vcpu);
+	kvm_pmu_update_run(vcpu);
 
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
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 69ccce3..51218be 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -230,13 +230,47 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
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
+	if (likely(irqchip_in_kernel(vcpu->kvm)))
+		return;
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
