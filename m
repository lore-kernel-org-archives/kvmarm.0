From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 3/5] KVM: arm/arm64: replace vcpu->arch.power_off with a
 vcpu-request
Date: Mon, 27 Feb 2017 18:55:02 +0100
Message-ID: <20170227175504.15751-4-drjones@redhat.com>
References: <20170227175504.15751-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C6FF40C2C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:54:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d5GyPjPz4t4i for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Feb 2017 12:54:06 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31CD440C45
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:54:06 -0500 (EST)
In-Reply-To: <20170227175504.15751-1-drjones@redhat.com>
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
Cc: marc.zyngier@arm.com, ashoks@broadcom.com, imammedo@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Like pause, replacing power_off with a vcpu-request ensures
visibility of changes and avoids the final race before entering
the guest.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/include/asm/kvm_host.h   |  4 +---
 arch/arm/kvm/arm.c                | 32 ++++++++++++++++++--------------
 arch/arm/kvm/psci.c               | 17 +++++------------
 arch/arm64/include/asm/kvm_host.h |  4 +---
 4 files changed, 25 insertions(+), 32 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3b5d60611cac..73f61773e9c2 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -47,6 +47,7 @@
 #endif
 
 #define KVM_REQ_VCPU_PAUSE	8
+#define KVM_REQ_VCPU_POWER_OFF	9
 
 u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
 int __attribute_const__ kvm_target_cpu(void);
@@ -171,9 +172,6 @@ struct kvm_vcpu_arch {
 	 * here.
 	 */
 
-	/* vcpu power-off state */
-	bool power_off;
-
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
 
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 17d5f3fb33d9..aa68354a0bf8 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -366,7 +366,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	if (vcpu->arch.power_off)
+	if (__kvm_request_test(KVM_REQ_VCPU_POWER_OFF, vcpu))
 		mp_state->mp_state = KVM_MP_STATE_STOPPED;
 	else
 		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
@@ -379,10 +379,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 {
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
-		vcpu->arch.power_off = false;
+		__kvm_request_clear(KVM_REQ_VCPU_POWER_OFF, vcpu);
 		break;
 	case KVM_MP_STATE_STOPPED:
-		vcpu->arch.power_off = true;
+		__kvm_request_set(KVM_REQ_VCPU_POWER_OFF, vcpu);
 		break;
 	default:
 		return -EINVAL;
@@ -400,9 +400,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
  */
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
-	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !v->arch.power_off
-		&& !__kvm_request_test(KVM_REQ_VCPU_PAUSE, v));
+	return (!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
+	       && !__kvm_request_test(KVM_REQ_VCPU_POWER_OFF, v)
+	       && !__kvm_request_test(KVM_REQ_VCPU_PAUSE, v);
 }
 
 /* Just ensure a guest exit from a particular CPU */
@@ -563,8 +563,9 @@ static void vcpu_sleep(struct kvm_vcpu *vcpu)
 {
 	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
 
-	swait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
-		(!__kvm_request_test(KVM_REQ_VCPU_PAUSE, vcpu))));
+	swait_event_interruptible(*wq,
+		!__kvm_request_test(KVM_REQ_VCPU_POWER_OFF, vcpu) &&
+		!__kvm_request_test(KVM_REQ_VCPU_PAUSE, vcpu));
 }
 
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
@@ -617,8 +618,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		update_vttbr(vcpu->kvm);
 
-		if (vcpu->arch.power_off || __kvm_request_test(KVM_REQ_VCPU_PAUSE, vcpu))
-			vcpu_sleep(vcpu);
+		if (kvm_request_pending(vcpu)) {
+			if (__kvm_request_test(KVM_REQ_VCPU_POWER_OFF, vcpu) ||
+			    __kvm_request_test(KVM_REQ_VCPU_PAUSE, vcpu))
+				vcpu_sleep(vcpu);
+		}
 
 		/*
 		 * Preparing the interrupts to be injected also
@@ -643,8 +647,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		vcpu->mode = IN_GUEST_MODE;
 		smp_mb(); /* ensure vcpu->mode is visible to kvm_vcpu_kick */
 
-		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
-			vcpu->arch.power_off || kvm_request_pending(vcpu)) {
+		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)
+		    || kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			smp_mb();
 			local_irq_enable();
@@ -872,9 +876,9 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * Handle the "start in power-off" case.
 	 */
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
-		vcpu->arch.power_off = true;
+		__kvm_request_set(KVM_REQ_VCPU_POWER_OFF, vcpu);
 	else
-		vcpu->arch.power_off = false;
+		__kvm_request_clear(KVM_REQ_VCPU_POWER_OFF, vcpu);
 
 	return 0;
 }
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index fd7e381b13b2..6c6255f9d8ff 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -64,7 +64,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 
 static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.power_off = true;
+	__kvm_request_set(KVM_REQ_VCPU_POWER_OFF, vcpu);
 }
 
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
@@ -88,7 +88,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
-	if (!vcpu->arch.power_off) {
+	if (!__kvm_request_test(KVM_REQ_VCPU_POWER_OFF, vcpu)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
@@ -116,8 +116,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 * the general puspose registers are undefined upon CPU_ON.
 	 */
 	vcpu_set_reg(vcpu, 0, context_id);
-	vcpu->arch.power_off = false;
-	smp_mb();		/* Make sure the above is visible */
+	__kvm_request_clear(KVM_REQ_VCPU_POWER_OFF, vcpu);
 
 	wq = kvm_arch_vcpu_wq(vcpu);
 	swake_up(wq);
@@ -154,7 +153,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
 		if ((mpidr & target_affinity_mask) == target_affinity) {
 			matching_cpus++;
-			if (!tmp->arch.power_off)
+			if (!__kvm_request_test(KVM_REQ_VCPU_POWER_OFF, tmp))
 				return PSCI_0_2_AFFINITY_LEVEL_ON;
 		}
 	}
@@ -167,9 +166,6 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 
 static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
 {
-	int i;
-	struct kvm_vcpu *tmp;
-
 	/*
 	 * The KVM ABI specifies that a system event exit may call KVM_RUN
 	 * again and may perform shutdown/reboot at a later time that when the
@@ -179,10 +175,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
 	 * after this call is handled and before the VCPUs have been
 	 * re-initialized.
 	 */
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
-		tmp->arch.power_off = true;
-		kvm_vcpu_kick(tmp);
-	}
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_VCPU_POWER_OFF);
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
 	vcpu->run->system_event.type = type;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c03e1fc3bc34..d1e4b5d962eb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,6 +44,7 @@
 #define KVM_VCPU_MAX_FEATURES 4
 
 #define KVM_REQ_VCPU_PAUSE	8
+#define KVM_REQ_VCPU_POWER_OFF	9
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
@@ -254,9 +255,6 @@ struct kvm_vcpu_arch {
 		u32	mdscr_el1;
 	} guest_debug_preserved;
 
-	/* vcpu power-off state */
-	bool power_off;
-
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
 
-- 
2.9.3
