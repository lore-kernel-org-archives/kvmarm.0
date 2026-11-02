Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793612395;
	b=LuX0cxg6+VYfrcjUEWHFpdElCm262902Xomo0VbLAiMQ2s1cYg1aFlShxAEDuexWpenj
	 lzBk7u/o64aMsJ0Vhn8kU/Ad5cfOHFNxgDHXQj3Eaf0Th0leGiy0s8+OVyCWC468MVA//
	 dK7IWjEYfXgZs0UFDlor4+wxcWcH1vkQQ2iBS29Iqfb4k5D/HnttlONUe+THrn6OhHB/N
	 bviXFJGXjuRNdEkJZd2+0l8UyADrmsZD/jzswtRT533+8+Pvdi7JM2hLF5VsAPRZ7IETX
	 KaWANUZTnRzQI4l6e2bRKPzeUsUlmHRwZabwolovELjgyw0R6QGCqIh3/gC/d8Kj8TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793612395;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=DhqedRR4az/uxbrOAZjla/ffplx4oLVvfwX9vhPDhZc=;
	b=pvB81tQT3nhZkhJTCKBHtmmm0R9Atn/ljArxKfYDtx1cNBPAhkOKpJcpla02fB+2HV3c
	 Ydk/QcBT5C8njPsvhTguonsiQJv/J4SyCeiwK10WTFuAlMqqsH28TxHyvfLumOqpgMSHK
	 +0Uc0ODF2y++zQwtohz6JX8sIwOy2buyPW4uTlock0h9U7kGkE/b+tuJ4quZ9k+2JuOoc
	 QUXl3soJrWcaUCSgehIamJeb4BBGOIt3LlVhmHhqkAaD5yr93hMziLmxthHckJLSozPRy
	 u99HdovIviG+oB21+NdWxVRB2/LXQXS/WBYwANNECWam+3ySahG2bEUEAWVUQVDte6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=G3bF4bGu;
	arc=none smtp.remote-ip=91.218.175.174
Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBBF606A32C
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 09:39:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFBBF606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=G3bF4bGu
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Dbw8940zR/jUhNkJIS8yVdfOTSwknMqwdcPr0t/bPyo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793612391; v=1; x=1794217191;
 b=G3bF4bGu4W9LBDqYe4s4H9hNVR1cDTt/ve6HR6rx05Llf5dGvNIhCFXBILYmT1AYyWh09Gtr
 RQ82GKxDxfDYRkxdIGa5qACVxCgy2PqOVjaSSmZGoCP4hDyOZBrbvrDBXAuB+Dkij5VMMe42PUy
 V/HK/HiDXasr6ZeQe/SqLxmc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f81ad78c3eac48bc;
	Mon, 02 Nov 2026 09:39:51 +0000
X-Mizu-Trace-ID: f81ad78c3eac48bc
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Add support for self-hosted debug in protected guests
Date: Mon,  2 Nov 2026 09:39:50 +0000
Message-ID: <20261102093950.2922035-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pKVM hides DebugVer from protected guests and makes their debug
registers RAZ/WI or UNDEFINED, so they don't have breakpoints,
watchpoints or single-step. For a non-protected guest, the host sets the
owner of the debug registers at vcpu load, from the guest's MDSCR_EL1
and OS Lock, and EL2 copies the owner and the registers in at each
entry. However, the host can't see a protected guest's registers.

Set the owner at EL2 for a protected vCPU instead, by the rules the host
uses for a non-protected guest, but keep MDCR_EL2.TDA set when the guest
is the owner. A trap handler returns to the guest without going back
through the world switch, so a handler that changes the owner switches
the debug registers itself. The PSCI CPU_ON reset runs after the vcpu
load, so it sets the owner again.

Advertise DebugVer, capped at V8P8 as for a non-protected guest, and the
breakpoint, watchpoint and context-aware breakpoint counts. The other
debug registers that took an UNDEF behave as they do for a non-protected
guest that doesn't own its debug registers.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Commit 3a81a814437d ("KVM: arm64: Expose self-hosted debug regs as
    RAZ/WI for protected guests") made these registers RAZ/WI and left
    debug support for later.
    
    Tested by running the breakpoint_test_arm64 kselftest in a protected
    guest under kvmtool. It passes on hVHE and nVHE hosts under QEMU,
    and on hVHE again after offlining and onlining the guest CPU it runs
    on. That test has no single-step case, so I checked single-step with
    the pkvm_exceptions test from my pKVM selftests series, coming soon.
    
    Based on Linux 7.4-rc1 (6628e7d4c6b25).

 Documentation/virt/kvm/arm/pkvm.rst    |   7 +-
 arch/arm64/include/asm/kvm_hyp.h       |   1 +
 arch/arm64/kvm/arm.c                   |   1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |   1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |   2 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c         |   8 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c     | 253 +++++++++++++++++++++++--
 7 files changed, 248 insertions(+), 25 deletions(-)

diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
index b75bb8ad6f26d..b8c8c94cba534 100644
--- a/Documentation/virt/kvm/arm/pkvm.rst
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -241,10 +241,9 @@ Other interface differences
 Debug
 -----
 
-Hardware-assisted debugging is not available to protected guests.
-``MDSCR_EL1``, ``OSLAR_EL1``, ``OSLSR_EL1``, ``OSDLR_EL1``, and breakpoint
-and watchpoint 0 are RAZ/WI; any other debug register access takes an
-undefined instruction exception.
+A protected guest can use self-hosted debug (breakpoints, watchpoints and
+single-step) as a non-protected guest can. ``KVM_SET_GUEST_DEBUG`` returns
+``-EPERM`` for a protected VM.
 
 Resources
 =========
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index b0e42be3d9eef..9a785a341090e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -151,6 +151,7 @@ extern u64 kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64dfr0_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 157bf4b812020..ec90a580e82a4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2834,6 +2834,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
 	kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64SMFR0_EL1);
+	kvm_nvhe_sym(id_aa64dfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 0261b2bc681f7..993d54ce44408 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -130,6 +130,7 @@ void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm);
 bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
+void kvm_load_pvm_debug(struct kvm_vcpu *vcpu);
 void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
 void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 179d7c8277b88..9958ca6d7b0a2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -837,6 +837,8 @@ DEFINE_KVM_HOST_HCALL(void, __pkvm_vcpu_load,
 		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_EL2_TWE | HCR_EL2_TWI);
 		hyp_vcpu->vcpu.arch.hcr_el2 |= hcr_el2 & (HCR_EL2_TWE | HCR_EL2_TWI);
 
+		kvm_load_pvm_debug(&hyp_vcpu->vcpu);
+
 		/* HPMN == 0 is reserved without FEAT_HPMN0. */
 		if (pmuv3_implemented(SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, dfr0)))
 			u64p_replace_bits(&hyp_vcpu->vcpu.arch.mdcr_el2,
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index fc0475f0877d1..1d484da274c0e 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -123,8 +123,11 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 		val &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME);
 	}
 
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, IMP))
-		val |= MDCR_EL2_TDRA | MDCR_EL2_TDA;
+	/*
+	 * Keep TDA set even when the guest owns debug: it also traps the DCC
+	 * and the claim tags, which the world switch doesn't switch.
+	 */
+	val |= MDCR_EL2_TDRA | MDCR_EL2_TDA;
 
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DoubleLock, IMP))
 		val |= MDCR_EL2_TDOSA;
@@ -1245,6 +1248,7 @@ int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	kvm_reset_vcpu_core(&hyp_vcpu->vcpu);
 	kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
+	kvm_load_pvm_debug(&hyp_vcpu->vcpu);
 
 	/* Must be done after resetting sys registers. */
 	kvm_reset_vcpu_psci(&hyp_vcpu->vcpu, reset_state);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 32e82653ebf7e..e7148254ec5b8 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -10,6 +10,8 @@
 #include <asm/kvm_mmu.h>
 
 #include <hyp/adjust_pc.h>
+#include <hyp/debug-sr.h>
+#include <hyp/sysreg-sr.h>
 
 #include <nvhe/pkvm.h>
 
@@ -28,6 +30,7 @@ u64 id_aa64mmfr0_el1_sys_val;
 u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 u64 id_aa64smfr0_el1_sys_val;
