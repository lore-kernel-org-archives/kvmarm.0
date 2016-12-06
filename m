From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2] arm64: KVM: pmu: Reset PMSELR_EL0.SEL to a sane value
 before entering the guest
Date: Tue, 6 Dec 2016 15:27:09 +0000
Message-ID: <20161206152708.GL2498@arm.com>
References: <1481036210-31816-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C37D40199
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 10:26:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u3s3RP-M7Gue for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 10:26:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B061A40187
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 10:26:09 -0500 (EST)
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
Cc: Itaru Kitayama <itaru.kitayama@riken.jp>, Catalin Marinas <catalin.marinas@arm.com>, Hoan Tran <hotran@apm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Tai Tri Nguyen <ttnguyen@apm.com>
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

"UNDEF at EL1, as opposed to trapping to EL2" might be clearer, but up to
you.

> +	 */
> +	if (vcpu->arch.mdcr_el2 & MDCR_EL2_HPMN_MASK)
> +		write_sysreg(0, pmselr_el0);
>  	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);

Curious, but why do you check MDCR.HPMN for PMSELR_EL0, but not for
PMUSERENR_EL0?

Anyway:

Acked-by: Will Deacon <will.deacon@arm.com>

Thanks,

Will
