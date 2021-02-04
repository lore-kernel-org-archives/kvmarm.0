Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD87CC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 17:36:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 39AD264DD6
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 17:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39AD264DD6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EFBD4B31F;
	Thu,  4 Feb 2021 12:36:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Au2mCO3mBFOm; Thu,  4 Feb 2021 12:36:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 823184B22B;
	Thu,  4 Feb 2021 12:36:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CFDB4B22B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 12:36:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jWUXYbXkSRXs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 12:36:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3659E4B0F0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 12:36:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A38BC13A1;
 Thu,  4 Feb 2021 09:36:25 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C2863F73B;
 Thu,  4 Feb 2021 09:36:24 -0800 (PST)
Date: Thu, 4 Feb 2021 17:36:04 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Daniel Kiss <daniel.kiss@arm.com>
Subject: Re: [PATCHv2] kvm: arm64: Add SVE support for nVHE.
Message-ID: <20210204173603.GC21837@arm.com>
References: <20210202185254.2726862-1-daniel.kiss@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210202185254.2726862-1-daniel.kiss@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: maz@kernel.org, broonie@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Feb 02, 2021 at 07:52:54PM +0100, Daniel Kiss wrote:
> CPUs that support SVE are architecturally required to support the
> Virtualization Host Extensions (VHE), so far the kernel supported
> SVE alongside KVM with VHE enabled. In same cases it is desired to
> run nVHE config even when VHE is available.
> This patch add support for SVE for nVHE configuration too.
> 
> Tested on FVP with a Linux guest VM that run with a different VL than
> the host system.
> 
> Signed-off-by: Daniel Kiss <daniel.kiss@arm.com>
> ---
>  arch/arm64/Kconfig                      |  7 -----
>  arch/arm64/include/asm/fpsimd.h         |  6 ++++
>  arch/arm64/include/asm/fpsimdmacros.h   | 24 +++++++++++++--
>  arch/arm64/include/asm/kvm_host.h       | 17 +++--------
>  arch/arm64/kernel/entry-fpsimd.S        |  5 ----
>  arch/arm64/kvm/arm.c                    |  5 ----
>  arch/arm64/kvm/fpsimd.c                 | 39 ++++++++++++++++++++-----
>  arch/arm64/kvm/hyp/fpsimd.S             | 15 ++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 34 +++++++++++----------
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 29 +++++++++++++++++-
>  arch/arm64/kvm/reset.c                  |  6 +---
>  11 files changed, 126 insertions(+), 61 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index f39568b28ec1..049428f1bf27 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1676,7 +1676,6 @@ endmenu
>  config ARM64_SVE
>  	bool "ARM Scalable Vector Extension support"
>  	default y
> -	depends on !KVM || ARM64_VHE
>  	help
>  	  The Scalable Vector Extension (SVE) is an extension to the AArch64
>  	  execution state which complements and extends the SIMD functionality
> @@ -1705,12 +1704,6 @@ config ARM64_SVE
>  	  booting the kernel.  If unsure and you are not observing these
>  	  symptoms, you should assume that it is safe to say Y.
>  
> -	  CPUs that support SVE are architecturally required to support the
> -	  Virtualization Host Extensions (VHE), so the kernel makes no
> -	  provision for supporting SVE alongside KVM without VHE enabled.
> -	  Thus, you will need to enable CONFIG_ARM64_VHE if you want to support
> -	  KVM in the same kernel image.
> -
>  config ARM64_MODULE_PLTS
>  	bool "Use PLTs to allow module memory to spill over into vmalloc area"
>  	depends on MODULES
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index bec5f14b622a..526d69f3eeb3 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -69,6 +69,12 @@ static inline void *sve_pffr(struct thread_struct *thread)
>  extern void sve_save_state(void *state, u32 *pfpsr);
>  extern void sve_load_state(void const *state, u32 const *pfpsr,
>  			   unsigned long vq_minus_1);
> +/*
> + * sve_load_state_nvhe function for the hyp code where the SVE registers are
> + * handled from the EL2, vector length is governed by ZCR_EL2.
> + */
> +extern void sve_load_state_nvhe(void const *state, u32 const *pfpsr,
> +			   unsigned long vq_minus_1);
>  extern void sve_flush_live(void);
>  extern void sve_load_from_fpsimd_state(struct user_fpsimd_state const *state,
>  				       unsigned long vq_minus_1);
> diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
> index af43367534c7..d309c6071bce 100644
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

This looks a little better, but can we just give sve_load_vq an extra
argument, say

.macro sve_load_vq ... , el=EL1

[...]

> +.macro sve_load_nvhe nxbase, xpfpsr, xvqminus1, nxtmp, xtmp2
> +		sve_load_vq_nvhe	\xvqminus1, x\nxtmp, \xtmp2

