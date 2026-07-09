Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B943B52FB;
	Thu,  9 Jul 2026 00:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558455; cv=none; b=RadA+WFMS4lZU8mZO6w4yU6V9rEDRTbirSyjRYgWpdG74XBVItWsLsDmb6ZL08Ne4ykzL654GEU58rJlBMxAdU1cvSA3kQEiysHIXKmXRw3sr9BkIbd8F3omGmYX0SajW/l4/XBsz2kZSqs5mkCL1QHssSeGxY2Hq9kh3WXYbd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558455; c=relaxed/simple;
	bh=ewc6MxdTFQrnYvQ4pRkzTspYwGUj+K2NicxNwR5qZIA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IRi8wzmPC5ML2IhXMt7y63WZjEYa+KR7QUgpjEt3ov4LAsbcFs11y5eNaffEuJa2z4uvLUjf3zqNvZJH13te94f1FeE13qtse8GLBoFK7+ODj9L6jqOhSo1f28v29tTs5pFPDsAJ92qz/5NlAvUUD4YIXdOt2nZ0nyk4Sb66cbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SXup5FMO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXup5FMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B17F1F00A3A;
	Thu,  9 Jul 2026 00:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558453;
	bh=MLStMQQAVDWe3AzNbiGQdQWZObxUA+fH6UwR9OaGb6w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SXup5FMOo9+rIy/NDwglw0HShkPlDefrR7W6+9emszfxvgST3iuov98K+EkhuFlUm
	 VOPTxkFoAs2bcDGWurr4hBzNeT4+Rom/iMKUHzQ6jsV8l19ILmcuFHoQrak/ee+Lr/
	 Kzm162Hrtai6mP8HL5OF4rwYQQI8//5AQMi/l4XuEy4uvMZq+LQUudh37IensBu8Ze
	 hnlyYMiY7xnQU/v8W5gMCV3EOKGFzMil7ymR0Xw3QF6ihhP9OcLGvvDPVi+OrrDyye
	 R2lF2hfX0NUonOs3CIV5fGS9MBkr9Dr4GHFtNoSH7JBOxxCb0Tim5he9uhntwPA6/h
	 qDG0qm0qPNw7Q==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 01:51:59 +0100
Subject: [PATCH v11 22/29] KVM: arm64: Context switch SME state for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v11-22-32799f66db9d@kernel.org>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=21691; i=broonie@kernel.org;
 h=from:subject:message-id; bh=ewc6MxdTFQrnYvQ4pRkzTspYwGUj+K2NicxNwR5qZIA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvDL7/19adDE/T/1wx5RrNHaovxEC/i/ytGqP
 7YpvFcbdMOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wywAKCRAk1otyXVSH
 0EnFB/9DgfZsDRa843FLQN+dTm2vdKE4hys4ybhhJHZ7UtyzZ92PSGsRHoNIHsVOQfgztPG5FmW
 SRJFIEUnVrwu6e4Z5DxpntPoKj0F5PRhGC0mjaWQiLBFJdk0D9BA2XjHKszhV/ZgFauEbVatmzL
 yXqVBbXGniNVv5BSe0gABL6oZUi3s1/DBntUVCsiBED9/Xtaz4rMwfaE7amHKS2CQuOazCBXaLa
 KH3ULMu/qYX0ZM1a6zrja9yq8U2Gm3nVh5Pw0KnrImQfdo08zYiy2GYltVIPfIYA0GkTrRuc5b+
 TZ/G0RJDzKrhLoc0BDwQp9sTh/JtwKjlru459gMzjIXSqCkN
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

Since in order to avoid duplication with SME we now restore the register
state outside of the SVE specific restore function we need to move the
restore of the effective VL for nested guests to a separate restore
function run after loading the floating point register state, along with
the similar handling required for SME.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h         |  10 ++
 arch/arm64/include/asm/kvm_host.h       |  25 +++--
 arch/arm64/kvm/fpsimd.c                 |  26 +++--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 173 ++++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 127 +++++++++++++++++++----
 5 files changed, 319 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index c3da16fdb158..9806b75e5e4c 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -431,6 +431,15 @@ static inline void sve_user_enable(void)
 			write_sysreg_s(__new, (reg));	\
 	} while (0)
 
