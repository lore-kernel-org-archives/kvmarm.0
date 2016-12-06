From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] arm64: KVM: pmu: Reset PMSELR_EL0.SEL to a sane value
 before entering the guest
Date: Tue, 6 Dec 2016 17:29:18 +0100
Message-ID: <20161206162918.GE4816@cbox>
References: <1481036210-31816-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3B4E4027C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 11:28:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oi4bp1oNjubq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 11:28:13 -0500 (EST)
Received: from mail-wj0-f181.google.com (mail-wj0-f181.google.com
 [209.85.210.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DF564022C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 11:28:12 -0500 (EST)
Received: by mail-wj0-f181.google.com with SMTP id v7so327925058wjy.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Dec 2016 08:29:11 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1481036210-31816-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Itaru Kitayama <itaru.kitayama@riken.jp>, Catalin Marinas <catalin.marinas@arm.com>, Hoan Tran <hotran@apm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Tai Tri Nguyen <ttnguyen@apm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 06, 2016 at 02:56:50PM +0000, Marc Zyngier wrote:
> The ARMv8 architecture allows the cycle counter to be configured
> by setting PMSELR_EL0.SEL==0x1f and then accessing PMXEVTYPER_EL0,
> hence accessing PMCCFILTR_EL0. But it disallows the use of
> PMSELR_EL0.SEL==0x1f to access the cycle counter itself through
> PMXEVCNTR_EL0.
> 
> Linux itself doesn't violate this rule, but we may end up with
> PMSELR_EL0.SEL being set to 0x1f when we enter a guest. If that
> guest accesses PMXEVCNTR_EL0, the access may UNDEF at EL1,
> despite the guest not having done anything wrong.
> 
> In order to avoid this unfortunate course of events (haha!), let's

I actually did find this funny.

> sanitize PMSELR_EL0 on guest entry. This ensures that the guest
> won't explode unexpectedly.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
> This is another approach to fix this issue, this time nuking PMSELR_EL0
> on guest entry instead of relying on perf not to clobber the register.
> 
> Tested on v4.9-rc8 with a Rev A3 X-Gene.
> 
>  arch/arm64/kvm/hyp/switch.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 83037cd..3b7cfbd 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -85,7 +85,13 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  	write_sysreg(val, hcr_el2);
>  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
>  	write_sysreg(1 << 15, hstr_el2);
> -	/* Make sure we trap PMU access from EL0 to EL2 */
> +	/*
> +	 * Make sure we trap PMU access from EL0 to EL2. Also sanitize
> +	 * PMSELR_EL0 to make sure it never contains the cycle
> +	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF.
> +	 */
> +	if (vcpu->arch.mdcr_el2 & MDCR_EL2_HPMN_MASK)
> +		write_sysreg(0, pmselr_el0);

I'm a bit confused about how we use the HPMN field.  This value is
always set to the full number of counters available on the system and
never modified by the guest, right?  So this is in essence a check that
says 'do you have any performance counters, then make sure accesses
don't undef to el1 instead of trapping to el2', but then my question is,
why not just set pmselr_el0 to zero unconditionally, because in the case
where (vcpu->arch.mdcr_el2 & MDCR_EL2_HPMN_MASK) == 0, it means we have
no counters, which we'll have exposed to the guest anyhow, and we should
undef at el1 in the guest, or did I get this completely wrong (like
everything else today)?

>  	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  	__activate_traps_arch()();
> -- 
> 2.1.4
> 

Thanks,
-Christoffer
