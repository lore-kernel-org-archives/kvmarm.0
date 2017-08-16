From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 02/27] arm64: KVM: Hide unsupported AArch64 CPU features
 from guests
Date: Wed, 16 Aug 2017 21:32:03 +0100
Message-ID: <20170816203112.GF6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-3-git-send-email-Dave.Martin@arm.com>
 <9397d41c-f6f2-af7e-913e-a09f85ecc6bb@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9397d41c-f6f2-af7e-913e-a09f85ecc6bb@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 16, 2017 at 12:10:38PM +0100, Marc Zyngier wrote:
> On 09/08/17 13:05, Dave Martin wrote:
> > Currently, a guest kernel sees the true CPU feature registers
> > (ID_*_EL1) when it reads them using MRS instructions.  This means
> > that the guest will observe features that are present in the
> > hardware but the host doesn't understand or doesn't provide support
> > for.  A guest may legimitately try to use such a feature as per the
> > architecture, but use of the feature may trap instead of working
> > normally, triggering undef injection into the guest.
> > 
> > This is not a problem for the host, but the guest may go wrong when
> > running on newer hardware than the host knows about.
> > 
> > This patch hides from guest VMs any AArch64-specific CPU features
> > that the host doesn't support, by exposing to the guest the
> > sanitised versions of the registers computed by the cpufeatures
> > framework, instead of the true hardware registers.  To achieve
> > this, HCR_EL2.TID3 is now set for AArch64 guests, and emulation
> > code is added to KVM to report the sanitised versions of the
> > affected registers in response to MRS and register reads from
> > userspace.
> > 
> > The affected registers are removed from invariant_sys_regs[] (since
> > the invariant_sys_regs handling is no longer quite correct for
> > them) and added to sys_reg_desgs[], with appropriate access(),
> > get_user() and set_user() methods.  No runtime vcpu storage is
> > allocated for the registers: instead, they are read on demand from
> > the cpufeatures framework.  This may need modification in the
> > future if there is a need for userspace to customise the features
> > visible to the guest.
> > 
> > Attempts by userspace to write the registers are handled similarly
> > to the current invariant_sys_regs handling: writes are permitted,
> > but only if they don't attempt to change the value.  This is
> > sufficient to support VM snapshot/restore from userspace.
> > 
> > Because of the additional registers, restoring a VM on an older
> > kernel may not work unless userspace knows how to handle the extra
> > VM registers exposed to the KVM user ABI by this patch.
> > 
> > Under the principle of least damage, this patch makes no attempt to
> > handle any of the other registers currently in
> > invariant_sys_regs[], or to emulate registers for AArch32: however,
> > these could be handled in a similar way in future, as necessary.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/switch.c |   6 ++
> >  arch/arm64/kvm/sys_regs.c   | 224 +++++++++++++++++++++++++++++++++++---------
> >  2 files changed, 185 insertions(+), 45 deletions(-)
> > 

[...]

> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 2e070d3..6583dd7 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -892,6 +892,135 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
> >  	return true;
> >  }
> >  
> > +/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > +static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> > +{
> > +	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> > +			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> > +
> > +	return raz ? 0 : read_sanitised_ftr_reg(id);
> > +}
> > +
> > +/* cpufeature ID register access trap handlers */
> > +
> > +static bool __access_id_reg(struct kvm_vcpu *vcpu,
> > +			    struct sys_reg_params *p,
> > +			    const struct sys_reg_desc const *r,
> > +			    bool raz)
> > +{
> > +	if (p->is_write) {
> > +		kvm_inject_undefined(vcpu);
> > +		return false;
> > +	}
> 
> I don't think this is supposed to happen (should have UNDEF-ed at EL1).
> You can call write_to_read_only() in that case, which will spit out a
> warning and inject the exception.

I'll check this -- sounds about right.

If is should never happen, should I just delete that code or BUG()?  I
notice a BUG_ON() for a similar situation in access_vm_reg() for example.

Or do we not quite trust hardware not to get this wrong?
(It feels like the kind of thing that could slip through validation
and/or would be considered not worth a respin, but it seems wrong to
work around a theoretical hardware bug before it's confirmed to exist,
unless we think for some reason that it's really likely.)

> > +
> > +	p->regval = read_id_reg(r, raz);
> > +	return true;
> > +}

[...]

> > @@ -944,6 +1073,32 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> >  	{ SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
> >  
> >  	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
> > +
> > +	/*
> > +	 * All non-RAZ feature registers listed here must also be
> > +	 * present in arm64_ftr_regs[].
> > +	 */
> > +
> > +	/* AArch64 mappings of the AArch32 ID registers */
> > +	/* ID_AFR0_EL1 not exposed to guests for now */
> > +	ID(PFR0),	ID(PFR1),	ID(DFR0),	_ID_RAZ(1,3),
> > +	ID(MMFR0),	ID(MMFR1),	ID(MMFR2),	ID(MMFR3),
> > +	ID(ISAR0),	ID(ISAR1),	ID(ISAR2),	ID(ISAR3),
> > +	ID(ISAR4),	ID(ISAR5),	ID(MMFR4),	_ID_RAZ(2,7),
> > +	_ID(MVFR0),	_ID(MVFR1),	_ID(MVFR2),	_ID_RAZ(3,3),
> > +	_ID_RAZ(3,4),	_ID_RAZ(3,5),	_ID_RAZ(3,6),	_ID_RAZ(3,7),
> 
> #bikeshed:
> 
> OK, this is giving me a headache. Too many variants with similar names.
> ID and _ID
> I'm also slightly perplexed with the amalgamation of RAZ because the
> register is not defined yet in the architecture, and RAZ because we
> don't expose it (like ID_AFR0_EL1). Yes, there is a number of comments

This "raz" overloading already seems present in other places, such as the
cpufeatures code.  (Which is not necessarily a good reason for adding
more of it...)

> to document that, but the code should aim to be be self-documenting. How
> about IDRAZ() for those we want to "hide", and IDRSV for encodings that
> are not allocated yet? It would look like this:
> 
> 	IDREG(ID_PFR0),		IDREG(ID_PFR1),		IDREG(ID_DFR0),
> 	IDRAZ(ID_AFR0),		IDREG(ID_MMFR0),	IDREG(ID_MMFR1),
> 	IDREG(ID_MMFR2),	IDREG(ID_MMFR3),	IDREG(ID_ISAR0),
> 	IDREG(ID_ISAR1),	IDREG(ID_ISAR2),	IDREG(ID_ISAR3),
> 	IDREG(ID_ISAR4),	IDREG(ID_ISAR5),	IDREG(ID_MMFR4),
> 	IDRSV(2,7),		IDREG(MVFR0),		IDREG(MVFR1),
> 	IDREG(MVFR2),		IDRSV(3,3),		IDRSV(3,4),	
> 	IDRSV(3,5),		IDRSV(3,6),		IDRSV(3,7),
> 
> Yes, only 3 a line. Lines are cheap. And yes, they also have similar
> names, but I said #bikeshed.

So, point taken, but the main reason for making this a table was to make
it easy to see by eye how the entries map to the encoding while hacking
this up, which helped me to make sure no entries were missed or in the
wrong place etc.

With 3 entries per line that visual map is lost, and with 2 entries per
line it's debatable whether it's worth having multiple entries per line
at all.

So now that the table exists maybe we should just have one entry per
line like everything else -- it really depends on which option you think
is best for ongoing maintenance.


Having one per line allows much less cryptic names, allowing the
temptingly short but ambiguous "RAZ" to be avoided:

	ID_SANITISED(ID_ISAR5),
	ID_RAZ_FOR_GUEST(ID_AFR0),
	ID_UNALLOCATED(crm, op2)

With a whole line and different lengths, it's easier to pick out
the different cases by eye, so they don't all look like IDRXX (and are a
more tasteful colour perhaps).

Blank lines and/or comments can split the list into sensible blocks for
readability if needed.

If you're happy with naming along those broad lines then I'm happy to
see what it looks like.

> > +
> > +	/* AArch64 ID registers */
> > +	ID(AA64PFR0),	ID(AA64PFR1),	_ID_RAZ(4,2),	_ID_RAZ(4,3),
> > +	_ID_RAZ(4,4),	_ID_RAZ(4,5),	_ID_RAZ(4,6),	_ID_RAZ(4,7),
> > +	ID(AA64DFR0),	ID(AA64DFR1),	_ID_RAZ(5,2),	_ID_RAZ(5,3),
> > +	/* ID_AA64AFR0_EL1 and ID_AA64AFR0_EL1 not exposed to guests for now */

There are no sysreg definitions for IA_AA64AFR{0,1}_EL1 yet.

If we want to macroise those rather than just commenting, I guess
they'll need adding in sysreg.h.  I'd prefer not to imply these are
"unallocated" or similar when the architecture does define them.

Can I take it there's no problem with zombie entries in sysreg.h so long
as they're at least referenced somewhere?  (Arguably they wouldn't be
zombies then, but hopefully you see what I mean.)

[...]

> > +static int walk_one_sys_reg(const struct sys_reg_desc *rd,
> > +			    u64 __user **uind,
> > +			    unsigned int *total)
> > +{
> > +	/*
> > +	 * Ignore registers we trap but don't save,
> > +	 * and for which no custom user accessor is provided.
> > +	 */
> > +	if (!(rd->reg || rd->get_user))
> > +		return 0;
> > +
> > +	if (!copy_reg_to_user(rd, uind))
> > +		return -EFAULT;
> > +
> > +	(*total)++;
> > +	return 0;
> > +}
> > +
> >  /* Assumed ordered tables, see kvm_sys_reg_table_init. */
> >  static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
> >  {
> >  	const struct sys_reg_desc *i1, *i2, *end1, *end2;
> >  	unsigned int total = 0;
> >  	size_t num;
> > +	int err;
> >  
> >  	/* We check for duplicates here, to allow arch-specific overrides. */
> >  	i1 = get_target_table(vcpu->arch.target, true, &num);
> > @@ -2098,21 +2244,9 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
> >  	while (i1 || i2) {
> >  		int cmp = cmp_sys_reg(i1, i2);
> >  		/* target-specific overrides generic entry. */
> > -		if (cmp <= 0) {
> > -			/* Ignore registers we trap but don't save. */
> > -			if (i1->reg) {
> > -				if (!copy_reg_to_user(i1, &uind))
> > -					return -EFAULT;
> > -				total++;
> > -			}
> > -		} else {
> > -			/* Ignore registers we trap but don't save. */
> > -			if (i2->reg) {
> > -				if (!copy_reg_to_user(i2, &uind))
> > -					return -EFAULT;
> > -				total++;
> > -			}
> > -		}
> > +		err = walk_one_sys_reg(cmp <= 0 ? i1 : i2, &uind, &total);
> 
> Please move this ternary operator out of the function parameters, as
> that code is hairy enough. Or use the new function twice within the "if"
> statement.

Can do.  Making this a one-liner doesn't buy us an awful lot.

Cheers
---Dave
