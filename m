From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 18/27] KVM: arm64/sve: Add SVE support to register
 access ioctl interface
Date: Thu, 4 Apr 2019 17:56:46 +0100
Message-ID: <20190404165645.GI3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-19-git-send-email-Dave.Martin@arm.com>
 <20190404135706.2yxakb4w6h6s7kxc@kamzik.brq.redhat.com>
 <20190404145056.GF3567@e103592.cambridge.arm.com>
 <20190404162539.tqygabtqrlma2272@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60CD84A36D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 12:56:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A+-Rw3aPTd7e for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 12:56:51 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF07C4A331
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 12:56:50 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190404162539.tqygabtqrlma2272@kamzik.brq.redhat.com>
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

On Thu, Apr 04, 2019 at 06:25:39PM +0200, Andrew Jones wrote:
> On Thu, Apr 04, 2019 at 03:50:56PM +0100, Dave Martin wrote:
> > On Thu, Apr 04, 2019 at 03:57:06PM +0200, Andrew Jones wrote:
> > > On Fri, Mar 29, 2019 at 01:00:43PM +0000, Dave Martin wrote:
> > > > This patch adds the following registers for access via the
> > > > KVM_{GET,SET}_ONE_REG interface:
> > > > 
> > > >  * KVM_REG_ARM64_SVE_ZREG(n, i) (n = 0..31) (in 2048-bit slices)
> > > >  * KVM_REG_ARM64_SVE_PREG(n, i) (n = 0..15) (in 256-bit slices)
> > > >  * KVM_REG_ARM64_SVE_FFR(i) (in 256-bit slices)
> > > > 
> > > > In order to adapt gracefully to future architectural extensions,
> > > > the registers are logically divided up into slices as noted above:
> > > > the i parameter denotes the slice index.
> > > > 
> > > > This allows us to reserve space in the ABI for future expansion of
> > > > these registers.  However, as of today the architecture does not
> > > > permit registers to be larger than a single slice, so no code is
> > > > needed in the kernel to expose additional slices, for now.  The
> > > > code can be extended later as needed to expose them up to a maximum
> > > > of 32 slices (as carved out in the architecture itself) if they
> > > > really exist someday.
> > > > 
> > > > The registers are only visible for vcpus that have SVE enabled.
> > > > They are not enumerated by KVM_GET_REG_LIST on vcpus that do not
> > > > have SVE.
> > > > 
> > > > Accesses to the FPSIMD registers via KVM_REG_ARM_CORE is not
> > > > allowed for SVE-enabled vcpus: SVE-aware userspace can use the
> > > > KVM_REG_ARM64_SVE_ZREG() interface instead to access the same
> > > > register state.  This avoids some complex and pointless emulation
> > > > in the kernel to convert between the two views of these aliased
> > > > registers.
> > > > 
> > > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> > > > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>

[...]

> > > > +#define KVM_REG_ARM64_SVE_FFR(i)	KVM_REG_ARM64_SVE_PREG(16, i)
> > > 
> > > Since this is user api and a user may want to construct their own register
> > > indices, then shouldn't we instead provide KVM_REG_ARM64_SVE_FFR_BASE as
> > > 
> > >  #define KVM_REG_ARM64_SVE_FFR_BASE KVM_REG_ARM64_SVE_PREG_BASE | (16 << 5)
> > 
> > Can do, or just
> > 
> > #define KVM_REG_ARM64_SVE_FFR_BASE KVM_REG_ARM64_SVE_PREG(0, 0)
> 
> I don't see how this would work for an FFR base.

Err yes, scratch that.  But I'm happy to have it, however defined.

[...]

