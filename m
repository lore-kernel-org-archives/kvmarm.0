From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 5/5] KVM: arm/arm64: support chained PMU counters
Date: Mon, 18 Feb 2019 14:02:11 +0000
Message-ID: <20190218140211.066b2d70@why.wild-wind.fr.eu.org>
References: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
 <1549299218-44714-6-git-send-email-andrew.murray@arm.com>
 <11a8c800-5c1d-08ce-9d85-402ca89727a3@arm.com>
 <236797c3-9f3a-91d4-c859-e8eb4d3eb3ee@arm.com>
 <20190218120305.GH54124@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 084624A2AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 09:02:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iRmcP5+4r6Pn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 09:02:48 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5FD349E3E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 09:02:48 -0500 (EST)
In-Reply-To: <20190218120305.GH54124@e119886-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 18 Feb 2019 12:03:05 +0000
Andrew Murray <andrew.murray@arm.com> wrote:

> On Thu, Feb 14, 2019 at 11:42:15AM +0000, Suzuki K Poulose wrote:
> > 
> > 
> > On 05/02/2019 14:33, Julien Thierry wrote:  
> > > Hi Andrew,
> > > 
> > > On 04/02/2019 16:53, Andrew Murray wrote:  
> > > > Emulate chained PMU counters by creating a single 64 bit event counter
> > > > for a pair of chained KVM counters.
> > > > 
> > > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > > ---
> > > >   include/kvm/arm_pmu.h |   1 +
> > > >   virt/kvm/arm/pmu.c    | 321 +++++++++++++++++++++++++++++++++++++++++---------
> > > >   2 files changed, 269 insertions(+), 53 deletions(-)
> > > > 
> > > > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > > > index b73f31b..8e691ee 100644
> > > > --- a/include/kvm/arm_pmu.h
> > > > +++ b/include/kvm/arm_pmu.h
> > > > @@ -29,6 +29,7 @@ struct kvm_pmc {
> > > >   	u8 idx;	/* index into the pmu->pmc array */
> > > >   	struct perf_event *perf_event;
> > > >   	u64 bitmask;
> > > > +	u64 overflow_count;
> > > >   };
> > > >   struct kvm_pmu {
> > > > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > > > index a64aeb2..9318130 100644
> > > > --- a/virt/kvm/arm/pmu.c
> > > > +++ b/virt/kvm/arm/pmu.c
> > > > @@ -24,9 +24,25 @@
> > > >   #include <kvm/arm_pmu.h>
> > > >   #include <kvm/arm_vgic.h>
> > > > +#define ARMV8_PMUV3_PERFCTR_CHAIN 0x1E  
> > > 
> > > I find it a bit awkward to have this redefined here.
> > > 
> > > Maybe we could define a helper in kvm_host.h:
> > > bool kvm_pmu_typer_is_chain(u64 typer);
> > > 
> > > That would always return false for arm32?  
> > 
> > We don't support ARMv7 host, so that doesn't matter. But
> > it is a good idea to wrap it in a function here.  
> 
> I'm not sure kvm_host.h is the right place for this as this really relates
> to the ARM PMU drivers. Seeing that armv8pmu_filter_match in
> arch/arm64/kernel/perf_event.c would also benefit from this new function I'll
> add it to arch/arm64/include/asm/perf_event.h and stub it out in arm_pmu.c
> for the ARM32 case.

Doing that is going to create a dependency with the perf subsystem,
and will need an Ack from the maintainer (Will).

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
