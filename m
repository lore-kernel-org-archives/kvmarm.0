Received: from mta0.migadu.com (out-153.mta0.migadu.com [91.218.175.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B6B47DD7B
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863162; cv=none; b=G5H/6D/lRHByRuXk8j8E5FmCyj08MSqqOXJLPlwzONS+J6XM2IlMhB9px2OBt2mDQAn1/SlWavvCRiWiNVlRyLR3ljOgfsadhvkK9K9vkS9iezwYlM0YwjGR16KWWxizJWQNhwCtVcSaRvuFs/hzDYFp6QUh89GF6UfBqVB7o6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863162; c=relaxed/simple;
	bh=8PgbjM3RudzbwOkoe5Gt2RQoxYVPLiuGki2F4kB8jq4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pew6p2zhG3m+8xowLXNgT2Ky03L87SSxmAImdvxjxPJyKMGhRxSXBl4l9chf+6uPk1aBGIJwwcFutqRT2jDglAhOohfWVQsr08d+DQlQ9/AG2O3/rxbJQv+XZmXxRTTAZ072mPrDE8KcHmyOB9vWNNXwDhLu9PCqCQSQfMq2aTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QC9CjX0a; arc=none smtp.client-ip=91.218.175.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QC9CjX0a"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=8PgbjM3RudzbwOkoe5Gt2RQoxYVPLiuGki2F4kB8jq4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790863158; v=1; x=1791467958;
 b=QC9CjX0ati5vaQheM/gwz2+H83RSittLuCB2DXPdXAaKPzFDdK3nr/RatpZUKVYd6Mf2DV+7
 upNXka0MtzmgAT9LnbGU5IxUMh0+zLjn7OPSg0OuBRvSWlCCRde4cVls932Q5tlyn9Offm8m0TB
 9zYzopToVvrQHGoT653/AEh0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 43ef2dae9eb95ac3;
	Thu, 01 Oct 2026 13:59:18 +0000
X-Mizu-Trace-ID: 43ef2dae9eb95ac3
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v4 16/18] KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off
Date: Thu,  1 Oct 2026 14:57:09 +0100
Message-Id: <20261001135711.1640520-17-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001135711.1640520-1-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A protected vCPU's power state belongs to EL2, which changes it only
on the guest's own PSCI calls. KVM_SET_MP_STATE(RUNNABLE) on a vCPU
EL2 holds powered off changes the host's copy alone, and the guest's
next CPU_ON of that vCPU then fails: mp_state is no longer STOPPED, so
the host returns ALREADY_ON, and the guest's retry fails the same way
until the VMM stops the vCPU again. SUSPENDED has the same effect.

Record a vCPU EL2 holds powered off as KVM_MP_STATE_UNINITIALIZED, an
encoding arm64 didn't use: the guest's CPU_OFF writes it, as does hyp
vCPU creation for a vCPU that starts STOPPED, and only the guest's
CPU_ON writes RUNNABLE over it. RUNNABLE and SUSPENDED from the VMM
return -EPERM on it, the VMM can't write the value itself, and
KVM_ARM_VCPU_INIT, which would write STOPPED or RUNNABLE over it, is
rejected once the vCPU has run.

The VMM can still pause and resume a vCPU EL2 has powered on. Neither
STOPPED nor kvm_prepare_system_event() overwrites the value: a vCPU at
it is already off, and a STOPPED in its place would turn the guest's
next CPU_ON into ALREADY_ON, after a SYSTEM_RESET exit the VMM runs on
from. kvm_arm_vcpu_stopped() covers it, so the run loop sleeps the
vCPU as before.

The guest's CPU_ON is gated on the value rather than on STOPPED. A
STOPPED written between the target's CPU_OFF exit and the host's
power-off of it, which kvm_prepare_system_event() can do from another
vCPU's SYSTEM_OFF or SYSTEM_RESET, would otherwise let the CPU_ON
through, and the power-off would then record the target powered off
while EL2 holds it ON_PENDING, with no way back before VM teardown.
Gated on the value, that CPU_ON returns ALREADY_ON and the retry
succeeds once the power-off has run.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              | 35 +++++++++++++++++++++++++------
 arch/arm64/kvm/pkvm.c             | 21 +++++++++++++++----
 arch/arm64/kvm/psci.c             | 11 ++++++++--
 4 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 37d0721d39a45..e99b706c879cf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1564,6 +1564,7 @@ static inline void kvm_hyp_reserve(void) { }
 
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
+bool kvm_pkvm_vcpu_is_powered_off(struct kvm_vcpu *vcpu);
 
 static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
 {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14fe4e7275796..a89087c83e27f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -770,23 +770,28 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
-static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
+static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu, u32 mp_state)
 {
-	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
+	WRITE_ONCE(vcpu->arch.mp_state.mp_state, mp_state);
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
+/* The guest's own CPU_OFF: EL2 has already powered the vCPU off. */
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
+	u32 mp_state = vcpu_is_protected(vcpu) ? KVM_MP_STATE_UNINITIALIZED : KVM_MP_STATE_STOPPED;
+
 	spin_lock(&vcpu->arch.mp_state_lock);
-	__kvm_arm_vcpu_power_off(vcpu);
+	__kvm_arm_vcpu_power_off(vcpu, mp_state);
 	spin_unlock(&vcpu->arch.mp_state_lock);
 }
 
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
 {
-	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_STOPPED;
+	u32 mp_state = READ_ONCE(vcpu->arch.mp_state.mp_state);
+
+	return mp_state == KVM_MP_STATE_STOPPED || mp_state == KVM_MP_STATE_UNINITIALIZED;
 }
 
 static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
@@ -801,6 +806,12 @@ static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
 	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_SUSPENDED;
 }
 
