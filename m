Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B527C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 16:11:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15B5D4B1A5;
	Wed,  8 Dec 2021 11:11:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DTAPEoOECc48; Wed,  8 Dec 2021 11:11:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C43E84B19F;
	Wed,  8 Dec 2021 11:11:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CA094A98B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 11:11:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oZnMkI-Vsn5A for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 11:11:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4E7E4B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 11:11:20 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 381C7101E;
 Wed,  8 Dec 2021 08:11:20 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74FD73F5A1;
 Wed,  8 Dec 2021 08:11:18 -0800 (PST)
Date: Wed, 8 Dec 2021 16:11:13 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU
 attribute
Message-ID: <YbDZIfeOxYgRODGg@monolith.localdoman>
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
 <20211206170223.309789-4-alexandru.elisei@arm.com>
 <CAAeT=Fxeu7vRHyt1P8c1YKZ2sKyUjo6W9tqXeUAGHKn=y09AEg@mail.gmail.com>
 <YbCj0IrjZoBR9dwQ@monolith.localdoman>
 <87czm718cp.wl-maz@kernel.org>
 <YbDNPrDOriI5FjfS@monolith.localdoman>
 <87bl1r14po.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87bl1r14po.wl-maz@kernel.org>
Cc: mingo@redhat.com, tglx@linutronix.de, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On Wed, Dec 08, 2021 at 03:44:35PM +0000, Marc Zyngier wrote:
> On Wed, 08 Dec 2021 15:20:30 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Wed, Dec 08, 2021 at 02:25:58PM +0000, Marc Zyngier wrote:
> > > On Wed, 08 Dec 2021 12:23:44 +0000,
> > > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > > > 
> > > > This makes me wonder. Should KVM enforce having userspace either not
> > > > setting the PMU for any VCPU, either setting it for all VCPUs? I think this
> > > > would be a good idea and will reduce complexity in the long run. I also
> > > > don't see a use case for userspace choosing to set the PMU for a subset of
> > > > VCPUs, leaving the other VCPUs with the default behaviour.
> > > 
> > > Indeed. As much as I'm happy to expose a PMU to a guest on an
> > > asymmetric system, I really do not want the asymmetry in the guest
> > > itself. So this should be an all or nothing behaviour.
> > 
> > From what I can tell, the only asymmetry that can be exposed to a guest as
> > a result of the series is the number of events supported on a VCPU.
> 
> Not only. It means that the events are counting different things. It
> isn't only about pmuver, which is only about the architectural
> revision implemented by the PMU. If you start assigning two different
> PMUs (in the perf sense) to a guest, you open the Pandora box of
> having to deal with all the subtle nonsense that asymmetric systems
> bring. What about event filtering, for example?

kvm_pmu_set_counter_event_type() uses the number of events to mask out the
unsupported events, so still depends on pmuver.

But I understand what you are saying, there might be differences between what
exactly an event is counting, how it increments and how the counter value should
be interpreted based on the microarchitecture.

> 
> > I don't like the idea of forcing userspace to set the *same* PMU for all
> > VCPUs, as that would severely limit running VMs with PMU on asymmetric
> > systems.
> 
> On the contrary, I am *very* happy to limit a VM to a single PMU (and
> thus CPU) type on these systems. Really.

Ok, so any kind of asymmetry is unacceptable.

Accepted behaviour:

1. If userspace sets PMU for one VCPU, then *all* other VCPUs must have a PMU
set, and furthermore, it must be the same PMU as the first VCPU,

or

2. If userspace has initialized a PMU (via
KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_V3_INIT)) without setting a PMU, then
it is forbidden for userspace to set a PMU for the other VCPUs.

Is that what you had in mind?

> 
> > Even if KVM forces to set a PMU (does not have to be the same PMU) for all
> > VCPUs, that still does not look like the correct solution for me, because
> > userspace can set PMUs with different number of events.
> 
> I don't understand what you mean. If you associate a single PMU type
> to the guest, that's all the guest sees.

I was talking in the context of allowing userspace to associate different PMUs
to different VCPUs.

Thanks,
Alex

> 
> > What I can try is to make kvm->arch.pmuver the minimum version of all the
> > VCPU PMUs and the implict PMU. I'll give that a go in the next iteration.
> 
> I really don't think we need any of this.
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
