Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1916238E8CE;
	Sun, 19 Jul 2026 23:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502707; cv=none; b=s0LN5XV0cFDJd8Qd1Q77OjqfJjuTxZmghbJp5W8XYV2oUEAPima1RvnqblPrmF1IwlGFRjN5wTZR7/Vln49/gp7uryrZYLu4KIIN1eEN5qOGW0vQSiAHWbnToJ0YuFaEnvvT168LOdIdGj6QLOH9iYD3GO+y9lWyI4GfIguZyJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502707; c=relaxed/simple;
	bh=V9lhbJTygqd7i1P+aMU/FsUCdWItdRpf+EOnavENZ1I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ApiWsXEYnydFxRsCSBMk9MWpUmzd1UyTXnmwh2WjuhtXyoRvr1mjYJ6e91i2vPVvUIlV4ymQlnwKRa7aol7QtrNVYm4Kv/jxc/Lapcw/nHYK0DdoO3zOqfHCZ2lyo4dtjKIZUW7wlBL/lYobg7dNz/POIxiltMcAJAYnMF0wvJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVIDhyNP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVIDhyNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06C61F00A3D;
	Sun, 19 Jul 2026 23:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502705;
	bh=HghW6M6niObkOasBxAde9LGFXC86Em82YvIc/IyzCPs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aVIDhyNPcoEfrgRwi7a6blEvdPumF5cziPxbLsjuFPPS7XqyMWFSozvY0vSXDHYqy
	 J7/u1p26XkuKLTD6Gj2lNkJcHI9RvKjemEer8uR4jqqE06J41yjjZHXIvtm8/uHAaV
	 ckZ7FlZkar5YrV3yAc+QTU3D0iibKsAW1f9KshPZrqQvmCg85x28xceO1usMzCpTGr
	 suyUt4SWlRy+OeHOCQeUfVjL39PVjOxbJxbnix5W9FpT/+MSYfkXViNJxN40gzBkJQ
	 6jbL/jna0x909pPw5Q7vME/d1TP0covA8D4T1HAHTZlCeVJ2kt4J/Uww/1RZc2XDDC
	 X45TQKbV4qx7w==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:52 +0100
Subject: [PATCH v13 25/32] KVM: arm64: Context switch SME state for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-25-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=21393; i=broonie@kernel.org;
 h=from:subject:message-id; bh=V9lhbJTygqd7i1P+aMU/FsUCdWItdRpf+EOnavENZ1I=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVk6UIbKMeC2EnUMs1R0vvu6Hesy+s/5Ne3IR
 51v8U/nSPOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZOgAKCRAk1otyXVSH
 0FU/B/4lfINIS2dtgabwnUxtIU68UrpB1kjI+bhtm4WLWOPnX9heM/R/LlABWiJcTlewmN8Hr4L
 JwV8Ao8iQeoUTZ1jgvkEsgb/nJQDJZaNACbo66suZaEXDoF+G/YgvDyxLB+cHlbnHIzUB2jHJwg
 tvwDuk2j5QlpgWZEtPOkDxB4WlNhotbif6s5+kGu/OzlMnU92lh1o9PTSouE23J2kRTpVXcjo5n
 5TcDJ330YMaRGRgcMEjSdTQFvdAk76H+nAzGde5KLA0bjhFiIDXA7vZLIdcdaX2mOXA1KiVgCgB
 V8HGJPZN8HRHD62SEw8yxqMgSndtNXkSRfh1RynXlHpcNE0I
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

If the guest has SME state we need to context switch that state, provide
support for that for normal guests.

SME has three sets of registers, ZA, ZT (only present for SME2) and also
streaming SVE which replaces the standard floating point registers when
active. The first two are fairly straightforward, they are accessible only
when PSTATE.ZA is set and we can reuse the assembly from the host to save
and load them from a single contiguous buffer. When PSTATE.ZA is not set
then these registers are inaccessible, when the guest enables PSTATE.ZA
all bits will be set to 0 by that and nothing is required on restore.

Streaming mode is slightly more complicated, when enabled via PSTATE.SM it
provides a version of the SVE registers using the SME vector length and may
optionally omit the FFR register. SME may also be present without SVE. The
register state is stored in sve_state as for non-streaming SVE mode, we
make an initial selection of registers to update based on the guest SVE
support and then override this when loading SVCR if streaming mode is
enabled.

