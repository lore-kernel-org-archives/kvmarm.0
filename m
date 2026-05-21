Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E977C211A28
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369991; cv=none; b=grevHaN47t26FNpFHaLxUn5ol2tY5/7rhR2VTBYKH9t9k2I1bW/OpxbJLRRQb9k3k3hMiDKHJy0Oj0PpfUuquB8B2Vg0QOgSHkectutN6hMHFunXY4OEacp8U+g9l5WgDSYtCTqwn/wZNd2z1w+HyLZsLo3jKYQgEq7gFtY4BnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369991; c=relaxed/simple;
	bh=NXucpzrzT0YGDeKLiVImvtG3QdlslUuVBYSFfRXdGPA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Oa5AymicY7UKnE6e5NkhAx4dzze2u4OapvRxbGf8XuVaOeK+K4tOU7kjKbcuioLSHjeb6DTSY1SsOile6hi8oVfGY/KjDMIVETsV3z9qEot80HgWOULp5vgqtzVtrYBS0+n1n5L8pYzgNKOYgTex0cc2d1KKZvRu5Tf1sMULmuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jlexyaTZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jlexyaTZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B0FC1C00;
	Thu, 21 May 2026 06:26:24 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 399973F7B4;
	Thu, 21 May 2026 06:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779369989; bh=NXucpzrzT0YGDeKLiVImvtG3QdlslUuVBYSFfRXdGPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlexyaTZFZIYh4h4bFt5pmj4kN9KMO1SMAhukPucd77bBSY1Jc6Gaj7hJxoVgZgUC
	 NHgyKMIviwwjMBu+BWa2cyMoz9MdhbYMSU1I2g7ZkQI36LBtQ4rJ5xYeZTnsCYvln+
	 xK611hTW7BFkUeUA9W5wrbRKGGRUpefukT6ZDABU=
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 11/18] arm64: fpsimd: Split FPSR/FPCR from SVE save/restore
Date: Thu, 21 May 2026 14:25:49 +0100
Message-Id: <20260521132556.584676-12-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260521132556.584676-1-mark.rutland@arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Regardless of whether the vector registers are saved in FPSIMD or SVE
format, we store FPSR and FPCR in user_fpsimd_state::{fpsr,fpcr}.

For historical reasons, the functions which save/restore SVE context
take a pointer to user_fpsimd_state::fpsr, and use this to access both
user_fpsimd_state::fpsr and user_fpsimd_state::fpcr. This is
unnecessarily fragile.

Move the save/restore of FPSR and FPCR into separate helper functions
which take a pointer to user_fpsimd_state. I've used read_sysreg_s() and
write_sysreg_s() as contemporary versions of LLVM will refuse to
directly assemble accesses to FPCR or FPSR unless the "fp" arch
extension is enabled.

Note that the SVE assembly sequence for restoring FPCR uses an
unconditional write to FPCR. The plain FPSIMD assembly sequence has used
a conditional write to FPCR since 2014 in commit:

  5959e25729a5 ("arm64: fpsimd: avoid restoring fpcr if the contents haven't change")

... but this was not followed for the SVE restore assembly implemented
in 2017 in commit:

  1fc5dce78ad1 ("arm64/sve: Low-level SVE architectural state manipulation functions")

... so I've assumed that this doesn't actually matter in practice, and
implemented the C version matching the existing SVE assembly.

For the moment, fpsimd_save_state() and fpsimd_load_state() are left
as-is with their own logic to save/restore FPSR and FPCR. This will be
unified in subsequent patches.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h         | 17 ++++++++++++++---
 arch/arm64/include/asm/fpsimdmacros.h   | 13 ++-----------
 arch/arm64/include/asm/kvm_hyp.h        |  4 ++--
 arch/arm64/kernel/entry-fpsimd.S        | 10 ++++------
 arch/arm64/kernel/fpsimd.c              |  5 +++--
 arch/arm64/kvm/hyp/fpsimd.S             |  4 ++--
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  5 +++--
 8 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 36cf528e64971..6fd5cdf5e5f17 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -74,6 +74,18 @@ static inline void cpacr_restore(unsigned long cpacr)
 
 struct task_struct;
 
