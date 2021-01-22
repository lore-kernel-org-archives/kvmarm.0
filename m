Return-Path: <SRS0=o0cc=GZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C694C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 18:21:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78E9823A6A
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 18:21:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78E9823A6A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C20844B11D;
	Fri, 22 Jan 2021 13:21:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Q+zrHbBDdBm; Fri, 22 Jan 2021 13:21:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B56954B111;
	Fri, 22 Jan 2021 13:21:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B5F84B10F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 13:21:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cFia6F4tNWH9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jan 2021 13:21:25 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 284F04B10D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 13:21:25 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C9E1023A6A;
 Fri, 22 Jan 2021 18:21:23 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l313h-009TkH-Nv; Fri, 22 Jan 2021 18:21:21 +0000
MIME-Version: 1.0
Date: Fri, 22 Jan 2021 18:21:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: Daniel Kiss <daniel.kiss@arm.com>
Subject: Re: [PATCH] kvm: arm64: Add SVE support for nVHE.
In-Reply-To: <20210122010707.2456982-1-daniel.kiss@arm.com>
References: <20210122010707.2456982-1-daniel.kiss@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <eee98e0f59f75960e30233d4bde54459@misterjones.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: daniel.kiss@arm.com, linux-arm-kernel@lists.infradead.org,
 Mark.Brown@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Mark.Brown@arm.com, Dave.Martin@arm.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Daniel,

