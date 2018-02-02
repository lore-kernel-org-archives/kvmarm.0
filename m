From: Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH v3 18/18] arm64: Kill PSCI_GET_VERSION as a variant-2
 workaround
Date: Fri, 2 Feb 2018 12:05:00 +0800
Message-ID: <d130b0b5-edc3-b305-c33e-33f9954d0858@huawei.com>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-19-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180201114657.7323-19-marc.zyngier@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Jones <drjones@redhat.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

Thank you for keeping me in the loop, just minor comments below.

On 2018/2/1 19:46, Marc Zyngier wrote:
> Now that we've standardised on SMCCC v1.1 to perform the branch
> prediction invalidation, let's drop the previous band-aid.
> If vendors haven't updated their firmware to do SMCCC 1.1, they
> haven't updated PSCI either, so we don't loose anything.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kernel/bpi.S        | 24 -----------------------
>  arch/arm64/kernel/cpu_errata.c | 43 ++++++++++++------------------------------
>  arch/arm64/kvm/hyp/switch.c    | 14 --------------
>  3 files changed, 12 insertions(+), 69 deletions(-)
> 
> diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
> index fdeed629f2c6..e5de33513b5d 100644
> --- a/arch/arm64/kernel/bpi.S
> +++ b/arch/arm64/kernel/bpi.S
> @@ -54,30 +54,6 @@ ENTRY(__bp_harden_hyp_vecs_start)
>  	vectors __kvm_hyp_vector
>  	.endr
>  ENTRY(__bp_harden_hyp_vecs_end)
> -ENTRY(__psci_hyp_bp_inval_start)
> -	sub	sp, sp, #(8 * 18)
> -	stp	x16, x17, [sp, #(16 * 0)]
> -	stp	x14, x15, [sp, #(16 * 1)]
> -	stp	x12, x13, [sp, #(16 * 2)]
> -	stp	x10, x11, [sp, #(16 * 3)]
> -	stp	x8, x9, [sp, #(16 * 4)]
> -	stp	x6, x7, [sp, #(16 * 5)]
> -	stp	x4, x5, [sp, #(16 * 6)]
> -	stp	x2, x3, [sp, #(16 * 7)]
> -	stp	x0, x1, [sp, #(16 * 8)]
> -	mov	x0, #0x84000000
> -	smc	#0
> -	ldp	x16, x17, [sp, #(16 * 0)]
> -	ldp	x14, x15, [sp, #(16 * 1)]
> -	ldp	x12, x13, [sp, #(16 * 2)]
> -	ldp	x10, x11, [sp, #(16 * 3)]
> -	ldp	x8, x9, [sp, #(16 * 4)]
> -	ldp	x6, x7, [sp, #(16 * 5)]
> -	ldp	x4, x5, [sp, #(16 * 6)]
> -	ldp	x2, x3, [sp, #(16 * 7)]
> -	ldp	x0, x1, [sp, #(16 * 8)]
> -	add	sp, sp, #(8 * 18)
> -ENTRY(__psci_hyp_bp_inval_end)
>  
>  ENTRY(__qcom_hyp_sanitize_link_stack_start)
>  	stp     x29, x30, [sp, #-16]!
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 9e77809a3b23..b8279a11f57b 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -67,7 +67,6 @@ static int cpu_enable_trap_ctr_access(void *__unused)
>  DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
>  
>  #ifdef CONFIG_KVM
> -extern char __psci_hyp_bp_inval_start[], __psci_hyp_bp_inval_end[];
>  extern char __qcom_hyp_sanitize_link_stack_start[];
>  extern char __qcom_hyp_sanitize_link_stack_end[];
>  extern char __smccc_workaround_1_smc_start[];
> @@ -116,8 +115,6 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
>  	spin_unlock(&bp_lock);
>  }
>  #else
> -#define __psci_hyp_bp_inval_start		NULL
> -#define __psci_hyp_bp_inval_end			NULL
>  #define __qcom_hyp_sanitize_link_stack_start	NULL
>  #define __qcom_hyp_sanitize_link_stack_end	NULL
>  #define __smccc_workaround_1_smc_start		NULL
> @@ -164,14 +161,15 @@ static void call_hvc_arch_workaround_1(void)
>  	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
>  }
>  
> -static bool check_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
> +static int smccc_arch_workaround_1(void *data)
>  {
> +	const struct arm64_cpu_capabilities *entry = data;
>  	bp_hardening_cb_t cb;
>  	void *smccc_start, *smccc_end;
>  	struct arm_smccc_res res;
>  
>  	if (!entry->matches(entry, SCOPE_LOCAL_CPU))

entry->matches() will be called twice in this function, another
one is in install_bp_hardening_cb() below, but install_bp_hardening_cb()
will be called in qcom_enable_link_stack_sanitization(), and
this is in the init path, so I think it's fine to keep as it is now.

> -		return false;
> +		return 0;
>  
>  	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
>  		return false;

return 0;

> @@ -181,7 +179,7 @@ static bool check_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *e
>  		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>  				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
>  		if (res.a0)
> -			return false;
> +			return 0;
>  		cb = call_hvc_arch_workaround_1;
>  		smccc_start = __smccc_workaround_1_hvc_start;
>  		smccc_end = __smccc_workaround_1_hvc_end;
> @@ -191,35 +189,18 @@ static bool check_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *e
>  		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>  				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
>  		if (res.a0)
> -			return false;
> +			return 0;
>  		cb = call_smc_arch_workaround_1;
>  		smccc_start = __smccc_workaround_1_smc_start;
>  		smccc_end = __smccc_workaround_1_smc_end;
>  		break;
>  
>  	default:
> -		return false;
> +		return 0;
>  	}
>  
>  	install_bp_hardening_cb(entry, cb, smccc_start, smccc_end);

Thanks
Hanjun
