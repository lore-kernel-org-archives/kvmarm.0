From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 12/27] KVM: arm64/sve: System register context switch
 and access support
Date: Thu, 4 Apr 2019 09:06:58 +0100
Message-ID: <20190404080658.GX3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-13-git-send-email-Dave.Martin@arm.com>
 <20190403193943.nv7s36yf2nkzvzwo@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6F424A380
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 04:07:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uzdpfQOuRgq8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 04:07:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 087E64A36C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 04:07:04 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190403193943.nv7s36yf2nkzvzwo@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 03, 2019 at 09:39:43PM +0200, Andrew Jones wrote:
> On Fri, Mar 29, 2019 at 01:00:37PM +0000, Dave Martin wrote:
> > This patch adds the necessary support for context switching ZCR_EL1
> > for each vcpu.
> > 
> > ZCR_EL1 is trapped alongside the FPSIMD/SVE registers, so it makes
> > sense for it to be handled as part of the guest FPSIMD/SVE context
> > for context switch purposes instead of handling it as a general
> > system register.  This means that it can be switched in lazily at
> > the appropriate time.  No effort is made to track host context for
> > this register, since SVE requires VHE: thus the hosts's value for
> > this register lives permanently in ZCR_EL2 and does not alias the
> > guest's value at any time.
> > 
> > The Hyp switch and fpsimd context handling code is extended
> > appropriately.
> > 
> > Accessors are added in sys_regs.c to expose the SVE system
> > registers and ID register fields.  Because these need to be
> > conditionally visible based on the guest configuration, they are
> > implemented separately for now rather than by use of the generic
> > system register helpers.  This may be abstracted better later on
> > when/if there are more features requiring this model.
> > 
> > ID_AA64ZFR0_EL1 is RO-RAZ for MRS/MSR when SVE is disabled for the
> > guest, but for compatibility with non-SVE aware KVM implementations
> > the register should not be enumerated at all for KVM_GET_REG_LIST
> > in this case.  For consistency we also reject ioctl access to the
> > register.  This ensures that a non-SVE-enabled guest looks the same
> > to userspace, irrespective of whether the kernel KVM implementation
> > supports SVE.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> > 
> > ---
> > 
> > Changes since v5:
> > 
> >  * Port to the renamed visibility() framework.
> > 
> >  * Swap visiblity() helpers so that they appear by the relevant accessor
> >    functions.
> > 
> >  * [Julien Grall] With the visibility() checks, {get,set}_zcr_el1()
> >    degenerate to doing exactly what the common code does, so drop them.
> > 
> >    The ID_AA64ZFR0_EL1 handlers are still needed to provide contitional
> >    RAZ behaviour.  This could be moved to the common code too, but since
> >    this is a one-off case I don't do this for now.  We can address this
> >    later if other regs need to follow the same pattern.
> > 
> >  * [Julien Thierry] Reset ZCR_EL1 to a fixed value using reset_val
> >    instead of using relying on reset_unknown() honouring set bits in val
> >    as RES0.
> > 
> >    Most of the bits in ZCR_EL1 are RES0 anyway, and many implementations
> >    of SVE will support larger vectors than 128 bits, so 0 seems as good
> >    a value as any to expose guests that forget to initialise this
> >    register properly.
> > ---

[...]

> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 3563fe6..9d46066 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c

[...]

> > +static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> > +		const struct sys_reg_desc *rd,
> > +		const struct kvm_one_reg *reg, void __user *uaddr)
> > +{
> > +	u64 val;
> > +
> > +	if (!vcpu_has_sve(vcpu))
> > +		return -ENOENT;
> 
> This shouldn't be necessary. The visibility check in
> kvm_arm_sys_reg_get_reg already covers it.
> 
> > +
> > +	val = guest_id_aa64zfr0_el1(vcpu);
> > +	return reg_to_user(uaddr, &val, reg->id);
> > +}
> > +
> > +static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> > +		const struct sys_reg_desc *rd,
> > +		const struct kvm_one_reg *reg, void __user *uaddr)
> > +{
> > +	const u64 id = sys_reg_to_index(rd);
> > +	int err;
> > +	u64 val;
> > +
> > +	if (!vcpu_has_sve(vcpu))
> > +		return -ENOENT;
> 
> Also not necessary.

Hmm, true.  Because the logic is a bit spread out I felt uneasy with
simply deleting these checks, but if they fire, something has
definitely gone wrong elsewhere.

In its current form the code makes it look like it could be legitimate
to get here with !vcpu_has_sve(vcpu), which is misleading.

What if we demote these to WARN_ON()?  This isn't a fast path.

[...]

> >  /*
> >   * cpufeature ID register user accessors
> >   *
> > @@ -1346,7 +1418,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> >  	ID_SANITISED(ID_AA64PFR1_EL1),
> >  	ID_UNALLOCATED(4,2),
> >  	ID_UNALLOCATED(4,3),
> > -	ID_UNALLOCATED(4,4),
> > +	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, .visibility = sve_id_visibility },
> >  	ID_UNALLOCATED(4,5),
> >  	ID_UNALLOCATED(4,6),
> >  	ID_UNALLOCATED(4,7),
> > @@ -1383,6 +1455,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> >  
> >  	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
> >  	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
> > +	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
> >  	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
> >  	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
> >  	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
> 
> Mixing designated and non-designated initializers isn't particularly nice,
> but I guess it's valid, and the simple alternatives are probably worse.

Agreed.  We could add designators everywhere or more wrapper macros, but
I couldn't see any option that didn't have drawbacks.

Since this is a rare case today, I preferred to keep it as explicit in
the source as possible.

Cheers
---Dave