Please consider cc'ing the maintainer (me) as well as the KVM/arm64
reviewers (Julien, James, Suzuki) and the kvmarm list (all now Cc'd).

On 2021-01-22 01:07, Daniel Kiss wrote:
> CPUs that support SVE are architecturally required to support the
> Virtualization Host Extensions (VHE), so far the kernel supported
> SVE alongside KVM with VHE enabled. In same cases it is desired to
> run nVHE config even when VHE is available.
> This patch add support for SVE for nVHE configuration too.
> 
> In case of nVHE the system registers behave a bit differently.
> ZCR_EL2 defines the maximum vector length that could be set in ZCR_EL1
> effectively. To limit the vector length for the guest the ZCR_EL2 need
> to be set accordingly therefore it become part of the context.

Not really. It's just part of the *hypervisor* state for this guest,
and not part of the guest state. Not different from HCR_EL2, for 
example.

> The sve_state will be loaded in EL2 so it need to be mapped and during
> the load ZCR_EL2 will control the vector length.
> Trap control is similar to the VHE case except the bit values are the
> opposite. ZCR_EL1 access trapping with VHE is ZEN value 0 but in case 
> of
> nVHE the TZ need to be set 1 to trigger the exception. Trap control 
> need
> to be respected during the context switch even in EL2.

Isn't that exactly the same as FPSIMD accesses?

> 
> Tested on FVP with a Linux guest VM that run with a different VL than
> the host system.
> 
> This patch requires sve_set_vq from
>  - arm64/sve: Rework SVE trap access to minimise memory access

Care to add a pointer to this patch? This also shouldn't be part
of the commit message. When you repost it, please include the
other patch as a series unless it has already been merged by then.

> 
> Signed-off-by: Daniel Kiss <daniel.kiss@arm.com>
> ---
>  arch/arm64/Kconfig                         |  7 ----
>  arch/arm64/include/asm/fpsimd.h            |  4 ++
>  arch/arm64/include/asm/fpsimdmacros.h      | 38 +++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h          | 19 +++------
>  arch/arm64/kernel/fpsimd.c                 | 11 +++++
>  arch/arm64/kvm/arm.c                       |  5 ---
>  arch/arm64/kvm/fpsimd.c                    | 22 +++++++---
>  arch/arm64/kvm/hyp/fpsimd.S                | 15 +++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h    | 48 ++++++++++++----------
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 26 ++++++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c           |  6 ++-
>  arch/arm64/kvm/reset.c                     |  8 ++--
>  12 files changed, 153 insertions(+), 56 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index a6b5b7ef40ae..f17ab095e99f 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1692,7 +1692,6 @@ endmenu
>  config ARM64_SVE
>  	bool "ARM Scalable Vector Extension support"
>  	default y
> -	depends on !KVM || ARM64_VHE
>  	help
>  	  The Scalable Vector Extension (SVE) is an extension to the AArch64
>  	  execution state which complements and extends the SIMD 
> functionality
> @@ -1721,12 +1720,6 @@ config ARM64_SVE
>  	  booting the kernel.  If unsure and you are not observing these
>  	  symptoms, you should assume that it is safe to say Y.
> 
> -	  CPUs that support SVE are architecturally required to support the
> -	  Virtualization Host Extensions (VHE), so the kernel makes no
> -	  provision for supporting SVE alongside KVM without VHE enabled.
> -	  Thus, you will need to enable CONFIG_ARM64_VHE if you want to 
> support
> -	  KVM in the same kernel image.
> -
>  config ARM64_MODULE_PLTS
>  	bool "Use PLTs to allow module memory to spill over into vmalloc 
> area"
>  	depends on MODULES
> diff --git a/arch/arm64/include/asm/fpsimd.h 
> b/arch/arm64/include/asm/fpsimd.h
> index e60aa4ebb351..e7889f4c5cef 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -69,6 +69,10 @@ static inline void *sve_pffr(struct thread_struct 
> *thread)
>  extern void sve_save_state(void *state, u32 *pfpsr);
>  extern void sve_load_state(void const *state, u32 const *pfpsr,
>  			   unsigned long vq_minus_1);
> +extern void sve_save_state_nvhe(void *state, u32 *pfpsr,
> +			   unsigned long vq_minus_1);
> +extern void sve_load_state_nvhe(void const *state, u32 const *pfpsr,
> +			   unsigned long vq_minus_1);

Why do we need two different entry points?

>  extern void sve_flush_live(void);
>  extern void sve_load_from_fpsimd_state(struct user_fpsimd_state const 
> *state,
>  				       unsigned long vq_minus_1);
> diff --git a/arch/arm64/include/asm/fpsimdmacros.h
> b/arch/arm64/include/asm/fpsimdmacros.h
> index af43367534c7..3a18172ee4f6 100644
> --- a/arch/arm64/include/asm/fpsimdmacros.h
> +++ b/arch/arm64/include/asm/fpsimdmacros.h
> @@ -205,6 +205,17 @@
>  921:
>  .endm
> 
> +/* Update ZCR_EL2.LEN with the new VQ */
> +.macro sve_load_vq_nvhe xvqminus1, xtmp, xtmp2
> +		mrs_s		\xtmp, SYS_ZCR_EL2
> +		bic		\xtmp2, \xtmp, ZCR_ELx_LEN_MASK
> +		orr		\xtmp2, \xtmp2, \xvqminus1
> +		cmp		\xtmp2, \xtmp
> +		b.eq		922f
> +		msr_s		SYS_ZCR_EL2, \xtmp2	//self-synchronising
> +922:
> +.endm
> +
>  /* Preserve the first 128-bits of Znz and zero the rest. */
>  .macro _sve_flush_z nz
>  	_sve_check_zreg \nz
> @@ -230,6 +241,20 @@
>  		str		w\nxtmp, [\xpfpsr, #4]
>  .endm
> 
> +.macro sve_save_nvhe nxbase, xpfpsr, xvqminus1, nxtmp, xtmp2
> +		sve_load_vq_nvhe	\xvqminus1, x\nxtmp, \xtmp2
> + _for n, 0, 31,	_sve_str_v	\n, \nxbase, \n - 34
> + _for n, 0, 15,	_sve_str_p	\n, \nxbase, \n - 16
> +		_sve_rdffr	0
> +		_sve_str_p	0, \nxbase
> +		_sve_ldr_p	0, \nxbase, -16
> +
> +		mrs		x\nxtmp, fpsr
> +		str		w\nxtmp, [\xpfpsr]
> +		mrs		x\nxtmp, fpcr
> +		str		w\nxtmp, [\xpfpsr, #4]
> +.endm

Please document what this macro does.

> +
>  .macro sve_load nxbase, xpfpsr, xvqminus1, nxtmp, xtmp2
>  		sve_load_vq	\xvqminus1, x\nxtmp, \xtmp2
>   _for n, 0, 31,	_sve_ldr_v	\n, \nxbase, \n - 34
> @@ -242,3 +267,16 @@
>  		ldr		w\nxtmp, [\xpfpsr, #4]
>  		msr		fpcr, x\nxtmp
>  .endm
> +
> +.macro sve_load_nvhe nxbase, xpfpsr, xvqminus1, nxtmp, xtmp2
> +		sve_load_vq_nvhe	\xvqminus1, x\nxtmp, \xtmp2
> + _for n, 0, 31,	_sve_ldr_v	\n, \nxbase, \n - 34
> +		_sve_ldr_p	0, \nxbase
> +		_sve_wrffr	0
> + _for n, 0, 15,	_sve_ldr_p	\n, \nxbase, \n - 16
> +
> +		ldr		w\nxtmp, [\xpfpsr]
> +		msr		fpsr, x\nxtmp
> +		ldr		w\nxtmp, [\xpfpsr, #4]
> +		msr		fpcr, x\nxtmp
> +.endm
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index 0cd9f0f75c13..8bfac6f52858 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -137,6 +137,7 @@ enum vcpu_sysreg {
>  	ACTLR_EL1,	/* Auxiliary Control Register */
>  	CPACR_EL1,	/* Coprocessor Access Control */
>  	ZCR_EL1,	/* SVE Control */
> +	ZCR_EL2,	/* SVE Control */

No. This obviously isn't a guest register, and it has no purpose
in this array.

>  	TTBR0_EL1,	/* Translation Table Base Register 0 */
>  	TTBR1_EL1,	/* Translation Table Base Register 1 */
>  	TCR_EL1,	/* Translation Control Register */
> @@ -283,6 +284,7 @@ struct vcpu_reset_state {
>  struct kvm_vcpu_arch {
>  	struct kvm_cpu_context ctxt;
>  	void *sve_state;
> +	void *sve_state_hyp;

Why do we need a separate state pointer?

>  	unsigned int sve_max_vl;
> 
>  	/* Stage 2 paging state used by the hardware on next switch */
> @@ -386,6 +388,10 @@ struct kvm_vcpu_arch {
>  #define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) 
> + \
>  				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
> 
> +#define vcpu_sve_pffr_hyp(vcpu) \
> +			((void *)((char *)((vcpu)->arch.sve_state_hyp) + \
> +			sve_ffr_offset((vcpu)->arch.sve_max_vl)))

Why can't you have a single macro that embeds kern_hyp_va()?

> +
>  #define vcpu_sve_state_size(vcpu) ({					\
>  	size_t __size_ret;						\
>  	unsigned int __vcpu_vq;						\
> @@ -579,19 +585,6 @@ static inline void
> kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
>  	ctxt_sys_reg(cpu_ctxt, MPIDR_EL1) = read_cpuid_mpidr();
>  }
> 
> -static inline bool kvm_arch_requires_vhe(void)
> -{
> -	/*
> -	 * The Arm architecture specifies that implementation of SVE
> -	 * requires VHE also to be implemented.  The KVM code for arm64
> -	 * relies on this when SVE is present:
> -	 */
> -	if (system_supports_sve())
> -		return true;
> -
> -	return false;
> -}
> -
>  void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
> 
>  static inline void kvm_arch_hardware_unsetup(void) {}
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 062b21f30f94..1f94c5ca4943 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -308,6 +308,17 @@ static void fpsimd_save(void)
> 
>  	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
>  		if (system_supports_sve() && test_thread_flag(TIF_SVE)) {
> +
> +			if (!has_vhe() && (sve_get_vl() != last->sve_vl)) {
> +				/* last->sve_state could belong to a vcpu, nVHE
> +				   case the context is loaded in EL2 where ZCR_EL2
> +				   is used. In this context the ZCR_EL1 is used but
> +				   it could be different because it was not
> +				   set when the vcpu context is loaded. Let's set
> +				   it to the guest's VL.
> +				 */

Please use the kernel comment style.

> +				sve_set_vq(sve_vq_from_vl(last->sve_vl) - 1);
> +			}
>  			if (WARN_ON(sve_get_vl() != last->sve_vl)) {
>  				/*
>  				 * Can't save the user regs, so current would
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c0ffb019ca8b..3d37f4ad2228 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1749,11 +1749,6 @@ int kvm_arch_init(void *opaque)
> 
>  	in_hyp_mode = is_kernel_in_hyp_mode();
> 
> -	if (!in_hyp_mode && kvm_arch_requires_vhe()) {
> -		kvm_pr_unimpl("CPU unsupported in non-VHE mode, not 
> initializing\n");
> -		return -ENODEV;
> -	}
> -
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>  	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>  		kvm_info("Guests without required CPU erratum workarounds can
> deadlock system!\n" \
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 3e081d556e81..cfbc869caeeb 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -42,6 +42,15 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
>  	if (ret)
>  		goto error;
> 
> +	if (!has_vhe() && vcpu->arch.sve_state) {
> +		ret = create_hyp_mappings(vcpu->arch.sve_state,
> +					vcpu->arch.sve_state +
> +					SVE_SIG_REGS_SIZE(sve_vq_from_vl(vcpu->arch.sve_max_vl)),
> +					PAGE_HYP);
> +		if (ret)
> +			goto error;
> +		vcpu->arch.sve_state_hyp = kern_hyp_va(vcpu->arch.sve_state);

How useful is it to keep that duplicated pointer around, given that
we can compute it on the fly at a very low cost?

> +	}
>  	vcpu->arch.host_thread_info = kern_hyp_va(ti);
>  	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
>  error:
> @@ -111,8 +120,9 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
>  		fpsimd_save_and_flush_cpu_state();
> 
> -		if (guest_has_sve)
> +		if (guest_has_sve && has_vhe())
>  			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL12);
> +

Spurious blank line.

>  	} else if (host_has_sve) {
>  		/*
>  		 * The FPSIMD/SVE state in the CPU has not been touched, and we
> @@ -121,10 +131,12 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  		 * for EL0.  To avoid spurious traps, restore the trap state
>  		 * seen by kvm_arch_vcpu_load_fp():
>  		 */
> -		if (vcpu->arch.flags & KVM_ARM64_HOST_SVE_ENABLED)
> -			sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
> -		else
> -			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
> +		if (has_vhe()) {
> +			if (vcpu->arch.flags & KVM_ARM64_HOST_SVE_ENABLED)
> +				sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
> +			else
> +				sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
> +		}
>  	}
> 
>  	update_thread_flag(TIF_SVE,
> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> index 01f114aa47b0..15d47ebdd30a 100644
> --- a/arch/arm64/kvm/hyp/fpsimd.S
> +++ b/arch/arm64/kvm/hyp/fpsimd.S
> @@ -6,6 +6,7 @@
> 
>  #include <linux/linkage.h>
> 
> +#include <asm/assembler.h>
>  #include <asm/fpsimdmacros.h>
> 
>  	.text
> @@ -19,3 +20,17 @@ SYM_FUNC_START(__fpsimd_restore_state)
>  	fpsimd_restore	x0, 1
>  	ret
>  SYM_FUNC_END(__fpsimd_restore_state)
> +
> +#ifdef CONFIG_ARM64_SVE
> +
> +SYM_FUNC_START(sve_save_state_nvhe)
> +	sve_save_nvhe 0, x1, x2, 3, x4
> +	ret
> +SYM_FUNC_END(sve_save_state_nvhe)
> +
> +SYM_FUNC_START(sve_load_state_nvhe)
> +	sve_load_nvhe 0, x1, x2, 3, x4
> +	ret
> +SYM_FUNC_END(sve_load_state_nvhe)
> +
> +#endif
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h
> b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 1f875a8f20c4..a14b0d92d9ca 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -197,25 +197,18 @@ static inline bool __populate_fault_info(struct
> kvm_vcpu *vcpu)
>  /* Check for an FPSIMD/SVE trap and handle as appropriate */
>  static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>  {
> -	bool vhe, sve_guest, sve_host;
> +	bool sve_guest, sve_host;
>  	u8 esr_ec;
> 
>  	if (!system_supports_fpsimd())
>  		return false;
> 
> -	/*
> -	 * Currently system_supports_sve() currently implies has_vhe(),
> -	 * so the check is redundant. However, has_vhe() can be determined
> -	 * statically and helps the compiler remove dead code.
> -	 */
> -	if (has_vhe() && system_supports_sve()) {
> +	if (system_supports_sve()) {
>  		sve_guest = vcpu_has_sve(vcpu);
>  		sve_host = vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE;
> -		vhe = true;
>  	} else {
>  		sve_guest = false;
>  		sve_host = false;
> -		vhe = has_vhe();
>  	}
> 
>  	esr_ec = kvm_vcpu_trap_get_class(vcpu);
> @@ -229,8 +222,7 @@ static inline bool __hyp_handle_fpsimd(struct
> kvm_vcpu *vcpu)
>  			return false;
> 
>  	/* Valid trap.  Switch the context: */
> -
> -	if (vhe) {
> +	if (has_vhe()) {
>  		u64 reg = read_sysreg(cpacr_el1) | CPACR_EL1_FPEN;
> 
>  		if (sve_guest)
> @@ -238,24 +230,30 @@ static inline bool __hyp_handle_fpsimd(struct
> kvm_vcpu *vcpu)
> 
>  		write_sysreg(reg, cpacr_el1);
>  	} else {
> -		write_sysreg(read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP,
> -			     cptr_el2);
> +		u64 reg = read_sysreg(cptr_el2) & ~CPTR_EL2_TFP ;
> +		if (sve_guest)
> +			reg &= ~CPTR_EL2_TZ;
> +		write_sysreg(reg, cptr_el2);
>  	}
> 
>  	isb();
> 
>  	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
> -		/*
> -		 * In the SVE case, VHE is assumed: it is enforced by
> -		 * Kconfig and kvm_arch_init().
> -		 */
>  		if (sve_host) {
>  			struct thread_struct *thread = container_of(
>  				vcpu->arch.host_fpsimd_state,
>  				struct thread_struct, uw.fpsimd_state);
> +			if (has_vhe())
> +				sve_save_state(sve_pffr(thread),
> +						&vcpu->arch.host_fpsimd_state->fpsr);
> +			else {
> +				struct kvm_cpu_context *host_ctxt =
> +					&this_cpu_ptr(&kvm_host_data)->host_ctxt;

Assignments on a single line please.

> +				sve_save_state_nvhe(sve_pffr(thread),
> +						&vcpu->arch.host_fpsimd_state->fpsr,
> +						ctxt_sys_reg(host_ctxt, ZCR_EL2));
> +			}
> 
> -			sve_save_state(sve_pffr(thread),
> -				       &vcpu->arch.host_fpsimd_state->fpsr);
>  		} else {
>  			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
>  		}
> @@ -264,10 +262,18 @@ static inline bool __hyp_handle_fpsimd(struct
> kvm_vcpu *vcpu)
>  	}
> 
>  	if (sve_guest) {
> -		sve_load_state(vcpu_sve_pffr(vcpu),
> +		if (has_vhe()) {
> +			sve_load_state(vcpu_sve_pffr(vcpu),
>  			       &vcpu->arch.ctxt.fp_regs.fpsr,
>  			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
> -		write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
> +			write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
> +		} else {
> +			sve_load_state_nvhe(vcpu_sve_pffr_hyp(vcpu),
> +			       &vcpu->arch.ctxt.fp_regs.fpsr,
> +			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
> +			write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL2), SYS_ZCR_EL2);

I think you really need to explain why you restore ZCR_EL2 here, and not 
ZCR_EL1.

> +
> +		}
>  	} else {
>  		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
>  	}
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index cce43bfe158f..45c16b81b826 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -46,6 +46,19 @@ static inline void __sysreg_save_el1_state(struct
> kvm_cpu_context *ctxt)
>  	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg_par();
>  	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
> 
> +	if (!has_vhe()) {
> +		u64 reg = read_sysreg(cptr_el2);
> +		if (reg & CPTR_EL2_TZ) {
> +			write_sysreg(reg & ~CPTR_EL2_TZ, cptr_el2);
> +			ctxt_sys_reg(ctxt, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL1);
> +			ctxt_sys_reg(ctxt, ZCR_EL2) = read_sysreg_s(SYS_ZCR_EL2);
> +			write_sysreg(reg, cptr_el2);
> +		} else {
> +			ctxt_sys_reg(ctxt, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL1);
> +			ctxt_sys_reg(ctxt, ZCR_EL2) = read_sysreg_s(SYS_ZCR_EL2);

Why do you need to save ZCR_EL2? It cannot change behind your back, can 
it?
Also, why aren't these registers saved lazily? If TZ is set, the guest 
cannot
possibly have changed ZCR_EL1.

> +		}
> +	}
> +
>  	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
>  	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
>  	ctxt_sys_reg(ctxt, SPSR_EL1)	= read_sysreg_el1(SYS_SPSR);
> @@ -107,6 +120,19 @@ static inline void
> __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1),	par_el1);
>  	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1),	tpidr_el1);
> 
> +	if (!has_vhe()) {
> +		u64 reg = read_sysreg(cptr_el2);
> +		if (reg & CPTR_EL2_TZ) {
> +			write_sysreg(reg & ~CPTR_EL2_TZ, cptr_el2);
> +			write_sysreg_s(ctxt_sys_reg(ctxt, ZCR_EL1), SYS_ZCR_EL1);
> +			write_sysreg_s(ctxt_sys_reg(ctxt, ZCR_EL2), SYS_ZCR_EL2);
> +			write_sysreg(reg, cptr_el2);

Same thing here. If TZ is set, there is no point in restoring these 
registers,
and it should be delegated to the point where you actually restore the 
bulk
of the SVE state.

> +		} else {
> +			write_sysreg_s(ctxt_sys_reg(ctxt, ZCR_EL1), SYS_ZCR_EL1);
> +			write_sysreg_s(ctxt_sys_reg(ctxt, ZCR_EL2), SYS_ZCR_EL2);
> +		}
> +	}
> +
>  	if (!has_vhe() &&
>  	    cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT) &&
>  	    ctxt->__hyp_running_vcpu) {
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c 
> b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 8ae8160bc93a..bffd78203448 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -41,7 +41,11 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
> 
>  	val = CPTR_EL2_DEFAULT;
>  	val |= CPTR_EL2_TTA | CPTR_EL2_TZ | CPTR_EL2_TAM;
> -	if (!update_fp_enabled(vcpu)) {
> +
> +	if (update_fp_enabled(vcpu)) {
> +		if (vcpu_has_sve(vcpu))
> +			val &= ~CPTR_EL2_TZ;
> +	} else {

nit: please don't invert conditions like this.

>  		val |= CPTR_EL2_TFP;
>  		__activate_traps_fpsimd32(vcpu);
>  	}
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index f32490229a4c..3c62fb10a3fe 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -127,10 +127,6 @@ static int kvm_vcpu_enable_sve(struct kvm_vcpu 
> *vcpu)
>  	if (!system_supports_sve())
>  		return -EINVAL;
> 
> -	/* Verify that KVM startup enforced this when SVE was detected: */
> -	if (WARN_ON(!has_vhe()))
> -		return -EINVAL;
> -
>  	vcpu->arch.sve_max_vl = kvm_sve_max_vl;
> 
>  	/*
> @@ -168,6 +164,10 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu 
> *vcpu)
>  		return -ENOMEM;
> 
>  	vcpu->arch.sve_state = buf;
> +
> +	if (!has_vhe())
> +		__vcpu_sys_reg(vcpu, ZCR_EL2) = sve_vq_from_vl(vl) - 1;

As I understand it, this is the only time where ZCR_EL2 is ever set
for a given guest. It only has to be restored on guest entry, never
saved back.

> +
>  	vcpu->arch.flags |= KVM_ARM64_VCPU_SVE_FINALIZED;
>  	return 0;
>  }

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
