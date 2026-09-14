Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800C344238B
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385765; cv=none; b=m++seXu9NADp6mElAkvJdzaHDd87aVk+2f8R6AyGeBRoWQe/P+NJzl/WNHaDfextLZoXUvOtnYcqR3vKb2Ho53slB/CaU9rMVLKMlHIXGhOh++70yOoi7SYJVmzuTvaLrNBKXEG019fyWZP0WddElmm4DwVaWZ3jIHAg9t8DuNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385765; c=relaxed/simple;
	bh=S9VI8acDBXkn+fDiSgMrcfPQmjE15/IabTP7L5uvsm8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E1Z51Zldtv3/gshvUCZn2tEj2KJaEj3GSKQob9FRyBQsrMqCtml0uLSLuHb19wTEaF3atJmy/fWiycEkuNWNY6XYuCfAAiZgt/DURSMzb78Fk4ymGYrdMMmX8cu1Db2n6febyQtaJJcGglxh3+/8WANG85UW+IZbtP4t3zt6qF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tVHypydu; arc=none smtp.client-ip=91.218.175.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tVHypydu"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=S9VI8acDBXkn+fDiSgMrcfPQmjE15/IabTP7L5uvsm8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789385761; v=1; x=1789990561;
 b=tVHypyduh4VNrckobgQmwNJPSPin/b3HExpuWcKblipvbNknljZAaL6Pefg69HgzsR20BK//
 jAInauesNLSRDNf2atyeyRR6ThrL4TnPWtzf1pYVUheDsBpMFHR7/Fs5bJHrqkoyLfcSBIzb7EP
 o0oA7hrr/WYcsDoBVVUiRpkc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c82e9c03e5c472d4;
	Mon, 14 Sep 2026 11:36:01 +0000
X-Mizu-Trace-ID: c82e9c03e5c472d4
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
Subject: [PATCH v3 16/18] KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off
Date: Mon, 14 Sep 2026 12:33:36 +0100
Message-Id: <20260914113338.159227-17-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260914113338.159227-1-fuad.tabba@linux.dev>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
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

Track at the host whether EL2 holds a protected vCPU powered off and
return -EPERM for both writes in that state. STOPPED stays permitted,
so a VMM can pause a vCPU, and RUNNABLE on a vCPU EL2 has powered on,
so it can resume one.

The guest's CPU_ON is gated on the same record rather than on STOPPED.
A VMM that sets STOPPED between the target's CPU_OFF exit and the
host's power-off of it would otherwise let the CPU_ON through, and the
power-off would then record the target powered off while EL2 holds it
ON_PENDING, with no way back before VM teardown. Gated on the record,
that CPU_ON returns ALREADY_ON and the retry succeeds once the
power-off has run.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 19 +++++++++++++++++++
 arch/arm64/kvm/pkvm.c             | 21 +++++++++++++++++----
 arch/arm64/kvm/psci.c             | 10 +++++++++-
 4 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 37d0721d39a45..2e2c051dd8e62 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -922,6 +922,8 @@ struct kvm_vcpu_arch {
 	/* vcpu power state */
 	struct kvm_mp_state mp_state;
 	spinlock_t mp_state_lock;
+	/* EL2 holds the protected vCPU powered off. Under mp_state_lock. */
+	bool pkvm_powered_off;
 
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0362f5f235e02..3892223252643 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -777,9 +777,12 @@ static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
+/* The guest's own CPU_OFF: EL2 has already powered the vCPU off. */
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
 	spin_lock(&vcpu->arch.mp_state_lock);
+	if (vcpu_is_protected(vcpu))
+		vcpu->arch.pkvm_powered_off = true;
 	__kvm_arm_vcpu_power_off(vcpu);
 	spin_unlock(&vcpu->arch.mp_state_lock);
 }
@@ -801,6 +804,12 @@ static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
 	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_SUSPENDED;
 }
 
+/* Only the guest's CPU_ON may start a vCPU EL2 holds powered off. */
+static bool kvm_pkvm_vcpu_is_powered_off(struct kvm_vcpu *vcpu)
+{
+	return vcpu_is_protected(vcpu) && vcpu->arch.pkvm_powered_off;
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
@@ -818,12 +827,22 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 
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
 		__kvm_arm_vcpu_power_off(vcpu);
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
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8e4c6e4bec123..388c89f637b85 100644
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
+			vcpu->arch.pkvm_powered_off = true;
+		spin_unlock(&vcpu->arch.mp_state_lock);
+	}
+
+	vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);
+
+	return 0;
 }
 
 /*
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index e3db84400d1f8..3796fcfd701e9 100644
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
+	    (vcpu_is_protected(vcpu) && !vcpu->arch.pkvm_powered_off)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			ret = PSCI_RET_ALREADY_ON;
 		else
@@ -94,6 +99,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	smp_wmb();
 
+	/* EL2 has committed the protected vCPU to ON_PENDING to get here. */
+	vcpu->arch.pkvm_powered_off = false;
+
 	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
 	kvm_vcpu_wake_up(vcpu);
 
-- 
2.39.5

