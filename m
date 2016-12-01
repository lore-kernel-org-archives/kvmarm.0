From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 1/4] arm: Define macros
 for accessing system registers
Date: Thu, 1 Dec 2016 14:16:50 +0100
Message-ID: <20161201131650.p3fg5bhjdlv4g4ky@kamzik.brq.redhat.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-2-git-send-email-wei@redhat.com>
 <20161201085903.gcc5g7x6ixxgxofl@kamzik.brq.redhat.com>
 <db7a4912-4969-0f46-3ac6-83fe75534f16@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <db7a4912-4969-0f46-3ac6-83fe75534f16@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Wei Huang <wei@redhat.com>, alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, cov@codeaurora.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 01, 2016 at 11:11:55AM +0000, Andre Przywara wrote:
> Hi,
> 
> On 01/12/16 08:59, Andrew Jones wrote:
> > 
> > Should this be From: Andre?
> 
> No need from my side, this way all the bug reports are send to Wei ;-)
> 
> > On Wed, Nov 30, 2016 at 11:16:39PM -0600, Wei Huang wrote:
> >> This patch defines four macros to assist creating system register
> >> accessors under both ARMv7 and AArch64:
> >>    * DEFINE_GET_SYSREG32(name, ...)
> >>    * DEFINE_SET_SYSREG32(name, ...)
> >>    * DEFINE_GET_SYSREG64(name, ...)
> >>    * DEFINE_SET_SYSREG64(name, ...)
> >> These macros are translated to inline functions with consistent naming,
> >> get_##name() and set_##name(), which can be used by C code directly.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> Signed-off-by: Wei Huang <wei@redhat.com>
> >> ---
> >>  lib/arm/asm/processor.h   | 37 ++++++++++++++++++++++++++++++++-----
> >>  lib/arm64/asm/processor.h | 35 ++++++++++++++++++++++++++++-------
> >>  2 files changed, 60 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> >> index f25e7ee..3ca6b42 100644
> >> --- a/lib/arm/asm/processor.h
> >> +++ b/lib/arm/asm/processor.h
> >> @@ -33,13 +33,40 @@ static inline unsigned long current_cpsr(void)
> >>  
> >>  #define current_mode() (current_cpsr() & MODE_MASK)
> >>  
> >> -static inline unsigned int get_mpidr(void)
> >> -{
> >> -	unsigned int mpidr;
> >> -	asm volatile("mrc p15, 0, %0, c0, c0, 5" : "=r" (mpidr));
> >> -	return mpidr;
> >> +#define DEFINE_GET_SYSREG32(name, opc1, crn, crm, opc2)			\
> >> +static inline uint32_t get_##name(void)					\
> >> +{									\
> >> +	uint32_t reg;							\
> >> +	asm volatile("mrc p15, " #opc1 ", %0, " #crn ", " #crm ", "	\
> >> +		     #opc2 : "=r" (reg));				\
> >> +	return reg;							\
> >> +}
> >> +
> >> +#define DEFINE_SET_SYSREG32(name, opc1, crn, crm, opc2)			\
> >> +static inline void set_##name(uint32_t value)				\
> >> +{									\
> >> +	asm volatile("mcr p15, " #opc1 ", %0, " #crn ", " #crm ", "	\
> >> +		     #opc2 :: "r" (value));				\
> >                            ^ nit: no space here, checkpatch would complain
> >> +}
> >> +
> >> +#define DEFINE_GET_SYSREG64(name, opc, crm)				\
> >> +static inline uint64_t get_##name(void)					\
> >> +{									\
> >> +	uint32_t lo, hi;						\
> >> +	asm volatile("mrrc p15, " #opc ", %0, %1, " #crm		\
> >> +		     : "=r" (lo), "=r" (hi));				\
> >> +	return (uint64_t)hi << 32 | lo;					\
> >> +}
> >> +
> >> +#define DEFINE_SET_SYSREG64(name, opc, crm)				\
> >> +static inline void set_##name(uint64_t value)				\
> >> +{									\
> >> +	asm volatile("mcrr p15, " #opc ", %0, %1, " #crm		\
> >> +		     :: "r" (value & 0xffffffff), "r" (value >> 32));	\
> >>  }
> >>  
> >> +DEFINE_GET_SYSREG32(mpidr, 0, c0, c0, 5)
> >> +
> >>  /* Only support Aff0 for now, up to 4 cpus */
> >>  #define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
> >>  
> >> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> >> index 84d5c7c..dfa75eb 100644
> >> --- a/lib/arm64/asm/processor.h
> >> +++ b/lib/arm64/asm/processor.h
> >> @@ -66,14 +66,35 @@ static inline unsigned long current_level(void)
> >>  	return el & 0xc;
> >>  }
> >>  
> >> -#define DEFINE_GET_SYSREG32(reg)				\
> >> -static inline unsigned int get_##reg(void)			\
> >> -{								\
> >> -	unsigned int reg;					\
> >> -	asm volatile("mrs %0, " #reg "_el1" : "=r" (reg));	\
> >> -	return reg;						\
> >> +#define DEFINE_GET_SYSREG32(reg, el)					\
> >> +static inline uint32_t get_##reg(void)					\
> >> +{									\
> >> +	uint32_t reg;							\
> >> +	asm volatile("mrs %0, " #reg "_" #el : "=r" (reg));		\
> >> +	return reg;							\
> >>  }
> >> -DEFINE_GET_SYSREG32(mpidr)
> >> +
> >> +#define DEFINE_SET_SYSREG32(reg, el)					\
> >> +static inline void set_##reg(uint32_t value)				\
> >> +{									\
> >> +	asm volatile("msr " #reg "_" #el ", %0" :: "r" (value));	\
> >> +}
> >> +
> >> +#define DEFINE_GET_SYSREG64(reg, el)					\
> >> +static inline uint64_t get_##reg(void)					\
> >> +{									\
> >> +	uint64_t reg;							\
> >> +	asm volatile("mrs %0, " #reg "_" #el : "=r" (reg));		\
> >> +	return reg;							\
> >> +}
> >> +
> >> +#define DEFINE_SET_SYSREG64(reg, el)					\
> >> +static inline void set_##reg(uint64_t value)				\
> >> +{									\
> >> +	asm volatile("msr " #reg "_" #el ", %0" :: "r" (value));	\
> >> +}
> >> +
> >> +DEFINE_GET_SYSREG32(mpidr, el1)
> > 
> > 32-bit mpidr for arm64 isn't right, and it's changed by [1] in the
> > gic series.
> 
> So how are we actually handling this? Waiting for the GIC series to be
> merged, then rebasing on top of that (which is what I thought we'd do)?
> 
> Or make a combined patch (taking it out of both series), and merge it
> before?

Let's make sure this one addresses the need of the gic one, and then
I'll merge this one into arm/next first and drop the other one.

> 
> > However changing it to 64-bit with this patch would result
> > in a get_mpidr() call that returns uint64_t on arm64 and uint32_t on
> > arm32, which won't be nice for common code. Andre brought up during the
> > review of [1] that we should be using the architectural types for register
> > accessors.
> 
> At least for registers that differ in size between A32 and A64. Many
> system registers are actually 32-bit wide and are explicitly stated as
> such in the ARM(v8) ARM (for instance MIDR_EL1).
> Yes, the A64 msr/mrs instructions only know a 64-bit register encoding,
> but the actual content is often confined to 32 bits (in MIDR or PMCR,
> for instance).
> So I wonder if we should take care of those with an explicit uint32_t
> return type?
> 
> > That means, that while internally all the above functions can
> > know what's 32-bit and what's 64-bit, using uint32/64_t appropriately,
> > the external interfaces should be 'unsigned long', 'unsigned int',
> > 'unsigned long long'.
> 
> Not so sure about that.
> I think we may need _three_ types of system register accessors?
> 1) always 32-bit (e.g. MIDR_EL1): use uint32_t
> 2) always 64-bit (e.g. CNTVCT_EL0),: use uint64_t
> 3) natural register size (e.g. MPIDR_EL1): use unsigned long
> 
> Does that make sense or is that overkill?

OK, now that'd I've rethought about this, the natural sizes weren't
a good idea. They don't really give us better common code anyway,
because 64-bit code may want to look at the upper 32 bits. I think
we need to forget (3) above, and special case MPIDR for arm32 accesses.
MPIDR is special because it gets used by core smp and gic code, and we
don't want #ifdefs everywhere.

So, for this patch, I think we only need to add

DEFINE_GET_SYSREG32(mpidr32, 0, c0, c0, 5)
static inline uint64_t get_mpidr(void)
{
	return get_mpidr32();
}

to the 32-bit processor.h

and in the 64-bit file we need to switch DEFINE_GET_SYSREG32(mpidr, el1)
to DEFINE_GET_SYSREG64(mpidr, el1). Also, the second reply I made still
holds; always using 64-bit (unsigned long) internally for AArch64
registers, but choosing to just return the lower 32 bits for the "32-bit"
ones (Peter's arguments weren't lost on me :-)

How's that sound?

Thanks,
drew

(Changing get_mpidr() to return a uint64_t means I'll need to fixup [2],
 but no biggy...)

[2] https://github.com/rhdrjones/kvm-unit-tests/commit/9f3f7f8141a98d0cd5175ad6cb491a4e1c5f7cd9

> 
> Cheers,
> Andre.
> 
> > [1] https://github.com/rhdrjones/kvm-unit-tests/commit/57e48b8e6dc2ddf4b2e4eb1ceb5a5f87f2dd074b
> > 
> > Thanks,
> > drew
> > 
> >>  
> >>  /* Only support Aff0 for now, gicv2 only */
> >>  #define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
> >> -- 
> >> 1.8.3.1
> >>
> >>
> 