and do sve_load_vq \xvqminus1, x\nxtmp, \xtmp2, EL2

> +		_sve_load	 \nxbase, \xpfpsr, \nxtmp
> +.endm
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8fcfab0c2567..11a058c81c1d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -376,6 +376,10 @@ struct kvm_vcpu_arch {
>  #define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) + \
>  				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
>  
> +#define vcpu_sve_pffr_hyp(vcpu) ((void *)((char *) \
> +			(kern_hyp_va((vcpu)->arch.sve_state)) + \
> +			sve_ffr_offset((vcpu)->arch.sve_max_vl)))
> +
>  #define vcpu_sve_state_size(vcpu) ({					\
>  	size_t __size_ret;						\
>  	unsigned int __vcpu_vq;						\
> @@ -693,19 +697,6 @@ static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
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
> diff --git a/arch/arm64/kernel/entry-fpsimd.S b/arch/arm64/kernel/entry-fpsimd.S
> index 2ca395c25448..e444b753c518 100644
> --- a/arch/arm64/kernel/entry-fpsimd.S
> +++ b/arch/arm64/kernel/entry-fpsimd.S
> @@ -33,11 +33,6 @@ SYM_FUNC_END(fpsimd_load_state)
>  
>  #ifdef CONFIG_ARM64_SVE
>  
> -SYM_FUNC_START(sve_save_state)
> -	sve_save 0, x1, 2
> -	ret
> -SYM_FUNC_END(sve_save_state)
> -
>  SYM_FUNC_START(sve_load_state)
>  	sve_load 0, x1, x2, 3, x4
>  	ret
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe60d25c000e..6284563b352a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1890,11 +1890,6 @@ int kvm_arch_init(void *opaque)
>  
>  	in_hyp_mode = is_kernel_in_hyp_mode();
>  
> -	if (!in_hyp_mode && kvm_arch_requires_vhe()) {
> -		kvm_pr_unimpl("CPU unsupported in non-VHE mode, not initializing\n");
> -		return -ENODEV;
> -	}
> -
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>  	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>  		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 3e081d556e81..8f29b468e989 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -42,6 +42,16 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
>  	if (ret)
>  		goto error;
>  
> +	if (!has_vhe() && vcpu->arch.sve_state) {
> +		void *sve_state_end = vcpu->arch.sve_state +
> +					    SVE_SIG_REGS_SIZE(
> +						sve_vq_from_vl(vcpu->arch.sve_max_vl));
> +		ret = create_hyp_mappings(vcpu->arch.sve_state,
> +					  sve_state_end,
> +					  PAGE_HYP);
> +		if (ret)
> +			goto error;
> +	}
>  	vcpu->arch.host_thread_info = kern_hyp_va(ti);
>  	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
>  error:
> @@ -109,10 +119,22 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  	local_irq_save(flags);
>  
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> +		if (guest_has_sve) {
> +			if (has_vhe())
> +				__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL12);
> +			else {
> +				__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL1);
> +				/*
> +				 * vcpu could set ZCR_EL1 to a shorter VL then the max VL but
> +				 * the context is still valid there. Save the whole context.
> +				 * In nVHE case we need to reset the ZCR_EL1 for that
> +				 * because the save will be done in EL1.
> +				 */
> +				write_sysreg_s(sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1,
> +					       SYS_ZCR_EL1);

This still doesn't feel right.  We're already in EL1 here I think, in
which case ZCR_EL1 has an immediate effect on what state the
architecture guarantees to preserve: if we need to change ZCR_EL1, it's
because it might be wrong.  If it's wrong, it might be too small.  And
if it's too small, we may have already lost some SVE register bits that
the guest cares about.

I think that we need to handle this on our way out of hyp instead,
_before_ returning back to EL1.

When at EL2 exiting back to the host: if and only if
KVM_ARM64_FP_ENABLED is set then save the guest's ZCR_EL1 and ZCR_EL1 to
match the guest's sve_max_vl (possibly by just cloning ZCR_EL2).

