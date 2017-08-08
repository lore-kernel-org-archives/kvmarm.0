From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Reject non-compliant HVC calls from guest
 kernel
Date: Tue, 8 Aug 2017 09:36:22 +0200
Message-ID: <20170808073622.GA26652@cbox>
References: <1502132608-26077-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1502132608-26077-1-git-send-email-shankerd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shanker,

On Mon, Aug 07, 2017 at 02:03:28PM -0500, Shanker Donthineni wrote:
> The SMC/HVC instructions with an immediate value non-zero are not compliant
> according to 'SMC calling convention system software document'. Add a
> validation check in handle_hvc() to avoid malicious HVC calls from VM, and


Why do the HVC calls become malicious if they have non-zero immediate
values --- can it actually break something today?


> inject an undefined instruction for those calls.
> 
> http://infocenter.arm.com/help/topic/com.arm.doc.den0028b/ARM_DEN0028B_SMC_Calling_Convention.pdf
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
>  arch/arm64/include/asm/esr.h |  4 ++++
>  arch/arm64/kvm/handle_exit.c | 12 +++++++-----
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 8cabd57..fa988e5 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -107,6 +107,9 @@
>  #define ESR_ELx_AR 		(UL(1) << 14)
>  #define ESR_ELx_CM 		(UL(1) << 8)
>  
> +/* ISS field definitions for HVC/SVC instruction execution traps */
> +#define ESR_HVC_IMMEDIATE(esr)	((esr) & 0xFFFF)
> +
>  /* ISS field definitions for exceptions taken in to Hyp */
>  #define ESR_ELx_CV		(UL(1) << 24)
>  #define ESR_ELx_COND_SHIFT	(20)
> @@ -114,6 +117,7 @@
>  #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
>  #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
>  
> +
>  /* ESR value templates for specific events */
>  
>  /* BRK instruction trap from AArch64 state */
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 17d8a16..a900dcd 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -42,13 +42,15 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			    kvm_vcpu_hvc_get_imm(vcpu));
>  	vcpu->stat.hvc_exit_stat++;
>  
> -	ret = kvm_psci_call(vcpu);
> -	if (ret < 0) {
> -		kvm_inject_undefined(vcpu);
> -		return 1;
> +	/* HVC immediate value must be zero for all compliant calls */
> +	if (!ESR_HVC_IMMEDIATE(kvm_vcpu_get_hsr(vcpu))) {
> +		ret = kvm_psci_call(vcpu);
> +		if (ret >= 0)
> +			return ret;

Out of curiosity, have you seen guests or any bad behavior with a
non-zero PSCI value, or are we just making sure we only support callers
that follow the SMC calling convention?

I hope we don't break any existing guests out there with this change,
including UEFI, old versions of Linux, etc.

(I do have this feeling that this check should be inside kvm_psci_call
instead, but it really doesn't matter at this point and we can always
move things around later if we start using other types of hypercalls
for anything.)

Thanks,
-Christoffer

>  	}
>  
> -	return ret;
> +	kvm_inject_undefined(vcpu);
> +	return 1;
>  }
>  
>  static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
> -- 
> Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
> 
