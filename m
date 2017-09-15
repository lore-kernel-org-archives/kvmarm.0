From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 02/28] arm64: KVM: Hide unsupported AArch64 CPU
 features from guests
Date: Fri, 15 Sep 2017 01:04:24 +0100
Message-ID: <20170915000424.GD24231@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-3-git-send-email-Dave.Martin@arm.com>
 <87r2vaacll.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r2vaacll.fsf@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 13, 2017 at 03:37:42PM +0100, Alex Bennée wrote:
> 
> Dave Martin <Dave.Martin@arm.com> writes:

[...]

> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 945e79c..35a90b8 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -81,11 +81,17 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> >  	 * it will cause an exception.
> >  	 */
> >  	val = vcpu->arch.hcr_el2;
> > +
> >  	if (!(val & HCR_RW) && system_supports_fpsimd()) {
> >  		write_sysreg(1 << 30, fpexc32_el2);
> >  		isb();
> >  	}
> > +
> > +	if (val & HCR_RW) /* for AArch64 only: */
> > +		val |= HCR_TID3; /* TID3: trap feature register accesses */
> > +
> 
> I wondered as this is the hyp switch can we make use of testing val &
> HCR_RW for both this and above. But it seems minimal in the generated
> code so probably not.

I figured that the code was cleaner ths way, since they're independent
bits of code that both happen to be applicable only to AArch64 guests.

[...]

> > +
> > +	/*
> > +	 * ID regs: all ID_SANITISED() entries here must have corresponding
> > +	 * entries in arm64_ftr_regs[].
> > +	 */
> 
> arm64_ftr_regs isn't updated in this commit. Does this break bisection?

This commit only adds ID_SANITISED() entries for regs that are already
present in arm64_ftr_regs[].  (If you spot any that are missing, give me
a shout...)

SVE only adds one new ID register, ID_AA64ZFR0_EL1 -- but SVE defines no
fields in there yet, so I just leave it ID_UNALLOCATED() which will
cause it to read as zero for the guest.

> > +
> > +	/* AArch64 mappings of the AArch32 ID registers */
> > +	/* CRm=1 */
> > +	ID_SANITISED(ID_PFR0_EL1),
> > +	ID_SANITISED(ID_PFR1_EL1),

[...]

> > +	/* CRm=7 */
> > +	ID_SANITISED(ID_AA64MMFR0_EL1),
> > +	ID_SANITISED(ID_AA64MMFR1_EL1),
> > +	ID_SANITISED(ID_AA64MMFR2_EL1),
> > +	ID_UNALLOCATED(7,3),
> > +	ID_UNALLOCATED(7,4),
> > +	ID_UNALLOCATED(7,5),
> > +	ID_UNALLOCATED(7,6),
> > +	ID_UNALLOCATED(7,7),
> > +
> 
> I think it might be worthwhile adding a test to kvm-unit-tests to walk
> all the ID registers to check this.

Sounds sensible, I'll take a look at that.

[...]

Cheers
---Dave