+u64 id_aa64dfr0_el1_sys_val;
 
 struct pvm_ftr_bits {
 	bool		sign;
@@ -55,6 +58,13 @@ struct pvm_ftr_bits {
 #define MAX_FEAT_ENUM(id, fld, max)						\
 	__MAX_FEAT_FUNC(id, fld, max, NULL, false)
 
+#define MAX_FEAT_PASSTHRU(id, fld)						\
+	{									\
+		.shift = id##_##fld##_SHIFT,					\
+		.width = id##_##fld##_WIDTH,					\
+		.max_val = GENMASK(id##_##fld##_WIDTH - 1, 0),			\
+	}
+
 #define FEAT_END {	.width = 0,	}
 
 static bool vm_has_ptrauth(const struct kvm *kvm)
@@ -175,17 +185,18 @@ static const struct pvm_ftr_bits pvmid_aa64isar2[] = {
 	FEAT_END
 };
 
-/*
- * None of the features in ID_AA64DFR0_EL1 nor ID_AA64MMFR4_EL1 are supported.
- * However, both have Not-Implemented values that are non-zero. Define them
- * so they can be used when getting the value of these registers.
- */
-#define ID_AA64DFR0_EL1_NONZERO_NI					\
-(									\
-	SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DoubleLock, NI)	|	\
-	SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, MTPMU, NI)			\
-)
+/* DoubleLock and MTPMU are hidden, but their Not-Implemented values are non-zero. */
+static const struct pvm_ftr_bits pvmid_aa64dfr0[] = {
+	MAX_FEAT(ID_AA64DFR0_EL1, DebugVer, V8P8),
+	MAX_FEAT_PASSTHRU(ID_AA64DFR0_EL1, BRPs),
+	MAX_FEAT_PASSTHRU(ID_AA64DFR0_EL1, WRPs),
+	MAX_FEAT_PASSTHRU(ID_AA64DFR0_EL1, CTX_CMPs),
+	MAX_FEAT(ID_AA64DFR0_EL1, DoubleLock, NI),
+	MAX_FEAT(ID_AA64DFR0_EL1, MTPMU, NI),
+	FEAT_END
+};
 
+/* ID_AA64MMFR4_EL1 is hidden, but its Not-Implemented value is non-zero. */
 #define ID_AA64MMFR4_EL1_NONZERO_NI					\
 	SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, E2H0, NI)
 
@@ -245,7 +256,7 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 	case SYS_ID_AA64MMFR2_EL1:
 		return get_restricted_features(vcpu, id_aa64mmfr2_el1_sys_val, pvmid_aa64mmfr2);
 	case SYS_ID_AA64DFR0_EL1:
-		return ID_AA64DFR0_EL1_NONZERO_NI;
+		return get_restricted_features(vcpu, id_aa64dfr0_el1_sys_val, pvmid_aa64dfr0);
 	case SYS_ID_AA64MMFR4_EL1:
 		return ID_AA64MMFR4_EL1_NONZERO_NI;
 	default:
