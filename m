Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A70C04A68
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 10:18:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B88834C2D2;
	Wed, 27 Jul 2022 06:18:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z6dZdUTGxnKd; Wed, 27 Jul 2022 06:18:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA2864C20A;
	Wed, 27 Jul 2022 06:18:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8645B4C088
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 06:18:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rxAShELFIwO5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 06:18:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 809424BFD0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 06:18:50 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 471BFD6E;
 Wed, 27 Jul 2022 03:18:50 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD7473F70D;
 Wed, 27 Jul 2022 03:18:48 -0700 (PDT)
Date: Wed, 27 Jul 2022 11:19:20 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <YuERKEjJh1qsZf8x@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman>
 <YuApmZFdZzTi5ROu@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YuApmZFdZzTi5ROu@google.com>
Cc: maz@kernel.org, Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Oliver,

Thank you for the help, replies below.

On Tue, Jul 26, 2022 at 10:51:21AM -0700, Oliver Upton wrote:
> Hi Alex,
> 
> On Mon, Jul 25, 2022 at 11:06:24AM +0100, Alexandru Elisei wrote:
> 
> [...]
> 
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
> > 4. Guest does an ERET to EL0, thus enabling profiling.
> > 
> > Since KVM cannot trap the ERET to EL0, it will be impossible for KVM to pin
> > the buffer at stage 2 when profiling gets enabled at EL0.
> 
> Not saying we necessarily should, but this is possible with FGT no?

It doesn't look to me like FEAT_FGT offers any knobs to trap ERET from EL1.
Unless there's no other way, I would prefer not to have the emulation of one
feature depend on the presence of another feature,

> 
> > I can see two solutions here:
> > 
> > a. Accept the limitation (and advertise it in the documentation) that if
> > someone wants to use SPE when running as a Linux guest, the kernel used by
> > the guest must not change the buffer translation table entries after the
> > buffer has been enabled (PMBLIMITR_EL1.E = 1). Linux already does that, so
> > running a Linux guest should not be a problem. I don't know how other OSes
> > do it (but I can find out). We could also phrase it that the buffer
> > translation table entries can be changed after enabling the buffer, but
> > only if profiling happens at EL1. But that sounds very arbitrary.
> > 
> > b. Pin the buffer after the stage 2 DABT that SPE will report in the
> > situation above. This means that there is a blackout window, but will
> > happen only once after each time the guest reprograms the buffer. I don't
> > know if this is acceptable. We could say that this if this blackout window
> > is not acceptable, then the guest kernel shouldn't change the translation
> > table entries after enabling the buffer.
> > 
> > Or drop the approach of pinning the buffer and go back to pinning the
> > entire memory of the VM.
> > 
> > Any thoughts on this? I would very much prefer to try to pin only the
> > buffer.
> 
> Doesn't pinning the buffer also imply pinning the stage 1 tables
> responsible for its translation as well? I agree that pinning the buffer

See my reply [1] to a question someone asked in an earlier iteration of the
pKVM series. My conclusion is that it's impossible to stop the
invalidate_range_start() MMU notifiers from being invoked for pinned pages.
But I believe that can be circumvented passing the enum mmu_notifier_event
event field to the arm64 KVM code and use that to decide to do the
unmapping or not. I am still investigating that, but it looks promising.

[1] https://lore.kernel.org/all/YuEMkKY2RU%2F2KiZW@monolith.localdoman/

> is likely the best way forward as pinning the whole of guest memory is
> entirely impractical.

I would say it's undesirable, not impractical. Like Marc said, vfio already
pins the entire guest memory with the VFIO_IOMMMU_MAP_DMA ioctl. The
difference there is that the SMMU tables are unmapped via the explicit
ioctl VFIO_IOMMU_UNMAP_DMA; the SMMU doesn't use the MMU notifiers to keep
in sync with host's stage 1 like KVM does.

> 
> I'm also a bit confused on how we would manage to un-pin memory on the
> way out with this. The guest is free to muck with the stage 1 and could
> cause the SPU to spew a bunch of stage 2 aborts if it wanted to be
> annoying. One way to tackle it would be to only allow a single
> root-to-target walk to be pinned by a vCPU at a time. Any time a new
> stage 2 abort comes from the SPU, we un-pin the old walk and pin the new
> one instead.
> 
> Live migration also throws a wrench in this. IOW, there are still potential
> sources of blackout unattributable to guest manipulation of the SPU.

I have a proposal to handle [2] that, if you want to have a look.
Basically, userspace tells KVM to never allow the guest to start profiling.
That means a possibly huge blackout window while the guest is being
migrated, but I don't see any better solutions.

[2] https://lore.kernel.org/all/20211117153842.302159-35-alexandru.elisei@arm.com/

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