> > > > +/* Get sanitised bounds for user/kernel SVE register copy */
> > > > +static int sve_reg_to_region(struct sve_state_reg_region *region,
> > > > +			     struct kvm_vcpu *vcpu,
> > > > +			     const struct kvm_one_reg *reg)
> > > > +{

[...]

> > > > +	sve_state_size = vcpu_sve_state_size(vcpu);
> > > > +	if (!sve_state_size)
> > > > +		return -EINVAL;
> > > > +
> > > > +	region->koffset = array_index_nospec(reqoffset, sve_state_size);
> > > > +	region->klen = min(maxlen, reqlen);
> > > > +	region->upad = reqlen - region->klen;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > > +{
> > > > +	struct sve_state_reg_region region;
> > > > +	char __user *uptr = (char __user *)reg->addr;
> > > > +
> > > > +	if (!vcpu_has_sve(vcpu) || sve_reg_to_region(&region, vcpu, reg))
> > > > +		return -ENOENT;
> > > 
> > > sve_reg_to_region() can return EINVAL, but here it would get changed to
> > > ENOENT.
> > 
> > Hmm, I'd say the affected code in sve_reg_to_region() should really be
> > a WARN_ON(): we're not supposed to hit it because we can't get here
> > until the vcpu is finalized.  It's really just a defensive check before
> > dividing by some potentially invalid value.  In such a case, it's
> > reasonable to have that EINVAL show through to userspace.
> 
> Adding the WARN_ON is a good idea. The thing is that the EINVAL is *not*
> going to show through to userspace. ENOENT will. Which might be fine,
> but if so, then it would clear things up to just return ENOENT in
> sve_reg_to_region() as well.

I meant that we can propagate the actual return value back.

It might be better just to merge the vcpu_has_sve() check into sve_reg_to_region(), and simply have

	int ret;

	ret = sve_reg_to_region(...);
	if (ret)
		return ret;

here.

Currently we return -ENOENT for a non-SVE-enabled vcpu, even if the reg
ID is complete garbage.  It would probably be useful to tidy that up at
the same time: -EINVAL would probably be more appropriate for such
cases.

[...]

> > > >  int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> > > >  {
> > > >  	return -EINVAL;
> > > > @@ -346,12 +461,12 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > >  	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
> > > >  		return -EINVAL;
> > > >  
> > > > -	/* Register group 16 means we want a core register. */
> > > > -	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
> > > > -		return get_core_reg(vcpu, reg);
> > > > -
> > > > -	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
> > > > -		return kvm_arm_get_fw_reg(vcpu, reg);
> > > > +	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
> > > > +	case KVM_REG_ARM_CORE:	return get_core_reg(vcpu, reg);
> > > > +	case KVM_REG_ARM_FW:	return kvm_arm_get_fw_reg(vcpu, reg);
> > > > +	case KVM_REG_ARM64_SVE:	return get_sve_reg(vcpu, reg);
> > > > +	default: break; /* fall through */
> > > 
> > > This case has a 'break', so it's not a 'fall through'. Do we require
> > > default cases even when they're unused? If not, why have it?
> > 
> > My reason for having that was to highlight that we fall through to the
> > code following the switch only in this case, because the other cases
> > all consist of return statements.
> 
> I think it's pretty clear from the 'case,return' pattern what's going on
> and the default case isn't needed at all. And since the fall through
> comment is typically used to document why there is not a break, then
> having both looks weird.

Sure, I'm more than happy to remove the redundant default case if you
feel its presence is confusing rather than helpful.

I didn't want it to look like the switch() was supposed to be exhaustive,
but the presence of code after it _should_ make that obvious.

> > 
> > > > +	}
> > > >  
> > > >  	if (is_timer_reg(reg->id))
> > > >  		return get_timer_reg(vcpu, reg);
> > > > @@ -365,12 +480,12 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > >  	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
> > > >  		return -EINVAL;
> > > >  
> > > > -	/* Register group 16 means we set a core register. */
> > > > -	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
> > > > -		return set_core_reg(vcpu, reg);
> > > > -
> > > > -	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
> > > > -		return kvm_arm_set_fw_reg(vcpu, reg);
> > > > +	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
> > > > +	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
> > > > +	case KVM_REG_ARM_FW:	return kvm_arm_set_fw_reg(vcpu, reg);
> > > > +	case KVM_REG_ARM64_SVE:	return set_sve_reg(vcpu, reg);
> > > > +	default: break; /* fall through */
> > > 
> > > Same as above.
> > 
> > I could move the trailing code into the default case, but that felt a
> > bit ugly.
> > 
> > Thoughts?
> 
> I'd remove the default case :)

OK

Cheers
---Dave