@@ -372,6 +383,179 @@ static bool pvm_idst_access(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static void pvm_set_external_mdscr(struct kvm_vcpu *vcpu, u64 mdscr)
+{
+	vcpu->arch.external_mdscr_el1 = mdscr & ~(MDSCR_EL1_SS | MDSCR_EL1_MDE | MDSCR_EL1_KDE);
+}
+
+/* KVM_SET_GUEST_DEBUG fails for a protected vCPU, so only the OS Lock makes it HOST_OWNED. */
+static int pvm_debug_owner(struct kvm_vcpu *vcpu, u64 mdscr)
+{
+	if (kvm_vcpu_os_lock_enabled(vcpu))
+		return VCPU_DEBUG_HOST_OWNED;
+
+	if (mdscr & (MDSCR_EL1_KDE | MDSCR_EL1_MDE))
+		return VCPU_DEBUG_GUEST_OWNED;
+
+	return VCPU_DEBUG_FREE;
+}
+
+/* Trap handlers run after entry has loaded the debug state. */
+static void pvm_debug_switch_owner(struct kvm_vcpu *vcpu, int new)
+{
+	*ctxt_mdscr_el1(&vcpu->arch.ctxt) = read_sysreg(mdscr_el1);
+
+	__debug_switch_to_host_common(vcpu);
+	vcpu->arch.debug_owner = new;
+	__debug_switch_to_guest_common(vcpu);
+
+	write_sysreg(*ctxt_mdscr_el1(&vcpu->arch.ctxt), mdscr_el1);
+}
+
+static void pvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu)
+{
+	if (kvm_debug_regs_in_use(vcpu))
+		return;
+
+	pvm_debug_switch_owner(vcpu, VCPU_DEBUG_GUEST_OWNED);
+}
+
+/* Runs before the world switch, which loads the debug state that debug_owner selects. */
+void kvm_load_pvm_debug(struct kvm_vcpu *vcpu)
+{
+	u64 mdscr = __vcpu_sys_reg(vcpu, MDSCR_EL1);
+
+	vcpu->arch.debug_owner = pvm_debug_owner(vcpu, mdscr);
+
+	if (kvm_host_owns_debug_regs(vcpu))
+		pvm_set_external_mdscr(vcpu, mdscr);
+}
+
+static bool pvm_trap_dbg_wb_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+				const struct sys_reg_desc *r)
+{
+	struct kvm_guest_debug_arch *dbg = &vcpu->arch.vcpu_debug_state;
+	u64 *reg;
+
+	switch (r->Op2) {
+	case 0b100:
+		reg = &dbg->dbg_bvr[r->CRm];
+		break;
+	case 0b101:
+		reg = &dbg->dbg_bcr[r->CRm];
+		break;
+	case 0b110:
+		reg = &dbg->dbg_wvr[r->CRm];
+		break;
+	default:
+		reg = &dbg->dbg_wcr[r->CRm];
+	}
+
+	if (p->is_write)
+		*reg = p->regval;
+	else
+		p->regval = *reg;
+
+	/* Guest-owned registers are live: __debug_switch_to_host() overwrites memory with them. */
+	if (p->is_write && kvm_guest_owns_debug_regs(vcpu))
+		__debug_restore_state(dbg, &vcpu->arch.ctxt);
+
+	pvm_debug_set_guest_ownership(vcpu);
+	return true;
+}
+
+/* Outside HOST_OWNED, use the live register: __sysreg_save_state_nvhe() overwrites memory. */
+static u64 pvm_read_mdscr(struct kvm_vcpu *vcpu)
+{
+	if (kvm_host_owns_debug_regs(vcpu))
+		return __vcpu_sys_reg(vcpu, MDSCR_EL1);
+
+	return read_sysreg(mdscr_el1);
+}
+
+static bool pvm_trap_mdscr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	if (!p->is_write) {
+		p->regval = pvm_read_mdscr(vcpu);
+	} else if (kvm_host_owns_debug_regs(vcpu)) {
+		__vcpu_assign_sys_reg(vcpu, MDSCR_EL1, p->regval);
+		pvm_set_external_mdscr(vcpu, p->regval);
+		write_sysreg(vcpu->arch.external_mdscr_el1, mdscr_el1);
+	} else {
+		write_sysreg(p->regval, mdscr_el1);
+	}
+
+	pvm_debug_set_guest_ownership(vcpu);
+	return true;
+}
+
+/* __debug_restore_state() loads MDCCINT_EL1 from memory, so keep memory current. */
+static bool pvm_trap_mdccint(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	if (p->is_write) {
+		__vcpu_assign_sys_reg(vcpu, MDCCINT_EL1, p->regval);
+		if (kvm_debug_regs_in_use(vcpu))
+			write_sysreg(p->regval, mdccint_el1);
+	} else {
+		p->regval = __vcpu_sys_reg(vcpu, MDCCINT_EL1);
+	}
+
+	pvm_debug_set_guest_ownership(vcpu);
+	return true;
+}
+
+static bool pvm_trap_oslar(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	int new_owner;
+	u64 mdscr;
+
+	if (!p->is_write) {
+		inject_undef64(vcpu);
+		return false;
+	}
+
+	mdscr = pvm_read_mdscr(vcpu);
+
+	if (p->regval & OSLAR_EL1_OSLK)
+		__vcpu_rmw_sys_reg(vcpu, OSLSR_EL1, |=, OSLSR_EL1_OSLK);
+	else
+		__vcpu_rmw_sys_reg(vcpu, OSLSR_EL1, &=, ~OSLSR_EL1_OSLK);
+
+	new_owner = pvm_debug_owner(vcpu, mdscr);
+	if (new_owner == VCPU_DEBUG_HOST_OWNED)
+		pvm_set_external_mdscr(vcpu, mdscr);
+
+	if (new_owner != vcpu->arch.debug_owner)
+		pvm_debug_switch_owner(vcpu, new_owner);
+
+	return true;
+}
+
+static bool pvm_trap_oslsr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	if (p->is_write) {
+		inject_undef64(vcpu);
+		return false;
+	}
+
+	p->regval = __vcpu_sys_reg(vcpu, OSLSR_EL1);
+	return true;
+}
+
+/* As the host's trap_dbgauthstatus_el1(). */
+static bool pvm_trap_dbgauthstatus(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	if (!p->is_write)
+		p->regval = read_sysreg(dbgauthstatus_el1);
+
+	return true;
+}
+
 /* Mark the specified system register as an AArch32 feature id register. */
 #define AARCH32(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch32 }
 
