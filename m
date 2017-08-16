From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 23/27] arm64/sve: KVM: Hide SVE from CPU features exposed
 to guests
Date: Wed, 16 Aug 2017 11:54:38 +0100
Message-ID: <20170816105438.GA6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-24-git-send-email-Dave.Martin@arm.com>
 <39b6ee07-1258-e733-3495-38b0d31ab800@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <39b6ee07-1258-e733-3495-38b0d31ab800@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 15, 2017 at 05:37:55PM +0100, Marc Zyngier wrote:
> On 09/08/17 13:05, Dave Martin wrote:
> > KVM guests cannot currently use SVE, because SVE is always
> > configured to trap to EL2.
> > 
> > However, a guest that sees SVE reported as present in
> > ID_AA64PFR0_EL1 may legitimately expect that SVE works and try to
> > use it.  Instead of working, the guest will receive an injected
> > undef exception, which may cause the guest to oops or go into a
> > spin.
> > 
> > To avoid misleading the guest into believing that SVE will work,
> > this patch masks out the SVE field from ID_AA64PFR0_EL1 when a
> > guest attempts to read this register.  No support is explicitly
> > added for ID_AA64ZFR0_EL1 either, so that is still emulated as
> > reading as zero, which is consistent with SVE not being
> > implemented.
> > 
> > This is a temporary measure, and will be removed in a later series
> > when full KVM support for SVE is implemented.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 6583dd7..9e8c54e 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -897,8 +897,20 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> >  {
> >  	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> >  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> > +	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> >  
> > -	return raz ? 0 : read_sanitised_ftr_reg(id);
> > +	if (id == SYS_ID_AA64PFR0_EL1) {
> > +		static bool printed;
> > +
> > +		if ((val & (0xfUL << ID_AA64PFR0_SVE_SHIFT)) && !printed) {
> > +			kvm_info("SVE unsupported for guests, suppressing\n");
> > +			printed = true;
> > +		}
> 
> Ideally, this should be a vcpu_unimpl_once(). But:
> - it doesn't exist
> - vcpu_unimpl looks hopelessly x86 specific

Yeah, I looked for an appropriate function and didn't find one ... and
writing one just for this seemed overkill.

> How about turning it into a pr_err_once() instead?

Can do, though should it be an err?

No error has occurred here, rather I want people who discover that their
guest mysteriously doesn't see SVE gets a clue about why.

[...]

Cheers
---Dave