+static inline void fpsimd_save_common(struct user_fpsimd_state *state)
+{
+	state->fpsr = read_sysreg_s(SYS_FPSR);
+	state->fpcr = read_sysreg_s(SYS_FPCR);
+}
+
+static inline void fpsimd_load_common(const struct user_fpsimd_state *state)
+{
+	write_sysreg_s(state->fpsr, SYS_FPSR);
+	write_sysreg_s(state->fpcr, SYS_FPCR);
+}
+
 extern void fpsimd_save_state(struct user_fpsimd_state *state);
 extern void fpsimd_load_state(struct user_fpsimd_state *state);
 
@@ -157,9 +169,8 @@ static inline unsigned int sve_get_vl(void)
 	return vl;
 }
 
-extern void sve_save_state(void *state, u32 *pfpsr, int save_ffr);
-extern void sve_load_state(void const *state, u32 const *pfpsr,
-			   int restore_ffr);
+extern void sve_save_state(void *state, int save_ffr);
+extern void sve_load_state(void const *state, int restore_ffr);
 extern void sve_flush_live(bool flush_ffr, unsigned long vq_minus_1);
 extern void sme_save_state(void *state, int zt);
 extern void sme_load_state(void const *state, int zt);
diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
index d75c9d4c9989b..c79ae7ec1ff05 100644
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ b/arch/arm64/include/asm/fpsimdmacros.h
@@ -235,7 +235,7 @@
 		_sve_wrffr	0
 .endm
 
-.macro sve_save nxbase, xpfpsr, save_ffr, nxtmp
+.macro sve_save nxbase, save_ffr
  _for n, 0, 31,	_sve_str_v	\n, \nxbase, \n - 34
  _for n, 0, 15,	_sve_str_p	\n, \nxbase, \n - 16
 		cbz		\save_ffr, 921f
@@ -246,24 +246,15 @@
 922:
 		_sve_str_p	0, \nxbase
 		_sve_ldr_p	0, \nxbase, -16
