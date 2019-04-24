From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 2/5] KVM: arm/arm64: context-switch ptrauth registers
Date: Wed, 24 Apr 2019 14:40:23 +0100
Message-ID: <20190424134023.GV3567@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-3-git-send-email-amit.kachhap@arm.com>
 <8636m9awmu.wl-marc.zyngier@arm.com>
 <c961a9d1-8cc8-6e40-de1d-527f7feb0f41@arm.com>
 <20190423154430.GM3567@e103592.cambridge.arm.com>
 <09bd4e79-c507-1f00-01c5-38afb2a62077@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <09bd4e79-c507-1f00-01c5-38afb2a62077@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Amit Daniel Kachhap <amit.kachhap@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 24, 2019 at 11:29:37AM +0100, Marc Zyngier wrote:
> On 23/04/2019 16:44, Dave Martin wrote:
> > On Tue, Apr 23, 2019 at 03:54:32PM +0530, Amit Daniel Kachhap wrote:
> >> Hi Mark,
> >>
> >> On 4/23/19 3:09 PM, Marc Zyngier wrote:
> >>> On Tue, 23 Apr 2019 05:42:35 +0100,
> >>> Amit Daniel Kachhap <amit.kachhap@arm.com> wrote:

[...]

> >>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >>>> index 7e34b9e..3cfe2eb 100644
> >>>> --- a/arch/arm64/Kconfig
> >>>> +++ b/arch/arm64/Kconfig
> >>>> @@ -1301,8 +1301,9 @@ config ARM64_PTR_AUTH
> >>>>  	  context-switched along with the process.
> >>>>  	  The feature is detected at runtime. If the feature is not present in
> >>>> -	  hardware it will not be advertised to userspace nor will it be
> >>>> -	  enabled.
> >>>> +	  hardware it will not be advertised to userspace/KVM guest nor will it
> >>>> +	  be enabled. However, KVM guest also require VHE mode and hence
> >>>> +	  CONFIG_ARM64_VHE=y option to use this feature.
> >>>
> >>> SVE seems to have the exact same requirements, and has
> >>>
> >>> 	depends on !KVM || ARM64_VHE
> >>>
> >>> Why don't we have that for PTR_AUTH too?
> >> This point came up earlier also and it was suggested by  Dave[1] to leave
> >> userspace ptrauth for non-vhe mode as that would bring regression now.
> >> [1]:https://lkml.org/lkml/2019/3/27/583
> > 
> > I see Marc applied this change in
> > https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=queue&id=e19b245fa4c61558536bd34f80845f0c41eab65f0
> 
> That's only for me not to forget anything, and it hasn't been folded
> into the original patch yet.

Ah, right, misunderstood.

> > The risk here is that someone has a custom config from an old kernel
> > that explicitly turns CONFIG_ARM64_VHE off, and that try to use that
> > config with this patch.
> > 
> > I'm not sure how much we care about that.
> > 
> > Otherwise, blocking this config so that people don't accidentally rely
> > on it seems sensible.
> 
> What I'm trying to do is to reduce the amount of valid kernel
> configurations that we need to validate independently.
> 
> At this stage, I'm tempted to just restrict it as described above, and
> maybe relax it if someone shouts at me.

Sounds good to me.

Cheers
---Dave
