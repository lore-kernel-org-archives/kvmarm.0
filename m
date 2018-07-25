From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 14/16] KVM: arm64/sve: Add SVE support to register
 access ioctl interface
Date: Wed, 25 Jul 2018 15:06:21 +0100
Message-ID: <20180725140621.GK4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-15-git-send-email-Dave.Martin@arm.com>
 <20180719130433.mfqqnxxlmvhduqri@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FDB4404D9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:06:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HtMsnevq93cC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 10:06:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D3DC4045F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:06:26 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180719130433.mfqqnxxlmvhduqri@kamzik.brq.redhat.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 19, 2018 at 03:04:33PM +0200, Andrew Jones wrote:
> On Thu, Jun 21, 2018 at 03:57:38PM +0100, Dave Martin wrote:
> > This patch adds the following registers for access via the
> > KVM_{GET,SET}_ONE_REG interface:
> > 
> >  * KVM_REG_ARM64_SVE_ZREG(n, i) (n = 0..31) (in 2048-bit slices)
> >  * KVM_REG_ARM64_SVE_PREG(n, i) (n = 0..15) (in 256-bit slices)
> >  * KVM_REG_ARM64_SVE_FFR(i) (in 256-bit slices)
> > 
> > In order to adapt gracefully to future architectural extensions,
> > the registers are divided up into slices as noted above:  the i
> > parameter denotes the slice index.
> > 
> > For simplicity, bits or slices that exceed the maximum vector
> > length supported for the vcpu are ignored for KVM_SET_ONE_REG, and
> > read as zero for KVM_GET_ONE_REG.
> > 
> > For the current architecture, only slice i = 0 is significant.  The
> > interface design allows i to increase to up to 31 in the future if
> > required by future architectural amendments.
> > 
> > The registers are only visible for vcpus that have SVE enabled.
> > They are not enumerated by KVM_GET_REG_LIST on vcpus that do not
> > have SVE.  In all cases, surplus slices are not enumerated by
> > KVM_GET_REG_LIST.
> > 
> > Accesses to the FPSIMD registers via KVM_REG_ARM_CORE are
> > redirected to access the underlying vcpu SVE register storage as
> > appropriate.  In order to make this more straightforward, register
> > accesses that straddle register boundaries are no longer guaranteed
> > to succeed.  (Support for such use was never deliberate, and
> > userspace does not currently seem to be relying on it.)
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/include/uapi/asm/kvm.h |  10 ++
> >  arch/arm64/kvm/guest.c            | 219 +++++++++++++++++++++++++++++++++++---
> >  2 files changed, 216 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 4e76630..f54a9b0 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -213,6 +213,16 @@ struct kvm_arch_memory_slot {
> >  					 KVM_REG_ARM_FW | ((r) & 0xffff))
> >  #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
> >  
> > +/* SVE registers */
> > +#define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
> > +#define KVM_REG_ARM64_SVE_ZREG(n, i)	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
> > +					 KVM_REG_SIZE_U2048 |		\
> > +					 ((n) << 5) | (i))
> > +#define KVM_REG_ARM64_SVE_PREG(n, i)	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
> > +					 KVM_REG_SIZE_U256 |		\
> > +					 ((n) << 5) | (i) | 0x400)
> > +#define KVM_REG_ARM64_SVE_FFR(i)	KVM_REG_ARM64_SVE_PREG(16, i)
> > +
> >  /* Device Control API: ARM VGIC */
> >  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> >  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 4a9d77c..005394b 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -23,14 +23,19 @@
> >  #include <linux/err.h>
> >  #include <linux/kvm_host.h>
> >  #include <linux/module.h>
> > +#include <linux/uaccess.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/fs.h>
> > +#include <linux/stddef.h>
> >  #include <kvm/arm_psci.h>
> >  #include <asm/cputype.h>
> >  #include <linux/uaccess.h>
> > +#include <asm/fpsimd.h>
> >  #include <asm/kvm.h>
> >  #include <asm/kvm_emulate.h>
> >  #include <asm/kvm_coproc.h>
> > +#include <asm/kvm_host.h>
> > +#include <asm/sigcontext.h>
> >  
> >  #include "trace.h"
> >  
> > @@ -57,6 +62,106 @@ static u64 core_reg_offset_from_id(u64 id)
> >  	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
> >  }
> >  
> > +static bool is_zreg(const struct kvm_one_reg *reg)
> > +{
> > +	return	reg->id >= KVM_REG_ARM64_SVE_ZREG(0, 0) &&
> > +		reg->id <= KVM_REG_ARM64_SVE_ZREG(SVE_NUM_ZREGS, 0x1f);
> > +}
> > +
> > +static bool is_preg(const struct kvm_one_reg *reg)
> > +{
> > +	return	reg->id >= KVM_REG_ARM64_SVE_PREG(0, 0) &&
> > +		reg->id <= KVM_REG_ARM64_SVE_FFR(0x1f);
> > +}
> > +
> > +static unsigned int sve_reg_num(const struct kvm_one_reg *reg)
> > +{
> > +	return (reg->id >> 5) & 0x1f;
> > +}
> > +
> > +static unsigned int sve_reg_index(const struct kvm_one_reg *reg)
> > +{
> > +	return reg->id & 0x1f;
> > +}
> > +
> > +struct reg_bounds_struct {
> > +	char *kptr;
> > +	size_t start_offset;
> 
> Maybe start_offset gets used in a later patch, but it doesn't seem
> to be used here.

Good spot.  It looks like I was originally going to have kptr point to
the base of the thing to be copied, rather than the exact start
location, with start_offset providing the necessary offset from the
base... then at some point I changed my mind.

I need to check through the code to see whether the code is consistent
now.  fpsimd_vreg_bounds() assigns this member, but nothing uses it
subsequently :/

[...]

> > +static int fpsimd_vreg_bounds(struct reg_bounds_struct *b,
> > +			      struct kvm_vcpu *vcpu,
> > +			      const struct kvm_one_reg *reg)
> > +{
> > +	const size_t stride = KVM_REG_ARM_CORE_REG(fp_regs.vregs[1]) -
> > +				KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]);
> > +	const size_t start = KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]);
> > +	const size_t limit = KVM_REG_ARM_CORE_REG(fp_regs.vregs[32]);
> > +
> > +	const u64 uoffset = core_reg_offset_from_id(reg->id);
> > +	size_t usize = KVM_REG_SIZE(reg->id);
> > +	size_t start_vreg, end_vreg;
> > +
> > +	if (WARN_ON((reg->id & KVM_REG_ARM_COPROC_MASK) != KVM_REG_ARM_CORE))
> > +		return -ENOENT;
> 
> This warn-on can never fire, as the condition was already checked to even
> get here, back in kvm_arm_set_reg(). If there's concern this function will
> get called from the wrong place someday, then we should make it a bug-on.

