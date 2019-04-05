From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v12 8/8] arm64: docs: document perf event attributes
Date: Fri, 5 Apr 2019 13:43:08 +0100
Message-ID: <20190405124308.GD3100@fuggles.cambridge.arm.com>
References: <20190328103731.27264-1-andrew.murray@arm.com>
 <20190328103731.27264-9-andrew.murray@arm.com>
 <20190404162128.GD27577@fuggles.cambridge.arm.com>
 <20190404193350.GP53702@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ACC24A36D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 08:43:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tgRqoWTg+y0t for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Apr 2019 08:43:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE5814A320
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 08:43:13 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190404193350.GP53702@e119886-lin.cambridge.arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 08:33:51PM +0100, Andrew Murray wrote:
> On Thu, Apr 04, 2019 at 05:21:28PM +0100, Will Deacon wrote:
> > On Thu, Mar 28, 2019 at 10:37:31AM +0000, Andrew Murray wrote:
> > > +exclude_kernel
> > > +--------------
> > > +
> > > +This attribute excludes the kernel.
> > > +
> > > +The kernel runs at EL2 with VHE and EL1 without. Guest kernels always run
> > > +at EL1.
> > > +
> > > +This attribute will exclude EL1 and additionally EL2 on a VHE system.
> > 
> > I find this last sentence a bit confusing, because it can be read to imply
> > that if you don't set exclude_kernel and you're in a guest on a VHE system,
> > then you can profile EL2.
> 
> Yes this could be misleading.
> 
> However from the perspective of the guest, when exclude_kernel is not set we
> do indeed allow the guest to program it's PMU with ARMV8_PMU_INCLUDE_EL2 - and
> thus the statement above is correct in terms of what the kernel believes it is
> doing.
> 
> I think these statements are less confusing if we treat the exception levels
> as those 'detected' by the running context (e.g. consider the impact of nested
> virt here) - and we if ignore what the hypervisor (KVM) does outside (e.g.
> stops counting upon switching between guest/host, translating PMU filters in
> kvm_pmu_set_counter_event_type etc, etc). This then makes this document useful
> for those wishing to change this logic (which is the intent) rather than those
> trying to understand how we filter for EL levels as seen bare-metal.
> 
> With regards to the example you gave (exclude_kernel, EL2) - yes we want the
> kernel to believe it can count EL2 - because one day we may want to update
> KVM to allow the guest to count it's hypervisor overhead (e.g. host kernel
> time associated with the guest).

If we were to support this in the future, then exclude_hv will suddenly
start meaning something in a guest, so this could be considered to be an ABI
break.

> I could write some preface that describes this outlook. Alternatively I could
> just spell out what happens on a guest, e.g.
> 
> "For the host this attribute will exclude EL1 and additionally EL2 on a VHE
> system.
> 
> For the guest this attribute will exclude EL1."
> 
> Though I'm less comfortable with this, as the last statement "For the guest this
> attribute will exclude EL1." describes the product of both
> kvm_pmu_set_counter_event_type and armv8pmu_set_event_filter which is confusing
> to work out and also makes an assumption that we don't have nested virt (true
> for now at least) and also reasons about bare-metal EL levels which probably
> aren't that useful for someone changing this logic or understanding what the
> flags do for there performance analysis.
> 
> Do you have a preference for how this is improved?

I think you should be explicit about what is counted. If we don't count EL2
when profiling in a guest (regardless of the exclude_*) flags, then we
should say that. By not documenting this we don't actually buy ourselves
room to change things in future, we should have an emergent behaviour which
isn't covered by our docs.

Will
