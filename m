From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 1/4] arm: Define macros
 for accessing system registers
Date: Thu, 1 Dec 2016 10:38:54 +0100
Message-ID: <20161201093854.4ax4pfgahhbnor33@kamzik.brq.redhat.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-2-git-send-email-wei@redhat.com>
 <20161201085903.gcc5g7x6ixxgxofl@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83CB2404EF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 04:38:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wSH89dLvejlG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2016 04:38:09 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 643CE40457
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 04:38:09 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161201085903.gcc5g7x6ixxgxofl@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Wei Huang <wei@redhat.com>
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, andre.przywara@arm.com, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 01, 2016 at 09:59:03AM +0100, Andrew Jones wrote:
> 
> Should this be From: Andre?
> 
> On Wed, Nov 30, 2016 at 11:16:39PM -0600, Wei Huang wrote:
> > This patch defines four macros to assist creating system register
> > accessors under both ARMv7 and AArch64:
> >    * DEFINE_GET_SYSREG32(name, ...)
> >    * DEFINE_SET_SYSREG32(name, ...)
> >    * DEFINE_GET_SYSREG64(name, ...)
> >    * DEFINE_SET_SYSREG64(name, ...)
> > These macros are translated to inline functions with consistent naming,
> > get_##name() and set_##name(), which can be used by C code directly.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > Signed-off-by: Wei Huang <wei@redhat.com>
> > ---
> >  lib/arm/asm/processor.h   | 37 ++++++++++++++++++++++++++++++++-----
> >  lib/arm64/asm/processor.h | 35 ++++++++++++++++++++++++++++-------
> >  2 files changed, 60 insertions(+), 12 deletions(-)
> > 
> > diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> > index f25e7ee..3ca6b42 100644
> > --- a/lib/arm/asm/processor.h
> > +++ b/lib/arm/asm/processor.h
> > @@ -33,13 +33,40 @@ static inline unsigned long current_cpsr(void)
> >  
> >  #define current_mode() (current_cpsr() & MODE_MASK)
> >  
> > -static inline unsigned int get_mpidr(void)
> > -{
> > -	unsigned int mpidr;
> > -	asm volatile("mrc p15, 0, %0, c0, c0, 5" : "=r" (mpidr));
> > -	return mpidr;
> > +#define DEFINE_GET_SYSREG32(name, opc1, crn, crm, opc2)			\
> > +static inline uint32_t get_##name(void)					\
> > +{									\
> > +	uint32_t reg;							\
> > +	asm volatile("mrc p15, " #opc1 ", %0, " #crn ", " #crm ", "	\
> > +		     #opc2 : "=r" (reg));				\
> > +	return reg;							\
> > +}
> > +
> > +#define DEFINE_SET_SYSREG32(name, opc1, crn, crm, opc2)			\
> > +static inline void set_##name(uint32_t value)				\
> > +{									\
> > +	asm volatile("mcr p15, " #opc1 ", %0, " #crn ", " #crm ", "	\
> > +		     #opc2 :: "r" (value));				\
>                            ^ nit: no space here, checkpatch would complain
> > +}
> > +
> > +#define DEFINE_GET_SYSREG64(name, opc, crm)				\
> > +static inline uint64_t get_##name(void)					\
> > +{									\
> > +	uint32_t lo, hi;						\
> > +	asm volatile("mrrc p15, " #opc ", %0, %1, " #crm		\
> > +		     : "=r" (lo), "=r" (hi));				\
> > +	return (uint64_t)hi << 32 | lo;					\
> > +}
> > +
> > +#define DEFINE_SET_SYSREG64(name, opc, crm)				\
> > +static inline void set_##name(uint64_t value)				\
> > +{									\
> > +	asm volatile("mcrr p15, " #opc ", %0, %1, " #crm		\
> > +		     :: "r" (value & 0xffffffff), "r" (value >> 32));	\
> >  }
> >  
> > +DEFINE_GET_SYSREG32(mpidr, 0, c0, c0, 5)
> > +
> >  /* Only support Aff0 for now, up to 4 cpus */
> >  #define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
> >  
> > diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> > index 84d5c7c..dfa75eb 100644
> > --- a/lib/arm64/asm/processor.h
> > +++ b/lib/arm64/asm/processor.h
> > @@ -66,14 +66,35 @@ static inline unsigned long current_level(void)
> >  	return el & 0xc;
> >  }
> >  
> > -#define DEFINE_GET_SYSREG32(reg)				\
> > -static inline unsigned int get_##reg(void)			\
> > -{								\
> > -	unsigned int reg;					\
> > -	asm volatile("mrs %0, " #reg "_el1" : "=r" (reg));	\
> > -	return reg;						\
> > +#define DEFINE_GET_SYSREG32(reg, el)					\
> > +static inline uint32_t get_##reg(void)					\
> > +{									\
> > +	uint32_t reg;							\
> > +	asm volatile("mrs %0, " #reg "_" #el : "=r" (reg));		\
> > +	return reg;							\
> >  }
> > -DEFINE_GET_SYSREG32(mpidr)
> > +
> > +#define DEFINE_SET_SYSREG32(reg, el)					\
> > +static inline void set_##reg(uint32_t value)				\
> > +{									\
> > +	asm volatile("msr " #reg "_" #el ", %0" :: "r" (value));	\
> > +}

Another comment for arm64's SYSREG32 accessors. Technically there's no
32-bit register in AArch64, so the asm should always use an unsigned long
and explicit casts. That's what I did in [1].

> > +
> > +#define DEFINE_GET_SYSREG64(reg, el)					\
> > +static inline uint64_t get_##reg(void)					\
> > +{									\
> > +	uint64_t reg;							\
> > +	asm volatile("mrs %0, " #reg "_" #el : "=r" (reg));		\
> > +	return reg;							\
> > +}
> > +
> > +#define DEFINE_SET_SYSREG64(reg, el)					\
> > +static inline void set_##reg(uint64_t value)				\
> > +{									\
> > +	asm volatile("msr " #reg "_" #el ", %0" :: "r" (value));	\
> > +}
> > +
> > +DEFINE_GET_SYSREG32(mpidr, el1)
> 
> 32-bit mpidr for arm64 isn't right, and it's changed by [1] in the
> gic series. However changing it to 64-bit with this patch would result
> in a get_mpidr() call that returns uint64_t on arm64 and uint32_t on
> arm32, which won't be nice for common code. Andre brought up during the
> review of [1] that we should be using the architectural types for register
> accessors. That means, that while internally all the above functions can
> know what's 32-bit and what's 64-bit, using uint32/64_t appropriately,
> the external interfaces should be 'unsigned long', 'unsigned int',
> 'unsigned long long'.
> 
> [1] https://github.com/rhdrjones/kvm-unit-tests/commit/57e48b8e6dc2ddf4b2e4eb1ceb5a5f87f2dd074b
> 
> Thanks,
> drew
> 
> >  
> >  /* Only support Aff0 for now, gicv2 only */
> >  #define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
> > -- 
> > 1.8.3.1
> > 
> > 
> 