After some past flamings, I tend to prefer WARN_ON() unless there is
no reasonable way to recover at all.

Here, we have a clear path for returning an error to the upstream
caller.  qemu/kvmtool will fail and we'll make some noise in dmesg,
but it's better than taking the whole system down (or so I thought).

> > +
> > +	if (usize % sizeof(u32))
> > +		return -EINVAL;
> 
> We should do the below is vreg check first. Otherwise we may return EINVAL
> for a valid non-vreg. Actually I think we should check if the reg is a
> vreg in get/set_core_reg and only come here if it is, rather than coming
> unconditionally and then requiring the handling of ENOENT.

Possibly.

I was trying to reduce noise at the call site: in (e.g.) get_core_reg(),
the call to fpsimd_vreg_bounds() has the semantics "try to parse reg as
an FPSIMD vector register", where -EINVAL means reg is definitely not
valid, -ENOENT means reg is not an FPSIMD vector register but might
be valid as something else, and 0 means reg is a vector register.

Currently we don't enforce the register size to be a multiple of 32 bits,
but I'm trying to establish a stronger position.  Passing different
register sizes feels like an abuse of the API and there is no evidence
that qemu or kvmtool is relying on this so far.  The ability to pass
a misaligned register ID and/or slurp multiple vcpu registers (or parts
of registers) is once call really seems like it works by accident today
and seems not to be intentional design.  Rather, it exposes kernel
implementation details, which is best avoided.

