Return-Path: <SRS0=JN4F=7B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B83C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 19 May 2020 10:45:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A670220674
	for <kvmarm@archiver.kernel.org>; Tue, 19 May 2020 10:45:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A670220674
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 231814B1BC;
	Tue, 19 May 2020 06:45:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hMrVDDrP9g0U; Tue, 19 May 2020 06:45:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C25654B1B2;
	Tue, 19 May 2020 06:45:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 477F14B1B0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2020 06:45:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YStfCaGqFZeI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 May 2020 06:45:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01DE14B1AF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2020 06:45:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A279A101E;
 Tue, 19 May 2020 03:45:05 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.1.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5837B3F305;
 Tue, 19 May 2020 03:45:02 -0700 (PDT)
Date: Tue, 19 May 2020 11:44:57 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 26/26] KVM: arm64: Parametrize exception entry with a
 target EL
Message-ID: <20200519104457.GA19548@C02TD0UTHF1T.local>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-27-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200422120050.3693593-27-maz@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>,
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

On Wed, Apr 22, 2020 at 01:00:50PM +0100, Marc Zyngier wrote:
> We currently assume that an exception is delivered to EL1, always.
> Once we emulate EL2, this no longer will be the case. To prepare
> for this, add a target_mode parameter.
> 
> While we're at it, merge the computing of the target PC and PSTATE in
> a single function that updates both PC and CPSR after saving their
> previous values in the corresponding ELR/SPSR. This ensures that they
> are updated in the correct order (a pretty common source of bugs...).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/inject_fault.c | 75 ++++++++++++++++++-----------------
>  1 file changed, 38 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index d3ebf8bca4b89..3dbcbc839b9c3 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -26,28 +26,12 @@ enum exception_type {
>  	except_type_serror	= 0x180,
>  };
>  
> -static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
> -{
> -	u64 exc_offset;
> -
> -	switch (*vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
> -	case PSR_MODE_EL1t:
> -		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
> -		break;
> -	case PSR_MODE_EL1h:
> -		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
> -		break;
> -	case PSR_MODE_EL0t:
> -		exc_offset = LOWER_EL_AArch64_VECTOR;
> -		break;
> -	default:
> -		exc_offset = LOWER_EL_AArch32_VECTOR;
> -	}
> -
> -	return vcpu_read_sys_reg(vcpu, VBAR_EL1) + exc_offset + type;
> -}
> -
>  /*
> + * This performs the exception entry at a given EL (@target_mode), stashing PC
> + * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
> + * The EL passed to this function *must* be a non-secure, privileged mode with
> + * bit 0 being set (PSTATE.SP == 1).
> + *
>   * When an exception is taken, most PSTATE fields are left unchanged in the
>   * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
>   * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
> @@ -59,10 +43,35 @@ static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
>   * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
>   * MSB to LSB.
>   */
> -static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
> +static void enter_exception(struct kvm_vcpu *vcpu, unsigned long target_mode,
> +			    enum exception_type type)

Since this is all for an AArch64 target, could we keep `64` in the name,
e.g enter_exception64? That'd mirror the callers below.

>  {
> -	unsigned long sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> -	unsigned long old, new;
> +	unsigned long sctlr, vbar, old, new, mode;
> +	u64 exc_offset;
> +
> +	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +	if      (mode == target_mode)
> +		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
> +	else if ((mode | 1) == target_mode)
> +		exc_offset = CURRENT_EL_SP_EL0_VECTOR;

It would be nice if we could add a mnemonic for the `1` here, e.g.
PSR_MODE_SP0 or PSR_MODE_THREAD_BIT.

> +	else if (!(mode & PSR_MODE32_BIT))
> +		exc_offset = LOWER_EL_AArch64_VECTOR;
> +	else
> +		exc_offset = LOWER_EL_AArch32_VECTOR;

Other than the above, I couldn't think of a nicer way of writing thism
and AFAICT this is correct.

> +
> +	switch (target_mode) {
> +	case PSR_MODE_EL1h:
> +		vbar = vcpu_read_sys_reg(vcpu, VBAR_EL1);
> +		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
> +		break;
> +	default:
> +		/* Don't do that */
> +		BUG();
> +	}
> +
> +	*vcpu_pc(vcpu) = vbar + exc_offset + type;
>  
>  	old = *vcpu_cpsr(vcpu);
>  	new = 0;
> @@ -105,9 +114,10 @@ static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
>  	new |= PSR_I_BIT;
>  	new |= PSR_F_BIT;
>  
> -	new |= PSR_MODE_EL1h;
> +	new |= target_mode;

As a heads-up, some of the other bits will need to change for an EL2
target (e.g. SPAN will depend on HCR_EL2.E2H), but as-is this this is
fine.

Regardless of the above comments:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
