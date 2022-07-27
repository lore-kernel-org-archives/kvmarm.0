Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B33EC04A68
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 12:09:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1A14C342;
	Wed, 27 Jul 2022 08:09:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cf0585nh24CJ; Wed, 27 Jul 2022 08:09:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D2454C35C;
	Wed, 27 Jul 2022 08:09:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3626B4C345
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 08:09:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oP0nXcN8MJQV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 08:09:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A1814C331
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 08:09:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D046FD6E;
 Wed, 27 Jul 2022 05:09:31 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 429A83F73B;
 Wed, 27 Jul 2022 05:09:30 -0700 (PDT)
Date: Wed, 27 Jul 2022 13:10:02 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <YuEqiLbThsrb1pHh@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman>
 <YuApmZFdZzTi5ROu@google.com> <875yjiyka4.wl-maz@kernel.org>
 <YuEZyeW9Hq6poWYL@monolith.localdoman>
 <ca2d505c9099f9a8726dbd95537ad0eb@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ca2d505c9099f9a8726dbd95537ad0eb@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Hi,

On Wed, Jul 27, 2022 at 12:18:41PM +0100, Marc Zyngier wrote:
> On 2022-07-27 11:56, Alexandru Elisei wrote:
> > Hi Marc,
> > 
> > On Wed, Jul 27, 2022 at 10:30:59AM +0100, Marc Zyngier wrote:
> > > On Tue, 26 Jul 2022 18:51:21 +0100,
> > > Oliver Upton <oliver.upton@linux.dev> wrote:
> > > >
> > > > Hi Alex,
> > > >
> > > > On Mon, Jul 25, 2022 at 11:06:24AM +0100, Alexandru Elisei wrote:
> > > >
> > > > [...]
> > > >
> > > > > > A funkier approach might be to defer pinning of the buffer until the SPE is
> > > > > > enabled and avoid pinning all of VM memory that way, although I can't
> > > > > > immediately tell how flexible the architecture is in allowing you to cache
> > > > > > the base/limit values.
> > > > >
> > > > > I was investigating this approach, and Mark raised a concern that I think
> > > > > might be a showstopper.
> > > > >
> > > > > Let's consider this scenario:
> > > > >
> > > > > Initial conditions: guest at EL1, profiling disabled (PMBLIMITR_EL1.E = 0,
> > > > > PMBSR_EL1.S = 0, PMSCR_EL1.{E0SPE,E1SPE} = {0,0}).
> > > > >
> > > > > 1. Guest programs the buffer and enables it (PMBLIMITR_EL1.E = 1).
> > > > > 2. Guest programs SPE to enable profiling at **EL0**
> > > > > (PMSCR_EL1.{E0SPE,E1SPE} = {1,0}).
> > > > > 3. Guest changes the translation table entries for the buffer. The
> > > > > architecture allows this.
> > > > > 4. Guest does an ERET to EL0, thus enabling profiling.
> > > > >
> > > > > Since KVM cannot trap the ERET to EL0, it will be impossible for KVM to pin
> > > > > the buffer at stage 2 when profiling gets enabled at EL0.
> > > >
> > > > Not saying we necessarily should, but this is possible with FGT no?
> > > 
> > > Given how often ERET is used at EL1, I'd really refrain from doing
> > > so. NV uses the same mechanism to multiplex vEL2 and vEL1 on the real
> > > EL1, and this comes at a serious cost (even an exception return that
> > > stays at the same EL gets trapped). Once EL1 runs, we disengage this
> > > trap because it is otherwise way too costly.
> > > 
> > > >
> > > > > I can see two solutions here:
> > > > >
> > > > > a. Accept the limitation (and advertise it in the documentation) that if
> > > > > someone wants to use SPE when running as a Linux guest, the kernel used by
> > > > > the guest must not change the buffer translation table entries after the
> > > > > buffer has been enabled (PMBLIMITR_EL1.E = 1). Linux already does that, so
> > > > > running a Linux guest should not be a problem. I don't know how other OSes
> > > > > do it (but I can find out). We could also phrase it that the buffer
> > > > > translation table entries can be changed after enabling the buffer, but
> > > > > only if profiling happens at EL1. But that sounds very arbitrary.
> > > > >
> > > > > b. Pin the buffer after the stage 2 DABT that SPE will report in the
> > > > > situation above. This means that there is a blackout window, but will
> > > > > happen only once after each time the guest reprograms the buffer. I don't
> > > > > know if this is acceptable. We could say that this if this blackout window
> > > > > is not acceptable, then the guest kernel shouldn't change the translation
> > > > > table entries after enabling the buffer.
> > > > >
> > > > > Or drop the approach of pinning the buffer and go back to pinning the
> > > > > entire memory of the VM.
> > > > >
> > > > > Any thoughts on this? I would very much prefer to try to pin only the
> > > > > buffer.
> > > >
> > > > Doesn't pinning the buffer also imply pinning the stage 1 tables
> > > > responsible for its translation as well? I agree that pinning the buffer
> > > > is likely the best way forward as pinning the whole of guest memory is
> > > > entirely impractical.
> > > 
> > > How different is this from device assignment, which also relies on
> > > full page pinning? The way I look at it, SPE is a device directly
> > > assigned to the guest, and isn't capable of generating synchronous
> > > exception. Not that I'm madly in love with the approach, but this is
> > > at least consistent. There was also some concerns around buggy HW that
> > > would blow itself up on S2 faults, but I think these implementations
> > > are confidential enough that we don't need to worry about them.
> > > 
> > > > I'm also a bit confused on how we would manage to un-pin memory on the
> > > > way out with this. The guest is free to muck with the stage 1 and could
> > > > cause the SPU to spew a bunch of stage 2 aborts if it wanted to be
> > > > annoying. One way to tackle it would be to only allow a single
> > > > root-to-target walk to be pinned by a vCPU at a time. Any time a new
> > > > stage 2 abort comes from the SPU, we un-pin the old walk and pin the new
> > > > one instead.
> > > 
> > > This sounds like a reasonable option. Only one IPA range covering the
> > > SPE buffer (as described by the translation of PMBPTR_EL1) is pinned
> > > at any given time. Generate a SPE S2 fault outside of this range, and
> > > we unpin the region before mapping in the next one. Yes, the guest can
> > > play tricks on us and exploit the latency of the interrupt. But at the
> > > end of the day, this is its own problem.
> > > 
> > > Of course, this results in larger blind windows. Ideally, we should be
> > > able to report these to the guest, either as sideband data or in the
> > > actual profiling buffer (but I have no idea whether this is possible).
> > 
> > I believe solution b, pin the buffer when guest enables profiling (where
> > by
> > profiling enabled I mean StatisticalProfilingEnabled() returns true),
> > and
> > only in the situation that I described pin the buffer as a result of a
> > stage 2 fault, would reduce the blackouts to a minimum.
> 
> In all honesty, I'd rather see everything be done as the result
> of a S2 fault for now, and only introduce heuristics to reduce the blackout
> window at a later time. And this includes buffer pinning
> if that can be avoided.

I believe it's not feasible to do everything as a result of a SPE stage 2
fault. I've explained where in this reply [1]. Sorry for fragmenting the
discussion into so many different threads.

Having the first write, and only that first write, trigger a stage 2 fault
that KVM handles by pinning the buffer works because the guest hasn't
written anything useful to the buffer.

[1] https://lore.kernel.org/all/YuEVq8Au7YsDLOdI@monolith.localdoman/

> 
> My hunch is that people wanting zero blackout will always pin
> all their memory, one way or another, and that the rest of us
> will be happy just to get *something* out of SPE in a VM...

What are you thinking when you are saying "one way or another"? Because
that would need changes to KVM (mlock() is not enough).

Thanks,
Alex

> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
