From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for Falkor BP
 hardening
Date: Mon, 5 Mar 2018 15:56:14 +0000
Message-ID: <20180305155614.GG6618@arm.com>
References: <1520027418-10646-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520027418-10646-1-git-send-email-shankerd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Vikram Sethi <vikrams@codeaurora.org>, Sean Campbell <scampbel@codeaurora.org>, Thomas Speier <tspeier@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shanker,

On Fri, Mar 02, 2018 at 03:50:18PM -0600, Shanker Donthineni wrote:
> The function SMCCC_ARCH_WORKAROUND_1 was introduced as part of SMC
> V1.1 Calling Convention to mitigate CVE-2017-5715. This patch uses
> the standard call SMCCC_ARCH_WORKAROUND_1 for Falkor chips instead
> of Silicon provider service ID 0xC2001700.
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
>  arch/arm64/include/asm/cpucaps.h |  2 +-
>  arch/arm64/include/asm/kvm_asm.h |  2 --
>  arch/arm64/kernel/bpi.S          |  8 ------
>  arch/arm64/kernel/cpu_errata.c   | 55 ++++++++++++++--------------------------
>  arch/arm64/kvm/hyp/entry.S       | 12 ---------
>  arch/arm64/kvm/hyp/switch.c      | 10 --------
>  6 files changed, 20 insertions(+), 69 deletions(-)

I'm happy to take this via arm64 if I get an ack from Marc/Christoffer.

> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index bb26382..6ecc249 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -43,7 +43,7 @@
>  #define ARM64_SVE				22
>  #define ARM64_UNMAP_KERNEL_AT_EL0		23
>  #define ARM64_HARDEN_BRANCH_PREDICTOR		24
> -#define ARM64_HARDEN_BP_POST_GUEST_EXIT		25
> +/* #define ARM64_UNALLOCATED_ENTRY			25 */
>  #define ARM64_HAS_RAS_EXTN			26
>  
>  #define ARM64_NCAPS				27

These aren't ABI, so I think you can just drop
ARM64_HARDEN_BP_POST_GUEST_EXIT and repack the others accordingly.

> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 24961b7..ab4d0a9 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -68,8 +68,6 @@
>  
>  extern u32 __init_stage2_translation(void);
>  
> -extern void __qcom_hyp_sanitize_btac_predictors(void);
> -
>  #endif
>  
>  #endif /* __ARM_KVM_ASM_H__ */
> diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
> index e5de335..dc4eb15 100644
> --- a/arch/arm64/kernel/bpi.S
> +++ b/arch/arm64/kernel/bpi.S
> @@ -55,14 +55,6 @@ ENTRY(__bp_harden_hyp_vecs_start)
>  	.endr
>  ENTRY(__bp_harden_hyp_vecs_end)
>  
> -ENTRY(__qcom_hyp_sanitize_link_stack_start)
> -	stp     x29, x30, [sp, #-16]!
> -	.rept	16
> -	bl	. + 4
> -	.endr
> -	ldp	x29, x30, [sp], #16
> -ENTRY(__qcom_hyp_sanitize_link_stack_end)
> -
>  .macro smccc_workaround_1 inst
>  	sub	sp, sp, #(8 * 4)
>  	stp	x2, x3, [sp, #(8 * 0)]
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 52f15cd..d779ffd4 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -67,8 +67,6 @@ static int cpu_enable_trap_ctr_access(void *__unused)
>  DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
>  
>  #ifdef CONFIG_KVM
> -extern char __qcom_hyp_sanitize_link_stack_start[];
> -extern char __qcom_hyp_sanitize_link_stack_end[];
>  extern char __smccc_workaround_1_smc_start[];
>  extern char __smccc_workaround_1_smc_end[];
>  extern char __smccc_workaround_1_hvc_start[];
> @@ -115,8 +113,6 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
>  	spin_unlock(&bp_lock);
>  }
>  #else
> -#define __qcom_hyp_sanitize_link_stack_start	NULL
> -#define __qcom_hyp_sanitize_link_stack_end	NULL
>  #define __smccc_workaround_1_smc_start		NULL
>  #define __smccc_workaround_1_smc_end		NULL
>  #define __smccc_workaround_1_hvc_start		NULL
> @@ -161,12 +157,25 @@ static void call_hvc_arch_workaround_1(void)
>  	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
>  }
>  
> +static void qcom_link_stack_sanitization(void)
> +{
> +	u64 tmp;
> +
> +	asm volatile("mov	%0, x30		\n"
> +		     ".rept	16		\n"
> +		     "bl	. + 4		\n"
> +		     ".endr			\n"
> +		     "mov	x30, %0		\n"
> +		     : "=&r" (tmp));
> +}
> +
>  static int enable_smccc_arch_workaround_1(void *data)
>  {
>  	const struct arm64_cpu_capabilities *entry = data;
>  	bp_hardening_cb_t cb;
>  	void *smccc_start, *smccc_end;
>  	struct arm_smccc_res res;
> +	u32 midr = read_cpuid_id();
>  
>  	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
>  		return 0;
> @@ -199,33 +208,15 @@ static int enable_smccc_arch_workaround_1(void *data)
>  		return 0;
>  	}
>  
> +	if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
> +	    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
> +		cb = qcom_link_stack_sanitization;

Is this just a performance thing? Do you actually see an advantage over
always making the firmware call? We've seen minimal impact in our testing.

Will
