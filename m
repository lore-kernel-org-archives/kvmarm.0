From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2] arm64: KVM: pmu: Reset PMSELR_EL0.SEL to a sane value
 before entering the guest
Date: Tue, 6 Dec 2016 16:37:07 +0000
Message-ID: <20161206163706.GR2498@arm.com>
References: <1481036210-31816-1-git-send-email-marc.zyngier@arm.com>
 <20161206162918.GE4816@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9292402AF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 11:36:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oVF6xBcF8dEq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 11:36:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 233D64027C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 11:36:07 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161206162918.GE4816@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Hoan Tran <hotran@apm.com>, Itaru Kitayama <itaru.kitayama@riken.jp>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Tai Tri Nguyen <ttnguyen@apm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 06, 2016 at 05:29:18PM +0100, Christoffer Dall wrote:
> On Tue, Dec 06, 2016 at 02:56:50PM +0000, Marc Zyngier wrote:
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 83037cd..3b7cfbd 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -85,7 +85,13 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> >  	write_sysreg(val, hcr_el2);
> >  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
> >  	write_sysreg(1 << 15, hstr_el2);
> > -	/* Make sure we trap PMU access from EL0 to EL2 */
> > +	/*
> > +	 * Make sure we trap PMU access from EL0 to EL2. Also sanitize
> > +	 * PMSELR_EL0 to make sure it never contains the cycle
> > +	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF.
> > +	 */
> > +	if (vcpu->arch.mdcr_el2 & MDCR_EL2_HPMN_MASK)
> > +		write_sysreg(0, pmselr_el0);
> 
> I'm a bit confused about how we use the HPMN field.  This value is
> always set to the full number of counters available on the system and
> never modified by the guest, right?  So this is in essence a check that
> says 'do you have any performance counters, then make sure accesses
> don't undef to el1 instead of trapping to el2', but then my question is,
> why not just set pmselr_el0 to zero unconditionally, because in the case
> where (vcpu->arch.mdcr_el2 & MDCR_EL2_HPMN_MASK) == 0, it means we have
> no counters, which we'll have exposed to the guest anyhow, and we should
> undef at el1 in the guest, or did I get this completely wrong (like
> everything else today)?

I think Marc and I came to the same conclusion a few minutes ago. The check
you might want is "Have I instantiated a virtual PMU for this device?",
but that's probably a micro-optimisation.

Will
