From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: Add save/restore support for
 firmware workaround state
Date: Wed, 30 Jan 2019 12:07:50 +0000
Message-ID: <20190130120743.GC3567@e103592.cambridge.arm.com>
References: <20190107120537.184252-1-andre.przywara@arm.com>
 <20190107120537.184252-2-andre.przywara@arm.com>
 <20190122151714.GG3578@e103592.cambridge.arm.com>
 <20190125144657.3db91c91@donnerap.cambridge.arm.com>
 <20190129213223.GB3567@e103592.cambridge.arm.com>
 <20190130113900.10089070@donnerap.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A304E4A320
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 07:07:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lkr5sUPmOL9e for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Jan 2019 07:07:55 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 071D14A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 07:07:55 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190130113900.10089070@donnerap.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 30, 2019 at 11:39:00AM +0000, Andre Przywara wrote:
> On Tue, 29 Jan 2019 21:32:23 +0000
> Dave Martin <Dave.Martin@arm.com> wrote:
> 
> Hi Dave,
> 
> > On Fri, Jan 25, 2019 at 02:46:57PM +0000, Andre Przywara wrote:

[...]

> > > What I like about the signedness is this "0 means unknown", which is
> > > magically forwards compatible. However I am not sure we can transfer
> > > this semantic into every upcoming register that pops up in the
> > > future.  
> > 
> > I appreciate the concern, but can you give an example of how it might
> > break?
> 
> The general problem is that we don't know how future firmware registers
> would need to look like and whether they are actually for workarounds.
> Take for instance KVM_REG_ARM_FW_REG(0), which holds the PSCI version.
> So at the very least we would need to reserve a region of the 64K
> firmware registers to use this scheme, yet don't know how many we would
> need.

My idea was that we reserve a large block of register IDs for this
purpose.  This means that we can say in advance what the semantics
of these registers are going to be, and ensure plenty of expansion
room.

> > My idea is that you can check for compatibility by comparing fields
> > without any need to know what they mean, but we wouldn't pre-assign
> > meanings for the values of unallocated fields, just create a precedent
> > that future fields can follow (where it works).
> 
> For clarity, what do you mean with "... you can check ...", exactly? I
> think this "you" would be the receiving kernel, which is very strict
> about unknown registers (-EINVAL), because we don't take any chances.
> From what I understand how QEMU works, is that it just takes the list
> of registers from the originating kernel and asks the receiving kernel
> about them. It doesn't try to interpret most registers in any way.

Can we solve this by pre-allocating a block of registers for future
allocation: they all become RAZ, and writes are permitted provided that
the value written to each field satisfies our usual comparison rule
(every field must be written with <= 0 in this case).

This is what I had in mind.

> Now QEMU *could* ignore the -EINVAL return and proceed anyway, if it
> would be very sure about the implications or the admin told it so.
> But I believe this should be done on a per register basis, and in QEMU,
> relying on some forward looking scheme sounds a bit fragile to me.
> It is my understanding that QEMU does not want to gamble with migration.
> 
> > This is much like the CPU ID features scheme itself.  A "0" might
> > mean that something is absent, but there's no way (or need) to know
> > what.
> 
> So I think we don't disagree about that this is possible or even would
> be nice, but it's just not how it's used today. I am not sure we want
> to introduce something like this, given that we don't know if there will
> be any future workaround registers at all. Sounds a bit over-engineered
> and fragile to me.

Yes, that's a concern.

We could just allocate a single register with these semantics, but
use it as a template for future expansion if it turns out that we
need more fields.  We'll know pretty soon how fast the number of
fields is likely to grow.

> Peter, can you give your opinion about whether having some generic class
> of firmware workaround registers which could be checked in a generic way
> is something we want?
> 
> > > Actually we might not need this:
> > > My understanding of how QEMU handles this in migration is that it
> > > reads the f/w reg on the originating host A and writes this into
> > > the target host B, without itself interpreting this in any way.
> > > It's up to the target kernel (basically this code here) to check
> > > compatibility. So I am not sure we actually need a stable scheme.
> > > If host A doesn't know about  
> > 
> > Nothing stops userspace from interpreting the data, so there's a risk
> > people may grow to rely on it even if we don't want them to.
> 
> Well, but userland would not interpret unknown registers, under the
> current scheme, would it?
> So it can surely tinker with KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> because it knows about its meaning. But I would be very careful judging
> about anything else.
> The moment we introduce some scheme, we would have to stick with it
> forever. I am just not sure that's worth it. At the end of the day you
> could always update QEMU to ignore an -EINVAL on a new firmware w/a
> register.

