From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 4/5] KVM: arm/arm64: Implement PSCI ON_PENDING when turning on
 VCPUs
Date: Fri, 25 Jan 2019 10:46:55 +0100
Message-ID: <20190125094656.5026-5-christoffer.dall@arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D674B4A3E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 04:47:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AdGmidwfZh5G for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 04:47:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4DF34A3F0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 04:47:10 -0500 (EST)
In-Reply-To: <20190125094656.5026-1-christoffer.dall@arm.com>
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
Cc: kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We are currently not implementing the PSCI spec completely, as we do not
take handle the situation where two VCPUs are attempting to turn on a
third VCPU at the same time.  The PSCI implementation should make sure
that only one requesting VCPU wins the race and that the other receives
PSCI_RET_ON_PENDING.

Implement this by changing the VCPU power state to a tristate enum and
ensure only a single VCPU can turn on another VCPU at a given time using
a cmpxchg operation.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 10 ++++++++--
 arch/arm64/include/asm/kvm_host.h | 10 ++++++++--
 virt/kvm/arm/arm.c                | 24 +++++++++++++++---------
 virt/kvm/arm/psci.c               | 21 ++++++++++++++-------
 4 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index b1cfae222441..4dc47fea1ac8 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -157,6 +157,12 @@ struct vcpu_reset_state {
 	bool		reset;
 };
 
+enum vcpu_power_state {
+	KVM_ARM_VCPU_OFF,
+	KVM_ARM_VCPU_ON_PENDING,
+	KVM_ARM_VCPU_ON,
+};
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
@@ -184,8 +190,8 @@ struct kvm_vcpu_arch {
 	 * here.
 	 */
 
-	/* vcpu power-off state */
-	bool power_off;
+	/* vcpu power state */
+	enum vcpu_power_state power_state;
 
 	 /* Don't run the guest (internal implementation need) */
 	bool pause;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d43b13421987..0647a409657b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -218,6 +218,12 @@ struct vcpu_reset_state {
 	bool		reset;
 };
 
+enum vcpu_power_state {
+	KVM_ARM_VCPU_OFF,
+	KVM_ARM_VCPU_ON_PENDING,
+	KVM_ARM_VCPU_ON,
+};
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
@@ -285,8 +291,8 @@ struct kvm_vcpu_arch {
 		u32	mdscr_el1;
 	} guest_debug_preserved;
 
-	/* vcpu power-off state */
-	bool power_off;
+	/* vcpu power state */
+	enum vcpu_power_state power_state;
 
 	/* Don't run the guest (internal implementation need) */
 	bool pause;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 785076176814..1e3195155860 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -411,7 +411,7 @@ static void vcpu_power_off(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	if (vcpu->arch.power_off)
+	if (vcpu->arch.power_state != KVM_ARM_VCPU_ON)
 		mp_state->mp_state = KVM_MP_STATE_STOPPED;
 	else
 		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
@@ -426,7 +426,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
-		vcpu->arch.power_off = false;
+		vcpu->arch.power_state = KVM_ARM_VCPU_ON;
 		break;
 	case KVM_MP_STATE_STOPPED:
 		vcpu_power_off(vcpu);
@@ -448,8 +448,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
-	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !v->arch.power_off && !v->arch.pause);
+	return (irq_lines || kvm_vgic_vcpu_pending_irq(v)) &&
+		v->arch.power_state == KVM_ARM_VCPU_ON &&
+		!v->arch.pause;
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
@@ -614,14 +615,19 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	}
 }
 
+static bool vcpu_sleeping(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.power_state != KVM_ARM_VCPU_ON ||
+		vcpu->arch.pause;
+}
+
 static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 {
 	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
 
-	swait_event_interruptible_exclusive(*wq, ((!vcpu->arch.power_off) &&
-				       (!vcpu->arch.pause)));
+	swait_event_interruptible_exclusive(*wq, !vcpu_sleeping(vcpu));
 
-	if (vcpu->arch.power_off || vcpu->arch.pause) {
+	if (vcpu_sleeping(vcpu)) {
 		/* Awaken to handle a signal, request we sleep again later. */
 		kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	}
@@ -646,7 +652,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			vcpu_req_sleep(vcpu);
 
 		if (kvm_check_request(KVM_REQ_VCPU_OFF, vcpu)) {
-			vcpu->arch.power_off = true;
+			vcpu->arch.power_state = KVM_ARM_VCPU_OFF;
 			vcpu_req_sleep(vcpu);
 		}
 
@@ -1016,7 +1022,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
 		vcpu_power_off(vcpu);
 	else
-		vcpu->arch.power_off = false;
+		vcpu->arch.power_state = KVM_ARM_VCPU_ON;
 
 	return 0;
 }
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 20255319e193..5c2d9eeb810c 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -106,6 +106,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	struct kvm *kvm = source_vcpu->kvm;
 	struct kvm_vcpu *vcpu = NULL;
 	unsigned long cpu_id;
+	enum vcpu_power_state old_power_state;
 
 	cpu_id = smccc_get_arg1(source_vcpu) & MPIDR_HWID_BITMASK;
 	if (vcpu_mode_is_32bit(source_vcpu))
@@ -119,12 +120,18 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
-	if (!vcpu->arch.power_off) {
-		if (kvm_psci_version(source_vcpu, kvm) != KVM_ARM_PSCI_0_1)
-			return PSCI_RET_ALREADY_ON;
-		else
+	old_power_state = cmpxchg(&vcpu->arch.power_state,
+				  KVM_ARM_VCPU_OFF,
+				  KVM_ARM_VCPU_ON_PENDING);
+
+	if (old_power_state != KVM_ARM_VCPU_OFF &&
+	    kvm_psci_version(source_vcpu, kvm) == KVM_ARM_PSCI_0_1)
 			return PSCI_RET_INVALID_PARAMS;
-	}
+
+	if (old_power_state == KVM_ARM_VCPU_ON_PENDING)
+			return PSCI_RET_ON_PENDING;
+	else if (old_power_state == KVM_ARM_VCPU_ON)
+			return PSCI_RET_ALREADY_ON;
 
 	reset_state = &vcpu->arch.reset_state;
 
@@ -148,7 +155,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	smp_wmb();
 
-	vcpu->arch.power_off = false;
+	vcpu->arch.power_state = KVM_ARM_VCPU_ON;
 	kvm_vcpu_wake_up(vcpu);
 
 	return PSCI_RET_SUCCESS;
@@ -183,7 +190,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
 		if ((mpidr & target_affinity_mask) == target_affinity) {
 			matching_cpus++;
-			if (!tmp->arch.power_off)
+			if (tmp->arch.power_state == KVM_ARM_VCPU_ON)
 				return PSCI_0_2_AFFINITY_LEVEL_ON;
 		}
 	}
-- 
2.18.0