A further complication is that when the hardware is in streaming mode
guest operations that are invalid in in streaming mode will generate SME
exceptions. There are also subfeature exceptions for SME2 controlled via
SMCR which generate distinct exception codes. In many situations these
exceptions are routed directly to the lower ELs with no opportunity for
the hypervisor to intercept. So that guests do not see unexpected
exception types due to the actual hardware configuration not being what
the guest configured we update the SMCRs and SVCR even if the guest does
not own the registers.

For nested guests we also need to forward exceptions generated as the
result of SMCR_EL2.EZT0 being disabled in the guest.

Since in order to avoid duplication with SME we now restore the register
state outside of the SVE specific restore function we need to move the
restore of the effective VL for nested guests to a separate restore
function run after loading the floating point register state, along with
the similar handling required for SME.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       |  25 ++--
 arch/arm64/kvm/fpsimd.c                 |  26 ++++-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 197 ++++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 131 ++++++++++++++++++---
 4 files changed, 337 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cafc43776ac3..7ebe7b6cc96e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1126,6 +1126,9 @@ struct kvm_vcpu_arch {
 #define vcpu_sve_zcr_elx(vcpu)						\
 	(unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
 
+#define vcpu_sme_smcr_elx(vcpu)						\
+	(unlikely(is_hyp_ctxt(vcpu)) ? SMCR_EL2 : SMCR_EL1)
+
 #define sve_state_size_from_vl(sve_max_vl) ({				\
 	size_t __size_ret;						\
 	unsigned int __vq;						\
@@ -1140,10 +1143,20 @@ struct kvm_vcpu_arch {
 	__size_ret;							\
 })
 
-#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl(vcpu_sve_max_vl(vcpu))
+#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl(vcpu_max_vl(vcpu))
 
 #define vcpu_sme_state(vcpu) (kern_hyp_va((vcpu)->arch.sme_state))
 
+/*
+ * Always provide space for ZT0 to avoid ordering requirements with ID
+ * register writes and vector finalization.
+ */
+#define vcpu_sme_state_size(vcpu) ({					\
+	unsigned long __vl;						\
+	__vl = (vcpu)->arch.max_vl[ARM64_VEC_SME];			\
+	sme_state_size_from_vl(__vl, system_supports_sme2());		\
+})
+
 #define sme_state_size_from_vl(vl, sme2) ({				\
 	size_t __size_ret;                                              \
 	unsigned int __vq;                                              \
@@ -1160,16 +1173,6 @@ struct kvm_vcpu_arch {
 	__size_ret;                                                     \
 })
 
-/*
- * Always provide space for ZT0 to avoid ordering requirements with ID
- * register writes and vector finalization.
- */
-#define vcpu_sme_state_size(vcpu) ({					\
-	unsigned long __vl;						\
-	__vl = (vcpu)->arch.max_vl[ARM64_VEC_SME];			\
-	sme_state_size_from_vl(__vl, system_supports_sme2());		\
-})
-
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
 				 KVM_GUESTDBG_USE_HW | \
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 567dd43970c5..bb0bf8d81522 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -83,19 +83,24 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (guest_owns_fp_regs()) {
-		/*
-		 * Currently we do not support SME guests so SVCR is
-		 * always 0 and we just need a variable to point to.
-		 */
 		fp_state.st = &vcpu->arch.ctxt.fp_regs;
 		fp_state.sve_state = vcpu->arch.sve_state;
 		fp_state.zcr = vcpu_sve_max_vq(vcpu) - 1;
-		fp_state.smcr = 0;
-		fp_state.sme_state = NULL;
+		fp_state.smcr = vcpu_sme_max_vq(vcpu) - 1;
+		fp_state.sme_state = vcpu->arch.sme_state;
 		fp_state.svcr = __ctxt_sys_reg(&vcpu->arch.ctxt, SVCR);
 		fp_state.fpmr = __ctxt_sys_reg(&vcpu->arch.ctxt, FPMR);
 		fp_state.fp_type = &vcpu->arch.fp_type;
 
+		if (kvm_has_fa64(vcpu->kvm))
+			fp_state.smcr |= SMCR_ELx_FA64;
+		if (kvm_has_sme2(vcpu->kvm))
+			fp_state.smcr |= SMCR_ELx_EZT0;
+
+		/*
+		 * For SME only guests fpsimd_save() will override the
+		 * state selection if we are in streaming mode.
+		 */
 		if (vcpu_has_sve(vcpu))
 			fp_state.to_save = FP_STATE_SVE;
 		else
@@ -104,6 +109,15 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 		fpsimd_bind_state_to_cpu(&fp_state);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
+	} else {
+		/*
+		 * We might have enabled SME to configure traps but
+		 * insist the host doesn't run the hypervisor with SME
+		 * enabled, ensure it's disabled again.
+		 */
+		if (system_supports_sme()) {
+			sme_smstop();
+		}
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index ce586110c226..2eabffb640e9 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -462,6 +462,44 @@ static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+/* The SMCR_EL2 for non-nested guests */
+static inline u64 __hyp_smcr_el2(struct kvm_vcpu *vcpu)
+{
+	u64 smcr_el2;
+
+	/*
+	 * The vCPU's saved SVE state layout always matches the max VL of the
+	 * vCPU.
+	 */
+	smcr_el2 = vcpu_sme_max_vq(vcpu) - 1;
+	if (vcpu_has_fa64(vcpu))
+		smcr_el2 |= SMCR_ELx_FA64;
+	if (vcpu_has_sme2(vcpu))
+		smcr_el2 |= SMCR_ELx_EZT0;
+
+	return smcr_el2;
+}
+
+static inline void __hyp_sme_restore_guest(struct kvm_vcpu *vcpu,
+					   bool *restore_sve,
+					   bool *restore_ffr)
+{
+	/* EZT0 and FA64 are not self synchronizing */
+	sysreg_cond_update_s(SYS_SMCR_EL2, __hyp_smcr_el2(vcpu));
+	isb();
+
+	if (vcpu_in_streaming_mode(vcpu)) {
+		*restore_sve = true;
+		*restore_ffr = vcpu_has_fa64(vcpu);
+	}
+
+	if (vcpu_za_enabled(vcpu))
+		sme_load_state(kern_hyp_va(vcpu->arch.sme_state),
+			       vcpu_has_sme2(vcpu));
+
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, vcpu_sme_smcr_elx(vcpu)), SYS_SMCR);
+}
+
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
 	u64 zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