My point is, we are introducing a scheme whether we like it or not.

Perhaps we could do this, but make it explicit that these regs hold
KVM private metadata that userspace is not expected to interpret, say

	KVM_REG_ARM_PRIVATE_1
	KVM_REG_ARM_PRIVATE_2
	// ...

which will be listed by KVM_GET_REG_LIST, but with no #defines in the
UAPI headers, except perhaps to identify these IDs as a class (i.e.,
userspace can see it's in the KVM_REG_ARM_PRIVATE_ space, but it's
told what a given ID means).

Source and destination node might understand different numbers of such
registers: we'd need a way to handle this (or at least to guarantee that
the mismatch is detected).


>  
> > So we should try to have something that's forward-compatible if at all
> > possible...
> > > a certain register, it won't appear in the result of the
> > > KVM_GET_REG_LIST ioctl, so it won't be transferred to host B at
> > > all. In the opposite case the receiving host would reject an
> > > unknown register, which I believe is safer, although I see that it
> > > leaves the "unknown" case on the table.
> > > 
> > > It would be good to have some opinion of how forward looking we
> > > want to (and can) be here.
> > > 
> > > Meanwhile I am sending a v2 which implements the linear scale idea,
> > > without using signed values, as this indeed simplifies the code.
> > > I have the signed version still in a branch here, let me know if you
> > > want to have a look.  
> > 
> > Happy to take a look at it.
> 
> See below.
> 
> > I was hoping that cpufeatures already had a helper for extracting a
> > signed field, but I didn't go looking for it...
> > 
> > At the asm level this is just a sbfx, so it's hardly expensive.
> 
> The length of the code or the "performance" is hardly an issue (we are
> talking about migration here, which is mostly limited by the speed of
> the network). And yes, we have sign_extend32() and (i & 0xf) to
> convert, it just looks a bit odd in the code and in the API
> documentation.
> 
> Cheers,
> Andre
> 
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 6c6757c9571b..a7b10d835ce7 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -218,10 +218,10 @@ struct kvm_vcpu_events {
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
> -#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	0
> -#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN	1
> -#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	2
> -#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	3
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	(-1 & 0xf)
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN	0
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	1
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	2
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED	(1U << 4)
>  
>  /* Device Control API: ARM VGIC */
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 367e96fe654e..7d03f8339100 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -229,10 +229,10 @@ struct kvm_vcpu_events {
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
> -#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	0
> -#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN	1
> -#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	2
> -#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	3
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	(-1 & 0xf)
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN	0
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	1
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	2
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     (1U << 4)
>  
>  /* Device Control API: ARM VGIC */
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index fb6af5ca259e..cfb1519b9a11 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -498,7 +498,8 @@ static int get_kernel_wa_level(u64 regid)
>  	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
>  		switch (fake_kvm_arm_have_ssbd()) {
>  		case KVM_SSBD_FORCE_DISABLE:
> -			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> +			return sign_extend32(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL,
> +					     KVM_REG_FEATURE_LEVEL_WIDTH - 1);
>  		case KVM_SSBD_KERNEL:
>  			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL;
>  		case KVM_SSBD_FORCE_ENABLE:
> @@ -574,7 +575,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	}
>  
>  	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> -		wa_level = val & KVM_REG_FEATURE_LEVEL_MASK;
> +		wa_level = sign_extend32(val, KVM_REG_FEATURE_LEVEL_WIDTH - 1);
>  
>  		if (get_kernel_wa_level(reg->id) < wa_level)
>  			return -EINVAL;
> @@ -582,7 +583,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  		return 0;
>  
>  	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> -		wa_level = val & KVM_REG_FEATURE_LEVEL_MASK;
> +		wa_level = sign_extend32(val, KVM_REG_FEATURE_LEVEL_WIDTH - 1);

We could have a helper to do this.  I agree it's marginally uglier than
working with unsigned fields, we could probably use
cpuid_feature_extract_signed_field() to achieve the same.

I agree that this is bikeshedding though, and it doesn't matter one way
or the other unless there is some other compelling argument.

Cheers
---Dave
