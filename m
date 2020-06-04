Return-Path: <SRS0=AWUd=7R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4311C433DF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 15:23:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 698ED207DF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 15:23:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 698ED207DF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAC3D4B404;
	Thu,  4 Jun 2020 11:23:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UVSMlebvJBbZ; Thu,  4 Jun 2020 11:23:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B8C14B400;
	Thu,  4 Jun 2020 11:23:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61DC34B400
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 11:23:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GbJ80S81SiQ9 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2020 11:23:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDB9D4B1ED
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 11:23:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75CFE1FB;
 Thu,  4 Jun 2020 08:23:38 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.9.165])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C8D93F305;
 Thu,  4 Jun 2020 08:23:36 -0700 (PDT)
Date: Thu, 4 Jun 2020 16:23:33 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Handle PtrAuth traps early
Message-ID: <20200604152333.GD75320@C02TD0UTHF1T.local>
References: <20200604133354.1279412-1-maz@kernel.org>
 <20200604133354.1279412-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200604133354.1279412-3-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Jun 04, 2020 at 02:33:53PM +0100, Marc Zyngier wrote:
> The current way we deal with PtrAuth is a bit heavy handed:
> 
> - We forcefully save the host's keys on each vcpu_load()
> - Handling the PtrAuth trap forces us to go all the way back
>   to the exit handling code to just set the HCR bits
> 
> Overall, this is pretty heavy handed. A better approach would be
> to handle it the same way we deal with the FPSIMD registers:
> 
> - On vcpu_load() disable PtrAuth for the guest
> - On first use, save the host's keys, enable PtrAuth in the
>   guest
> 
> Crutially, this can happen as a fixup, which is done very early
> on exit. We can then reenter the guest immediately without
> leaving the hypervisor role.
> 
> Another thing is that it simplify the rest of the host handling:
> exiting all the way to the host means that the only possible
> outcome for this trap is to inject an UNDEF.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c         | 17 +----------
>  arch/arm64/kvm/handle_exit.c | 17 ++---------
>  arch/arm64/kvm/hyp/switch.c  | 59 ++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c    | 13 +++-----
>  4 files changed, 68 insertions(+), 38 deletions(-)

[...]

> +static bool __hyp_text __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
> +{
> +	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_hsr(vcpu));
> +	u32 ec = kvm_vcpu_trap_get_class(vcpu);
> +	struct kvm_cpu_context *ctxt;
> +	u64 val;
> +
> +	if (!vcpu_has_ptrauth(vcpu))
> +		return false;
> +
> +	switch (ec) {
> +	case ESR_ELx_EC_PAC:
> +		break;
> +	case ESR_ELx_EC_SYS64:
> +		switch (sysreg) {
> +		case SYS_APIAKEYLO_EL1:
> +		case SYS_APIAKEYHI_EL1:
> +		case SYS_APIBKEYLO_EL1:
> +		case SYS_APIBKEYHI_EL1:
> +		case SYS_APDAKEYLO_EL1:
> +		case SYS_APDAKEYHI_EL1:
> +		case SYS_APDBKEYLO_EL1:
> +		case SYS_APDBKEYHI_EL1:
> +		case SYS_APGAKEYLO_EL1:
> +		case SYS_APGAKEYHI_EL1:
> +			break;
> +		default:
> +			return false;
> +		}
> +		break;
> +	default:
> +		return false;
> +	}

The ESR triage looks correct, but I think it might be clearer split out
into a helper, since you can avoid the default cases with direct
returns, and you could avoid the nested switch, e.g.

static inline bool __hyp_text esr_is_ptrauth_trap(u32 esr)
{
	u32 ec = ESR_ELx_EC(esr);

	if (ec == ESR_ELx_EC_PAC)
		return true;

	if (ec != ESR_ELx_EC_SYS64)
		return false;
	
	switch (esr_sys64_to_sysreg(esr)) {
	case SYS_APIAKEYLO_EL1:
	case SYS_APIAKEYHI_EL1:
	case SYS_APIBKEYLO_EL1:
	case SYS_APIBKEYHI_EL1:
	case SYS_APDAKEYLO_EL1:
	case SYS_APDAKEYHI_EL1:
	case SYS_APDBKEYLO_EL1:
	case SYS_APDBKEYHI_EL1:
	case SYS_APGAKEYLO_EL1:
	case SYS_APGAKEYHI_EL1:
		return true;
	}

	return false;
}


> +
> +	ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +	__ptrauth_save_key(ctxt->sys_regs, APIA);
> +	__ptrauth_save_key(ctxt->sys_regs, APIB);
> +	__ptrauth_save_key(ctxt->sys_regs, APDA);
> +	__ptrauth_save_key(ctxt->sys_regs, APDB);
> +	__ptrauth_save_key(ctxt->sys_regs, APGA);
> +
> +	vcpu_ptrauth_enable(vcpu);
> +
> +	val = read_sysreg(hcr_el2);
> +	val |= (HCR_API | HCR_APK);
> +	write_sysreg(val, hcr_el2);
> +
> +	return true;
> +}
> +
>  /*
>   * Return true when we were able to fixup the guest exit and should return to
>   * the guest, false when we should restore the host state and return to the
> @@ -524,6 +580,9 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	if (__hyp_handle_fpsimd(vcpu))
>  		return true;
>  
> +	if (__hyp_handle_ptrauth(vcpu))
> +		return true;
> +
>  	if (!__populate_fault_info(vcpu))
>  		return true;
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ad1d57501d6d..564995084cf8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1034,16 +1034,13 @@ static bool trap_ptrauth(struct kvm_vcpu *vcpu,
>  			 struct sys_reg_params *p,
>  			 const struct sys_reg_desc *rd)
>  {
> -	kvm_arm_vcpu_ptrauth_trap(vcpu);
> -
>  	/*
> -	 * Return false for both cases as we never skip the trapped
> -	 * instruction:
> -	 *
> -	 * - Either we re-execute the same key register access instruction
> -	 *   after enabling ptrauth.
> -	 * - Or an UNDEF is injected as ptrauth is not supported/enabled.
> +	 * If we land here, that is because we didn't fixup the access on exit
> +	 * by allowing the PtrAuth sysregs. The only way this happens is when
> +	 * the guest does not have PtrAuth support enabled.
>  	 */
> +	kvm_inject_undefined(vcpu);
> +
>  	return false;
>  }
>  
> -- 
> 2.26.2
> 

Regardless of the suggestion above, this looks sound to me. I agree that
it's much nicer to handle this in hyp, and AFAICT the context switch
should do the right thing, so:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
