From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 10/21] KVM: arm/arm64: rename pause into power_off
Date: Wed,  4 Nov 2015 15:49:49 +0100
Message-ID: <1446648600-27297-11-git-send-email-christoffer.dall@linaro.org>
References: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85EBE499E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:49:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pl7XVgiqKyE7 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2015 09:49:56 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA9A749A00
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:49:55 -0500 (EST)
Received: by wmeg8 with SMTP id g8so112699445wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2015 06:53:08 -0800 (PST)
In-Reply-To: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

The kvm_vcpu_arch pause field is renamed into power_off to prepare
for the introduction of a new pause field. Also vcpu_pause is renamed
into vcpu_sleep since we will sleep until both power_off and pause are
false.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   |  4 ++--
 arch/arm/kvm/arm.c                | 20 ++++++++++----------
 arch/arm/kvm/psci.c               | 10 +++++-----
 arch/arm64/include/asm/kvm_host.h |  4 ++--
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index c4072d9..107374f 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -126,8 +126,8 @@ struct kvm_vcpu_arch {
 	 * here.
 	 */
 
-	/* Don't run the guest on this vcpu */
-	bool pause;
+	/* vcpu power-off state */
+	bool power_off;
 
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 59125f4..9d2fb47 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -318,7 +318,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	if (vcpu->arch.pause)
+	if (vcpu->arch.power_off)
 		mp_state->mp_state = KVM_MP_STATE_STOPPED;
 	else
 		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
@@ -331,10 +331,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 {
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
-		vcpu->arch.pause = false;
+		vcpu->arch.power_off = false;
 		break;
 	case KVM_MP_STATE_STOPPED:
-		vcpu->arch.pause = true;
+		vcpu->arch.power_off = true;
 		break;
 	default:
 		return -EINVAL;
@@ -478,11 +478,11 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
 	return vgic_initialized(kvm);
 }
 
-static void vcpu_pause(struct kvm_vcpu *vcpu)
+static void vcpu_sleep(struct kvm_vcpu *vcpu)
 {
 	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
 
-	wait_event_interruptible(*wq, !vcpu->arch.pause);
+	wait_event_interruptible(*wq, !vcpu->arch.power_off);
 }
 
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
@@ -532,8 +532,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		update_vttbr(vcpu->kvm);
 
-		if (vcpu->arch.pause)
-			vcpu_pause(vcpu);
+		if (vcpu->arch.power_off)
+			vcpu_sleep(vcpu);
 
 		/*
 		 * Disarming the background timer must be done in a
@@ -780,12 +780,12 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	vcpu_reset_hcr(vcpu);
 
 	/*
-	 * Handle the "start in power-off" case by marking the VCPU as paused.
+	 * Handle the "start in power-off" case.
 	 */
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
-		vcpu->arch.pause = true;
+		vcpu->arch.power_off = true;
 	else
-		vcpu->arch.pause = false;
+		vcpu->arch.power_off = false;
 
 	return 0;
 }
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index ad6f642..0b55696 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -63,7 +63,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 
 static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.pause = true;
+	vcpu->arch.power_off = true;
 }
 
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
@@ -87,7 +87,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
-	if (!vcpu->arch.pause) {
+	if (!vcpu->arch.power_off) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
@@ -115,7 +115,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 * the general puspose registers are undefined upon CPU_ON.
 	 */
 	*vcpu_reg(vcpu, 0) = context_id;
-	vcpu->arch.pause = false;
+	vcpu->arch.power_off = false;
 	smp_mb();		/* Make sure the above is visible */
 
 	wq = kvm_arch_vcpu_wq(vcpu);
@@ -153,7 +153,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
 		if ((mpidr & target_affinity_mask) == target_affinity) {
 			matching_cpus++;
-			if (!tmp->arch.pause)
+			if (!tmp->arch.power_off)
 				return PSCI_0_2_AFFINITY_LEVEL_ON;
 		}
 	}
@@ -179,7 +179,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
 	 * re-initialized.
 	 */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
-		tmp->arch.pause = true;
+		tmp->arch.power_off = true;
 		kvm_vcpu_kick(tmp);
 	}
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ed03968..4b4157b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -149,8 +149,8 @@ struct kvm_vcpu_arch {
 		u32	mdscr_el1;
 	} guest_debug_preserved;
 
-	/* Don't run the guest */
-	bool pause;
+	/* vcpu power-off state */
+	bool power_off;
 
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
-- 
2.1.2.330.g565301e.dirty
