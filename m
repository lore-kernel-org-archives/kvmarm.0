From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 18/26] KVM: arm64/sve: Add SVE support to register
 access ioctl interface
Date: Tue, 26 Feb 2019 12:13:36 +0000
Message-ID: <20190226121336.GS3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-19-git-send-email-Dave.Martin@arm.com>
 <f6d9f731-e9f8-a54d-1165-2b188e22b4df@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0420749E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:13:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ED1z9F-1RKl9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:13:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EC1C4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:13:41 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <f6d9f731-e9f8-a54d-1165-2b188e22b4df@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 21, 2019 at 03:23:37PM +0000, Julien Thierry wrote:
> Hi Dave,
> 
> On 18/02/2019 19:52, Dave Martin wrote:
> > This patch adds the following registers for access via the
> > KVM_{GET,SET}_ONE_REG interface:
> > 
> >  * KVM_REG_ARM64_SVE_ZREG(n, i) (n = 0..31) (in 2048-bit slices)
> >  * KVM_REG_ARM64_SVE_PREG(n, i) (n = 0..15) (in 256-bit slices)
> >  * KVM_REG_ARM64_SVE_FFR(i) (in 256-bit slices)
> > 
> > In order to adapt gracefully to future architectural extensions,
> > the registers are logically divided up into slices as noted above:
> > the i parameter denotes the slice index.
> > 
> > This allows us to reserve space in the ABI for future expansion of
> > these registers.  However, as of today the architecture does not
> > permit registers to be larger than a single slice, so no code is
> > needed in the kernel to expose additional slices, for now.  The
> > code can be extended later as needed to expose them up to a maximum
> > of 32 slices (as carved out in the architecture itself) if they
> > really exist someday.
> > 
> > The registers are only visible for vcpus that have SVE enabled.
> > They are not enumerated by KVM_GET_REG_LIST on vcpus that do not
> > have SVE.
> > 
> > Accesses to the FPSIMD registers via KVM_REG_ARM_CORE is not
> > allowed for SVE-enabled vcpus: SVE-aware userspace can use the
> > KVM_REG_ARM64_SVE_ZREG() interface instead to access the same
> > register state.  This avoids some complex and pointless emulation
> > in the kernel to convert between the two views of these aliased
> > registers.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > 
> > ---
> > 
> > Changes since v4:
> > 
> >  * Add "BASE" #defines for the Z-reg and P-reg ranges in the KVM
> >    register ID space, to make the 0x400 magic number a little less
> >    cryptic.
> > 
> >  * Pull KVM_SVE_{Z,P}REG_SIZE defines from "KVM: arm64: Enumerate SVE
> >    register indices for KVM_GET_REG_LIST", since we now use them here.
> > 
> >  * Simplify sve_reg_region(), and give up on the attempt to make
> >    kreg_region a general thing: nothing else will use it for now,
> >    anyway, so let's keep it as simple as possible.
> > 
> >  * Drop support for multiple slices per register.  This functionality
> >    can be added back in later if needed, without ABI breaks.
> > 
> >  * Pull vcpu_sve_state_size() into kvm_host.h, from "KVM: arm64/sve:
> >    Allow userspace to enable SVE for vcpus".  This is needed for use
> >    with array_index_nospec() to determine the applicable buffer bounds.
> >    To avoid circular header deependency issues, the function is also
> >    converted into a macro, but is otherwise equivalent to the original
> >    version.
> > 
> >  * Guard sve_state base offset in kernel memory with
> >    array_index_nospec(), since it is generated from user data that can
> >    put it out of range.
> > 
> >    (sve_state will get allocated with the corresponding size later in
> >    the series.  For now, this code is dormant since no means is
> >    provided for userspace to create SVE-enabled vcpus yet.)
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  14 ++++
> >  arch/arm64/include/uapi/asm/kvm.h |  17 +++++
> >  arch/arm64/kvm/guest.c            | 138 ++++++++++++++++++++++++++++++++++----
> >  3 files changed, 157 insertions(+), 12 deletions(-)
> > 
> 
> [...]
> 
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index f491456..8cfa889 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> 
> [...]
> 
> > @@ -211,6 +217,114 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  	return err;
> >  }
> >  
> > +#define SVE_REG_SLICE_SHIFT	0
> > +#define SVE_REG_SLICE_BITS	5
> > +#define SVE_REG_ID_SHIFT	(SVE_REG_SLICE_SHIFT + SVE_REG_SLICE_BITS)
> > +#define SVE_REG_ID_BITS		5
> > +
> > +#define SVE_REG_SLICE_MASK					\
> > +	GENMASK(SVE_REG_SLICE_SHIFT + SVE_REG_SLICE_BITS - 1,	\
> > +		SVE_REG_SLICE_SHIFT)
> > +#define SVE_REG_ID_MASK							\
> > +	GENMASK(SVE_REG_ID_SHIFT + SVE_REG_ID_BITS - 1, SVE_REG_ID_SHIFT)
> > +
> > +#define SVE_NUM_SLICES (1 << SVE_REG_SLICE_BITS)
> > +
> > +#define KVM_SVE_ZREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0))
> > +#define KVM_SVE_PREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_PREG(0, 0))
> > +
> > +struct sve_state_region {
> 
> This sve_state_region feels a bit too generic too me.
> 
> So far it is only used to access a single (slice of a) register at a
> time. Is there a plan to use it for more?

It's there as a way to factor out security-sensitive range computations
that we otherwise have to do twice -- I'd rather have the (potential)
bugs in one place.  sve_state is particularly awkward because it is
heterogeneous, with variably sized members for which no C declaration
is avaiable (or possible).

Previously it was used in four places, because I tried to emulate the
VFP get/set functions for SVE vcpus.  Now that functionality has been
dropped I agree that this function looks like a bit like overkill.  But
I didn't come up with a good way to split it without duplicating an
undesirable amount of fiddly logic.

"sve_state" in the name comes from the naming of the kernel field(s)
that this computes ranges on: vcpu->arch.sve_state (and thread->
sve_state, which we don't operate on here, but which has the same
format).

So, this struct describes a slice of "sve_state", hence the name.  But
you're right, it is only ever supposed to span a single SVE register
within there.

> Otherwise I'd suggest at least naming it something like sve_reg_region,
> sve_reg_mem_region or sve_reg_mem_desc.

It used to be called struct kreg_region.  The name "sve_state_region"
was an attempt to make it look less generic, which doesn't appear to
have worked too well.

Maybe "sve_state_reg_region" would narrow the apparent scope of this a
little further.

Thoughts?

I'll take a look, and at least add a comment explaining what this
struct is supposed to represent.

> 
> 
> > +	unsigned int koffset;	/* offset into sve_state in kernel memory */
> > +	unsigned int klen;	/* length in kernel memory */
> > +	unsigned int upad;	/* extra trailing padding in user memory */
> > +};
> > +
> > +/* Get sanitised bounds for user/kernel SVE register copy */
> > +static int sve_reg_region(struct sve_state_region *region,
> 
> I feel that sve_reg_to_region or sve_reg_get_region would be a clearer name.

..._reg_to_region() seems a good name.  I'll pick that up, modulo other
changes.

Cheers
---Dave