@@ -471,20 +509,45 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	 * vCPU. Start off with the max VL so we can load the SVE state.
 	 */
 	sve_cond_update_zcr_vq(zcr_el2, SYS_ZCR_EL2);
-	sve_load_state(kern_hyp_va(vcpu->arch.sve_state), true);
-	fpsimd_load_common(&vcpu->arch.ctxt.fp_regs);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)), SYS_ZCR);
+}
+
+static inline u64 __hyp_smcr_el2_nested(struct kvm_vcpu *vcpu)
+{
+	u64 max_len = vcpu_sme_max_vq(vcpu) - 1;
+	u64 smcr_el2 = SYS_FIELD_GET(SMCR_ELx, LEN,
+				     __vcpu_sys_reg(vcpu, SMCR_EL2));
+
+	smcr_el2 = min(max_len, smcr_el2);
+
+	if (vcpu_has_fa64(vcpu))
+		smcr_el2 |= __vcpu_sys_reg(vcpu, SMCR_EL2) & SMCR_ELx_FA64;
+	if (vcpu_has_sme2(vcpu))
+		smcr_el2 |= __vcpu_sys_reg(vcpu, SMCR_EL2) & SMCR_ELx_EZT0;
+
+	return smcr_el2;
+}
+
+static inline void __hyp_nv_restore_guest_vls(struct kvm_vcpu *vcpu)
+{
+	if (!is_nested_ctxt(vcpu))
+		return;
 
 	/*
 	 * The effective VL for a VM could differ from the max VL when running a
 	 * nested guest, as the guest hypervisor could select a smaller VL. Slap
 	 * that into hardware before wrapping up.
 	 */
-	if (is_nested_ctxt(vcpu)) {
+
+	if (vcpu_has_sve(vcpu)) {
+		u64 zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+
 		zcr_el2 = min(zcr_el2, __vcpu_sys_reg(vcpu, ZCR_EL2));
 		sve_cond_update_zcr_vq(zcr_el2, SYS_ZCR_EL2);
 	}
 
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)), SYS_ZCR);
+	if (vcpu_has_sme(vcpu))
+		sysreg_cond_update_s(SYS_SMCR_EL2, __hyp_smcr_el2_nested(vcpu));
 }
 
 static inline void __hyp_sve_save_host(void)
@@ -498,10 +561,38 @@ static inline void __hyp_sve_save_host(void)
 	fpsimd_save_common(&hctxt->fp_regs);
 }
 
