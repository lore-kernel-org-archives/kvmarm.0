Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC83C46467
	for <kvmarm@archiver.kernel.org>; Wed,  4 Jan 2023 09:19:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C304B9A6;
	Wed,  4 Jan 2023 04:19:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5JVU8weFqyxL; Wed,  4 Jan 2023 04:19:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C37444B9C0;
	Wed,  4 Jan 2023 04:19:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85CDA4B9C0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Jan 2023 04:19:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W1kSd7YnFOKW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Jan 2023 04:19:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86B654BA28
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Jan 2023 04:19:37 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8AEF1063;
 Wed,  4 Jan 2023 01:20:18 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.37.146])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E6B53F71A;
 Wed,  4 Jan 2023 01:19:35 -0800 (PST)
Date: Wed, 4 Jan 2023 09:19:25 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: KVM: arm64: A new approach for SPE support
Message-ID: <Y7VEkaSf4LXCnMBI@FVFF77S0Q05N>
References: <Y34GvXY/xMpev39K@monolith.localdoman>
 <Y7Q7b7+BKKBajIo2@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y7Q7b7+BKKBajIo2@monolith.localdoman>
Cc: maz@kernel.org, kvmarm@lists.linux.dev, will@kernel.org,
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

On Tue, Jan 03, 2023 at 02:27:59PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> Gentle ping regarding this.

Hi Alexandru,

Sorry for the delay; things were a bit hectic at the end of last year, and this
is still on my queue of things to look at.

> Thanks,
> Alex
> 
> On Wed, Nov 23, 2022 at 11:40:45AM +0000, Alexandru Elisei wrote:
> > The previous discussion about how best to add SPE support to KVM [1] is
> > heading in the direction of pinning at EL2 only the buffer, when the guest
> > enables profiling, instead of pinning the entire VM memory. Although better
> > than pinning the entire VM at EL2, it still has some disadvantages:
> > 
> > 1. Pinning memory at stage 2 goes against the design principle of secondary
> > MMUs, which must reflect all changes in the primary (host's stage 1) page
> > tables. This means a mechanism by which to pin VM memory at stage 2 must be
> > created from scratch just for SPE. Although I haven't done this yet, I'm a
> > bit concerned that this will turn out to be fragile and/or complicated.
> > 
> > 2. The architecture allows software to change the VA to IPA translations
> > for the profiling buffer when the buffer is enabled if profiling is
> > disabled (the buffer is enabled, but sampling is disabled). Since SPE can
> > be programmed to profile EL0 only, and there is no easy way for KVM to trap
> > the exact moment when profiling becomes enabled in this scenario to
> > translate the buffer's guest VAs to IPA, to pin the IPAs at stage 2, it is
> > required for KVM impose limitations on how a guest uses SPE for emulation
> > to work.
> > 
> > I've prototyped a new approach [2] which eliminates both disadvantages, but
> > comes with its own set of drawbacks. The approach I've been working on is
> > to have KVM allocate a buffer in the kernel address space to profile the
> > guest, and when the buffer becomes full (or profiling is disabled for other
> > reasons), to copy the contents of the buffer to guest memory.

This sounds neat!

I have a few comments below, I'll try to take a more in-depth look shortly.

> > I'll start with the advantages:
> > 
> > 1. No memory pinning at stage 2.
> > 
> > 2. No meaningful restrictions on how the guest programs SPE, since the
> > translation of the guest VAs to IPAs is done by KVM when profiling has been
> > completed.
> > 
> > 3. Neoverse N1 errata 1978083 ("Incorrect programming of PMBPTR_EL1 might
> > result in a deadlock") [6] is handled without any extra work.
> > 
> > As I see it, there are two main disadvantages:
> > 
> > 1. The contents of the KVM buffer must be copied to the guest. In the
> > prototype this is done all at once, when profiling is stopped [3].
> > Presumably this can be amortized by unmapping the pages corresponding to
> > the guest buffer from stage 2 (or marking them as invalid) and copying the
> > data when the guest reads from those pages. Needs investigating.

I don't think we need to mess with the translation tables here; for a guest to
look at the buffer it's going to have to look at PMBPTR_EL1 (and a guest could
poll that and issue barriers without ever stopping SPE), so we could also force
writebacks when the guest reads PMBPTR_EL1.

> > 2. When KVM profiles the guest, the KVM buffer owning exception level must
> > necessarily be EL2. This means that while profiling is happening,
> > PMBIDR_EL1.P = 1 (programming of the buffer is not allowed). PMBIDR_EL1
> > cannot be trapped without FEAT_FGT, so a guest that reads the register
> > after profiling becomes enabled will read the P bit as 1. I cannot think of
> > any valid reason for a guest to look at the bit after enabling profiling.
> > With FEAT_FGT, KVM would be able to trap accesses to the register.

This is unfortunate. :/

I agree it's unlikely the a guest would look at this, but I could imagine some
OSs doing this as a sanity-check, since they never expect this to change, and
if it suddenly becomes 1 they might treat this as an error.

Can we require FGT for guest SPE usage?

> > 3. In the worst case scenario, when the entire VM memory is mapped in the
> > host, this approach consumes more memory because the memory for the buffer
> > is separate from the memory allocated to the VM. On the plus side, there
> > will always be less memory pinned in the host for the VM process, since
> > only the buffer has to be pinned, instead of the buffer plus the guest's
> > stage 1 translation tables (to avoid SPE encountering a stage 2 fault on a
> > stage 1 translation table walk). Could be mitigated by providing an ioctl
> > to userspace to set the maximum size for the buffer.

It's a shame we don't have a mechanism to raise an interrupt prior to the SPE
buffer becoming full, or we could force a writeback each time we hit a
watermark.

I suspect having a maximum size set ahead of time (and pre-allocating the
buffer?) is the right thing to do. As long as it's set to a reasonably large
value we can treat filling the buffer as a collision.

> > I prefer this new approach instead of pinning the buffer at stage 2. It is
> > straightforward, less fragile and doesn't limit how a guest can program
> > SPE.

Likewise, aside from the PMBIDR_EL1.P issue, this sounds very nice to me!

Thanks,
Mark.

> > As for the prototype, I wrote it as a quick way to check if this approach
> > is viable. Does not have SPE support for the nVHE case because I would have
> > had to figure out how to map a continuous VA range in the EL2's translation
> > tables; supporting only the VHE case was a lot easier.  The prototype
> > doesn't have a stage 1 walker, so it's limited to guests that use id-mapped
> > addresses from TTBR0_EL1 for the buffer (although it would be trivial to
> > modify it to accept addresses from TTBR1_EL1) - I've used kvm-unit-tests
> > for testing [4]. I've tested the prototype on the model and on an Ampere
> > Altra.
> > 
> > For those interested, kvmtool support to run the prototype has also been
> > added [5] (add --spe to the command line to run a VM).
> > 
> > [1] https://lore.kernel.org/all/Yl6+JWaP+mq2Nc0b@monolith.localdoman/
> > [2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v6-copy-buffer-wip4-without-nvhe
> > [3] https://gitlab.arm.com/linux-arm/linux-ae/-/blob/kvm-spe-v6-copy-buffer-wip4-without-nvhe/arch/arm64/kvm/spe.c#L197
> > [4] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/kvm-spe-v6-copy-buffer-wip4
> > [5] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v6-copy-buffer-wip4
> > [6] https://developer.arm.com/documentation/SDEN885747/latest
> > 
> > Thanks,
> > Alex
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
