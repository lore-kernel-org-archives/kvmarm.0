Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786C52E6122
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995556; cv=none; b=G6pIPLGkFmGxJOzIIzlyEUvy24Z/flliCBdptTTlJYeUvx0endaZeHM0SwYmXXVlMM+X0QZ4tvzEf7Xk2T4NEfYs7icxB3OCXCVzyoeeWzjX7s4WBlNDmAOznSL3ax0bWlw3QC+1E8xQWrCYbFpsXtyh+VByP5fmUE/sima2Ehk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995556; c=relaxed/simple;
	bh=QjOoz0UJXSbMu5ltMbcyr+oUwnAiTiA7BKKXU+FEZlc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C343M/5OwMjwTRjVJdmYEa5cx/miaB6w8Qm/gZDg8yi4Q0q4hpgLUL+Bf+oZVOCSZOm71Mu2wcjtRBCmOhmmYHmhLrfe4yL2nHCJDo2fb65ofvm/virnBwKxq62ouyEz2n3vLkkSCKgDc1fGXbH3xKIRShjLNq7dsJW4O2TlxwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WP3HU5lX; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WP3HU5lX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gdDQYfiJqYW1D5HHnclNQ0dBCugfA72fNzeA3LC/smw=;
	b=WP3HU5lXk0ziBXTW8Od5rPQjR9ncsMs9w/Qb6tuOYHMEpkUem0sZ93/ZwctfiLI2ORUdD0
	IysbmHFt27Nxud6aXu74JMfpZrYZkOFuEYNFzyBQBBK2eHunAJh7xXtg1cNB68Q8Zn8gGP
	sG5+WnP4O4O4dRBgkwcF7X4nDLE8yx8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 05/27] KVM: arm64: nv: Respect exception routing rules for SEAs
Date: Tue,  8 Jul 2025 10:25:10 -0700
Message-Id: <20250708172532.1699409-6-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Synchronous external aborts are taken to EL2 if ELIsInHost() or
HCR_EL2.TEA=1. Rework the SEA injection plumbing to respect the imposed
routing of the guest hypervisor and opportunistically rephrase things to
make their function a bit more obvious.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h | 14 +++++++--
 arch/arm64/kvm/emulate-nested.c      | 10 +++++++
 arch/arm64/kvm/guest.c               |  5 ++--
 arch/arm64/kvm/inject_fault.c        | 45 +++++++++++-----------------
 arch/arm64/kvm/mmio.c                |  6 ++--
 arch/arm64/kvm/mmu.c                 | 15 +++-------
 6 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 8ba991b4bcfd..3a27ed4de9ac 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -46,15 +46,25 @@ void kvm_skip_instr32(struct kvm_vcpu *vcpu);
 
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_vabt(struct kvm_vcpu *vcpu);
-void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
-void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
+int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
 
+static inline int kvm_inject_sea_dabt(struct kvm_vcpu *vcpu, u64 addr)
+{
+	return kvm_inject_sea(vcpu, false, addr);
+}
+
+static inline int kvm_inject_sea_iabt(struct kvm_vcpu *vcpu, u64 addr)
+{
+	return kvm_inject_sea(vcpu, true, addr);
+}
+
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
 int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
 int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
+int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
 
 static inline void kvm_inject_nested_sve_trap(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 1de4a9001d9d..65a2471c5638 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2811,3 +2811,13 @@ int kvm_inject_nested_irq(struct kvm_vcpu *vcpu)
 	/* esr_el2 value doesn't matter for exits due to irqs. */
 	return kvm_inject_nested(vcpu, 0, except_type_irq);
 }
+
+int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
+{
+	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK,
+			     iabt ? ESR_ELx_EC_IABT_LOW : ESR_ELx_EC_DABT_LOW);
+	esr |= ESR_ELx_FSC_EXTABT | ESR_ELx_IL;
+
+	vcpu_write_sys_reg(vcpu, FAR_EL2, addr);
+	return kvm_inject_nested_sync(vcpu, esr);
+}
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2196979a24a3..b4d2a1deec23 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -839,6 +839,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	bool serror_pending = events->exception.serror_pending;
 	bool has_esr = events->exception.serror_has_esr;
 	bool ext_dabt_pending = events->exception.ext_dabt_pending;