+static inline void kvm_sme_configure_traps(struct kvm_vcpu *vcpu)
+{
+	u64 smcr_el1, smcr_el2, svcr;
+
+	if (!vcpu_has_sme(vcpu))
+		return;
+
+	if (is_nested_ctxt(vcpu))
+		smcr_el2 = __hyp_smcr_el2_nested(vcpu);
+	else
+		smcr_el2 = __hyp_smcr_el2(vcpu);
+	sysreg_cond_update_s(SYS_SMCR_EL2, smcr_el2);
+
+	smcr_el1 = __vcpu_sys_reg(vcpu, vcpu_sme_smcr_elx(vcpu));
+	write_sysreg_el1(smcr_el1, SYS_SMCR);
+
+	svcr = __vcpu_sys_reg(vcpu, SVCR);
+	write_sysreg_s(svcr, SYS_SVCR);
+}
+
 static inline void fpsimd_lazy_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	u64 zcr_el1, zcr_el2;
 
+	/*
+	 * We always load the SME control registers that affect traps
+	 * since if they are not configured as expected by the guest
+	 * then it may have exceptions that it does not expect
+	 * directly delivered.
+	 */
+	kvm_sme_configure_traps(vcpu);
+
 	if (!guest_owns_fp_regs())
 		return;
 
@@ -555,8 +646,59 @@ static inline void sve_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 	}
 }
 
+static inline void sme_lazy_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	u64 smcr_el1, smcr_el2;
+
+	if (!vcpu_has_sme(vcpu))
+		return;
+
+	/*
+	 * __deactivate_cptr_traps() disabled traps, but there hasn't
+	 * necessarily been a context synchronization event yet.
+	 */
+	isb();
+
+	smcr_el1 = read_sysreg_el1(SYS_SMCR);
+	__vcpu_assign_sys_reg(vcpu, vcpu_sme_smcr_elx(vcpu), smcr_el1);
+
+	smcr_el2 = 0;
+	if (system_supports_fa64())
+		smcr_el2 |= SMCR_ELx_FA64;
+	if (system_supports_sme2())
+		smcr_el2 |= SMCR_ELx_EZT0;
+
+	/*
+	 * The guest's state is always saved using the guest's max VL.
+	 * Ensure that the host has the guest's max VL active such
+	 * that the host can save the guest's state lazily, but don't
+	 * artificially restrict the host to the guest's max VL.
+	 */
+	if (has_vhe()) {
+		smcr_el2 |= vcpu_sme_max_vq(vcpu) - 1;
+		write_sysreg_el2(smcr_el2, SYS_SMCR);
+		/* Guest might not have had EZT0 or FA64 */
+		isb();
+	} else {
+		smcr_el1 = smcr_el2;
+		smcr_el2 |= sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SME]) - 1;
+		write_sysreg_el2(smcr_el2, SYS_SMCR);
+
+		smcr_el1 |= vcpu_sme_max_vq(vcpu) - 1;
+		write_sysreg_el1(smcr_el1, SYS_SMCR);
+	}
+
+	__vcpu_assign_sys_reg(vcpu, SVCR, read_sysreg_s(SYS_SVCR));
+}
+
 static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * We always load the control registers for the guest so we
+	 * always restore state for the host.
+	 */
+	sme_lazy_switch_to_host(vcpu);
+
 	if (!guest_owns_fp_regs())
 		return;
 
@@ -567,6 +709,16 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
 
+	/*
+	 * The hypervisor refuses to run if streaming mode or ZA is
+	 * enabled, we only need to save SMCR_EL1 for SME.  For pKVM
+	 * we will restore this, reset SMCR_EL2 to a fixed value and
+	 * disable streaming mode and ZA to avoid any state being
+	 * leaked.
+	 */
+	if (system_supports_sme())
+		ctxt_sys_reg(hctxt, SMCR_EL1) = read_sysreg_el1(SYS_SMCR);
+
 	/*
 	 * Non-protected kvm relies on the host restoring its sve state.
 	 * Protected kvm restores the host's sve state as not to reveal that
@@ -591,14 +743,17 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
  */
 static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	bool sve_guest;
-	u8 esr_ec;
+	bool restore_sve, restore_ffr;
+	bool sve_guest, sme_guest;
+	u8 esr_ec, esr_iss_smtc;
 
 	if (!system_supports_fpsimd())
 		return false;
 
 	sve_guest = vcpu_has_sve(vcpu);
+	sme_guest = vcpu_has_sme(vcpu);
 	esr_ec = kvm_vcpu_trap_get_class(vcpu);