+/* Only the guest's CPU_ON may start a vCPU EL2 holds powered off. */
+bool kvm_pkvm_vcpu_is_powered_off(struct kvm_vcpu *vcpu)
+{
+	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_UNINITIALIZED;
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
@@ -818,12 +829,24 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
+		if (kvm_pkvm_vcpu_is_powered_off(vcpu)) {
+			ret = -EPERM;
+			break;
+		}
+
 		WRITE_ONCE(vcpu->arch.mp_state, *mp_state);
 		break;
 	case KVM_MP_STATE_STOPPED:
-		__kvm_arm_vcpu_power_off(vcpu);
+		/* Keep EL2's off record: STOPPED over it would let RUNNABLE through. */
+		if (!kvm_pkvm_vcpu_is_powered_off(vcpu))
+			__kvm_arm_vcpu_power_off(vcpu, KVM_MP_STATE_STOPPED);
 		break;
 	case KVM_MP_STATE_SUSPENDED:
+		if (kvm_pkvm_vcpu_is_powered_off(vcpu)) {
+			ret = -EPERM;
+			break;
+		}
+
 		kvm_arm_vcpu_suspend(vcpu);
 		break;
 	default:
@@ -1788,7 +1811,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	spin_lock(&vcpu->arch.mp_state_lock);
 
 	if (power_off)
-		__kvm_arm_vcpu_power_off(vcpu);
+		__kvm_arm_vcpu_power_off(vcpu, KVM_MP_STATE_STOPPED);
 	else
 		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8e4c6e4bec123..99a5d9a913129 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -118,12 +118,25 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 		return -ENOMEM;
 
 	ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, vcpu, hyp_vcpu);
-	if (!ret)
-		vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);
-	else
+	if (ret) {
 		free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
+		return ret;
+	}
 
-	return ret;
+	/*
+	 * Mirror EL2's seeding of power_state from mp_state. The hyp vCPU is
+	 * published, so take mp_state_lock against kvm_psci_vcpu_on().
+	 */
+	if (vcpu_is_protected(vcpu)) {
+		spin_lock(&vcpu->arch.mp_state_lock);
+		if (kvm_arm_vcpu_stopped(vcpu))
+			WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_UNINITIALIZED);
+		spin_unlock(&vcpu->arch.mp_state_lock);
+	}
+
+	vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);
+
+	return 0;
 }
 
 /*
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index e3db84400d1f8..b01f8d44033f1 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -63,7 +63,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 		return PSCI_RET_INVALID_PARAMS;
 
 	spin_lock(&vcpu->arch.mp_state_lock);
-	if (!kvm_arm_vcpu_stopped(vcpu)) {
+	/*
+	 * A protected vCPU is off once the host has acted on EL2's CPU_OFF.
+	 * STOPPED before that is the VMM's pause.
+	 */
+	if (!kvm_arm_vcpu_stopped(vcpu) ||
+	    (vcpu_is_protected(vcpu) && !kvm_pkvm_vcpu_is_powered_off(vcpu))) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			ret = PSCI_RET_ALREADY_ON;
 		else
@@ -161,7 +166,9 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 	 */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
 		spin_lock(&tmp->arch.mp_state_lock);
-		WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
+		/* Keep EL2's off record for the guest's next CPU_ON. */
+		if (!kvm_pkvm_vcpu_is_powered_off(tmp))
+			WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
 		spin_unlock(&tmp->arch.mp_state_lock);
 	}
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
-- 
2.39.5