+	int ret = 0;
 
 	if (serror_pending && has_esr) {
 		if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
@@ -853,9 +854,9 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	}
 
 	if (ext_dabt_pending)
-		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+		ret = kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 
-	return 0;
+	return ret;
 }
 
 u32 __attribute_const__ kvm_target_cpu(void)
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a640e839848e..d9fa4046b602 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -155,36 +155,28 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
 	vcpu_write_sys_reg(vcpu, far, FAR_EL1);
 }
 
-/**
- * kvm_inject_dabt - inject a data abort into the guest
- * @vcpu: The VCPU to receive the data abort
- * @addr: The address to report in the DFAR
- *
- * It is assumed that this code is called from the VCPU thread and that the
- * VCPU therefore is not currently executing guest code.
- */
-void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
+static void __kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 {
 	if (vcpu_el1_is_32bit(vcpu))
-		inject_abt32(vcpu, false, addr);
+		inject_abt32(vcpu, iabt, addr);
 	else
-		inject_abt64(vcpu, false, addr);
+		inject_abt64(vcpu, iabt, addr);
 }
 
-/**
- * kvm_inject_pabt - inject a prefetch abort into the guest
- * @vcpu: The VCPU to receive the prefetch abort
- * @addr: The address to report in the DFAR
- *
- * It is assumed that this code is called from the VCPU thread and that the
- * VCPU therefore is not currently executing guest code.
- */
-void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
+static bool kvm_sea_target_is_el2(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_el1_is_32bit(vcpu))
-		inject_abt32(vcpu, true, addr);
-	else
-		inject_abt64(vcpu, true, addr);
+	return __vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_TGE | HCR_TEA);
+}
+
+int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
+{
+	lockdep_assert_held(&vcpu->mutex);
+
+	if (is_nested_ctxt(vcpu) && kvm_sea_target_is_el2(vcpu))
+		return kvm_inject_nested_sea(vcpu, iabt, addr);
+
+	__kvm_inject_sea(vcpu, iabt, addr);
+	return 1;
 }
 
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
@@ -194,10 +186,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
 	addr  = kvm_vcpu_get_fault_ipa(vcpu);
 	addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
 
-	if (kvm_vcpu_trap_is_iabt(vcpu))
-		kvm_inject_pabt(vcpu, addr);
-	else
-		kvm_inject_dabt(vcpu, addr);
+	__kvm_inject_sea(vcpu, kvm_vcpu_trap_is_iabt(vcpu), addr);
 
 	/*
 	 * If AArch64 or LPAE, set FSC to 0 to indicate an Address
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index ab365e839874..573a6ade2f4e 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -169,10 +169,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
 				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
-		if (vcpu_is_protected(vcpu)) {
-			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
-			return 1;
-		}
+		if (vcpu_is_protected(vcpu))
+			return kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 
 		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
 			     &vcpu->kvm->arch.flags)) {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2942ec92c5a4..f05d70dd6d51 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1836,11 +1836,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
 			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
 
-			if (is_iabt)
-				kvm_inject_pabt(vcpu, fault_ipa);
-			else
-				kvm_inject_dabt(vcpu, fault_ipa);
-			return 1;
+			return kvm_inject_sea(vcpu, is_iabt, fault_ipa);
 		}
 	}
 
@@ -1912,8 +1908,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		}
 
 		if (kvm_vcpu_abt_iss1tw(vcpu)) {
-			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
-			ret = 1;
+			ret = kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 			goto out_unlock;
 		}
 
@@ -1958,10 +1953,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	if (ret == 0)
 		ret = 1;
 out:
-	if (ret == -ENOEXEC) {
-		kvm_inject_pabt(vcpu, kvm_vcpu_get_hfar(vcpu));
-		ret = 1;
-	}
+	if (ret == -ENOEXEC)
+		ret = kvm_inject_sea_iabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 out_unlock:
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	return ret;
-- 
2.39.5

