Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7145FC00140
	for <kvmarm@archiver.kernel.org>; Tue,  2 Aug 2022 09:48:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A763E50B32;
	Tue,  2 Aug 2022 05:48:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3FdQTzZCScSQ; Tue,  2 Aug 2022 05:48:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C96AE50B34;
	Tue,  2 Aug 2022 05:48:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 774F050B34
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2022 05:48:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BCuMpR4AXOyr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Aug 2022 05:48:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E27B50B32
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2022 05:48:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C861139F;
 Tue,  2 Aug 2022 02:48:31 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB1803F67D;
 Tue,  2 Aug 2022 02:48:28 -0700 (PDT)
Date: Tue, 2 Aug 2022 10:49:07 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <YujzE33aPSD22wvY@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman>
 <20220801170055.GB26471@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220801170055.GB26471@willie-the-truck>
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi,

(+Oliver)

On Mon, Aug 01, 2022 at 06:00:56PM +0100, Will Deacon wrote:
> Hi Alex,
> 
> On Mon, Jul 25, 2022 at 11:06:24AM +0100, Alexandru Elisei wrote:
> > On Tue, Apr 19, 2022 at 03:10:13PM +0100, Will Deacon wrote:
> > > On Tue, Apr 19, 2022 at 02:51:05PM +0100, Alexandru Elisei wrote:
> > > > The approach I've taken so far in adding support for SPE in KVM [1] relies
> > > > on pinning the entire VM memory to avoid SPE triggering stage 2 faults
> > > > altogether. I've taken this approach because:
> > > > 
> > > > 1. SPE reports the guest VA on an stage 2 fault, similar to stage 1 faults,
> > > > and at the moment KVM has no way to resolve the VA to IPA translation.  The
> > > > AT instruction is not useful here, because PAR_EL1 doesn't report the IPA
> > > > in the case of a stage 2 fault on a stage 1 translation table walk.
> > > > 
> > > > 2. The stage 2 fault is reported asynchronously via an interrupt, which
> > > > means there will be a window where profiling is stopped from the moment SPE
> > > > triggers the fault and when the PE taks the interrupt. This blackout window
> > > > is obviously not present when running on bare metal, as there is no second
> > > > stage of address translation being performed.
> > > 
> > > Are these faults actually recoverable? My memory is a bit hazy here, but I
> > > thought SPE buffer data could be written out in whacky ways such that even
> > > a bog-standard page fault could result in uncoverable data loss (i.e. DL=1),
> > > and so pinning is the only game in town.
> > > 
> > > A funkier approach might be to defer pinning of the buffer until the SPE is
> > > enabled and avoid pinning all of VM memory that way, although I can't
> > > immediately tell how flexible the architecture is in allowing you to cache
> > > the base/limit values.
> > 
> > I was investigating this approach, and Mark raised a concern that I think
> > might be a showstopper.
> > 
> > Let's consider this scenario:
> > 
> > Initial conditions: guest at EL1, profiling disabled (PMBLIMITR_EL1.E = 0,
> > PMBSR_EL1.S = 0, PMSCR_EL1.{E0SPE,E1SPE} = {0,0}).
> > 
> > 1. Guest programs the buffer and enables it (PMBLIMITR_EL1.E = 1).
> > 2. Guest programs SPE to enable profiling at **EL0**
> > (PMSCR_EL1.{E0SPE,E1SPE} = {1,0}).
> > 3. Guest changes the translation table entries for the buffer. The
> > architecture allows this.
> 
> The architecture also allows MMIO accesses to use writeback addressing
> modes, but it doesn't provide a mechanism to virtualise them sensibly.
> 
> So I'd prefer that we don't pin all of guest memory just to satisfy a corner
> case -- as long as the impact of a guest doing this funny sequence is
> constrained to the guest, then I think pinning only what is required is
> probably the most pragmatic approach.
> 
> Is it ideal? No, of course not, and we should probably try to get the debug
> architecture extended to be properly virtualisable, but in the meantime
> having major operating systems as guests and being able to use SPE without
> pinning seems like a major design goal to me.
> 
> In any case, that's just my thinking on this and I defer to Oliver and
> Marc on the ultimate decision.

Thank you for the input.

To summarize the approaches we've discussed so far:

1. Pinning the entire guest memory
- Heavy handed and not ideal.
- Tried this approach in v5 of the SPE series [1], patches #2-#12.

2. Mapping the guest SPE buffer on demand, page by page, as a result of stage 2
faults reported by SPE.
- Not feasible, because the entire contents of the buffer must be discarded is
  PMBSR_EL1.DL is set to 1 when taking the fault.
- Requires KVM to walk the guest's stage 1 tables, because SPE reports the VA,
  not the IPA.

3. Pinning the guest SPE buffer when profiling becomes enabled*:
- There is the corner case described above, when profiling becomes enabled as a
  result of an ERET to EL0. This can happen when the buffer is enabled and
  PMSCR_EL1.{E0SPE,E1SPE} = {1,0};
- The previous buffer is unpinned when a new buffer is pinned, to avoid SPE
  stage 2 faults when draining the buffer, which is performed with profiling
  disabled.
- Also requires KVM to walk the guest's stage 1 tables.

4. Pin the entire guest SPE buffer after the first stage 2 fault reported by
SPE.
- Gets rid of the corner case at 3.
- Same approach to buffer unpinning as 3.
- Introduces a blackout window before the first record is written.
- Also requires KVM to walk the guest's stage 1 tables.

As for the corner case at 3, I proposed either:

a) Mandate that guest operating systems must never modify the buffer
translation entries if the buffer is enabled and
PMSCR_EL1.{E0SPE,E1SPE} = {1,0}.

b) Pin the entire buffer as a result of the first stage 2 fault reported by SPE,
but **only** for this corner case. For all other cases, the buffer is pinned
when profiling becomes enabled, to eliminate the blackout window. Guest
operating systems can be modified to not change the translation entries for the
buffer if this blackout window is not desirable.

Pinning as a result of the **first** stage 2 fault should work, because there
are no prior records that would have to be discarded if PMSBR_EL1.DL = 1.

I hope I haven't missed anything. Thoughts and suggestions more than welcome.

*Profiling enabled, as per the Arm ARM, means buffer is enabled and sampling is
enabled at the current exception level.

[1] https://lore.kernel.org/all/20211117153842.302159-1-alexandru.elisei@arm.com/

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