It would be better to make this a global check for usize % 32 == 0
though, rather than burying it in fpsimd_vreg_bounds().

Opinions?

> > +
> > +	usize /= sizeof(u32);
> > +
> > +	if ((uoffset <= start && usize <= start - uoffset) ||
> > +	    uoffset >= limit)
> > +		return -ENOENT;	/* not a vreg */
> > +
> > +	BUILD_BUG_ON(uoffset > limit);
> 
> Hmm, a build bug on uoffset can't be right, it's not a constant.
> 
> > +	if (uoffset < start || usize > limit - uoffset)
> > +		return -EINVAL;	/* overlaps vregs[] bounds */

uoffset is not compile-time constant, but (uoffset > limit) is compile-
time constant, because the previous if() returns from the function
otherwise.

gcc seems to do the right thing here: the code compiles as-is, but
if the prior if() is commented out then the BUILD_BUG_ON() fires
because (uoffset > limit) is no longer compile-time constant.


This is a defensively-coded bounds check, where

	if (A + B > C)

is transformed to

	if (C >= B && A > C - B)

The former is susceptible to overflow in (A + B), whereas the latter is
not.  We might be able to hide the risk with type casts, but that trades
one kind of fragility for another IMHO.

In this patch, the C >= B part is subsumed into the previous if(), but
because this is non-obvious I dropped the BUILD_BUG_ON() in as a hint
to maintainers that we really do depend on a property of the previous
check, so although it may look like the checks could be swapped over
with no ill effects, really that is not safe.


Maybe the BUILD_BUG_ON() is superfluous, but I would prefer at least
to keep a comment here.

What do you think.


OTOH, if we can show conclusively that we can avoid overflow here
then the code can be simplified.  But I would want to be confident
that this is really safe not just now but also under future maintenance.

> > +	start_vreg = (uoffset - start) / stride;
> > +	end_vreg = ((uoffset - start) + usize - 1) / stride;
> > +	if (start_vreg != end_vreg)
> > +		return -EINVAL;	/* spans multiple vregs */
> 
> Aren't the above three lines equivalent to just (usize > stride)?

No. usize could be < stride, but uoffset may be misaligned so that
the range uoffset .. uoffset + usize - 1 still crosses a register
boundary.

The above lines are trying to check that the whole range doesn't
cross any register boundary at all.