> +			}
> +		}
>  		fpsimd_save_and_flush_cpu_state();
> -
> -		if (guest_has_sve)
> -			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL12);
>  	} else if (host_has_sve) {
>  		/*
>  		 * The FPSIMD/SVE state in the CPU has not been touched, and we
> @@ -120,11 +142,14 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  		 * reset to CPACR_EL1_DEFAULT by the Hyp code, disabling SVE
>  		 * for EL0.  To avoid spurious traps, restore the trap state
>  		 * seen by kvm_arch_vcpu_load_fp():
> +		 * nVHE case the CPACR_EL1 is context switched.
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
> index 01f114aa47b0..da824b46b81b 100644
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
> +SYM_FUNC_START(sve_save_state)
> +	sve_save 0, x1, 2
> +	ret
> +SYM_FUNC_END(sve_save_state)
> +
> +SYM_FUNC_START(sve_load_state_nvhe)
> +	sve_load_nvhe 0, x1, x2, 3, x4
> +	ret
> +SYM_FUNC_END(sve_load_state_nvhe)
> +
> +#endif
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 84473574c2e7..99e7f0d5bb64 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -205,19 +205,13 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>  	if (!system_supports_fpsimd())
>  		return false;
>  
> -	/*
> -	 * Currently system_supports_sve() currently implies has_vhe(),
> -	 * so the check is redundant. However, has_vhe() can be determined
> -	 * statically and helps the compiler remove dead code.
> -	 */
> -	if (has_vhe() && system_supports_sve()) {
> +	vhe = has_vhe();
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
> @@ -240,17 +234,17 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>  
>  		write_sysreg(reg, cpacr_el1);
>  	} else {
> -		write_sysreg(read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP,
> -			     cptr_el2);
> +		u64 reg = read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP;
> +
> +		if (sve_guest)
> +			reg &= ~(u64)CPTR_EL2_TZ;
> +
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
> @@ -266,10 +260,18 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (sve_guest) {
> -		sve_load_state(vcpu_sve_pffr(vcpu),
> +		if (vhe) {
> +			sve_load_state(vcpu_sve_pffr(vcpu),
> +			       &vcpu->arch.ctxt.fp_regs.fpsr,
> +			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
> +			write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
> +		} else {
> +			sve_load_state_nvhe(vcpu_sve_pffr_hyp(vcpu),
>  			       &vcpu->arch.ctxt.fp_regs.fpsr,
>  			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
> -		write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
> +			write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL1);
> +
> +		}
>  	} else {
>  		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
>  	}
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index f3d0e9eca56c..df9e912d1278 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -45,6 +45,18 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  	if (!update_fp_enabled(vcpu)) {
>  		val |= CPTR_EL2_TFP;
>  		__activate_traps_fpsimd32(vcpu);
> +	} else {
> +		if (vcpu_has_sve(vcpu)) {
> +			/*
> +			 * The register access will not be trapped so restore
> +			 * ZCR_EL1/ZCR_EL2 because those were set for the host.
> +			 */
> +			write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL1);
> +			write_sysreg_s(
> +				sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1,
> +				SYS_ZCR_EL2);
> +			val &= ~CPTR_EL2_TZ;
> +		}
>  	}
>  
>  	write_sysreg(val, cptr_el2);
> @@ -110,6 +122,17 @@ static void __load_host_stage2(void)
>  	write_sysreg(0, vttbr_el2);
>  }
>  
> +static void __restore_host_sve_state(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * If the guest uses SVE, the ZCR_EL2 was configured for the guest.
> +	 * Host might save the context in EL1 but for that the ZCR_EL2 need
> +	 * to be reset to the host's default.

This isn't just about saving the guest context correctly.  The host have
be using larger vectors than the guest's sve_max_vl allows.

> +	 */
> +	if (vcpu_has_sve(vcpu) && (vcpu->arch.flags |= KVM_ARM64_FP_ENABLED))
> +		write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);

I'm not sure if it's worth having a special #define for this, but it
would be a good idea at least to put comments here and in el2_setup.h to
remind people that the ZCR_EL2 settings need to match.  Otherwise this
might get mis-maintained in the future.

> +}
> +
>  /* Save VGICv3 state on non-VHE systems */
>  static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
>  {
> @@ -228,7 +251,11 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	__deactivate_traps(vcpu);
>  	__load_host_stage2();
> -
> +	/* Host might store the SVE state in EL1 but the guest could run

Nit: wrong comment style (/* on separate line, please).

> +	 * with different ZCR_EL2 config. It needs to be restored before
> +	 * returning to host EL1.
> +	 */
> +	__restore_host_sve_state(vcpu);

"sve_state" sounds like it operates on all the SVE state.  Maybe this
could just be called __restore_host_zcr_el2() for now?

>  	__sysreg_restore_state_nvhe(host_ctxt);
>  
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 47f3f035f3ea..17cc5e87adcd 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -74,10 +74,6 @@ static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
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
> @@ -113,7 +109,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
>  	buf = kzalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl)), GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
> -
> +	__vcpu_sys_reg(vcpu, ZCR_EL1) = sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1;

What's this for?

__vcpu_sys_reg(vcpu, ZCR_EL1) should already be being reset sensibly
somewhere.  If not, that would be a bug...

[...]

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
