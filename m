Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FB0C433E6
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 15:50:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 034A22083E
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 15:50:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 034A22083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 482224B2C3;
	Tue, 26 Jan 2021 10:50:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id unmBrOW9JPTW; Tue, 26 Jan 2021 10:50:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E45D94B2EA;
	Tue, 26 Jan 2021 10:50:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6CD14B2D9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 10:50:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CXHCr+5XfslQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 10:50:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F4B94B2C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 10:50:13 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22C0E31B;
 Tue, 26 Jan 2021 07:50:13 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BD9D3F66E;
 Tue, 26 Jan 2021 07:50:12 -0800 (PST)
Date: Tue, 26 Jan 2021 15:49:45 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] kvm: arm64: Add SVE support for nVHE.
Message-ID: <20210126154935.GA13952@arm.com>
References: <20210122010707.2456982-1-daniel.kiss@arm.com>
 <eee98e0f59f75960e30233d4bde54459@misterjones.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <eee98e0f59f75960e30233d4bde54459@misterjones.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Mark.Brown@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Daniel Kiss <daniel.kiss@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Jan 22, 2021 at 06:21:21PM +0000, Marc Zyngier wrote:
> Daniel,
> 
> Please consider cc'ing the maintainer (me) as well as the KVM/arm64
> reviewers (Julien, James, Suzuki) and the kvmarm list (all now Cc'd).
> 
> On 2021-01-22 01:07, Daniel Kiss wrote:
> >CPUs that support SVE are architecturally required to support the
> >Virtualization Host Extensions (VHE), so far the kernel supported
> >SVE alongside KVM with VHE enabled. In same cases it is desired to
> >run nVHE config even when VHE is available.
> >This patch add support for SVE for nVHE configuration too.
> >
> >In case of nVHE the system registers behave a bit differently.
> >ZCR_EL2 defines the maximum vector length that could be set in ZCR_EL1
> >effectively. To limit the vector length for the guest the ZCR_EL2 need
> >to be set accordingly therefore it become part of the context.
> 
> Not really. It's just part of the *hypervisor* state for this guest,
> and not part of the guest state. Not different from HCR_EL2, for example.

Also, ZCR_EL2 doesn't affect what can be written in ZCR_EL1, so this
might be reworded to say that it just limits the effective vector length
available to the guest.

> >The sve_state will be loaded in EL2 so it need to be mapped and during
> >the load ZCR_EL2 will control the vector length.
> >Trap control is similar to the VHE case except the bit values are the
> >opposite. ZCR_EL1 access trapping with VHE is ZEN value 0 but in case of
> >nVHE the TZ need to be set 1 to trigger the exception. Trap control need
> >to be respected during the context switch even in EL2.
> 
> Isn't that exactly the same as FPSIMD accesses?

(Yes, this isn't really new.  It might be best to let the code speak for
itself on that point, rather than trying to explain it in the commit
message.)

> 
> >
> >Tested on FVP with a Linux guest VM that run with a different VL than
> >the host system.
> >
> >This patch requires sve_set_vq from
> > - arm64/sve: Rework SVE trap access to minimise memory access
> 
> Care to add a pointer to this patch? This also shouldn't be part
> of the commit message. When you repost it, please include the
> other patch as a series unless it has already been merged by then.
> 
> >
> >Signed-off-by: Daniel Kiss <daniel.kiss@arm.com>
> >---
> > arch/arm64/Kconfig                         |  7 ----
> > arch/arm64/include/asm/fpsimd.h            |  4 ++
> > arch/arm64/include/asm/fpsimdmacros.h      | 38 +++++++++++++++++
> > arch/arm64/include/asm/kvm_host.h          | 19 +++------
> > arch/arm64/kernel/fpsimd.c                 | 11 +++++
> > arch/arm64/kvm/arm.c                       |  5 ---
> > arch/arm64/kvm/fpsimd.c                    | 22 +++++++---
> > arch/arm64/kvm/hyp/fpsimd.S                | 15 +++++++
> > arch/arm64/kvm/hyp/include/hyp/switch.h    | 48 ++++++++++++----------
> > arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 26 ++++++++++++
> > arch/arm64/kvm/hyp/nvhe/switch.c           |  6 ++-
> > arch/arm64/kvm/reset.c                     |  8 ++--
> > 12 files changed, 153 insertions(+), 56 deletions(-)
> >
> >diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >index a6b5b7ef40ae..f17ab095e99f 100644
> >--- a/arch/arm64/Kconfig
> >+++ b/arch/arm64/Kconfig
> >@@ -1692,7 +1692,6 @@ endmenu
> > config ARM64_SVE
> > 	bool "ARM Scalable Vector Extension support"
> > 	default y
> >-	depends on !KVM || ARM64_VHE
> > 	help
> > 	  The Scalable Vector Extension (SVE) is an extension to the AArch64
> > 	  execution state which complements and extends the SIMD functionality
> >@@ -1721,12 +1720,6 @@ config ARM64_SVE
> > 	  booting the kernel.  If unsure and you are not observing these
> > 	  symptoms, you should assume that it is safe to say Y.
> >
> >-	  CPUs that support SVE are architecturally required to support the
> >-	  Virtualization Host Extensions (VHE), so the kernel makes no
> >-	  provision for supporting SVE alongside KVM without VHE enabled.
> >-	  Thus, you will need to enable CONFIG_ARM64_VHE if you want to support
> >-	  KVM in the same kernel image.
> >-
> > config ARM64_MODULE_PLTS
> > 	bool "Use PLTs to allow module memory to spill over into vmalloc area"
> > 	depends on MODULES
> >diff --git a/arch/arm64/include/asm/fpsimd.h
> >b/arch/arm64/include/asm/fpsimd.h
> >index e60aa4ebb351..e7889f4c5cef 100644
> >--- a/arch/arm64/include/asm/fpsimd.h
> >+++ b/arch/arm64/include/asm/fpsimd.h
> >@@ -69,6 +69,10 @@ static inline void *sve_pffr(struct thread_struct
> >*thread)
> > extern void sve_save_state(void *state, u32 *pfpsr);
> > extern void sve_load_state(void const *state, u32 const *pfpsr,
> > 			   unsigned long vq_minus_1);
> >+extern void sve_save_state_nvhe(void *state, u32 *pfpsr,
> >+			   unsigned long vq_minus_1);
> >+extern void sve_load_state_nvhe(void const *state, u32 const *pfpsr,
> >+			   unsigned long vq_minus_1);
> 
> Why do we need two different entry points?
> 
> > extern void sve_flush_live(void);
> > extern void sve_load_from_fpsimd_state(struct user_fpsimd_state const
> >*state,
> > 				       unsigned long vq_minus_1);
> >diff --git a/arch/arm64/include/asm/fpsimdmacros.h
> >b/arch/arm64/include/asm/fpsimdmacros.h
> >index af43367534c7..3a18172ee4f6 100644
> >--- a/arch/arm64/include/asm/fpsimdmacros.h
> >+++ b/arch/arm64/include/asm/fpsimdmacros.h
> >@@ -205,6 +205,17 @@
> > 921:
> > .endm
> >
> >+/* Update ZCR_EL2.LEN with the new VQ */
> >+.macro sve_load_vq_nvhe xvqminus1, xtmp, xtmp2
> >+		mrs_s		\xtmp, SYS_ZCR_EL2
> >+		bic		\xtmp2, \xtmp, ZCR_ELx_LEN_MASK
> >+		orr		\xtmp2, \xtmp2, \xvqminus1
> >+		cmp		\xtmp2, \xtmp
> >+		b.eq		922f
> >+		msr_s		SYS_ZCR_EL2, \xtmp2	//self-synchronising
> >+922:
> >+.endm
> >+
> > /* Preserve the first 128-bits of Znz and zero the rest. */
> > .macro _sve_flush_z nz
> > 	_sve_check_zreg \nz
> >@@ -230,6 +241,20 @@
> > 		str		w\nxtmp, [\xpfpsr, #4]
> > .endm
> >
> >+.macro sve_save_nvhe nxbase, xpfpsr, xvqminus1, nxtmp, xtmp2
> >+		sve_load_vq_nvhe	\xvqminus1, x\nxtmp, \xtmp2
> >+ _for n, 0, 31,	_sve_str_v	\n, \nxbase, \n - 34
> >+ _for n, 0, 15,	_sve_str_p	\n, \nxbase, \n - 16
> >+		_sve_rdffr	0
> >+		_sve_str_p	0, \nxbase
> >+		_sve_ldr_p	0, \nxbase, -16
> >+
> >+		mrs		x\nxtmp, fpsr
> >+		str		w\nxtmp, [\xpfpsr]
> >+		mrs		x\nxtmp, fpcr
> >+		str		w\nxtmp, [\xpfpsr, #4]
> >+.endm
> 
> Please document what this macro does.
> 
> >+
> > .macro sve_load nxbase, xpfpsr, xvqminus1, nxtmp, xtmp2
> > 		sve_load_vq	\xvqminus1, x\nxtmp, \xtmp2
> >  _for n, 0, 31,	_sve_ldr_v	\n, \nxbase, \n - 34
> >@@ -242,3 +267,16 @@
> > 		ldr		w\nxtmp, [\xpfpsr, #4]
> > 		msr		fpcr, x\nxtmp
> > .endm
> >+
> >+.macro sve_load_nvhe nxbase, xpfpsr, xvqminus1, nxtmp, xtmp2
> >+		sve_load_vq_nvhe	\xvqminus1, x\nxtmp, \xtmp2
> >+ _for n, 0, 31,	_sve_ldr_v	\n, \nxbase, \n - 34
> >+		_sve_ldr_p	0, \nxbase
> >+		_sve_wrffr	0
> >+ _for n, 0, 15,	_sve_ldr_p	\n, \nxbase, \n - 16
> >+
> >+		ldr		w\nxtmp, [\xpfpsr]
> >+		msr		fpsr, x\nxtmp
> >+		ldr		w\nxtmp, [\xpfpsr, #4]
> >+		msr		fpcr, x\nxtmp
> >+.endm

These macros are virtually the same as some existing macros.  We don't
want to maintain this kind of thing in two places if we can avoid it --
can you try to keep them unified please?

> >diff --git a/arch/arm64/include/asm/kvm_host.h
> >b/arch/arm64/include/asm/kvm_host.h
> >index 0cd9f0f75c13..8bfac6f52858 100644
> >--- a/arch/arm64/include/asm/kvm_host.h
> >+++ b/arch/arm64/include/asm/kvm_host.h
> >@@ -137,6 +137,7 @@ enum vcpu_sysreg {
> > 	ACTLR_EL1,	/* Auxiliary Control Register */
> > 	CPACR_EL1,	/* Coprocessor Access Control */
> > 	ZCR_EL1,	/* SVE Control */
> >+	ZCR_EL2,	/* SVE Control */
> 
> No. This obviously isn't a guest register, and it has no purpose
> in this array.

Ack, the value in ZCR_EL2 should just be set based on
vcpu->arch.sve_max_vl, which is locked after kvm_arm_vcpu_finalize().
The guest can't change it, so we don't need to re-save this anywhere
when exiting back to the host: we just need to restore the host value.

We do need somewhere to save the host value for this register while the
guest is running, though.  The value is determined by
head.S:init_el2_nvhe() (in the __init_el2_nvhe_sve macro), and isn't
stored anywhere other than in ZCR_EL2 itself.  I feel it's better just
to save and restore that, rather than duplicating the logic that
determines what it should be for the host -- though obvioulsy it would
work either way.

> 
> > 	TTBR0_EL1,	/* Translation Table Base Register 0 */
> > 	TTBR1_EL1,	/* Translation Table Base Register 1 */
> > 	TCR_EL1,	/* Translation Control Register */
> >@@ -283,6 +284,7 @@ struct vcpu_reset_state {
> > struct kvm_vcpu_arch {
> > 	struct kvm_cpu_context ctxt;
> > 	void *sve_state;
> >+	void *sve_state_hyp;

[...]

> > 	unsigned int sve_max_vl;
> >
> > 	/* Stage 2 paging state used by the hardware on next switch */
> >@@ -386,6 +388,10 @@ struct kvm_vcpu_arch {
> > #define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) +
> >\
> > 				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
> >
> >+#define vcpu_sve_pffr_hyp(vcpu) \
> >+			((void *)((char *)((vcpu)->arch.sve_state_hyp) + \
> >+			sve_ffr_offset((vcpu)->arch.sve_max_vl)))
> 
> Why can't you have a single macro that embeds kern_hyp_va()?
> 
> >+
> > #define vcpu_sve_state_size(vcpu) ({					\
> > 	size_t __size_ret;						\
> > 	unsigned int __vcpu_vq;						\
> >@@ -579,19 +585,6 @@ static inline void
> >kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
> > 	ctxt_sys_reg(cpu_ctxt, MPIDR_EL1) = read_cpuid_mpidr();
> > }
> >
> >-static inline bool kvm_arch_requires_vhe(void)
> >-{
> >-	/*
> >-	 * The Arm architecture specifies that implementation of SVE
> >-	 * requires VHE also to be implemented.  The KVM code for arm64
> >-	 * relies on this when SVE is present:
> >-	 */
> >-	if (system_supports_sve())
> >-		return true;
> >-
> >-	return false;
> >-}
> >-
> > void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
> >
> > static inline void kvm_arch_hardware_unsetup(void) {}
> >diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> >index 062b21f30f94..1f94c5ca4943 100644
> >--- a/arch/arm64/kernel/fpsimd.c
> >+++ b/arch/arm64/kernel/fpsimd.c
> >@@ -308,6 +308,17 @@ static void fpsimd_save(void)
> >
> > 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
> > 		if (system_supports_sve() && test_thread_flag(TIF_SVE)) {
> >+
> >+			if (!has_vhe() && (sve_get_vl() != last->sve_vl)) {
> >+				/* last->sve_state could belong to a vcpu, nVHE
> >+				   case the context is loaded in EL2 where ZCR_EL2
> >+				   is used. In this context the ZCR_EL1 is used but
> >+				   it could be different because it was not
> >+				   set when the vcpu context is loaded. Let's set
> >+				   it to the guest's VL.
> >+				 */
> 
> Please use the kernel comment style.
> 
> >+				sve_set_vq(sve_vq_from_vl(last->sve_vl) - 1);
> >+			}

On the surface of it, this looks like it's in the wrong place -- there
shouldn't really be any need for KVM-specific hacks in the core context
switch code.

Thinking about this, don't we always save out any guest state in
kvm_arch_vcpu_put_fp(), no?  That code calls
fpsimd_save_and_flush_cpu_state(), so TIF_FOREIGN_FPSTATE should always
be set when reenabling preemption and exiting the KVM run loop.  The
core context switch code should never see dangling guest state.

There's potential for optimisation here -- we could avoid flushing the
guest state, but just save it.  This would allow the state to be reused
if the next user of FPSIMD/SVE on this cpu is the KVM run loop.  I
think we figured that the extra complexity wasn't worth it, since
exiting the guest is already costly and KVM does its best to avoid it
-- the additional cost of reloading the guest vector regs may therefore
not be worth caring about.

(Disclaimer -- my understanding of the code may be a bit out of date, so
shout if the above sounds suspicious!)


So in conclusion, actually I'm wondering whether we need to do anything
at all here.  Which is just as well, since fudging ZCR.LEN here would be
broken anyway: if it was already too small, the extra bits of the SVE
vector registers could have been thrown away by the hardware already.

> > 			if (WARN_ON(sve_get_vl() != last->sve_vl)) {
> > 				/*
> > 				 * Can't save the user regs, so current would
> >diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> >index c0ffb019ca8b..3d37f4ad2228 100644
> >--- a/arch/arm64/kvm/arm.c
> >+++ b/arch/arm64/kvm/arm.c
> >@@ -1749,11 +1749,6 @@ int kvm_arch_init(void *opaque)
> >
> > 	in_hyp_mode = is_kernel_in_hyp_mode();
> >
> >-	if (!in_hyp_mode && kvm_arch_requires_vhe()) {
> >-		kvm_pr_unimpl("CPU unsupported in non-VHE mode, not initializing\n");
> >-		return -ENODEV;
> >-	}
> >-
> > 	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
> > 	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
> > 		kvm_info("Guests without required CPU erratum workarounds can
> >deadlock system!\n" \
> >diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> >index 3e081d556e81..cfbc869caeeb 100644
> >--- a/arch/arm64/kvm/fpsimd.c
> >+++ b/arch/arm64/kvm/fpsimd.c
> >@@ -42,6 +42,15 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
> > 	if (ret)
> > 		goto error;
> >
> >+	if (!has_vhe() && vcpu->arch.sve_state) {
> >+		ret = create_hyp_mappings(vcpu->arch.sve_state,
> >+					vcpu->arch.sve_state +
> >+					SVE_SIG_REGS_SIZE(sve_vq_from_vl(vcpu->arch.sve_max_vl)),
> >+					PAGE_HYP);
> >+		if (ret)
> >+			goto error;
> >+		vcpu->arch.sve_state_hyp = kern_hyp_va(vcpu->arch.sve_state);
> 
> How useful is it to keep that duplicated pointer around, given that
> we can compute it on the fly at a very low cost?
> 
> >+	}
> > 	vcpu->arch.host_thread_info = kern_hyp_va(ti);
> > 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
> > error:
> >@@ -111,8 +120,9 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
> > 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> > 		fpsimd_save_and_flush_cpu_state();
> >
> >-		if (guest_has_sve)
> >+		if (guest_has_sve && has_vhe())
> > 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL12);
> >+

Spurious blank line?

> > 	} else if (host_has_sve) {
> > 		/*
> > 		 * The FPSIMD/SVE state in the CPU has not been touched, and we
> >@@ -121,10 +131,12 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
> > 		 * for EL0.  To avoid spurious traps, restore the trap state
> > 		 * seen by kvm_arch_vcpu_load_fp():
> > 		 */

With nVHE, the HYP exit code already restored CPACR_EL1, right?

Might be worth adding a sentence explaining why skipping this code for
nVHE is OK.

> >-		if (vcpu->arch.flags & KVM_ARM64_HOST_SVE_ENABLED)
> >-			sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
> >-		else
> >-			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
> >+		if (has_vhe()) {
> >+			if (vcpu->arch.flags & KVM_ARM64_HOST_SVE_ENABLED)
> >+				sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
> >+			else
> >+				sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
> >+		}
> > 	}
> >
> > 	update_thread_flag(TIF_SVE,
> >diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> >index 01f114aa47b0..15d47ebdd30a 100644
> >--- a/arch/arm64/kvm/hyp/fpsimd.S
> >+++ b/arch/arm64/kvm/hyp/fpsimd.S
> >@@ -6,6 +6,7 @@
> >
> > #include <linux/linkage.h>
> >
> >+#include <asm/assembler.h>
> > #include <asm/fpsimdmacros.h>
> >
> > 	.text
> >@@ -19,3 +20,17 @@ SYM_FUNC_START(__fpsimd_restore_state)
> > 	fpsimd_restore	x0, 1
> > 	ret
> > SYM_FUNC_END(__fpsimd_restore_state)
> >+
> >+#ifdef CONFIG_ARM64_SVE
> >+
> >+SYM_FUNC_START(sve_save_state_nvhe)
> >+	sve_save_nvhe 0, x1, x2, 3, x4
> >+	ret
> >+SYM_FUNC_END(sve_save_state_nvhe)
> >+
> >+SYM_FUNC_START(sve_load_state_nvhe)
> >+	sve_load_nvhe 0, x1, x2, 3, x4
> >+	ret
> >+SYM_FUNC_END(sve_load_state_nvhe)
> >+
> >+#endif
> >diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h
> >b/arch/arm64/kvm/hyp/include/hyp/switch.h
> >index 1f875a8f20c4..a14b0d92d9ca 100644
> >--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> >+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> >@@ -197,25 +197,18 @@ static inline bool __populate_fault_info(struct
> >kvm_vcpu *vcpu)
> > /* Check for an FPSIMD/SVE trap and handle as appropriate */
> > static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
> > {
> >-	bool vhe, sve_guest, sve_host;
> >+	bool sve_guest, sve_host;
> > 	u8 esr_ec;
> >
> > 	if (!system_supports_fpsimd())
> > 		return false;
> >
> >-	/*
> >-	 * Currently system_supports_sve() currently implies has_vhe(),
> >-	 * so the check is redundant. However, has_vhe() can be determined
> >-	 * statically and helps the compiler remove dead code.
> >-	 */
> >-	if (has_vhe() && system_supports_sve()) {
> >+	if (system_supports_sve()) {
> > 		sve_guest = vcpu_has_sve(vcpu);
> > 		sve_host = vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE;
> >-		vhe = true;
> > 	} else {
> > 		sve_guest = false;
> > 		sve_host = false;
> >-		vhe = has_vhe();
> > 	}
> >
> > 	esr_ec = kvm_vcpu_trap_get_class(vcpu);
> >@@ -229,8 +222,7 @@ static inline bool __hyp_handle_fpsimd(struct
> >kvm_vcpu *vcpu)
> > 			return false;
> >
> > 	/* Valid trap.  Switch the context: */
> >-
> >-	if (vhe) {
> >+	if (has_vhe()) {

You might still want to cache this.

There's no way to tell the compiler that consecutive checks on the same
static key yield the same result, so repeatedly calling has_vhe() may
emit a small amount of redundant code, IIUC.

> > 		u64 reg = read_sysreg(cpacr_el1) | CPACR_EL1_FPEN;
> >
> > 		if (sve_guest)
> >@@ -238,24 +230,30 @@ static inline bool __hyp_handle_fpsimd(struct
> >kvm_vcpu *vcpu)
> >
> > 		write_sysreg(reg, cpacr_el1);
> > 	} else {
> >-		write_sysreg(read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP,
> >-			     cptr_el2);
> >+		u64 reg = read_sysreg(cptr_el2) & ~CPTR_EL2_TFP ;

Spurious space before ;

Also, you changed ~(u64)CPTR_EL2_TFP to ~CPTR_EL2_TFP here.  Does it
make a difference?

> >+		if (sve_guest)
> >+			reg &= ~CPTR_EL2_TZ;

Same here.

> >+		write_sysreg(reg, cptr_el2);
> > 	}
> >
> > 	isb();
> >
> > 	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
> >-		/*
> >-		 * In the SVE case, VHE is assumed: it is enforced by
> >-		 * Kconfig and kvm_arch_init().
> >-		 */
> > 		if (sve_host) {
> > 			struct thread_struct *thread = container_of(
> > 				vcpu->arch.host_fpsimd_state,
> > 				struct thread_struct, uw.fpsimd_state);
> >+			if (has_vhe())
> >+				sve_save_state(sve_pffr(thread),
> >+						&vcpu->arch.host_fpsimd_state->fpsr);
> >+			else {
> >+				struct kvm_cpu_context *host_ctxt =
> >+					&this_cpu_ptr(&kvm_host_data)->host_ctxt;
> 
> Assignments on a single line please.
> 
> >+				sve_save_state_nvhe(sve_pffr(thread),
> >+						&vcpu->arch.host_fpsimd_state->fpsr,
> >+						ctxt_sys_reg(host_ctxt, ZCR_EL2));
> >+			}

Does this actually need to be different from the VHE case, if we just
leave ZCR_EL2 permanently set with the maxmium VL allowed for the guest?

> >
> >-			sve_save_state(sve_pffr(thread),
> >-				       &vcpu->arch.host_fpsimd_state->fpsr);
> > 		} else {
> > 			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
> > 		}
> >@@ -264,10 +262,18 @@ static inline bool __hyp_handle_fpsimd(struct
> >kvm_vcpu *vcpu)
> > 	}
> >
> > 	if (sve_guest) {
> >-		sve_load_state(vcpu_sve_pffr(vcpu),
> >+		if (has_vhe()) {
> >+			sve_load_state(vcpu_sve_pffr(vcpu),
> > 			       &vcpu->arch.ctxt.fp_regs.fpsr,
> > 			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
> >-		write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
> >+			write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
> >+		} else {
> >+			sve_load_state_nvhe(vcpu_sve_pffr_hyp(vcpu),
> >+			       &vcpu->arch.ctxt.fp_regs.fpsr,
> >+			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
> >+			write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL2), SYS_ZCR_EL2);
> 
> I think you really need to explain why you restore ZCR_EL2 here, and not
> ZCR_EL1.

Something doesn't smell quite right here.  ZCR_EL2.LEN determines how
regs are saved/restored, so for nVHE I think it needs to change as
follows:

 * In host, after saving guest SVE regs:

	ZCR_EL2.LEN = ZCR_ELx_LEN_MASK (from __init_el2_nvhe_sve)

 * Before saving the host SVE regs here:

	ZCR_EL2.LEN = host ZCR_EL1.LEN
(since the size and layout of current->thread.sve_state is VL dependent)

 * Before loading the guest SVE regs, and before running in the guest with
SVE untrapped:

	ZCR_EL2.LEN = sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1


I don't quite see how the code achieves this, though I might be missing
something.


The alternative would be to dump the registers in a common layout by
setting ZCR_EL2.LEN permanently ZCR_ELx_LEN_MASK except when actually
running the guest.  But that may tend to waste a bit of memory, and it
would be necessary to save the host regs in a side buffer and convert
them to host layout when exiting the guest.

This would avoid slowness arising from saving regs immediately after a
ZCR.LEN write, but would add complexity elsewhere.

> 
> >+
> >+		}
> > 	} else {
> > 		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
> > 	}
> >diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> >b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> >index cce43bfe158f..45c16b81b826 100644
> >--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> >+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> >@@ -46,6 +46,19 @@ static inline void __sysreg_save_el1_state(struct
> >kvm_cpu_context *ctxt)
> > 	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg_par();
> > 	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
> >
> >+	if (!has_vhe()) {
> >+		u64 reg = read_sysreg(cptr_el2);
> >+		if (reg & CPTR_EL2_TZ) {
> >+			write_sysreg(reg & ~CPTR_EL2_TZ, cptr_el2);
> >+			ctxt_sys_reg(ctxt, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL1);
> >+			ctxt_sys_reg(ctxt, ZCR_EL2) = read_sysreg_s(SYS_ZCR_EL2);
> >+			write_sysreg(reg, cptr_el2);
> >+		} else {
> >+			ctxt_sys_reg(ctxt, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL1);
> >+			ctxt_sys_reg(ctxt, ZCR_EL2) = read_sysreg_s(SYS_ZCR_EL2);
> 
> Why do you need to save ZCR_EL2? It cannot change behind your back, can it?
> Also, why aren't these registers saved lazily? If TZ is set, the guest
> cannot
> possibly have changed ZCR_EL1.
> 
> >+		}
> >+	}
> >+
> > 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
> > 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
> > 	ctxt_sys_reg(ctxt, SPSR_EL1)	= read_sysreg_el1(SYS_SPSR);
> >@@ -107,6 +120,19 @@ static inline void
> >__sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
> > 	write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1),	par_el1);
> > 	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1),	tpidr_el1);
> >
> >+	if (!has_vhe()) {
> >+		u64 reg = read_sysreg(cptr_el2);
> >+		if (reg & CPTR_EL2_TZ) {
> >+			write_sysreg(reg & ~CPTR_EL2_TZ, cptr_el2);
> >+			write_sysreg_s(ctxt_sys_reg(ctxt, ZCR_EL1), SYS_ZCR_EL1);
> >+			write_sysreg_s(ctxt_sys_reg(ctxt, ZCR_EL2), SYS_ZCR_EL2);
> >+			write_sysreg(reg, cptr_el2);
> 
> Same thing here. If TZ is set, there is no point in restoring these
> registers,
> and it should be delegated to the point where you actually restore the bulk
> of the SVE state.

Ack

> 
> >+		} else {
> >+			write_sysreg_s(ctxt_sys_reg(ctxt, ZCR_EL1), SYS_ZCR_EL1);
> >+			write_sysreg_s(ctxt_sys_reg(ctxt, ZCR_EL2), SYS_ZCR_EL2);
> >+		}
> >+	}
> >+
> > 	if (!has_vhe() &&
> > 	    cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT) &&
> > 	    ctxt->__hyp_running_vcpu) {
> >diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c
> >b/arch/arm64/kvm/hyp/nvhe/switch.c
> >index 8ae8160bc93a..bffd78203448 100644
> >--- a/arch/arm64/kvm/hyp/nvhe/switch.c
> >+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> >@@ -41,7 +41,11 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
> >
> > 	val = CPTR_EL2_DEFAULT;
> > 	val |= CPTR_EL2_TTA | CPTR_EL2_TZ | CPTR_EL2_TAM;
> >-	if (!update_fp_enabled(vcpu)) {
> >+
> >+	if (update_fp_enabled(vcpu)) {
> >+		if (vcpu_has_sve(vcpu))
> >+			val &= ~CPTR_EL2_TZ;
> >+	} else {
> 
> nit: please don't invert conditions like this.
> 
> > 		val |= CPTR_EL2_TFP;
> > 		__activate_traps_fpsimd32(vcpu);
> > 	}
> >diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> >index f32490229a4c..3c62fb10a3fe 100644
> >--- a/arch/arm64/kvm/reset.c
> >+++ b/arch/arm64/kvm/reset.c
> >@@ -127,10 +127,6 @@ static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
> > 	if (!system_supports_sve())
> > 		return -EINVAL;
> >
> >-	/* Verify that KVM startup enforced this when SVE was detected: */
> >-	if (WARN_ON(!has_vhe()))
> >-		return -EINVAL;
> >-
> > 	vcpu->arch.sve_max_vl = kvm_sve_max_vl;
> >
> > 	/*
> >@@ -168,6 +164,10 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu
> >*vcpu)
> > 		return -ENOMEM;
> >
> > 	vcpu->arch.sve_state = buf;
> >+
> >+	if (!has_vhe())
> >+		__vcpu_sys_reg(vcpu, ZCR_EL2) = sve_vq_from_vl(vl) - 1;
> 
> As I understand it, this is the only time where ZCR_EL2 is ever set
> for a given guest. It only has to be restored on guest entry, never
> saved back.

[...]
> 
> Thanks,
> 
>         M.

(Except that the hyp code may need to mess with ZCR_EL2 as outlined
above.  But ack that the value that needs to be in ZCR_EL2 while the
guest runs should never change from the value determined here IIUC.)

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
