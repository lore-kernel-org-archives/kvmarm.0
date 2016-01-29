From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v10 07/21] KVM: ARM64: PMU: Add perf event map and
 introduce perf event creating function
Date: Fri, 29 Jan 2016 10:18:12 +0000
Message-ID: <20160129101812.GB4541@arm.com>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
 <1453866709-20324-8-git-send-email-zhaoshenglong@huawei.com>
 <20160128163115.GC3807@hawk.localdomain>
 <56AA45B0.3060205@arm.com>
 <20160128180638.GO775@arm.com>
 <56AB0617.5060902@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AB0617.5060902@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 29, 2016 at 02:26:31PM +0800, Shannon Zhao wrote:
> 
> 
> On 2016/1/29 2:06, Will Deacon wrote:
> > On Thu, Jan 28, 2016 at 04:45:36PM +0000, Marc Zyngier wrote:
> >> > On 28/01/16 16:31, Andrew Jones wrote:
> >>> > > On Wed, Jan 27, 2016 at 11:51:35AM +0800, Shannon Zhao wrote:
> >>>> > >> From: Shannon Zhao <shannon.zhao@linaro.org>
> >>>> > >>
> >>>> > >> When we use tools like perf on host, perf passes the event type and the
> >>>> > >> id of this event type category to kernel, then kernel will map them to
> >>>> > >> hardware event number and write this number to PMU PMEVTYPER<n>_EL0
> >>>> > >> register. When getting the event number in KVM, directly use raw event
> >>>> > >> type to create a perf_event for it.
> >>>> > >>
> >>>> > >> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> >>>> > >> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> >>>> > >> ---
> >>>> > >>  arch/arm64/include/asm/pmu.h |   3 ++
> >>>> > >>  arch/arm64/kvm/Makefile      |   1 +
> >>>> > >>  include/kvm/arm_pmu.h        |  10 ++++
> >>>> > >>  virt/kvm/arm/pmu.c           | 122 +++++++++++++++++++++++++++++++++++++++++++
> >>>> > >>  4 files changed, 136 insertions(+)
> >>>> > >>  create mode 100644 virt/kvm/arm/pmu.c
> >>>> > >>
> >>>> > >> diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
> >>>> > >> index 4406184..2588f9c 100644
> >>>> > >> --- a/arch/arm64/include/asm/pmu.h
> >>>> > >> +++ b/arch/arm64/include/asm/pmu.h
> >>>> > >> @@ -21,6 +21,7 @@
> >>>> > >>  
> >>>> > >>  #define ARMV8_MAX_COUNTERS      32
> >>>> > >>  #define ARMV8_COUNTER_MASK      (ARMV8_MAX_COUNTERS - 1)
> >>>> > >> +#define ARMV8_CYCLE_IDX         (ARMV8_MAX_COUNTERS - 1)
> >>> > > 
> >>> > > I'm not sure we want to add this. It's name is wrong, as it's really
> >>> > > PMCNTENSET_EL0.C, and just a few lines above we have the idx defined
> >>> > > already (ARMV8_IDX_CYCLE_COUNTER), but as zero, because
> >>> > > arch/arm64/kernel/perf_event.c maps it that way.
> >>> > > 
> >>> > > I think we should do the same with the pmc array, i.e. map the cycle
> >>> > > counter to idx zero.
> >> > 
> >> > I tend to have the opposite view. Not for the sake of it, but because I
> >> > find it helpful to directly map the code to the architecture
> >> > documentation without having to bend another handful of neurons.
> >> > 
> >> > Will probably had some good reasons to structure it that way, but I
> >> > don't know the rational. Will?
> > It was years ago, but I suspect that the cycle counter is index zero
> > because its mandated, whilst the number of event counters is IMPDEF.
> 
> Since PMCNTENSET/CLR, PMINTENSET/CLR, PMOVSSET/CLR and PMSWINC are using
> bit 31 to stands the state of cycle counter, if we make cycle counter
> index to zero, we always need to do translation between the idx and bit
> 31 when we access these registers.

Conversely, if you stick the cycle counter right at the top, then you'll
need to rework a bunch of the perf code that iterates from
ARMV7_IDX_COUNTER0 to pmu->num_events.

Will
