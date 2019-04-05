From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 23/27] KVM: arm64/sve: Add pseudo-register for the
 guest's vector lengths
Date: Fri, 5 Apr 2019 17:33:21 +0200
Message-ID: <20190405153321.r4ide5n2bkiuflqn@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-24-git-send-email-Dave.Martin@arm.com>
 <20190404201854.7dzga3ctjj7427hk@kamzik.brq.redhat.com>
 <20190405093603.GM3567@e103592.cambridge.arm.com>
 <20190405101451.xtx7ggyomvrbrpxl@kamzik.brq.redhat.com>
 <20190405125413.GA3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0DCB4A43B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 11:33:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Eii39rGWuRx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Apr 2019 11:33:29 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0496C4A331
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 11:33:28 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190405125413.GA3567@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 05, 2019 at 01:54:13PM +0100, Dave Martin wrote:
> On Fri, Apr 05, 2019 at 12:14:51PM +0200, Andrew Jones wrote:
> > On Fri, Apr 05, 2019 at 10:36:03AM +0100, Dave Martin wrote:
> > > On Thu, Apr 04, 2019 at 10:18:54PM +0200, Andrew Jones wrote:
> > > > On Fri, Mar 29, 2019 at 01:00:48PM +0000, Dave Martin wrote:
> > > > > This patch adds a new pseudo-register KVM_REG_ARM64_SVE_VLS to
> > > > > allow userspace to set and query the set of vector lengths visible
> > > > > to the guest.
> > > > > 
> > > > > In the future, multiple register slices per SVE register may be
> > > > > visible through the ioctl interface.  Once the set of slices has
> > > > > been determined we would not be able to allow the vector length set
> > > > > to be changed any more, in order to avoid userspace seeing
> > > > > inconsistent sets of registers.  For this reason, this patch adds
> > > > > support for explicit finalization of the SVE configuration via the
> > > > > KVM_ARM_VCPU_FINALIZE ioctl.
> > > > > 
> > > > > Finalization is the proper place to allocate the SVE register state
> > > > > storage in vcpu->arch.sve_state, so this patch adds that as
> > > > > appropriate.  The data is freed via kvm_arch_vcpu_uninit(), which
> > > > > was previously a no-op on arm64.
> > > > > 
> > > > > To simplify the logic for determining what vector lengths can be
> > > > > supported, some code is added to KVM init to work this out, in the
> > > > > kvm_arm_init_arch_resources() hook.
> > > > > 
> > > > > The KVM_REG_ARM64_SVE_VLS pseudo-register is not exposed yet.
> > > > > Subsequent patches will allow SVE to be turned on for guest vcpus,
> > > > > making it visible.
> > > > > 
> > > > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > > > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> > > > > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> > > > > 
> > > > > ---
> > > 
> > > [...]
> > > 
> > > > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > > > index 2aa80a5..086ab05 100644
> > > > > --- a/arch/arm64/kvm/guest.c
> > > > > +++ b/arch/arm64/kvm/guest.c
> > > > > @@ -206,6 +206,73 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > > >  	return err;
> > > > >  }
> > > > >  
> > > > > +#define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
> > > > > +#define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
> > > > > +
> > > > > +static bool vq_present(
> > > > > +	const u64 (*const vqs)[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)],
> > > > > +	unsigned int vq)
> > > > > +{
> > > > > +	return (*vqs)[vq_word(vq)] & vq_mask(vq);
> > > > > +}
> > > > > +
> > > > > +static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > > > +{
> > > > > +	unsigned int max_vq, vq;
> > > > > +	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
> > > > > +
> > > > > +	if (WARN_ON(!sve_vl_valid(vcpu->arch.sve_max_vl)))
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	memset(vqs, 0, sizeof(vqs));
> > > > > +
> > > > > +	max_vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
> > > > > +	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
> > > > > +		if (sve_vq_available(vq))
> > > > > +			vqs[vq_word(vq)] |= vq_mask(vq);
> > > > > +
> > > > > +	if (copy_to_user((void __user *)reg->addr, vqs, sizeof(vqs)))
> > > > > +		return -EFAULT;
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > > > +{
> > > > > +	unsigned int max_vq, vq;
> > > > > +	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
> > > > 
> > > > There are three of these long 'DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)'.
> > > > A macro is probably warranted.
> > > 
> > > Fair point.  These are a bit cumbersome.  How about:
> > > 
> > > #define SVE_VLS_WORDS DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)
> > > 
> > > Annoyingly, this is virtually identical to a Linux bitmap: the base type
> > > is u64 instead of unsigned long; otherwise there's no intentional
> > > difference.
> > 
> > Yeah, I noticed it was a reinvented bitmap, but I liked that it was,
> > because, for the userspace api, removing the bitmap abstractions
> > ensures we know what is what and where exactly it is.
> 
> Agreed.  I thought of using the bitmap API inside the kernel, but even
> if this is arm64-specific code, it made me uneasy: the compiler doesn't
> necessarily think that u64 and unsigned long are the same type even if
> they're both 64-bit, so there's the potential for weird optimisations to
> happen.
> 
> > > (Aside: do you know why the KVM API insists on everything being u64?
> > > This makes sense for non-native types (like guest registers), but not
> > > for native things like host userspace addresses etc.)
> > 
> > Would that work when the kernel is 64-bit and the userspace is 32? I
> > personally like the interfaces being explicit with type size, as it
> > removes the brain burden of translating long and int when moving arch
> > to arch and kernel to userspace.
> 
> Ah yes, the joys of compat.  And ioctl.  Ignore me.
> 
> > > > > +
> > > > > +	if (kvm_arm_vcpu_sve_finalized(vcpu))
> > > > > +		return -EPERM; /* too late! */
> > > > > +
> > > > > +	if (WARN_ON(vcpu->arch.sve_state))
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	if (copy_from_user(vqs, (const void __user *)reg->addr, sizeof(vqs)))
> > > > > +		return -EFAULT;
> > > > > +
> > > > > +	max_vq = 0;
> > > > > +	for (vq = SVE_VQ_MIN; vq <= SVE_VQ_MAX; ++vq)
> > > > > +		if (vq_present(&vqs, vq))
> > > > > +			max_vq = vq;
> > > > > +
> > > > > +	if (max_vq > sve_vq_from_vl(kvm_sve_max_vl))
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
> > > > > +		if (vq_present(&vqs, vq) != sve_vq_available(vq))
> > > > > +			return -EINVAL;
> > > > 
> > > > What about supporting the optional non-power-of-2 vector lengths? For
> > > > example, if the maximum VL is 512, then in addition to 512, 128, and
> > > > 256 there could be a 384. If we plan to start a guest on a machine
> > > > that has all four and then migrate it to a machine that only has
> > > > 128,256,512 we would want to set the VL set to 128,256,512, even on
> > > > the machine that supports 384. If I understand the above test correctly,
> > > > then that wouldn't work.
> > > 
> > > This is exactly what the code is trying to forbid, though it may not be
> > > obvious here why.
> > > 
> > > The trouble is, we can't correctly emulate a vcpu supporting
> > > {128,256,512} on hardware that also supports 384-bit vectors: the
> > > architecture says that the vector length you get is determined by
> > > rounding ZCR_EL1.LEN down to the next vector length actually
> > > supported.
> > > 
> > > So, the guest would expect writing ZCR_EL1.LEN = 2 to give a vector
> > > length of 256 bits, whereas on this hardware the actual resulting
> > > vector length would be 384 bits.
> > 
> > Oh, I see.
> > 
> > > 
> > > sve_probe_vqs() relies on this property to detect the set of available
> > > vector lengths.  Simple, bare-metal guests might also just set
> > > ZCR_ELx.LEN = 0x1ff to just get the max available.
> > > 
> > > 
> > > The architecture says categorically that the set of vector lengths
> > > supported is a fixed property of the (emulated) hardware -- we can't
> > > having this changing under the guest's feet.
> > > 
> > > Fixing this would require an archietctural way to filter out individual
> > > vector lengths from the supported set, not just a way to clamp the
> > > maximum (which is all ZCR_EL2.LEN gives us).
> > > 
> > > The general expectation is that sanely designed cluster will be
> > > "homogeneous enough" and won't trigger this check -- it's here
> > > just in case.
> > 
> > Data centers evolve as they expand and hardware is replaced. I wouldn't
> > expect them to stay homogeneous for long, not without keeping them that
> > way at substantial cost. This isn't the first thing that is forcing Arm
> > virt data centers to be homogeneous (we still use qemu's '-cpu host'),
> > but it's disappointing to have yet another one.
> 
> This may or may not be a problem in practive, since I suspect
> implementations that support non-power-of-two vector lengths may be in
> the minority anyway.
> 
> The ARM Fast Model and probably QEMU can do it, but people are less
> likely to try to build a high-performance cluster out of those...
> 
> > > I attempt to capture this in api.txt, leaving the door open in case the
> > > architecture gives a way to support this in future:
> > > 
> > >   | KVM_REG_ARM64_SVE_VLS
> > >   | 
> > >   | [...]
> > >   | 
> > >   | Apart from simply removing all vector lengths from the host set
> > >   | that exceed some value, support for arbitrarily chosen sets of
> > >   | vector lengths is hardware-dependent and may not be available.
> > >   | Attempting to configure an invalid set of vector lengths via
> > >   | KVM_SET_ONE_REG will fail with EINVAL.
> > > 
> > > Is this enough, or do you think more explanation is needed somewhere?
> > 
> > I saw that before, so I guess more is needed :) What you wrote above about
> > how we can only shorten the list due to how zcr_el1.len works was the
> > missing piece for me. Maybe that should be integrated into the text
> > somehow.
> 
> If you think the above is enough for ABI documentation purposes, I will
> aim to drop the following comment into set_sve_vls():
> 
> 	/*
> 	 * Vector lengths supported by the host can't currently be
> 	 * hidden from the guest individually: instead we can only set a
> 	 * maxmium via ZCR_EL2.LEN.  So, make sure the available vector
> 	 * length match the set requested exactly up to the requested
> 	 * maximum:
> 	 */
> 	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
> 		if (vq_present(&vqs, vq) != sve_vq_available(vq))
> 			return -EINVAL;
> 
> Do you think that's enough?
>

That works for me, and I'm glad I now have it understood, because this
will be a key piece of the QEMU uesr interface to work out. I.e. we
need to be able to provide the user with the current host's VL list
up to the max virtualizable VL when queried, allow them to choose a max
from that list for a guest, and then commit to that VL sublist for the
guest. I'll dive into QEMU on Monday, hopefully I won't drown there.

drew
