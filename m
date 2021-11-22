Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826F8C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 22 Nov 2021 14:41:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00DD5407D1;
	Mon, 22 Nov 2021 09:41:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l7kSd-QkGip4; Mon, 22 Nov 2021 09:41:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD9B3405EE;
	Mon, 22 Nov 2021 09:41:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60E2E407D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 09:41:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2VKOMLpXyEsq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Nov 2021 09:41:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C8E24048B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 09:41:27 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 189C81063;
 Mon, 22 Nov 2021 06:41:27 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A02B23F66F;
 Mon, 22 Nov 2021 06:41:25 -0800 (PST)
Date: Mon, 22 Nov 2021 14:43:17 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 4/4] KVM: arm64: Refuse to run VCPU if the PMU doesn't
 match the physical CPU
Message-ID: <YZushUBHlla+tS+m@monolith.localdoman>
References: <20211115165041.194884-1-alexandru.elisei@arm.com>
 <20211115165041.194884-5-alexandru.elisei@arm.com>
 <87bl2ds3ny.wl-maz@kernel.org>
 <YZuJIUls8hl85Zia@monolith.localdoman>
 <871r386zlf.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <871r386zlf.wl-maz@kernel.org>
Cc: will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Mon, Nov 22, 2021 at 02:21:00PM +0000, Marc Zyngier wrote:
> On Mon, 22 Nov 2021 12:12:17 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Sun, Nov 21, 2021 at 07:35:13PM +0000, Marc Zyngier wrote:
> > > On Mon, 15 Nov 2021 16:50:41 +0000,
> > > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > > > 
> > > > Userspace can assign a PMU to a VCPU with the KVM_ARM_VCPU_PMU_V3_SET_PMU
> > > > device ioctl. If the VCPU is scheduled on a physical CPU which has a
> > > > different PMU, the perf events needed to emulate a guest PMU won't be
> > > > scheduled in and the guest performance counters will stop counting. Treat
> > > > it as an userspace error and refuse to run the VCPU in this situation.
> > > > 
> > > > The VCPU is flagged as being scheduled on the wrong CPU in vcpu_load(), but
> > > > the flag is cleared when the KVM_RUN enters the non-preemptible section
> > > > instead of in vcpu_put(); this has been done on purpose so the error
> > > > condition is communicated as soon as possible to userspace, otherwise
> > > > vcpu_load() on the wrong CPU followed by a vcpu_put() could clear the flag.
> > > 
> > > Can we make this something orthogonal to the PMU, and get userspace to
> > > pick an affinity mask independently of instantiating a PMU? I can
> > > imagine this would also be useful for SPE on asymmetric systems.
> > 
> > I actually went this way for the latest version of the SPE series [1] and
> > dropped the explicit userspace ioctl in favor of this mechanism.
> > 
> > The expectation is that userspace already knows which CPUs are associated
> > with the chosen PMU (or SPE) when setting the PMU for the VCPU, and having
> > userspace set it explicitely via an ioctl looks like an unnecessary step to
> > me. I don't see other usecases of an explicit ioctl outside of the above
> > two situation (if userspace wants a VCPU to run only on specific CPUs, it
> > can use thread affinity for that), so I decided to drop it.
> 
> My problem with that is that if you have (for whatever reason) a set
> of affinities that are not strictly identical for both PMU and SPE,
> and expose both of these to a guest, what do you choose?
> 
> As long as you have a single affinity set to take care of, you're
> good. It is when you have several ones that it becomes ugly (as with
> anything involving asymmetric CPUs).

I thought about it when I decided to do it this way, my solution was to do
a cpumask_and() with the existing VCPU cpumask when setting a VCPU feature
that requires it, and returning an error if we get an empty cpumask,
because userspace is requesting a combination of VCPU features that is not
supported by the hardware.

Going with the other solution (user sets the cpumask via an ioctl), KVM
would still have to check against certain combinations of VCPU features
(for SPE it's mandatory, so KVM doesn't trigger an undefined exception, we
could skip the check for PMU, but then what do we gain from the ioctl if
KVM doesn't check that it matches the PMU?), so I don't think we loose
anything by going with the implicit cpumask.

What do you think?

Thanks,
Alex

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
