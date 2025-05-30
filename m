Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B51288C00
	for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 23:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748646401; cv=none; b=arc59n8Xx9wI2T4wJBMwtH7RbuUkxcj1f6QDq0eMt8097PuBjX/YCcXLYgRFLTaYdmZ6Cy/O7OGTRD3Sb7vR9PCqZ8D/GOKxn6GYKVXmFx4J53xoLfT7jcvfhvBddQwiTTjiAZSV519N+bZUnfb6NZ6ZXmQGiy+u8XyxX8uYxl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748646401; c=relaxed/simple;
	bh=Tbf4yk2mZClpDZXNjEWO2raWAh9leN+bq3YlhcWsgKk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KJchX/3urqPi3Bb2+05WGv/pse64j5h+G+qAGwAU6HQ0GVp4KiTfXDEWVN7DvCnAIDTMdwx72y+T64ik1sUh0GF5eij7AGDdDFpwesbwAx/kE7uVqCfazxlZTk5Pukb+T0LiWjGA7gmtgpdY86DR768aVJCalB5zVS+mZPKw18k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w+JVN8Zn; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w+JVN8Zn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748646396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SGxE8Iy5qr1gBkr45LrhD96GG3xCY4F9r/puSEE0A0Q=;
	b=w+JVN8ZnoS5b/hYACzlp3BTQzTvHETzOnO0SmqW0bpuM0xVL+DBVI5gCF2e+hUxYGDS+Rf
	vb7WPxzReBC4wn/zorwg2kTHlQDYzXqM55y/sxB2rFpenipeegjEZpipiSW8ws9Wgn4MNC
	Tk9FYyXcp0NBQErSE/+xaXShm1OQS+I=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/4] KVM: arm64: nv: Respect exception routing rules for SEAs
Date: Fri, 30 May 2025 16:06:20 -0700
Message-Id: <20250530230623.650888-2-oliver.upton@linux.dev>
In-Reply-To: <20250530230623.650888-1-oliver.upton@linux.dev>
References: <20250530230623.650888-1-oliver.upton@linux.dev>
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

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h | 15 +++++++++--
 arch/arm64/kvm/emulate-nested.c      | 20 ++++++++++++++
 arch/arm64/kvm/guest.c               |  8 ++++--
 arch/arm64/kvm/inject_fault.c        | 40 +++++++++-------------------
 arch/arm64/kvm/mmio.c                |  6 ++---
 arch/arm64/kvm/mmu.c                 | 15 +++--------
 6 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index bd020fc28aa9..e0fa8a5a2530 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -46,15 +46,26 @@ void kvm_skip_instr32(struct kvm_vcpu *vcpu);
 
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_vabt(struct kvm_vcpu *vcpu);
-void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
-void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
+void __kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
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
index 3a384e9660b8..3d2f98fdca2f 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2816,3 +2816,23 @@ int kvm_inject_nested_irq(struct kvm_vcpu *vcpu)
 	/* esr_el2 value doesn't matter for exits due to irqs. */
 	return kvm_inject_nested(vcpu, 0, except_type_irq);
 }
+
+int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
+{
+	u64 esr;
+
+	/*
+	 * The destination EL is in the same translation regime as the origin;
+	 * directly inject the SEA.
+	 */
+	if (is_hyp_ctxt(vcpu) || !(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_TEA)) {
+		__kvm_inject_sea(vcpu, iabt, addr);
+		return 1;
+	}
+
+	esr = FIELD_PREP(ESR_ELx_EC_MASK,
+			 iabt ? ESR_ELx_EC_IABT_LOW : ESR_ELx_EC_DABT_LOW);
+	esr |= ESR_ELx_FSC_EXTABT | ESR_ELx_IL;
+
+	return kvm_inject_s2_fault(vcpu, esr);
+}
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2196979a24a3..dd5cce0006f3 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -839,6 +839,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	bool serror_pending = events->exception.serror_pending;
 	bool has_esr = events->exception.serror_has_esr;
 	bool ext_dabt_pending = events->exception.ext_dabt_pending;
+	int ret;
 
 	if (serror_pending && has_esr) {
 		if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
@@ -852,8 +853,11 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 		kvm_inject_vabt(vcpu);
 	}
 
-	if (ext_dabt_pending)
-		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+	if (ext_dabt_pending) {
+		ret = kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+		if (ret < 0)
+			return ret;
+	}
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a640e839848e..3e61fa0a721b 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -155,36 +155,23 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
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
+void __kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
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
+int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 {
-	if (vcpu_el1_is_32bit(vcpu))
-		inject_abt32(vcpu, true, addr);
-	else
-		inject_abt64(vcpu, true, addr);
+	lockdep_assert_held(&vcpu->mutex);
+
+	if (vcpu_has_nv(vcpu))
+		return kvm_inject_nested_sea(vcpu, iabt, addr);
+
+	__kvm_inject_sea(vcpu, iabt, addr);
+	return 1;
 }
 
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
@@ -194,10 +181,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
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
index e445db2cb4a4..0e0d51d7ab85 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1833,11 +1833,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
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
 
@@ -1909,8 +1905,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		}
 
 		if (kvm_vcpu_abt_iss1tw(vcpu)) {
-			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
-			ret = 1;
+			ret = kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 			goto out_unlock;
 		}
 
@@ -1955,10 +1950,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
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