+#define sme_cond_update_smcr_vq(val, reg)		\
+	do {						\
+		u64 __smcr = read_sysreg_s((reg));	\
+		u64 __new = __smcr & ~SMCR_ELx_LEN_MASK;	\
+		__new |= (val) & SMCR_ELx_LEN_MASK;	\
+		if (__smcr != __new)			\
+			write_sysreg_s(__new, (reg));	\
+	} while (0)
+
 /*
  * Probing and setup functions.
  * Calls to these functions must be serialised with one another.
@@ -549,6 +558,7 @@ static inline void sve_user_disable(void) { BUILD_BUG(); }
 static inline void sve_user_enable(void) { BUILD_BUG(); }
 
 #define sve_cond_update_zcr_vq(val, reg) do { } while (0)
+#define sme_cond_update_smcr_vq(val, reg) do { } while (0)
 
 static inline void vec_init_vq_map(enum vec_type t) { }
 static inline void vec_update_vq_map(enum vec_type t) { }
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b78c039cb5ec..26ad8962b65d 100644
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
index e444f0a94dcf..7c913da9babb 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -462,6 +462,28 @@ static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static inline void __hyp_sme_restore_guest(struct kvm_vcpu *vcpu,
+					   bool *restore_sve,
+					   bool *restore_ffr)
+{
+	/*
+	 * The vCPU's saved SVE state layout always matches the max VL of the
+	 * vCPU. Start off with the max VL so we can load the SVE state.
+	 */
+	sme_cond_update_smcr_vq(vcpu_sme_max_vq(vcpu) - 1, SYS_SMCR_EL2);
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
@@ -471,20 +493,34 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	 * vCPU. Start off with the max VL so we can load the SVE state.
 	 */
 	sve_cond_update_zcr_vq(zcr_el2, SYS_ZCR_EL2);
-	sve_load_state(kern_hyp_va(vcpu->arch.sve_state), true);
-	fpsimd_load_common(&vcpu->arch.ctxt.fp_regs);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)), SYS_ZCR);
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
+	if (vcpu_has_sme(vcpu)) {
+		u64 max_len = vcpu_sme_max_vq(vcpu) - 1;
+		u64 smcr_len = SYS_FIELD_GET(SMCR_ELx, LEN,
+					     __vcpu_sys_reg(vcpu, SMCR_EL2));
+
+		sme_cond_update_smcr_vq(min(smcr_len, max_len), SYS_SMCR_EL2);
+	}
 }
 
 static inline void __hyp_sve_save_host(void)
@@ -498,10 +534,48 @@ static inline void __hyp_sve_save_host(void)
 	fpsimd_save_common(&hctxt->fp_regs);
 }
 
+static inline void kvm_sme_configure_traps(struct kvm_vcpu *vcpu)
+{
+	u64 smcr_el1, smcr_el2, guest_el2_len, svcr;
+
+	if (!vcpu_has_sme(vcpu))
+		return;
+
+	smcr_el2 = vcpu_sme_max_vq(vcpu) - 1;
+
+	/* A guest hypervisor may restrict the effective max VL. */
+	if (is_nested_ctxt(vcpu)) {
+		guest_el2_len = SYS_FIELD_GET(SMCR_ELx, LEN,
+					      __vcpu_sys_reg(vcpu, SMCR_EL2));
+		smcr_el2 = min(smcr_el2, guest_el2_len);
+	}
+
+	if (vcpu_has_fa64(vcpu))
+		smcr_el2 |= SMCR_ELx_FA64;
+	if (vcpu_has_sme2(vcpu))
+		smcr_el2 |= SMCR_ELx_EZT0;
+
+	write_sysreg_el2(smcr_el2, SYS_SMCR);
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
 
@@ -555,8 +629,57 @@ static inline void sve_lazy_switch_to_host(struct kvm_vcpu *vcpu)
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
 
@@ -567,6 +690,16 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
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
@@ -591,14 +724,17 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
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
@@ -617,6 +753,15 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 		if (guest_hyp_sve_traps_enabled(vcpu))
 			return false;
 		break;
+	case ESR_ELx_EC_SME:
+		if (!sme_guest)
+			return false;
+		if (guest_hyp_sme_traps_enabled(vcpu))
+			return false;
+		if (!kvm_has_sme2(kern_hyp_va(vcpu->kvm)) &&
+		    (esr_iss_smtc == ESR_ELx_SME_ISS_SMTC_ZT_DISABLED))
+			return false;
+		break;
 	default:
 		return false;
 	}
@@ -632,10 +777,22 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
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
@@ -644,6 +801,8 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
 		write_sysreg(__vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
 
+	__hyp_nv_restore_guest_vls(vcpu);
+
 	*host_data_ptr(fp_owner) = FP_STATE_GUEST_OWNED;
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 14e24e257dcc..0f6e3479a7e4 100644
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
@@ -73,8 +152,15 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
 	bool has_fpmr;
 
-	if (!guest_owns_fp_regs())
+	if (!guest_owns_fp_regs()) {
+		/*
+		 * We always at least partially configure SME for the
+		 * guest due to traps.
+		 */
+		if (system_supports_sme())
+			__hyp_sme_restore_host();
 		return;
+	}
 
 	/*
 	 * Traps have been disabled by __deactivate_cptr_traps(), but there
@@ -82,7 +168,10 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
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
@@ -91,6 +180,9 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	if (has_fpmr)
 		__vcpu_assign_sys_reg(vcpu, FPMR, read_sysreg_s(SYS_FPMR));
 
+	if (system_supports_sme())
+		__hyp_sme_restore_host();
+
 	if (system_supports_sve())
 		__hyp_sve_restore_host();
 	else
@@ -128,7 +220,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 
-	fpsimd_sve_flush();
+	fpsimd_sve_flush(host_vcpu);
 	flush_debug_state(hyp_vcpu);
 
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
@@ -223,10 +315,9 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
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