+	esr_iss_smtc = ESR_ELx_SME_ISS_SMTC((kvm_vcpu_get_esr(vcpu)));
 
 	/* Only handle traps the vCPU can support here: */
 	switch (esr_ec) {
@@ -613,6 +768,20 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 		if (guest_hyp_sve_traps_enabled(vcpu))
 			return false;
 		break;
+	case ESR_ELx_EC_SME:
+		if (!sme_guest)
+			return false;
+		if (guest_hyp_sme_traps_enabled(vcpu))
+			return false;
+		if (esr_iss_smtc == ESR_ELx_SME_ISS_SMTC_ZT_DISABLED) {
+			if (!kvm_has_sme2(kern_hyp_va(vcpu->kvm)))
+				return false;
+
+			if (vcpu_has_nv(vcpu) &&
+			    !(__vcpu_sys_reg(vcpu, SMCR_EL2) & SMCR_ELx_EZT0))
+				return false;
+		}
+		break;
 	default:
 		return false;
 	}
@@ -628,10 +797,22 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 		kvm_hyp_save_fpsimd_host(vcpu);
 
 	/* Restore the guest state */
+
+	/* These may be overridden for a SME guest */
+	restore_sve = sve_guest;
+	restore_ffr = sve_guest;
+
 	if (sve_guest)
 		__hyp_sve_restore_guest(vcpu);
-	else
+	if (sme_guest)
+		__hyp_sme_restore_guest(vcpu, &restore_sve, &restore_ffr);
+
+	if (restore_sve) {
+		sve_load_state(kern_hyp_va(vcpu->arch.sve_state), restore_ffr);
+		fpsimd_load_common(&vcpu->arch.ctxt.fp_regs);
+	} else {
 		fpsimd_load_state(&vcpu->arch.ctxt.fp_regs);
+	}
 
 	if (kvm_has_fpmr(kern_hyp_va(vcpu->kvm)))
 		write_sysreg_s(__vcpu_sys_reg(vcpu, FPMR), SYS_FPMR);
@@ -640,6 +821,8 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
 		write_sysreg(__vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
 
+	__hyp_nv_restore_guest_vls(vcpu);
+
 	*host_data_ptr(fp_owner) = FP_STATE_GUEST_OWNED;
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 14e24e257dcc..33fd3bcb112a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -31,16 +31,28 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
 static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 {
-	__vcpu_assign_sys_reg(vcpu, ZCR_EL1, read_sysreg_el1(SYS_ZCR));
-	/*
-	 * On saving/restoring guest sve state, always use the maximum VL for
-	 * the guest. The layout of the data when saving the sve state depends
-	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
-	 */
-	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
-	sve_save_state(kern_hyp_va(vcpu->arch.sve_state), true);
+	bool save_ffr = !vcpu_in_streaming_mode(vcpu) || vcpu_has_fa64(vcpu);
+
+	if (vcpu_has_sve(vcpu)) {
+		__vcpu_assign_sys_reg(vcpu, ZCR_EL1, read_sysreg_el1(SYS_ZCR));
+
+		/*
+		 * On saving/restoring guest sve state, always use the
+		 * maximum VL for the guest. The layout of the data
+		 * when saving the sve state depends on the VL, so use
+		 * a consistent (i.e., the maximum) guest VL.
+		 */
+		sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	}
+
+	/* Ensure ZCR/SMCR updates for VL are seen */
+	isb();
+	sve_save_state(kern_hyp_va(vcpu->arch.sve_state), save_ffr);
 	fpsimd_save_common(&vcpu->arch.ctxt.fp_regs);
-	write_sysreg_s(sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1, SYS_ZCR_EL2);
+
+	if (system_supports_sve())
+		write_sysreg_s(sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1,
+			       SYS_ZCR_EL2);
 }
 
 static void __hyp_sve_restore_host(void)
@@ -63,9 +75,76 @@ static void __hyp_sve_restore_host(void)
 	write_sysreg_el1(ctxt_sys_reg(hctxt, ZCR_EL1), SYS_ZCR);
 }
 
