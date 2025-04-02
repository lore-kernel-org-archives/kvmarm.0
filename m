Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8A61C860E
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 20:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743625067; cv=none; b=t/K8dBOfT+paNPDjtqVTxKFY69muAquEqG1m4Wz92Yt89iEVM05gdQPONmjfEcCPHAJ4rVzlUBWhEy/ZdO28lVPfwrcMlIqzHEm81P5bt19IQQHNHDG72Se6mHx6nCtCUeWTxX1eok/IphAVhs6QMsIOolM2yUxcGGlg5m4SBrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743625067; c=relaxed/simple;
	bh=YaXIGlIwG8IxThPZEvDeVr0RVeqp2cqhoLU7iN9ypHE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h5MXZnQPg4w11cSatv6nlPNQM/oc+VNbKb/L36MmhPvgLpEN5uwfCNvEqyv1yz/fNRH90ENX6qicSuN5j+DNuxyAnojLjEEWlzkQK2rcK0kzHXZxpz6zepe7dbofjLLIsGgCEf2oTS+ZhNVAWUvP49jbuacw9De8wZjSYPuVnNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eXxXv4yz; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eXxXv4yz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743625063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sh/D7zGeJ7fQVYnITGhjtlpVF5gfeKZoqjsZ+yDtbVE=;
	b=eXxXv4yz9+M76LaPOwYI6ISwKsxh9d4vABs9Ze1nhtRfbI7nxw6HJORMQjm7RDOurirhNa
	3WSX+jCIcvZL/lCweGqR+9sZRTVnmXRX4fFX5Lc/gH6yRkTlkxcgfKbi2TtJ11zavss1MY
	WL8ELj6M5FviLhu9MoMUIMa8A24bHko=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 3/3] KVM: arm64: Don't translate FAR if invalid/unsafe
Date: Wed,  2 Apr 2025 13:17:25 -0700
Message-Id: <20250402201725.2963645-4-oliver.upton@linux.dev>
In-Reply-To: <20250402201725.2963645-1-oliver.upton@linux.dev>
References: <20250402201725.2963645-1-oliver.upton@linux.dev>
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
 arch/arm64/include/asm/kvm_emulate.h   |  3 +++
 arch/arm64/include/asm/kvm_ras.h       |  2 +-
 arch/arm64/kvm/hyp/include/hyp/fault.h | 26 ++++++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c  |  7 ++++++
 arch/arm64/kvm/mmu.c                   | 31 ++++++++++++++++----------
 6 files changed, 73 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 92fb26e90840..e4f77757937e 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -482,6 +482,28 @@ static inline bool esr_fsc_is_addr_sz_fault(unsigned long esr)
 	       (esr == ESR_ELx_FSC_ADDRSZ_L(-1));
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
index 44e3fc6483c8..bd020fc28aa9 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -307,6 +307,9 @@ static __always_inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu
 {
 	u64 hpfar = vcpu->arch.fault.hpfar_el2;
 
+	if (unlikely(!(hpfar & HPFAR_EL2_NS)))
+		return INVALID_GPA;
+
 	return FIELD_GET(HPFAR_EL2_FIPA, hpfar) << 12;
 }
 
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
index 59409685c14f..fc573fc767b0 100644
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
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 5ce2230054d9..2a5284f749b4 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -578,7 +578,14 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 		return;
 	}
 
+
+	/*
+	 * Yikes, we couldn't resolve the fault IPA. This should reinject an
+	 * abort into the host when we figure out how to do that.
+	 */
+	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
+
 	ret = host_stage2_idmap(addr);
 	BUG_ON(ret && ret != -EAGAIN);
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

