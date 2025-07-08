Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C622E03E0
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995561; cv=none; b=XQj9x+LhAFgPOKhS9PnsD2rGgP1uftLduSBP8oAJe2jlvhGvWlSWsqjDY9teXOEP3FCUvLl1NUFBxFUtZF9tiG+dRybS+gvlUMExcb83VNf7cqYWTtTYsnmbz9cIguyBQBNg2oWfdNHnSF9ZnZPnbzbh3bgJBb4wVq8ziN6o4bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995561; c=relaxed/simple;
	bh=YvVMpkKBRDcuGSwctE84+bRRuweBExwY1Uc1MNMp+GI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TRj0Ud36b4aRjN6jhnwxHuxl7rJWBVgGUBSq3KcjPejLtRGQ3BzNSHJXo+lgoHJXS8Fe+5FuSkptTuXWBQKBGsbRfaaEpnti6FpHEz/JhO7utdof8hLmMVPKQS7hIyNY7u1qGqoUkL63q+7DgDQZqoXER19y/uR41BpnG9n2+G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZSS0JaCE; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZSS0JaCE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvAuUt1OR0/CZQuLAWpSYwCSofxy6wxCXO/bPyUlHnY=;
	b=ZSS0JaCERUhoXloBOqMcsLiqpceDPmVwMWmQxyRTp9y1jsoua9WL7ZaF9Xpm+IeUS9j9Gh
	bbDpaEW13DRIvzlG2Hc366h0DDq81qyBsG3005wjz0+vnj45aEtm92g35OcQNqyPxl5KUa
	k3OlnkoZWMsPISKR7muo0ZGiUeous6I=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 08/27] KVM: arm64: nv: Use guest hypervisor's vSError state
Date: Tue,  8 Jul 2025 10:25:13 -0700
Message-Id: <20250708172532.1699409-9-oliver.upton@linux.dev>
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

When HCR_EL2.AMO is set, physical SErrors are routed to EL2 and virtual
SError injection is enabled for EL1. Conceptually treating
host-initiated SErrors as 'physical', this means we can delegate control
of the vSError injection context to the guest hypervisor when nesting &&
AMO is set.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h       |  5 +++
 arch/arm64/include/asm/kvm_host.h          |  3 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 45 +++++++++++++++++++---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 31 +++++++++++++--
 4 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index daa0410aaebf..1ff52e66514c 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -257,6 +257,11 @@ static inline bool is_nested_ctxt(struct kvm_vcpu *vcpu)
 	return vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu);
 }
 
+static inline bool vserror_state_is_nested(struct kvm_vcpu *vcpu)
+{
+	return is_nested_ctxt(vcpu) && vcpu_el2_amo_is_set(vcpu);
+}
+
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 468df4538371..20d63ece3138 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1682,6 +1682,9 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
+#define kvm_has_ras(k)					\
+	(kvm_has_feat((k), ID_AA64PFR0_EL1, RAS, IMP))
+
 static inline bool kvm_arch_has_irq_bypass(void)
 {
 	return true;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 8a854ab5f705..84ec4e100fbb 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -476,21 +476,56 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
 
 	write_sysreg_hcr(hcr);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
-		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE)) {
+		u64 vsesr;
+
+		/*
+		 * When HCR_EL2.AMO is set, physical SErrors are taken to EL2
+		 * and vSError injection is enabled for EL1. Conveniently, for
+		 * NV this means that it is never the case where a 'physical'
+		 * SError (injected by KVM or userspace) and vSError are
+		 * deliverable to the same context.
+		 *
+		 * As such, we can trivially select between the host or guest's
+		 * VSESR_EL2. Except for the case that FEAT_RAS hasn't been
+		 * exposed to the guest, where ESR propagation in hardware
+		 * occurs unconditionally.
+		 *
+		 * Paper over the architectural wart and use an IMPLEMENTATION
+		 * DEFINED ESR value in case FEAT_RAS is hidden from the guest.
+		 */
+		if (!vserror_state_is_nested(vcpu))
+			vsesr = vcpu->arch.vsesr_el2;
+		else if (kvm_has_ras(kern_hyp_va(vcpu->kvm)))
+			vsesr = __vcpu_sys_reg(vcpu, VSESR_EL2);
+		else
+			vsesr = ESR_ELx_ISV;
+
+		write_sysreg_s(vsesr, SYS_VSESR_EL2);
+	}
 }
 
 static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 {
+	u64 *hcr;
+
+	if (vserror_state_is_nested(vcpu))
+		hcr = __ctxt_sys_reg(&vcpu->arch.ctxt, HCR_EL2);
+	else
+		hcr = &vcpu->arch.hcr_el2;
+
 	/*
 	 * If we pended a virtual abort, preserve it until it gets
 	 * cleared. See D1.14.3 (Virtual Interrupts) for details, but
 	 * the crucial bit is "On taking a vSError interrupt,
 	 * HCR_EL2.VSE is cleared to 0."
+	 *
+	 * Additionally, when in a nested context we need to propagate the
+	 * updated state to the guest hypervisor's HCR_EL2.
 	 */
-	if (vcpu->arch.hcr_el2 & HCR_VSE) {
-		vcpu->arch.hcr_el2 &= ~HCR_VSE;
-		vcpu->arch.hcr_el2 |= read_sysreg(hcr_el2) & HCR_VSE;
+	if (*hcr & HCR_VSE) {
+		*hcr &= ~HCR_VSE;
+		*hcr |= read_sysreg(hcr_el2) & HCR_VSE;
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 4d0dbea4c56f..fd9e3ea84d9f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -109,6 +109,17 @@ static inline bool ctxt_has_s1poe(struct kvm_cpu_context *ctxt)
 	return kvm_has_s1poe(kern_hyp_va(vcpu->kvm));
 }
 
+static inline bool ctxt_has_ras(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+		return false;
+
+	vcpu = ctxt_to_vcpu(ctxt);
+	return kvm_has_ras(kern_hyp_va(vcpu->kvm));
+}
+
 static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
@@ -159,8 +170,13 @@ static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 	if (!has_vhe() && ctxt->__hyp_running_vcpu)
 		ctxt->regs.pstate	= read_sysreg_el2(SYS_SPSR);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+	if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+		return;
+
+	if (!vserror_state_is_nested(ctxt_to_vcpu(ctxt)))
 		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
+	else if (ctxt_has_ras(ctxt))
+		ctxt_sys_reg(ctxt, VDISR_EL2) = read_sysreg_s(SYS_VDISR_EL2);
 }
 
 static inline void __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
@@ -293,8 +309,17 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 	write_sysreg_el2(ctxt->regs.pc,			SYS_ELR);
 	write_sysreg_el2(pstate,			SYS_SPSR);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
-		write_sysreg_s(ctxt_sys_reg(ctxt, DISR_EL1), SYS_VDISR_EL2);
+	if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+		return;
+
+	if (!vserror_state_is_nested(ctxt_to_vcpu(ctxt)))
+		vdisr = ctxt_sys_reg(ctxt, DISR_EL1);
+	else if (ctxt_has_ras(ctxt))
+		vdisr = ctxt_sys_reg(ctxt, VDISR_EL2);
+	else
+		vdisr = 0;
+
+	write_sysreg_s(vdisr, SYS_VDISR_EL2);
 }
 
 static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
-- 
2.39.5

