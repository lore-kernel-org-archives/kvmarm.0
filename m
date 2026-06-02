Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7AF93E1717
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 15:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780413153; cv=none; b=GwR4VR7rGl5HXsj27BkVYJbBUUQ1NxluauV5rrrXgpv5EfZidRIpM0sRO9VYbqJ/gsvBXzf2NRRIM7LhnfXbO5GGFclLfDon/icjGq6WWXYa15eL2o52jyp63srCfDN6g49sJkcsKeeC/WvTZX9QmfFeaB9CjJimAKfpR/QmJtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780413153; c=relaxed/simple;
	bh=OY9i7ay3p55B4/+3DulJ4tcu/vx3uCe7E1SoixWhh74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oPivyfhtY50TKh5U8CsDmG+aNR9SwbV1MxA8/KXXZ5xeYtsoDlnHFDa/Uce5VjVFGNdivKG+OQk5Dl47Bf+qlBfRK39YoraymGLzxRBEW5pqdGZjengmA/GjoMCG/lU/pZiLuHn3bcfLtBy0gkp8ebLH94ZzrYAPOWiD9iKvK04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kkImodyq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kkImodyq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 698283573;
	Tue,  2 Jun 2026 08:12:26 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 004133F7D8;
	Tue,  2 Jun 2026 08:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780413151; bh=OY9i7ay3p55B4/+3DulJ4tcu/vx3uCe7E1SoixWhh74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkImodyqds3zvbV8M/u2mgfMDzKMbxm8PwZ5jJHVrxf8EiM0fW35bWpXH5nT9mCNe
	 nNw+dT0hEi1unk8aywIpGedYVpc3yv1RNZ7AJ+7Y2+Z2dIsqSUEiHahdFsTlUiDmEX
	 hbWfV7L2gRJ895KuxkTBxLdsluWdFL9vXw6dLUY8=
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
	vladimir.murzin@arm.com,
	will@kernel.org
Subject: [PATCH v3 13/18] arm64: fpsimd: Use opaque type for SVE state
Date: Tue,  2 Jun 2026 16:11:45 +0100
Message-Id: <20260602151150.925126-14-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260602151150.925126-1-mark.rutland@arm.com>
References: <20260602151150.925126-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the SVE state size can vary at runtime, we don't have a concrete type
for the in-memory SVE state, and pass this around using a pointer to
void. The functions which save/restore the SVE state have a very unusual
calling convention, expecting a pointer to the FFR *in the middle of*
the in-memory SVE state, which is also passed as a pointer to void.
Passing a pointer to the FFR also requires that callers find the live VL
and perform some arithmetic, which callers implement differently.

Using pointer to void means that it's very easy to introduce errors that
cannot be caught by the compiler (e.g. as 'void **' can be assigned to
'void *'). In general this is unnecessarily confusing and fragile.

Improve this by adding an opaque 'struct arm64_sve_state', and
consistently passing a pointer to this, performing the necessary
offsetting *within* the save/restore functions.