@@ -391,6 +575,12 @@ static bool pvm_idst_access(struct kvm_vcpu *vcpu,
 /* Mark the specified system register as Read-As-Zero/Write-Ignored */
 #define RAZ_WI(REG) { SYS_DESC(REG), .access = pvm_access_raz_wi }
 
+#define DBG_WB(n)							\
+	{ SYS_DESC(SYS_DBGBVRn_EL1(n)), .access = pvm_trap_dbg_wb_reg },	\
+	{ SYS_DESC(SYS_DBGBCRn_EL1(n)), .access = pvm_trap_dbg_wb_reg },	\
+	{ SYS_DESC(SYS_DBGWVRn_EL1(n)), .access = pvm_trap_dbg_wb_reg },	\
+	{ SYS_DESC(SYS_DBGWCRn_EL1(n)), .access = pvm_trap_dbg_wb_reg }
+
 /* Mark the specified system register as not being handled in hyp. */
 #define HOST_HANDLED(REG) { SYS_DESC(REG), .access = NULL }
 
@@ -404,15 +594,36 @@ static bool pvm_idst_access(struct kvm_vcpu *vcpu,
 static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Cache maintenance by set/way operations are restricted. */
 
-	/* Debug and Trace Registers are restricted. */
-	RAZ_WI(SYS_DBGBVRn_EL1(0)),
-	RAZ_WI(SYS_DBGBCRn_EL1(0)),
-	RAZ_WI(SYS_DBGWVRn_EL1(0)),
-	RAZ_WI(SYS_DBGWCRn_EL1(0)),
-	RAZ_WI(SYS_MDSCR_EL1),
-	RAZ_WI(SYS_OSLAR_EL1),
-	RAZ_WI(SYS_OSLSR_EL1),
+	/* Debug registers */
+	DBG_WB(0),
+	DBG_WB(1),
+	{ SYS_DESC(SYS_MDCCINT_EL1), .access = pvm_trap_mdccint },
+	{ SYS_DESC(SYS_MDSCR_EL1), .access = pvm_trap_mdscr },
+	DBG_WB(2),
+	DBG_WB(3),
+	DBG_WB(4),
+	DBG_WB(5),
+	DBG_WB(6),
+	DBG_WB(7),
+	DBG_WB(8),
+	DBG_WB(9),
+	DBG_WB(10),
+	DBG_WB(11),
+	DBG_WB(12),
+	DBG_WB(13),
+	DBG_WB(14),
+	DBG_WB(15),
+	RAZ_WI(SYS_MDRAR_EL1),
+	{ SYS_DESC(SYS_OSLAR_EL1), .access = pvm_trap_oslar },
+	{ SYS_DESC(SYS_OSLSR_EL1), .access = pvm_trap_oslsr },
 	RAZ_WI(SYS_OSDLR_EL1),
+	RAZ_WI(SYS_DBGPRCR_EL1),
+	RAZ_WI(SYS_DBGCLAIMSET_EL1),
+	RAZ_WI(SYS_DBGCLAIMCLR_EL1),
+	{ SYS_DESC(SYS_DBGAUTHSTATUS_EL1), .access = pvm_trap_dbgauthstatus },
+	RAZ_WI(SYS_MDCCSR_EL0),
+	RAZ_WI(SYS_DBGDTR_EL0),
+	RAZ_WI(SYS_DBGDTRTX_EL0),
 
 	/* Group 1 ID registers */
 	HOST_HANDLED(SYS_REVIDR_EL1),
@@ -559,6 +770,8 @@ static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
 	RESET_UNKNOWN(TPIDR_EL1),
 	RESET_ZERO(CNTKCTL_EL1),
 	RESET_UNKNOWN(PAR_EL1),
+	RESET_ZERO(MDCCINT_EL1),
+	RESET_VAL(OSLSR_EL1, OSLSR_EL1_OSLM_IMPLEMENTED),
 	RESET_ZERO(DISR_EL1),
 	RESET_ZERO(CPACR_EL1),
 	RESET_VAL(CONTEXTIDR_EL1, 0x00000000dbadc0deULL),
@@ -586,6 +799,8 @@ void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu)
 
 		r->reset(vcpu, r);
 	}
+
+	memset(&vcpu->arch.vcpu_debug_state, 0, sizeof(vcpu->arch.vcpu_debug_state));
 }
 
 /*

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.3

