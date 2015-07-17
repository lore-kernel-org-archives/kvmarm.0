From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 03/18] KVM: ARM64: Add offset defines for PMU registers
Date: Fri, 17 Jul 2015 12:17:38 +0200
Message-ID: <20150717101738.GM14024@cbox>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-4-git-send-email-shannon.zhao@linaro.org>
 <20150716184509.GC14024@cbox>
 <55A8BBE2.7010900@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55A8BBE2.7010900@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 17, 2015 at 04:25:06PM +0800, Shannon Zhao wrote:
> 
> 
> On 2015/7/17 2:45, Christoffer Dall wrote:
> > On Mon, Jul 06, 2015 at 10:17:33AM +0800, shannon.zhao@linaro.org wrote:
> >> From: Shannon Zhao <shannon.zhao@linaro.org>
> >>
> >> We are about to trap and emulate acccesses to each PMU register
> >> individually. This adds the context offsets for the AArch64 PMU
> >> registers and their AArch32 counterparts.
> >>
> >> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> >> ---
> >>  arch/arm64/include/asm/kvm_asm.h | 59 +++++++++++++++++++++++++++++++++++-----
> >>  1 file changed, 52 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> >> index 3c5fe68..21b5d3b 100644
> >> --- a/arch/arm64/include/asm/kvm_asm.h
> >> +++ b/arch/arm64/include/asm/kvm_asm.h
> >> @@ -56,14 +56,36 @@
> >>  #define DBGWVR15_EL1	86
> >>  #define MDCCINT_EL1	87	/* Monitor Debug Comms Channel Interrupt Enable Reg */
> >>  
> >> +/* Performance Monitors Registers */
> >> +#define PMCR_EL0	88	/* Control Register */
> >> +#define PMOVSSET_EL0	89	/* Overflow Flag Status Set Register */
> >> +#define PMOVSCLR_EL0	90	/* Overflow Flag Status Clear Register */
> >> +#define PMCCNTR_EL0	91	/* Cycle Counter Register */
> >> +#define PMSELR_EL0	92	/* Event Counter Selection Register */
> >> +#define PMCEID0_EL0	93	/* Common Event Identification Register 0 */
> >> +#define PMCEID1_EL0	94	/* Common Event Identification Register 1 */
> >> +#define PMEVCNTR0_EL0	95	/* Event Counter Register (0-30) */
> > 
> > why do we need these when we trap-and-emulate and we have the kvm_pmc
> > structs? 
> This just makes the guest work when accessing these registers.
> 
> > Is that because the kvm_pmc structs are only used when we
> > actually have an active counter running and registered with perf?
> > 
> 
> Right, the kvm_pmc structs are used to store the status of perf evnets,
> like the event type, count number of this perf event.
> 
> On the other hand, the kernel perf codes will not directly access to the
> PMEVCNTRx_EL0 and PMEVTYPERx_EL0 registers. It will firstly write the
> index of select counter to PMSELR_EL0 and access to PMXEVCNTR_EL0 or
> PMXEVTYPER_EL0. Then this is architecturally mapped to PMEVCNTRx_EL0 and
> PMEVTYPERx_EL0.
> 

I'm just wondering if it makes sense to keep virtual state around for
all these registers, since we don't emulate the counter values, so why
do we need to preserve any virtual cpu state for all of them?

-Christoffer