> 
> > +
> > +	b->start_offset = ((uoffset - start) % stride) * sizeof(u32);
> > +	b->copy_count = usize * sizeof(u32);
> > +	b->flush_count = 0;
> > +
> > +	if (vcpu_has_sve(&vcpu->arch)) {
> > +		const unsigned int vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
> > +
> > +		b->kptr = vcpu->arch.sve_state;
> > +		b->kptr += (SVE_SIG_ZREG_OFFSET(vq, start_vreg) -
> > +			    SVE_SIG_REGS_OFFSET);
> > +	} else {
> > +		b->kptr = (char *)&vcpu_gp_regs(vcpu)->fp_regs.vregs[
> > +				start_vreg];
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> >  	/*
> > @@ -65,11 +170,20 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  	 * array. Hence below, nr_regs is the number of entries, and
> >  	 * off the index in the "array".
> >  	 */
> > +	int err;
> > +	struct reg_bounds_struct b;
> >  	__u32 __user *uaddr = (__u32 __user *)(unsigned long)reg->addr;
> >  	struct kvm_regs *regs = vcpu_gp_regs(vcpu);
> >  	int nr_regs = sizeof(*regs) / sizeof(__u32);
> >  	u32 off;
> >  
> > +	err = fpsimd_vreg_bounds(&b, vcpu, reg);
> > +	switch (err) {
> > +	case 0:		return copy_bounded_reg_to_user(uaddr, &b);
> > +	case -ENOENT:	break;	/* not and FPSIMD vreg */
> 
> not an
> 
> > +	default:	return err;
> > +	}
> > +
> >  	/* Our ID is an index into the kvm_regs struct. */
> >  	off = core_reg_offset_from_id(reg->id);
> 
> How about instead of the above switch we just do this, with adjusted
> sanity checks in fpsimd_vreg_bounds?
> 
>   if (off >= KVM_REG_ARM_CORE_REG(fp_regs.vregs[0])) {
>       err = fpsimd_vreg_bounds(&b, vcpu, reg);

I would prefer to keep the check all inside or all outside.
Here we're doing half of it in the caller and half of it inside
fpsimd_vreg_bounds(), which feels clunky.

This also doesn't work with registers that are after vregs[] in the
struct (i.e., fpsr, fpcr -- possibly more stuff could be added in
future).

>       if (!err)
>           return copy_bounded_reg_to_user(uaddr, &b);
>       return err;
>   }
> 
> >  	if (off >= nr_regs ||
> > @@ -84,14 +198,23 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  
> >  static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> > +	int err;
> > +	struct reg_bounds_struct b;
> >  	__u32 __user *uaddr = (__u32 __user *)(unsigned long)reg->addr;
> >  	struct kvm_regs *regs = vcpu_gp_regs(vcpu);
> >  	int nr_regs = sizeof(*regs) / sizeof(__u32);
> >  	__uint128_t tmp;
> >  	void *valp = &tmp;
> >  	u64 off;
> > -	int err = 0;
> >  
> > +	err = fpsimd_vreg_bounds(&b, vcpu, reg);
> > +	switch (err) {
> > +	case 0:		return copy_bounded_reg_from_user(&b, uaddr);
> > +	case -ENOENT:	break;	/* not and FPSIMD vreg */
> 
> no an
> 
> and same comments as for get_core_reg
> 
> > +	default:	return err;
> > +	}
> > +
> > +	err = 0;
> >  	/* Our ID is an index into the kvm_regs struct. */
> >  	off = core_reg_offset_from_id(reg->id);
> >  	if (off >= nr_regs ||
> > @@ -130,6 +253,78 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  	return err;
> >  }
> >  
> > +static int sve_reg_bounds(struct reg_bounds_struct *b,
> > +			  const struct kvm_vcpu *vcpu,
> > +			  const struct kvm_one_reg *reg)
> > +{
> > +	unsigned int n = sve_reg_num(reg);
> > +	unsigned int i = sve_reg_index(reg);
> > +	unsigned int vl = vcpu->arch.sve_max_vl;
> > +	unsigned int vq = sve_vq_from_vl(vl);
> > +	unsigned int start, copy_limit, limit;
> > +
> > +	b->kptr = vcpu->arch.sve_state;
> > +	if (is_zreg(reg)) {
> > +		b->kptr += SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET;
> > +		start = i * 0x100;
> > +		limit = start + 0x100;
> > +		copy_limit = vl;
> > +	} else if (is_preg(reg)) {
> > +		b->kptr += SVE_SIG_PREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET;
> > +		start = i * 0x20;
> > +		limit = start + 0x20;
> > +		copy_limit = vl / 8;
> > +	} else {
> > +		WARN_ON(1);
> > +		start = 0;
> > +		copy_limit = limit = 0;
> 
> Instead of WARN_ON, shouldn't this be a return -EINVAL that gets
> propagated to the user?

Hmmm, yes.

> > +	}
> > +
> > +	b->kptr += start;
> > +
> > +	if (copy_limit < start)
> > +		copy_limit = start;
> > +	else if (copy_limit > limit)
> > +		copy_limit = limit;
> 
>  copy_limit = clamp(copy_limit, start, limit)

Hmmm, again, yes.  I always forget about kernel.h....

> > +
> > +	b->copy_count = copy_limit - start;
> > +	b->flush_count = limit - copy_limit;
> 
> nit: might be nice (less error prone?) to set b->kptr once here with
> the other bounds members, e.g.
> 
>   b->kptr = arch.sve_state + sve_reg_type_off + start;

Yes, I guess that would be a little cleaner.

[...]

Cheers
---Dave
