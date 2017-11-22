From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC] KVM API extensions for SVE
Date: Wed, 22 Nov 2017 20:52:30 +0100
Message-ID: <20171122195230.GT28855@cbox>
References: <20171121134913.GI22781@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1644240EA6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 14:49:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tBBiIfDjhFgf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Nov 2017 14:49:44 -0500 (EST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE69540D8B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 14:49:44 -0500 (EST)
Received: by mail-wm0-f44.google.com with SMTP id b189so12648314wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 11:52:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171121134913.GI22781@e103592.cambridge.arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On Tue, Nov 21, 2017 at 01:49:16PM +0000, Dave Martin wrote:
> Hi all,
> 
> SVE adds some new registers, and their size depends on the hardware ando
> on runtime sysreg settings.
> 
> Before coding something, I'd like to get people's views on my current
> approach here.
> 
> --8<--
> 
> New vcpu feature flag:
> /*
>  * userspace can support regs up to at least 2048 bits in size via ioctl,
>  * and will honour the size field in the reg iD
>  */
> #define KVM_ARM_VCPU_LARGE_REGS	4
> 
> Should we just error out of userspace fails to set this on a system that
> supports SVE, or is that too brutal?  

That would break older userspace on newer kernels on certain hardware,
which would certainly not be acceptable.  Or did I misunderstand?

> If we do treat that as an error,
> then we can unconditionally enable SVE for the guest when the host
> supports it -- which cuts down on unnecessary implementation complexity.

I think it makes sense to be able to disable SVE, especially if there's
high overhead related to context switching the state.  Since you say the
implementation complexity is unnecessary, I may be missing some larger
point?

> 
> Alternatively, we would need logic to disable SVE if userspace is too
> old, i.e., doesn't set this flag.  Then we might need to enforce that
> the flag is set the same on every vcpu -- but from the kernel's PoV
> it probably doesn't matter.

Not sure I understand why it doesn't matter from the kernel's PoV.

I think SVE should be disabled by default (as it is now) and then we
should expose a capability (potentially simply via the vcpu attributes
being present), and let userspace enable SVE and set a vector length.

It makes sense that userspace needs to know about SVE for VMs to use it,
doesn't it?

I assume SVE systems will have SVE on all CPUs in an SMP system, or am I
being way too optimistic about the ARM ecosystem here?  Just like we
don't model big.LITTLE, I think we should enforce in the kernel, that
userspace configures all VCPUs with the same SVE properties.

> 
> 
> /*
>  * For the SVE regs, we add some new reg IDs.
>  * Zn are presented in 2048-bit slices; Pn, FFR are presented in 256-bit
>  * slices.  This is sufficient for only a single slice to be required
>  * per register for SVE, but ensures expansion room in case future arch
>  * versions grow the maximum size.
>  */

I don't understand the last part of this comment?

> #define KVM_REG_SIZE_U2048 (ULL(8) << KVM_REG_SIZE_MASK)

Shift left by KVM_REG_SIZE_MASK?  I'm confused.

> #define KVM_REG_ARM64_SVE_Z(n, i) /* Zn[2048 * (i + 1) - 1 : 2048 * i] */ \
> 	((0x0014 << KVM_REG_ARM_COPROC_SHIFT) | KVM_REG_SIZE_U2048 |	\
> 		((n) << 5) | (i))
> #define KVM_REG_ARM64_SVE_P(n, i) /* Pn[256 * (i + 1) - 1 : 256 * i] */	\
> 	((0x0014 << KVM_REG_ARM_COPROC_SHIFT) | KVM_REG_SIZE_U256 |	\
> 		(((n) + 32) << 5) | (i))
> #define KVM_REG_ARM64_SVE_FFR(i) /* FFR[256 * (i + 1) - 1 : 256 * i] */	\
> 	 KVM_REG_ARM64_SVE_P(16, i)
> 
> For j in [0,3], KVM_REG_ARM64_SVE_Z(n, 0) bits [32(j + 1) - 1 : 32 * j]
> 	alias KVM_REG_ARM_CORE_REG(fp_regs.vregs[n]) + j
> 

This is hard to read and understand the way presented here.  I would
suggest you formulate this suggestion in the form of an RFC patch to
Documentation/virtual/kvm/api.txt plus the header definitions.

(I'm not sure where to look to look to decode the "<< 5" and the
" + 32) << 5)" stuff above.

> 
> Bits above the max vector length could be

Which bits are these and where are they, and why do we have them?

Is the max vector length the max architecturally (current version)
defined length, or what is chosen for this VM?

>  * don't care (or not copied at all) on read; ignored on write
>  * zero on read; ignored on write
>  * zero on read; must be zero on write
> 
> Bits between the current and max vector length are trickier to specify:
> the "current" vector length for ioctl access is ill-defined, because
> we would need to specify ordering dependencies between Zn/Pn/FFR access
> and access to ZCR_EL1.

I think you want userspace to be able to read/write these values in any
order compared to configuring SVE for the VM, and then fix up whatever
needs masking etc. in the kernel later, if possible.  Ordering
requirements to userspace accesses have shown to be hard to enforce and
get right in the past.

What happens on hardware if you give a certain vector length to EL0, EL0
writes a value of the full length, and then EL1 restricts the length to
something smaller, and subsequently expands it again?  Is the original
full value visible or are some bits potentially lost?  IOW, can't we
rely on what the architecture says here?

> 
> So, it may be simpler to expose the full maximum supported vector size
> unconditionally through ioctl, and pack/unpack as necessary.

yes, I think this was what I tried to say.

> 
> Currently, data is packed in the vcpu struct in a vector length
> dependent format, since this seems optimal for low-level save/restore,
> so there will be potential data loss / zero padding when converting.
> 
> This may cause some unexpected effects.  For example:
> 
> KVM_SET_ONE_REG(ZCR_EL1, 0) 
> /* Guest's current vector length will be 128 bits when started */
> 
> KVM_SET_ONE_REG(Z0, (uint256_t)1 << 128)
> KVM_GET_ONE_REG(Z0) /* yields (uint256_t)1 << 128 */
> 
> KVM_RUN /* reg data packed down to 128-bit in vcpu struct */
> 
> KVM_GET_ONE_REG(Z0) /* yields 0 even if guest doesn't use SVE */
> 

I really don't know how to parse this or what the point here is?  Sorry.

> 
> Since the guest should be treated mostly as a black box, I'm not sure
> how big a deal this is.  The guest _might_ have explicitly set those
> bits to 0... who are we to say?

How big a deal what is?  I'm lost.

> 
> Can anyone think of a scenario where effects like this would matter?
> 

I think we need more information.

Thanks,
-Christoffer
