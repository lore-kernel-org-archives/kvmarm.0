Return-Path: <SRS0=w4A1=J6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E6BC433ED
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 16:22:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 82CC561166
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 16:21:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82CC561166
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E072D4B3E8;
	Mon,  3 May 2021 12:21:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0Y1pC4agKQTO; Mon,  3 May 2021 12:21:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CD934B415;
	Mon,  3 May 2021 12:21:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09AC14B24A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 09:35:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8i2WietCRpTn for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 May 2021 09:35:28 -0400 (EDT)
Received: from sibelius.xs4all.nl (sibelius.xs4all.nl [83.163.83.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 886A54B249
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 09:35:28 -0400 (EDT)
Received: from localhost (bloch.sibelius.xs4all.nl [local])
 by bloch.sibelius.xs4all.nl (OpenSMTPD) with ESMTPA id 06eed435;
 Mon, 3 May 2021 15:35:25 +0200 (CEST)
Date: Mon, 3 May 2021 15:35:25 +0200 (CEST)
From: Mark Kettenis <mark.kettenis@xs4all.nl>
To: Marc Zyngier <maz@kernel.org>
In-Reply-To: <87bl9sunnw.wl-maz@kernel.org> (message from Marc Zyngier on Mon, 
 03 May 2021 11:17:23 +0100)
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
 <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
 <87czucngdc.wl-maz@kernel.org>
 <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
 <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
 <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87bl9sunnw.wl-maz@kernel.org>
Message-ID: <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
X-Mailman-Approved-At: Mon, 03 May 2021 12:21:55 -0400
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 sdonthineni@nvidia.com, vsethi@nvidia.com, alex.williamson@redhat.com,
 jsequeira@nvidia.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

> Date: Mon, 03 May 2021 11:17:23 +0100
> From: Marc Zyngier <maz@kernel.org>
> 
> Hi Vikram,
> 
> On Sun, 02 May 2021 18:56:31 +0100,
> Vikram Sethi <vsethi@nvidia.com> wrote:
> > 
> > Hi Marc, 
> > 
> > > From: Marc Zyngier <maz@kernel.org>
> > > Hi Vikram,
> > > 
> >  
> > > The problem I see is that we have VM and userspace being written in terms
> > > of Write-Combine, which is:
> > > 
> > > - loosely defined even on x86
> > > 
> > > - subject to interpretations in the way it maps to PCI
> > > 
> > > - has no direct equivalent in the ARMv8 collection of memory
> > >   attributes (and Normal_NC comes with speculation capabilities which
> > >   strikes me as extremely undesirable on arbitrary devices)
> > 
> > If speculation with Normal NC to prefetchable BARs in devices was a
> > problem, those devices would already be broken in baremetal with
> > ioremap_wc on arm64, and we would need quirks there to not do Normal
> > NC for them but Device GRE, and if such a quirk was needed on
> > baremetal, it could be picked up by vfio/KVM as well. But we haven't
> > seen any broken devices doing wc on baremetal on ARM64, have we?

I think the SC2A11 SoC used in the Socionext developerbox counts as
"broken":

https://www.96boards.org/documentation/enterprise/developerbox/support/known-issues.html

I'm not sure my understanding of the issue is 100% correct, but I
believe the firmware workaround described there uses the stage 2
translation tables to map "Normal NC" onto "Device nGRE" or something
even more restricted.  Now this hardware may be classified as simply
broken.  However...

On hardware based on the NXP LX2160A SoC we're seeing some weird
behaviour when using "Normal NC" mappings with an AMD GPU that
disappear by using "Device nGnRnE" mappings on OpenBSD.  No such issue
was observed with hardware based on an Ampere eMAG SoC.  I don't fully
understand this issue yet, and it may very well be a bug in OpenBSD
code, but it does show there are potential pitfalls with using "Normal
NC" for mapping prefetchable BARs of PCIe devices.

> The lack of evidence does not equate to a proof, and your devices not
> misbehaving doesn't mean it is the right thing, specially when we have
> such a wide range of CPU and interconnect implementation. Which is why
> I really want an answer at the architecture level. Not a "it works for
> me" type of answer.
> 
> Furthermore, as I replied to Shanker in a separate email, what
> Linux/arm64 does is pretty much irrelevant. KVM/arm64 implements the
> ARMv8 architecture, and it is at that level that we need to solve the
> problem.
> 
> If, by enumerating the properties of Prefetchable, you can show that
> they are a strict superset of Normal_NC, I'm on board. I haven't seen
> such an enumeration so far.
> 
> > I know we have tested NICs write combining on arm64 in baremetal, as
> > well as GPU and NVMe CMB without issues.
> > 
> > Further, I don't see why speculation to non cacheble would be an
> > issue if prefetch without side effects is allowed by the device,
> > which is what a prefetchable BAR is.
> > If it is an issue for a device I would consider that a bug already needing a quirk in
> > Baremetal/host kernel already. 
> > From PCI spec " A prefetchable address range may have write side effects, 
> > but it may not have read side effects."
> 
> Right, so we have made a small step in the direction of mapping
> "prefetchable" onto "Normal_NC", thanks for that. What about all the
> other properties (unaligned accesses, ordering, gathering)?

On x86 WC:

1. Is not cached (but stores are buffered).

2. Allows unaligned access just like normal memory.

3. Allows speculative reads.

4. Has weaker ordering than normal memory; [lsm]fence instructions are
   needed to guarantee a particular ordering of writes with respect to
   other writes and reads.

5. Stores are buffered.  This buffer isn't snooped so it has to be
   flushed before changes are globally visible.  The [sm]fence
   instructions flush the store buffer.

6. The store buffer may combine multiple writes into a single write.

Now whether the fact the unaligned access is allowed is really part of
the semantics of WC mappings is debatable as x86 always allows
unaligned access, even for areas mapped with ioremap().

However, this is where userland comes in.  The userland graphics stack
does assume that graphics memory mapped throug a prefetchable PCIe BAR
allows unaligned access if the architecture allows unaligned access
for cacheable memory.  On arm64 this means that such memory needs to
be "Normal NC".  And since kernel drivers tend to map such memory
using ioremap_wc() that pretty much implies ioremap_wc() shoul use
"Normal NC" as well isn't it?

> > > How do we translate this into something consistent? I'd like to
> > > see an actual description of what we *really* expect from WC on
> > > prefetchable PCI regions, turn that into a documented definition
> > > agreed across architectures, and then we can look at
> > > implementing it with one memory type or another on arm64.
> > > 
> > > Because once we expose that memory type at S2 for KVM guests, it
> > > becomes ABI and there is no turning back. So I want to get it
> > > right once and for all.
> > > 
> > I agree that we need a precise definition for the Linux ioremap_wc
> > API wrt what drivers (kernel and userspace) can expect and whether
> > memset/memcpy is expected to work or not and whether aligned
> > accesses are a requirement.
> > To the extent ABI is set, I would think that the ABI is also already
> > set in the host kernel for arm64 WC = Normal NC, so why should that
> > not also be the ABI for same driver in VMs.
> 
> KVM is an implementation of the ARM architecture, and doesn't really
> care about what WC is. If we come to the conclusion that Normal_NC is
> the natural match for Prefetchable attributes, than we're good and we
> can have Normal_NC being set by userspace, or even VFIO. But I don't
> want to set it only because "it works when bare-metal Linux uses it".
> Remember KVM doesn't only run Linux as guests.
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
