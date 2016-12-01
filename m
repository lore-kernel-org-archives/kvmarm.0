From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 1/4] arm: Define macros
 for accessing system registers
Date: Thu, 1 Dec 2016 16:50:38 +0100
Message-ID: <20161201155038.zwkiobik6kqij4jd@kamzik.brq.redhat.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-2-git-send-email-wei@redhat.com>
 <20161201085903.gcc5g7x6ixxgxofl@kamzik.brq.redhat.com>
 <f502c9c7-50dc-e62e-fbb8-7a8b82f466a0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f502c9c7-50dc-e62e-fbb8-7a8b82f466a0@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, andre.przywara@arm.com, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, cov@codeaurora.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 01, 2016 at 09:27:59AM -0600, Wei Huang wrote:
> 
> 
> On 12/01/2016 02:59 AM, Andrew Jones wrote:
> > 
> > Should this be From: Andre?
> > 
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
> 
> Which checkpatch script you are using? I didn't find one in
> kvm-unit-tests. I tried kernel's checkpatch script, but it didn't
> complain anything against this patch.

I use the kernel's, and it, at least used to, complains about no
spaces between the ':' in asms. If it doesn't complain now, then
it doesn't matter. Actually, it didn't really matter before :-)

Thanks,
drew
> 
> >> +}
> >> +
> 
> <snip>
> 
