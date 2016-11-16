From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v8 2/3] arm: pmu: Check cycle
 count increases
Date: Wed, 16 Nov 2016 14:01:45 +0100
Message-ID: <20161116130145.3x52rdlyytknclpy@kamzik.brq.redhat.com>
References: <1478629035-12938-1-git-send-email-wei@redhat.com>
 <1478629035-12938-3-git-send-email-wei@redhat.com>
 <20161111074321.5ayzmy4w7w73x4fi@hawk.localdomain>
 <cdc283e2-8905-5344-ac91-2b20e5c4980b@redhat.com>
 <20161114100510.k3pkhnyzqfraago2@kamzik.brq.redhat.com>
 <527cb90a-1c72-43df-7149-7058e988f562@codeaurora.org>
 <8e5d194e-ae4c-3a0d-b9f8-5ea1fa3d1921@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8e5d194e-ae4c-3a0d-b9f8-5ea1fa3d1921@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>
Cc: Christopher Covington <cov@codeaurora.org>, alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 15, 2016 at 04:50:53PM -0600, Wei Huang wrote:
> 
> 
> On 11/14/2016 09:12 AM, Christopher Covington wrote:
> > Hi Drew, Wei,
> > 
> > On 11/14/2016 05:05 AM, Andrew Jones wrote:
> >> On Fri, Nov 11, 2016 at 01:55:49PM -0600, Wei Huang wrote:
> >>>
> >>>
> >>> On 11/11/2016 01:43 AM, Andrew Jones wrote:
> >>>> On Tue, Nov 08, 2016 at 12:17:14PM -0600, Wei Huang wrote:
> >>>>> From: Christopher Covington <cov@codeaurora.org>
> >>>>>
> >>>>> Ensure that reads of the PMCCNTR_EL0 are monotonically increasing,
> >>>>> even for the smallest delta of two subsequent reads.
> >>>>>
> >>>>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> >>>>> Signed-off-by: Wei Huang <wei@redhat.com>
> >>>>> ---
> >>>>>  arm/pmu.c | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>>>>  1 file changed, 98 insertions(+)
> >>>>>
> >>>>> diff --git a/arm/pmu.c b/arm/pmu.c
> >>>>> index 0b29088..d5e3ac3 100644
> >>>>> --- a/arm/pmu.c
> >>>>> +++ b/arm/pmu.c
> >>>>> @@ -14,6 +14,7 @@
> >>>>>   */
> >>>>>  #include "libcflat.h"
> >>>>>  
> >>>>> +#define PMU_PMCR_E         (1 << 0)
> >>>>>  #define PMU_PMCR_N_SHIFT   11
> >>>>>  #define PMU_PMCR_N_MASK    0x1f
> >>>>>  #define PMU_PMCR_ID_SHIFT  16
> >>>>> @@ -21,6 +22,10 @@
> >>>>>  #define PMU_PMCR_IMP_SHIFT 24
> >>>>>  #define PMU_PMCR_IMP_MASK  0xff
> >>>>>  
> >>>>> +#define PMU_CYCLE_IDX      31
> >>>>> +
> >>>>> +#define NR_SAMPLES 10
> >>>>> +
> >>>>>  #if defined(__arm__)
> >>>>>  static inline uint32_t pmcr_read(void)
> >>>>>  {
> >>>>> @@ -29,6 +34,47 @@ static inline uint32_t pmcr_read(void)
> >>>>>  	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
> >>>>>  	return ret;
> >>>>>  }
> >>>>> +
> >>>>> +static inline void pmcr_write(uint32_t value)
> >>>>> +{
> >>>>> +	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (value));
> >>>>> +}
> >>>>> +
> >>>>> +static inline void pmselr_write(uint32_t value)
> >>>>> +{
> >>>>> +	asm volatile("mcr p15, 0, %0, c9, c12, 5" : : "r" (value));
> >>>>> +}
> >>>>> +
> >>>>> +static inline void pmxevtyper_write(uint32_t value)
> >>>>> +{
> >>>>> +	asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (value));
> >>>>> +}
> >>>>> +
> >>>>> +/*
> >>>>> + * While PMCCNTR can be accessed as a 64 bit coprocessor register, returning 64
> >>>>> + * bits doesn't seem worth the trouble when differential usage of the result is
> >>>>> + * expected (with differences that can easily fit in 32 bits). So just return
> >>>>> + * the lower 32 bits of the cycle count in AArch32.
> >>>>
> >>>> Like I said in the last review, I'd rather we not do this. We should
> >>>> return the full value and then the test case should confirm the upper
> >>>> 32 bits are zero.
> >>>
> >>> Unless I miss something in ARM documentation, ARMv7 PMCCNTR is a 32-bit
> >>> register. We can force it to a more coarse-grained cycle counter with
> >>> PMCR.D bit=1 (see below). But it is still not a 64-bit register.
> > 
> > AArch32 System Register Descriptions
> > Performance Monitors registers
> > PMCCNTR, Performance Monitors Cycle Count Register
> > 
> > To access the PMCCNTR when accessing as a 32-bit register:
> > MRC p15,0,<Rt>,c9,c13,0 ; Read PMCCNTR[31:0] into Rt
> > MCR p15,0,<Rt>,c9,c13,0 ; Write Rt to PMCCNTR[31:0]. PMCCNTR[63:32] are unchanged
> > 
> > To access the PMCCNTR when accessing as a 64-bit register:
> > MRRC p15,0,<Rt>,<Rt2>,c9 ; Read PMCCNTR[31:0] into Rt and PMCCNTR[63:32] into Rt2
> > MCRR p15,0,<Rt>,<Rt2>,c9 ; Write Rt to PMCCNTR[31:0] and Rt2 to PMCCNTR[63:32]
> > 
> 
> Thanks. I did some research based on your info and came back with the
> following proposals (Cov, correct me if I am wrong):
> 
> By comparing A57 TRM (page 394 in [1]) with A15 TRM (page 273 in [2]), I
> think this 64-bit cycle register is only available when running under
> aarch32 compatibility mode on ARMv8 because it is not specified in A15
> TRM.

OK, I hadn't realized that there would be differences between v7 and
AArch32. It looks like we need to add a function to the kvm-unit-tests
framework that enables unit tests to make that distinction, because we'll
want to explicitly test those differences in order to flush out emulation
bugs. I see now that Appendix K5 of the v8 ARM ARM lists some differences,
but this PMCCNTR difference isn't there...

As v8-A32 is an update/extension of v7-A, I'd expect there to be a RES0
bit in some v7 ID register that, on v8, is no longer reserved and a 1.
Unfortunately I just did some ARM doc skimming but can't find anything
like that. As we currently only use the cortex-a15 for our v7 processor,
then I guess we can just check MIDR, but yuck. Anyway, I'll send a
patch for that.

> To further verify it, I tested 32-bit pmu code on QEMU with TCG
> mode. The result is: accessing 64-bit PMCCNTR using the following
> assembly failed on A15:
> 
>    volatile("mrrc p15, 0, %0, %1, c9" : "=r" (lo), "=r" (hi));
> or
>    volatile("mrrc p15, 0, %Q0, %R0, c9" : "=r" (val));
> 
> Given this difference, I think there are two solutions for 64-bit
> AArch32 pmccntr_read, as requested by Drew:
> 
> 1) The PMU unit testing code tells if it is running under ARMv7 or under
> AArch32-compability mode. When it is running ARMv7, such as A15, let us
> use "MRC p15,0,<Rt>,c9,c13,0" and clear the upper 32-bit as 0. Otherwise
> use "MRRC p15,0,<Rt>,<Rt2>,c9".
> 
> 2) Returns 64-bit results for ARM pmccntr_read(). But we only uses "MRC
> p15,0,<Rt>,c9,c13,0" and always clear the upper 32-bit as 0. This will
> be the same as the original code.

3) For the basic test do (2), but add an additional test for AArch32
   mode that also does the MRRC. That way on AArch32 we test both access
   types.

Going with (3) means we can finish this series off now and then post
another patch later with the additional access, after my is_aarch32()
patch, that I'll write now, gets merged.

Thanks,
drew

> 
> Thoughts?
> 
> -Wei
> 
> [1] A57 TRM,
> http://infocenter.arm.com/help/topic/com.arm.doc.ddi0488c/DDI0488C_cortex_a57_mpcore_r1p0_trm.pdf
> [2] A15 TRM,
> http://infocenter.arm.com/help/topic/com.arm.doc.ddi0438c/DDI0438C_cortex_a15_r2p0_trm.pdf
> 
> > Regards,
> > Cov
> > 
> 
