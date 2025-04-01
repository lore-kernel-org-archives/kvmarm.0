Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B93A214A8B
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 22:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743547375; cv=none; b=dad5yqTYrIgPVAQnpC3ivxZ7Bjeik7nAWa8yfGjkuPyWjrTz+aWvxkq+faSdTmBl3wR2z8954I+XyVO/6pwtAi1hnmASIt+uSU6QUKwgRcD2BTt/57dGGaIXkJ6e90t0qXMuQXkICg3iyKuAiZLhmpCmhn9HaHluriarQOTLSJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743547375; c=relaxed/simple;
	bh=SS/bd4Co+OfS4RRo4kMDXvM1QHcg5hipdAn3MhNgawU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HO78r6UcfeYjAVXn/7z+zh32TS38wPUgR6PEq9HaJDsCOoShYgCBz4H5e6N5kZXs8fK9yku86O1qOFhE47o0/KLCMxDRaPEto4CXGuwXd1Eoyohz2SJD4fZoUYrigHRGm/AHhystdbvM2QVVDaNAE8/1CuuThTukLgTWTbfzBPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AuVrROFI; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AuVrROFI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743547369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3/7fn2LVj5WBXbBxB19rIfv1mYN9ZDGZFGs8e8/J1vU=;
	b=AuVrROFId5gfrgtN7EwQEBAO7+FP45RRwVHcnqZ/1BewTAEHr1dODlrJZ9MdWiG+dk5CL1
	6QemQD2Aw+FdZMCH1x/BT5J1YdW2IHCzrN0JBhSIRB2qys3IlWJtlcvihPBJDFVzTsuch8
	FxJnT/KY2HDJE+1UdZDIrpODbhRqvBA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: Don't translate FAR if invalid/unsafe
Date: Tue,  1 Apr 2025 15:42:34 -0700
Message-Id: <20250401224234.2906739-4-oliver.upton@linux.dev>
In-Reply-To: <20250401224234.2906739-1-oliver.upton@linux.dev>
References: <20250401224234.2906739-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Don't re-walk the page tables if an SEA occurred during the faulting
page table walk to avoid taking a fatal exception in the hyp.
Additionally, check that FAR_EL2 is valid for SEAs not taken on PTW
as the architecture doesn't guarantee it contains the fault VA.

Finally, fix up the rest of the abort path by checking for SEAs early
and bugging the VM if we get further along with an UNKNOWN fault IPA.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/esr.h           | 22 ++++++++++++++++++
 arch/arm64/include/asm/kvm_emulate.h   |  7 +++++-
 arch/arm64/include/asm/kvm_ras.h       |  2 +-
 arch/arm64/kvm/hyp/include/hyp/fault.h | 26 ++++++++++++++++-----
 arch/arm64/kvm/mmu.c                   | 31 ++++++++++++++++----------
 5 files changed, 69 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 7b096ed87360..4b874ad95f2e 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -465,6 +465,28 @@ static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
 	       (esr == ESR_ELx_FSC_ACCESS_L(0));
 }
 