-		mrs		x\nxtmp, fpsr
-		str		w\nxtmp, [\xpfpsr]
-		mrs		x\nxtmp, fpcr
-		str		w\nxtmp, [\xpfpsr, #4]
 .endm
 
-.macro sve_load nxbase, xpfpsr, restore_ffr, nxtmp
+.macro sve_load nxbase, restore_ffr
  _for n, 0, 31,	_sve_ldr_v	\n, \nxbase, \n - 34
 		cbz		\restore_ffr, 921f
 		_sve_ldr_p	0, \nxbase
 		_sve_wrffr	0
 921:
  _for n, 0, 15,	_sve_ldr_p	\n, \nxbase, \n - 16
-
-		ldr		w\nxtmp, [\xpfpsr]
-		msr		fpsr, x\nxtmp
-		ldr		w\nxtmp, [\xpfpsr, #4]
-		msr		fpcr, x\nxtmp
 .endm
 
 .macro sme_save_za nxbase, xvl, nw
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 8d06b62e7188c..0030cc1b52197 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,8 +123,8 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
-void __sve_save_state(void *sve_pffr, u32 *fpsr, int save_ffr);
-void __sve_restore_state(void *sve_pffr, u32 *fpsr, int restore_ffr);
+void __sve_save_state(void *sve, int save_ffr);
+void __sve_restore_state(void *sve, int restore_ffr);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kernel/entry-fpsimd.S b/arch/arm64/kernel/entry-fpsimd.S
index 7f2d31dff8c17..83fe9c32bbd1c 100644
--- a/arch/arm64/kernel/entry-fpsimd.S
+++ b/arch/arm64/kernel/entry-fpsimd.S
@@ -37,11 +37,10 @@ SYM_FUNC_END(fpsimd_load_state)
  * Save the SVE state
  *
  * x0 - pointer to buffer for state
- * x1 - pointer to storage for FPSR
- * x2 - Save FFR if non-zero
+ * x1 - Save FFR if non-zero
  */
 SYM_FUNC_START(sve_save_state)
-	sve_save 0, x1, x2, 3
+	sve_save 0, x1
 	ret
 SYM_FUNC_END(sve_save_state)
 
@@ -49,11 +48,10 @@ SYM_FUNC_END(sve_save_state)
  * Load the SVE state
  *
  * x0 - pointer to buffer for state
- * x1 - pointer to storage for FPSR
- * x2 - Restore FFR if non-zero
+ * x1 - Restore FFR if non-zero
  */
 SYM_FUNC_START(sve_load_state)
-	sve_load 0, x1, x2, 4
+	sve_load 0, x1
 	ret
 SYM_FUNC_END(sve_load_state)
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 2578c2372c89e..9806fea8fea7c 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -426,8 +426,8 @@ static void task_fpsimd_load(void)
 	if (restore_sve_regs) {
 		WARN_ON_ONCE(current->thread.fp_type != FP_STATE_SVE);
 		sve_load_state(sve_pffr(&current->thread),
-			       &current->thread.uw.fpsimd_state.fpsr,
 			       restore_ffr);
+		fpsimd_load_common(&current->thread.uw.fpsimd_state);
 	} else {
 		WARN_ON_ONCE(current->thread.fp_type != FP_STATE_FPSIMD);
 		fpsimd_load_state(&current->thread.uw.fpsimd_state);
@@ -509,7 +509,8 @@ static void fpsimd_save_user_state(void)
 
 		sve_save_state((char *)last->sve_state +
 					sve_ffr_offset(vl),
-			       &last->st->fpsr, save_ffr);
+			       save_ffr);
+		fpsimd_save_common(last->st);
 		*last->fp_type = FP_STATE_SVE;
 	} else {
 		fpsimd_save_state(last->st);
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index 6e16cbfc5df27..8575e32977d19 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -21,11 +21,11 @@ SYM_FUNC_START(__fpsimd_restore_state)
 SYM_FUNC_END(__fpsimd_restore_state)
 
 SYM_FUNC_START(__sve_restore_state)
-	sve_load 0, x1, x2, 3
+	sve_load 0, x1
 	ret
 SYM_FUNC_END(__sve_restore_state)
 
 SYM_FUNC_START(__sve_save_state)
-	sve_save 0, x1, x2, 3
+	sve_save 0, x1
 	ret
 SYM_FUNC_END(__sve_save_state)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6512dd3f75ae4..eb76a863ebb84 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -468,8 +468,8 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	 */
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
-			    &vcpu->arch.ctxt.fp_regs.fpsr,
 			    true);
+	fpsimd_load_common(&vcpu->arch.ctxt.fp_regs);
 
 	/*
 	 * The effective VL for a VM could differ from the max VL when running a
@@ -490,8 +490,8 @@ static inline void __hyp_sve_save_host(void)
 	ctxt_sys_reg(hctxt, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
 	__sve_save_state(sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
-			 &hctxt->fp_regs.fpsr,
 			 true);
+	fpsimd_save_common(&hctxt->fp_regs);
 }
 
 static inline void fpsimd_lazy_switch_to_guest(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 04a6d2e0ea73f..0be4577a67e7b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -35,7 +35,8 @@ static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
 	 */
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
-	__sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fpsr, true);
+	__sve_save_state(vcpu_sve_pffr(vcpu), true);
+	fpsimd_save_common(&vcpu->arch.ctxt.fp_regs);
 	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
 }
 
@@ -55,8 +56,8 @@ static void __hyp_sve_restore_host(void)
 	 */
 	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
-			    &hctxt->fp_regs.fpsr,
 			    true);
+	fpsimd_load_common(&hctxt->fp_regs);
 	write_sysreg_el1(ctxt_sys_reg(hctxt, ZCR_EL1), SYS_ZCR);
 }
 
-- 
2.30.2