For the moment, the offsetting is performed in a new '_sve_pffr'
assembly macro, using the ADDVL and ADDPL instructions. These add a
multiple of the live vector length and predicate length respectively.
The ADDVL immediate range cannot encode 32, so this is split into two
increments of 16.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h         | 24 +++---------------------
 arch/arm64/include/asm/fpsimdmacros.h   |  9 +++++++++
 arch/arm64/include/asm/kvm_host.h       |  8 ++------
 arch/arm64/include/asm/kvm_hyp.h        |  4 ++--
 arch/arm64/include/asm/processor.h      |  4 +++-
 arch/arm64/kernel/fpsimd.c              | 21 ++++++++++-----------
 arch/arm64/kvm/arm.c                    |  4 ++--
 arch/arm64/kvm/guest.c                  |  4 ++--
 arch/arm64/kvm/hyp/include/hyp/switch.h |  8 +++-----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  7 +++----
 arch/arm64/kvm/hyp/nvhe/setup.c         |  2 +-
 11 files changed, 40 insertions(+), 55 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 19b373ad0ebf7..581661a759a3f 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -162,7 +162,7 @@ extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
 
 struct cpu_fp_state {
 	struct user_fpsimd_state *st;
-	void *sve_state;
+	struct arm64_sve_state *sve_state;
 	void *sme_state;
 	u64 *svcr;
 	u64 *fpmr;
@@ -195,24 +195,6 @@ extern void task_smstop_sm(struct task_struct *task);
 /* Maximum VL that SVE/SME VL-agnostic software can transparently support */
 #define VL_ARCH_MAX 0x100
 
-/* Offset of FFR in the SVE register dump */
-static inline size_t sve_ffr_offset(int vl)
-{
-	return SVE_SIG_FFR_OFFSET(sve_vq_from_vl(vl)) - SVE_SIG_REGS_OFFSET;
-}
-
-static inline void *sve_pffr(struct thread_struct *thread)
-{
-	unsigned int vl;
-
-	if (system_supports_sme() && thread_sm_enabled(thread))
-		vl = thread_get_sme_vl(thread);
-	else
-		vl = thread_get_sve_vl(thread);
-
-	return (char *)thread->sve_state + sve_ffr_offset(vl);
-}
-
 static inline void *thread_zt_state(struct thread_struct *thread)
 {
 	/* The ZT register state is stored immediately after the ZA state */
@@ -233,8 +215,8 @@ static inline unsigned int sve_get_vl(void)
 	return vl;
 }
 
-extern void sve_save_state(void *state, int save_ffr);
-extern void sve_load_state(void const *state, int restore_ffr);
+extern void sve_save_state(struct arm64_sve_state *state, int save_ffr);
+extern void sve_load_state(const struct arm64_sve_state *state, int restore_ffr);
 extern void sve_flush_live(bool flush_ffr, unsigned long vq_minus_1);
 extern void sme_save_state(void *state, int zt);
 extern void sme_load_state(void const *state, int zt);
diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
index b486c6399bb4e..e613dc94dc357 100644
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ b/arch/arm64/include/asm/fpsimdmacros.h
@@ -177,7 +177,15 @@
 		_sve_wrffr	0
 .endm
 
+.macro _sve_pffr ptr
+	.arch_extension sve
+	addvl	\ptr, \ptr, #16
+	addvl	\ptr, \ptr, #16
+	addpl	\ptr, \ptr, #16
+.endm
+
 .macro sve_save nxbase, save_ffr
+		_sve_pffr	x\nxbase
  _for n, 0, 31,	_sve_str_v	\n, \nxbase, \n - 34
  _for n, 0, 15,	_sve_str_p	\n, \nxbase, \n - 16
 		cbz		\save_ffr, 921f
@@ -191,6 +199,7 @@
 .endm
 
 .macro sve_load nxbase, restore_ffr
+		_sve_pffr	x\nxbase
  _for n, 0, 31,	_sve_ldr_v	\n, \nxbase, \n - 34
 		cbz		\restore_ffr, 921f
 		_sve_ldr_p	0, \nxbase
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ae24617380b8f..6c75dc8932c52 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -759,7 +759,7 @@ struct kvm_host_data {
 	 * Hyp VA.
 	 * sve_regs is only used in pKVM and if system_supports_sve().
 	 */
-	u8	*sve_regs;
+	struct arm64_sve_state *sve_regs;
 
 	/* Ownership of the FP regs */
 	enum {
@@ -853,7 +853,7 @@ struct kvm_vcpu_arch {
 	 * floating point code saves the register state of a task it
 	 * records which view it saved in fp_type.
 	 */
-	void *sve_state;
+	struct arm64_sve_state *sve_state;
 	enum fp_type fp_type;
 	unsigned int sve_max_vl;
 
@@ -1097,10 +1097,6 @@ struct kvm_vcpu_arch {
 #define NESTED_SERROR_PENDING	__vcpu_single_flag(sflags, BIT(8))
 
 
-/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
-#define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
-			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
-
 #define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
 
 #define vcpu_sve_zcr_elx(vcpu)						\
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 8c4602c8f4356..190c256e34c03 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -121,8 +121,8 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu);
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
 #endif
 
-void __sve_save_state(void *sve, int save_ffr);
-void __sve_restore_state(void *sve, int restore_ffr);
+void __sve_save_state(struct arm64_sve_state *sve, int save_ffr);
+void __sve_restore_state(struct arm64_sve_state *sve, int restore_ffr);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index e30c4c8e3a7a7..96c0c30eac50f 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -130,6 +130,8 @@ enum fp_type {
 	FP_STATE_SVE,
 };
 
+struct arm64_sve_state;		/* Opaque type */
+
 struct cpu_context {
 	unsigned long x19;
 	unsigned long x20;
@@ -164,7 +166,7 @@ struct thread_struct {
 
 	enum fp_type		fp_type;	/* registers FPSIMD or SVE? */
 	unsigned int		fpsimd_cpu;
-	void			*sve_state;	/* SVE registers, if any */
+	struct arm64_sve_state	*sve_state;	/* SVE registers, if any */
 	void			*sme_state;	/* ZA and ZT state, if any */
 	unsigned int		vl[ARM64_VEC_MAX];	/* vector length */
 	unsigned int		vl_onexec[ARM64_VEC_MAX]; /* vl after next exec */
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 9806fea8fea7c..0da2f75de5dde 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -425,8 +425,7 @@ static void task_fpsimd_load(void)
 
 	if (restore_sve_regs) {
 		WARN_ON_ONCE(current->thread.fp_type != FP_STATE_SVE);
-		sve_load_state(sve_pffr(&current->thread),
-			       restore_ffr);
+		sve_load_state(current->thread.sve_state, restore_ffr);
 		fpsimd_load_common(&current->thread.uw.fpsimd_state);
 	} else {
 		WARN_ON_ONCE(current->thread.fp_type != FP_STATE_FPSIMD);
@@ -507,9 +506,7 @@ static void fpsimd_save_user_state(void)
 			return;
 		}
 
-		sve_save_state((char *)last->sve_state +
-					sve_ffr_offset(vl),
-			       save_ffr);
+		sve_save_state(last->sve_state, save_ffr);
 		fpsimd_save_common(last->st);
 		*last->fp_type = FP_STATE_SVE;
 	} else {
@@ -641,7 +638,8 @@ static __uint128_t arm64_cpu_to_le128(__uint128_t x)
 
 #define arm64_le128_to_cpu(x) arm64_cpu_to_le128(x)
 
-static void __fpsimd_to_sve(void *sst, struct user_fpsimd_state const *fst,
+static void __fpsimd_to_sve(struct arm64_sve_state *sst,
+			    struct user_fpsimd_state const *fst,
 			    unsigned int vq)
 {
 	unsigned int i;
@@ -668,7 +666,7 @@ static void __fpsimd_to_sve(void *sst, struct user_fpsimd_state const *fst,
 static inline void fpsimd_to_sve(struct task_struct *task)
 {
 	unsigned int vq;
-	void *sst = task->thread.sve_state;
+	struct arm64_sve_state *sst = task->thread.sve_state;
 	struct user_fpsimd_state const *fst = &task->thread.uw.fpsimd_state;
 
 	if (!system_supports_sve() && !system_supports_sme())
@@ -692,7 +690,7 @@ static inline void fpsimd_to_sve(struct task_struct *task)
 static inline void sve_to_fpsimd(struct task_struct *task)
 {
 	unsigned int vq, vl;
-	void const *sst = task->thread.sve_state;
+	const struct arm64_sve_state *sst = task->thread.sve_state;
 	struct user_fpsimd_state *fst = &task->thread.uw.fpsimd_state;
 	unsigned int i;
 	__uint128_t const *p;
@@ -791,7 +789,7 @@ void fpsimd_sync_from_effective_state(struct task_struct *task)
 void fpsimd_sync_to_effective_state_zeropad(struct task_struct *task)
 {
 	unsigned int vq;
-	void *sst = task->thread.sve_state;
+	struct arm64_sve_state *sst = task->thread.sve_state;
 	struct user_fpsimd_state const *fst = &task->thread.uw.fpsimd_state;
 
 	if (task->thread.fp_type != FP_STATE_SVE)
@@ -809,7 +807,8 @@ static int change_live_vector_length(struct task_struct *task,
 {
 	unsigned int sve_vl = task_get_sve_vl(task);
 	unsigned int sme_vl = task_get_sme_vl(task);
-	void *sve_state = NULL, *sme_state = NULL;
+	struct arm64_sve_state *sve_state = NULL;
+	void *sme_state = NULL;
 
 	if (type == ARM64_VEC_SME)
 		sme_vl = vl;
@@ -1645,7 +1644,7 @@ static void fpsimd_flush_thread_vl(enum vec_type type)
 
 void fpsimd_flush_thread(void)
 {
-	void *sve_state = NULL;
+	struct arm64_sve_state *sve_state = NULL;
 	void *sme_state = NULL;
 
 	if (!system_supports_fpsimd())
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f9fc85a0344e1..361bc0379feba 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2499,7 +2499,7 @@ static void __init teardown_hyp_mode(void)
 			continue;
 
 		if (free_sve) {
-			u8 *sve_regs;
+			struct arm64_sve_state *sve_regs;
 
 			sve_regs = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_regs;
 			free_pages((unsigned long) sve_regs, pkvm_host_sve_state_order());
@@ -2648,7 +2648,7 @@ static void finalize_init_hyp_mode(void)
 
 	if (system_supports_sve() && is_protected_kvm_enabled()) {
 		for_each_possible_cpu(cpu) {
-			u8 *sve_regs;
+			struct arm64_sve_state *sve_regs;
 
 			sve_regs = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_regs;
 			per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_regs =
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 332c453b87cf8..b01d6622b8720 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -500,7 +500,7 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (!kvm_arm_vcpu_sve_finalized(vcpu))
 		return -EPERM;
 
-	if (copy_to_user(uptr, vcpu->arch.sve_state + region.koffset,
+	if (copy_to_user(uptr, (void *)vcpu->arch.sve_state + region.koffset,
 			 region.klen) ||
 	    clear_user(uptr + region.klen, region.upad))
 		return -EFAULT;
@@ -526,7 +526,7 @@ static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (!kvm_arm_vcpu_sve_finalized(vcpu))
 		return -EPERM;
 
-	if (copy_from_user(vcpu->arch.sve_state + region.koffset, uptr,
+	if (copy_from_user((void *)vcpu->arch.sve_state + region.koffset, uptr,
 			   region.klen))
 		return -EFAULT;
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index aaa43554fd8e6..ee366a536c77b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -467,8 +467,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	 * vCPU. Start off with the max VL so we can load the SVE state.
 	 */
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
-	__sve_restore_state(vcpu_sve_pffr(vcpu),
-			    true);
+	__sve_restore_state(kern_hyp_va(vcpu->arch.sve_state), true);
 	fpsimd_load_common(&vcpu->arch.ctxt.fp_regs);
 
 	/*
@@ -485,12 +484,11 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 static inline void __hyp_sve_save_host(void)
 {
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
-	u8 *sve_regs = *host_data_ptr(sve_regs);
+	struct arm64_sve_state *sve_regs = *host_data_ptr(sve_regs);
 
 	ctxt_sys_reg(hctxt, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
-	__sve_save_state(sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
-			 true);
+	__sve_save_state(sve_regs, true);
 	fpsimd_save_common(&hctxt->fp_regs);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 627762ed7327f..b7d6faf07f71e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -35,7 +35,7 @@ static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
 	 */
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
-	__sve_save_state(vcpu_sve_pffr(vcpu), true);
+	__sve_save_state(kern_hyp_va(vcpu->arch.sve_state), true);
 	fpsimd_save_common(&vcpu->arch.ctxt.fp_regs);
 	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
 }
@@ -43,7 +43,7 @@ static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 static void __hyp_sve_restore_host(void)
 {
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
-	u8 *sve_regs = *host_data_ptr(sve_regs);
+	struct arm64_sve_state *sve_regs = *host_data_ptr(sve_regs);
 
 	/*
 	 * On saving/restoring host sve state, always use the maximum VL for
@@ -55,8 +55,7 @@ static void __hyp_sve_restore_host(void)
 	 * need to be revisited.
 	 */
 	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
-	__sve_restore_state(sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
-			    true);
+	__sve_restore_state(sve_regs, true);
 	fpsimd_load_common(&hctxt->fp_regs);
 	write_sysreg_el1(ctxt_sys_reg(hctxt, ZCR_EL1), SYS_ZCR);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index cdaf53c833409..75b00c3233102 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -82,7 +82,7 @@ static int pkvm_create_host_sve_mappings(void)
 
 	for (i = 0; i < hyp_nr_cpus; i++) {
 		struct kvm_host_data *host_data = per_cpu_ptr(&kvm_host_data, i);
-		u8 *sve_regs = host_data->sve_regs;
+		struct arm64_sve_state *sve_regs = host_data->sve_regs;
 
 		start = kern_hyp_va(sve_regs);
 		end = start + PAGE_ALIGN(pkvm_host_sve_state_size());
-- 
2.30.2

