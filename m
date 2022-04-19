Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E03C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 15:35:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A63324B1D5;
	Tue, 19 Apr 2022 11:35:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pISAUSgGaggL; Tue, 19 Apr 2022 11:35:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD6164B1E7;
	Tue, 19 Apr 2022 11:35:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB66F4B1D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 11:35:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u87q97vzRVAe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 11:35:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1575E4B19D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 11:35:50 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7968B106F;
 Tue, 19 Apr 2022 08:35:50 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D4573F766;
 Tue, 19 Apr 2022 08:35:49 -0700 (PDT)
Date: Tue, 19 Apr 2022 16:35:43 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <Yl7Wsmnp5APkD9oF@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yl7KewpTj+7NSonf@monolith.localdoman>
 <20220419145945.GC6186@willie-the-truck>
 <Yl7TKXY09ZA61aYT@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yl7TKXY09ZA61aYT@monolith.localdoman>
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

On Tue, Apr 19, 2022 at 04:20:09PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Tue, Apr 19, 2022 at 03:59:46PM +0100, Will Deacon wrote:
> > On Tue, Apr 19, 2022 at 03:44:02PM +0100, Alexandru Elisei wrote:
> > > On Tue, Apr 19, 2022 at 03:10:13PM +0100, Will Deacon wrote:
> > > > On Tue, Apr 19, 2022 at 02:51:05PM +0100, Alexandru Elisei wrote:
> > > > > 2. The stage 2 fault is reported asynchronously via an interrupt, which
> > > > > means there will be a window where profiling is stopped from the moment SPE
> > > > > triggers the fault and when the PE taks the interrupt. This blackout window
> > > > > is obviously not present when running on bare metal, as there is no second
> > > > > stage of address translation being performed.
> > > > 
> > > > Are these faults actually recoverable? My memory is a bit hazy here, but I
> > > > thought SPE buffer data could be written out in whacky ways such that even
> > > > a bog-standard page fault could result in uncoverable data loss (i.e. DL=1),
> > > > and so pinning is the only game in town.
> > > 
> > > Ah, I forgot about that, I think you're right (ARM DDI 0487H.a, page
> > > D10-5177):
> > > 
> > > "The architecture does not require that a sample record is written
> > > sequentially by the SPU, only that:
> > > [..]
> > > - On a Profiling Buffer management interrupt, PMBSR_EL1.DL indicates
> > >   whether PMBPTR_EL1 points to the first byte after the last complete
> > >   sample record.
> > > - On an MMU fault or synchronous External abort, PMBPTR_EL1 serves as a
> > >   Fault Address Register."
> > > 
> > > and (page D10-5179):
> > > 
> > > "If a write to the Profiling Buffer generates a fault and PMBSR_EL1.S is 0,
> > > then a Profiling Buffer management event is generated:
> > > [..]
> > > - If PMBPTR_EL1 is not the address of the first byte after the last
> > >   complete sample record written by the SPU, then PMBSR_EL1.DL is set to 1.
> > >   Otherwise, PMBSR_EL1.DL is unchanged."
> > > 
> > > Since there is no way to know the record size (well, unless
> > > PMSIDR_EL1.MaxSize == PMBIDR_EL1.Align, but that's not an architectural
> > > requirement), it means that KVM cannot restore the write pointer to the
> > > address of the last complete record + 1, to allow the guest to resume
> > > profiling without corrupted records.
> > > 
> > > > 
> > > > A funkier approach might be to defer pinning of the buffer until the SPE is
> > > > enabled and avoid pinning all of VM memory that way, although I can't
> > > > immediately tell how flexible the architecture is in allowing you to cache
> > > > the base/limit values.
> > > 
> > > A guest can use this to pin the VM memory (or a significant part of it),
> > > either by doing it on purpose, or by allocating new buffers as they get
> > > full. This will probably result in KVM killing the VM if the pinned memory
> > > is larger than ulimit's max locked memory, which I believe is going to be a
> > > bad experience for the user caught unaware. Unless we don't want KVM to
> > > take ulimit into account when pinning the memory, which as far as I can
> > > goes against KVM's approach so far.
> > 
> > Yeah, it gets pretty messy and ulimit definitely needs to be taken into
> > account, as it is today.
> > 
> > That said, we could just continue if the pinning fails and the guest gets to
> > keep the pieces if we get a stage-2 fault -- putting the device into an
> > error state and re-injecting the interrupt should cause the perf session in
> > the guest to fail gracefully. I don't think the complexity is necessarily
> > worth it, but pinning all of guest memory is really crap so it's worth
> > thinking about alternatives.
> 
> On the subject of pinning the memory when guest enables SPE, the guest can
> configure SPE to profile userspace only. Programming is done at EL1, and in
> this case SPE is disabled. KVM doesn't trap the ERET to EL0, so the only
> sensible thing to do here is to pin the memory when SPE is disabled. If it
> fails, then how should KVM notify the guest that something went wrong when
> SPE is disabled? KVM could inject an interrupt, as those are asynchronous
> and one could (rather weakly) argue that the interrupt might have been
> raised because of something that happened in the previous profiling
> session, but what if the guest never enabled SPE? What if the guest is in
> the middle of configuring SPE and the interrupt handler isn't even set? Or
> should KVM not use an interrupt to report error conditions to the guest, in
> which case, how can the guest detect that SPE is stopped?

Come to think of it, KVM can defer injecting the interrupt until after an
exit from the guest when the guest was executing at EL0 (and profiling
would have been enabled from the guest's point of view). I think this
should work, as a delay between the condition that causes an interrupt and
the PE taking the said interrupt is expected.

Thoughts?

I too would prefer not to have to pin the entire VM memory, and asking from
userspace to increase max locked memory to the size of the VM memory looks
a lot better to me.

Thanks,
Alex

> 
> Both options don't look particularly appealing to me.
> 
> Thanks,
> Alex
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