+static inline bool esr_fsc_is_sea_ttw(unsigned long esr)
+{
+	esr = esr & ESR_ELx_FSC;
+
+	return (esr == ESR_ELx_FSC_SEA_TTW(3)) ||
+	       (esr == ESR_ELx_FSC_SEA_TTW(2)) ||
+	       (esr == ESR_ELx_FSC_SEA_TTW(1)) ||
+	       (esr == ESR_ELx_FSC_SEA_TTW(0)) ||
+	       (esr == ESR_ELx_FSC_SEA_TTW(-1));
+}
+
+static inline bool esr_fsc_is_secc_ttw(unsigned long esr)
+{
+	esr = esr & ESR_ELx_FSC;
+
+	return (esr == ESR_ELx_FSC_SECC_TTW(3)) ||
+	       (esr == ESR_ELx_FSC_SECC_TTW(2)) ||
+	       (esr == ESR_ELx_FSC_SECC_TTW(1)) ||
+	       (esr == ESR_ELx_FSC_SECC_TTW(0)) ||
+	       (esr == ESR_ELx_FSC_SECC_TTW(-1));
+}
+
 /* Indicate whether ESR.EC==0x1A is for an ERETAx instruction */
 static inline bool esr_iss_is_eretax(unsigned long esr)
 {
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5d8c0832acbe..775e200a9be4 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -305,7 +305,12 @@ static __always_inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vc
 
 static __always_inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu *vcpu)
 {
-	return ((phys_addr_t)vcpu->arch.fault.hpfar_el2 & HPFAR_EL2_FIPA) << 8;
+	u64 hpfar = vcpu->arch.fault.hpfar_el2;
+
+	if (unlikely(!(hpfar & HPFAR_EL2_NS)))
+		return INVALID_GPA;
+
+	return ((phys_addr_t)hpfar & HPFAR_EL2_FIPA) << 8;
 }
 
 static inline u64 kvm_vcpu_get_disr(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/kvm_ras.h
index 87e10d9a635b..9398ade632aa 100644
--- a/arch/arm64/include/asm/kvm_ras.h
+++ b/arch/arm64/include/asm/kvm_ras.h
@@ -14,7 +14,7 @@
  * Was this synchronous external abort a RAS notification?
  * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
  */
-static inline int kvm_handle_guest_sea(phys_addr_t addr, u64 esr)
+static inline int kvm_handle_guest_sea(void)
 {
 	/* apei_claim_sea(NULL) expects to mask interrupts itself */
 	lockdep_assert_irqs_enabled();
diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
index 84d165e17bd0..1ac9b23a382a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/fault.h
+++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
@@ -12,6 +12,16 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+static inline bool __fault_safe_to_translate(u64 esr)
+{
+	u64 fsc = esr & ESR_ELx_FSC;
+
+	if (esr_fsc_is_sea_ttw(esr) || esr_fsc_is_secc_ttw(esr))
+		return false;
+
+	return !(fsc == ESR_ELx_FSC_EXTABT && (esr & ESR_ELx_FnV));
+}
+
 static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 {
 	int ret;
@@ -71,17 +81,23 @@ static inline bool __hpfar_valid(u64 esr)
 
 static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
 {
-	u64 hpfar, far;
+	u64 hpfar;
 
-	far = read_sysreg_el2(SYS_FAR);
+	fault->far_el2		= read_sysreg_el2(SYS_FAR);
+	fault->hpfar_el2	= 0;
 
 	if (__hpfar_valid(esr))
 		hpfar = read_sysreg(hpfar_el2);
-	else if (!__translate_far_to_hpfar(far, &hpfar))
+	else if (unlikely(!__fault_safe_to_translate(esr)))
+		return true;
+	else if (!__translate_far_to_hpfar(fault->far_el2, &hpfar))
 		return false;
 
-	fault->far_el2 = far;
-	fault->hpfar_el2 = hpfar;
+	/*
+	 * Hijack HPFAR_EL2.NS (RES0 in Non-secure) to indicate a valid
+	 * HPFAR value.
+	 */
+	fault->hpfar_el2 = hpfar | HPFAR_EL2_NS;
 	return true;
 }
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2feb6c6b63af..754f2fe0cc67 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1794,9 +1794,28 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int ret, idx;
 
+	/* Synchronous External Abort? */
+	if (kvm_vcpu_abt_issea(vcpu)) {
+		/*
+		 * For RAS the host kernel may handle this abort.
+		 * There is no need to pass the error into the guest.
+		 */
+		if (kvm_handle_guest_sea())
+			kvm_inject_vabt(vcpu);
+
+		return 1;
+	}
+
 	esr = kvm_vcpu_get_esr(vcpu);
 
+	/*
+	 * The fault IPA should be reliable at this point as we're not dealing
+	 * with an SEA.
+	 */
 	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	if (KVM_BUG_ON(ipa == INVALID_GPA, vcpu->kvm))
+		return -EFAULT;
+
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
 	if (esr_fsc_is_translation_fault(esr)) {
@@ -1818,18 +1837,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	/* Synchronous External Abort? */
-	if (kvm_vcpu_abt_issea(vcpu)) {
-		/*
-		 * For RAS the host kernel may handle this abort.
-		 * There is no need to pass the error into the guest.
-		 */
-		if (kvm_handle_guest_sea(fault_ipa, kvm_vcpu_get_esr(vcpu)))
-			kvm_inject_vabt(vcpu);
-
-		return 1;
-	}
-
 	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
 			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
-- 
2.39.5