-static void fpsimd_sve_flush(void)
+static void __hyp_sme_save_guest(struct kvm_vcpu *vcpu)
 {
-	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
+	unsigned long smcr_el2;
+
+	__vcpu_assign_sys_reg(vcpu, SMCR_EL1, read_sysreg_el1(SYS_SMCR));
+	__vcpu_assign_sys_reg(vcpu, SVCR, read_sysreg_s(SYS_SVCR));
+
+	/*
+	 * On saving/restoring guest sve state, always use the maximum VL for
+	 * the guest. The layout of the data when saving the sve state depends
+	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
+	 *
+	 * We restore the FA64 and SME2 enables for the host since we
+	 * will always restore the host configuration so if host and
+	 * guest VLs are the same we might suppress an update.
+	 */
+	smcr_el2 = vcpu_sme_max_vq(vcpu) - 1;
+	if (system_supports_fa64())
+		smcr_el2 |= SMCR_ELx_FA64;
+	if (system_supports_sme2())
+		smcr_el2 |= SMCR_ELx_EZT0;
+	sysreg_cond_update_s(SYS_SMCR_EL2, smcr_el2);
+
+	if (vcpu_za_enabled(vcpu)) {
+		isb();
+		sme_save_state(vcpu_sme_state(vcpu), vcpu_has_sme2(vcpu));
+	}
+}
+
+static void __hyp_sme_restore_host(void)
+{
+	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
+	u64 smcr_el2;
+
+	/*
+	 * The hypervisor refuses to run if we are in streaming mode
+	 * or have ZA enabled so there is no SME specific state to
+	 * restore other than the system registers.
+	 *
+	 * Note that this constrains the PE to the maximum shared VL
+	 * that was discovered, if we wish to use larger VLs this will
+	 * need to be revisited.
+	 */
+	smcr_el2 = sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SME]) - 1;
+	if (system_supports_fa64())
+		smcr_el2 |= SMCR_ELx_FA64;
+	if (system_supports_sme2())
+		smcr_el2 |= SMCR_ELx_EZT0;
+	sysreg_cond_update_s(SYS_SMCR_EL2, smcr_el2);
+
+	write_sysreg_el1(ctxt_sys_reg(hctxt, SMCR_EL1), SYS_SMCR);
+	sme_smstop();
+}
+
+static void fpsimd_sve_flush(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If the guest has SME then we need to restore the trap
+	 * controls in SMCR and mode in SVCR in order to ensure that
+	 * traps generated directly to EL1 have the correct types,
+	 * otherwise we can defer until we load the guest state.
+	 */
+	if (vcpu_has_sme(vcpu)) {
+		kvm_hyp_save_fpsimd_host(vcpu);
+		kvm_sme_configure_traps(vcpu);
+
+		*host_data_ptr(fp_owner) = FP_STATE_FREE;
+	} else {
+		*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
+	}
 }
 
 static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
@@ -73,8 +152,18 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
 	bool has_fpmr;
 
-	if (!guest_owns_fp_regs())
+	if (!guest_owns_fp_regs()) {
+		/*
+		 * We always at least partially configure SME for the
+		 * guest due to traps.
+		 */
+		if (vcpu_has_sme(vcpu)) {
+			/* Ensure __deactivate_cptr_traps() is visible */
+			isb();
+			__hyp_sme_restore_host();
+		}
 		return;
+	}
 
 	/*
 	 * Traps have been disabled by __deactivate_cptr_traps(), but there
@@ -82,7 +171,10 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	 */
 	isb();
 
-	if (vcpu_has_sve(vcpu))
+	if (vcpu_has_sme(vcpu))
+		__hyp_sme_save_guest(vcpu);
+
+	if (vcpu_has_sve(vcpu) || vcpu_in_streaming_mode(vcpu))
 		__hyp_sve_save_guest(vcpu);
 	else
 		fpsimd_save_state(&vcpu->arch.ctxt.fp_regs);
@@ -91,6 +183,9 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	if (has_fpmr)
 		__vcpu_assign_sys_reg(vcpu, FPMR, read_sysreg_s(SYS_FPMR));
 
+	if (system_supports_sme())
+		__hyp_sme_restore_host();
+
 	if (system_supports_sve())
 		__hyp_sve_restore_host();
 	else
@@ -128,11 +223,12 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 
-	fpsimd_sve_flush();
 	flush_debug_state(hyp_vcpu);
 
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
+	fpsimd_sve_flush(&hyp_vcpu->vcpu);
+
 	/* __hyp_running_vcpu must be NULL in a guest context. */
 	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
 
@@ -223,10 +319,9 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 		struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 
 		/*
-		 * KVM (and pKVM) doesn't support SME guests for now, and
-		 * ensures that SME features aren't enabled in pstate when
-		 * loading a vcpu. Therefore, if SME features enabled the host
-		 * is misbehaving.
+		 * KVM (and pKVM) refuses to run if PSTATE.{SM,ZA} are
+		 * enabled. Therefore, if SME features enabled the
+		 * host is misbehaving.
 		 */
 		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR))) {
 			ret = -EINVAL;

-- 
2.47.3

