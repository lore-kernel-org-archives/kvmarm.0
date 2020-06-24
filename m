Return-Path: <SRS0=cLfN=AF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BF4C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jun 2020 16:25:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 752E120A8B
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jun 2020 16:25:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 752E120A8B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF7A44B2C7;
	Wed, 24 Jun 2020 12:24:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZxVHmmLS3L0q; Wed, 24 Jun 2020 12:24:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA0D4B24A;
	Wed, 24 Jun 2020 12:24:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1B334B13B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2020 12:24:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zcoIchBp6Sdd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2020 12:24:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4894B4B13A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2020 12:24:56 -0400 (EDT)
Received: from gaia (unknown [2.26.170.173])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0E43220857;
 Wed, 24 Jun 2020 16:24:52 +0000 (UTC)
Date: Wed, 24 Jun 2020 17:24:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [RFC PATCH 0/2] MTE support for KVM guest
Message-ID: <20200624161954.GC27945@gaia>
References: <20200617123844.29960-1-steven.price@arm.com>
 <20200623174807.GD5180@gaia>
 <e04696b6-63de-1e25-f6f3-1da63f791754@arm.com>
 <20200624142131.GA27945@gaia>
 <66ed0732-17ee-8f5a-44af-31ab768d845f@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <66ed0732-17ee-8f5a-44af-31ab768d845f@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
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

On Wed, Jun 24, 2020 at 03:59:35PM +0100, Steven Price wrote:
> On 24/06/2020 15:21, Catalin Marinas wrote:
> > On Wed, Jun 24, 2020 at 12:16:28PM +0100, Steven Price wrote:
> > > On 23/06/2020 18:48, Catalin Marinas wrote:
> > > > On Wed, Jun 17, 2020 at 01:38:42PM +0100, Steven Price wrote:
> > > > > These patches add support to KVM to enable MTE within a guest. It is
> > > > > based on Catalin's v4 MTE user space series[1].
> > > > > 
> > > > > [1] http://lkml.kernel.org/r/20200515171612.1020-1-catalin.marinas%40arm.com
> > > > > 
> > > > > Posting as an RFC as I'd like feedback on the approach taken. First a
> > > > > little background on how MTE fits within the architecture:
> > > > > 
> > > > > The stage 2 page tables have limited scope for controlling the
> > > > > availability of MTE. If a page is mapped as Normal and cached in stage 2
> > > > > then it's the stage 1 tables that get to choose whether the memory is
> > > > > tagged or not. So the only way of forbidding tags on a page from the
> > > > > hypervisor is to change the cacheability (or make it device memory)
> > > > > which would cause other problems.  Note this restriction fits the
> > > > > intention that a system should have all (general purpose) memory
> > > > > supporting tags if it support MTE, so it's not too surprising.
> > > > > 
> > > > > However, the upshot of this is that to enable MTE within a guest all
> > > > > pages of memory mapped into the guest as normal cached pages in stage 2
> > > > > *must* support MTE (i.e. we must ensure the tags are appropriately
> > > > > sanitised and save/restore the tags during swap etc).
> > > > > 
> > > > > My current approach is that KVM transparently upgrades any pages
> > > > > provided by the VMM to be tag-enabled when they are faulted in (i.e.
> > > > > sets the PG_mte_tagged flag on the page) which has the benefit of
> > > > > requiring fewer changes in the VMM. However, save/restore of the VM
> > > > > state still requires the VMM to have a PROT_MTE enabled mapping so that
> > > > > it can access the tag values. A VMM which 'forgets' to enable PROT_MTE
> > > > > would lose the tag values when saving/restoring (tags are RAZ/WI when
> > > > > PROT_MTE isn't set).
> > > > > 
> > > > > An alternative approach would be to enforce the VMM provides PROT_MTE
> > > > > memory in the first place. This seems appealing to prevent the above
> > > > > potentially unexpected gotchas with save/restore, however this would
> > > > > also extend to memory that you might not expect to have PROT_MTE (e.g. a
> > > > > shared frame buffer for an emulated graphics card).
> > > > 
> > > > As you mentioned above, if memory is mapped as Normal Cacheable at Stage
> > > > 2 (whether we use FWB or not), the guest is allowed to turn MTE on via
> > > > Stage 1. There is no way for KVM to prevent a guest from using MTE other
> > > > than the big HCR_EL2.ATA knob.
> > > > 
> > > > This causes potential issues since we can't guarantee that all the
> > > > Cacheable memory slots allocated by the VMM support MTE. If they do not,
> > > > the arch behaviour is "unpredictable". We also can't trust the guest to
> > > > not enable MTE on such Cacheable mappings.
> > > 
> > > Architecturally it seems dodgy to export any address that isn't "normal
> > > memory" (i.e. with tag storage) to the guest as Normal Cacheable. Although
> > > I'm a bit worried this might cause a regression in some existing case.
> > 
> > What I had in mind is some persistent memory that may be given to the
> > guest for direct access. This is allowed to be cacheable (write-back)
> > but may not have tag storage.
> 
> At the moment we don't have a good idea what would happen if/when the guest
> (or host) attempts to use that memory as tagged. If we have a relatively
> safe hardware behaviour (e.g. the tags are silently dropped/read-as-zero)
> then that's not a big issue. But if the accesses cause some form of abort
> then we need to understand how that would be handled.

The architecture is not prescriptive here, the behaviour is
"unpredictable". It could mean tags read-as-zero/write-ignored or an
SError.

> > > > 1. As in your current patches, assume any Cacheable at Stage 2 can have
> > > >      MTE enabled at Stage 1. In addition, we need to check whether the
> > > >      physical memory supports MTE and it could be something simple like
> > > >      pfn_valid(). Is there a way to reject a memory slot passed by the
> > > >      VMM?
> > > 
> > > Yes pfn_valid() should have been in there. At the moment pfn_to_page() is
> > > called without any checks.
> > > 
> > > The problem with attempting to reject a memory slot is that the memory
> > > backing that slot can change. So checking at the time the slot is created
> > > isn't enough (although it might be a useful error checking feature).
> > 
> > But isn't the slot changed as a result of another VMM call? So we could
> > always have such check in place.
> 
> Once you have created a memslot the guest's view of memory follows the user
> space's address space. This is the KVM_CAP_SYNC_MMU capability. So there's
> nothing stopping a VMM adding a memslot backed with perfectly reasonable
> memory then mmap()ing over the top of it some memory which isn't MTE
> compatible. KVM gets told the memory is being removed (via mmu notifiers)
> but I think it waits for the next fault before (re)creating the stage 2
> entries.

OK, so that's where we could kill the guest if the VMM doesn't play
nicely. It means that we need the check when setting up the stage 2
entry. I guess it's fine if we only have the check at that point and
ignore it on KVM_SET_USER_MEMORY_REGION. It would be nice if we returned
on error on slot setup but we may not know (yet) whether the VMM intends
to enable MTE for the guest.

> > > It's not clear to me what we can do at fault time when we discover the
> > > memory isn't tag-capable and would have been mapped cacheable other than
> > > kill the VM.
> > 
> > Indeed, I don't have a better idea other than trying not to get in this
> > situation.
> 
> Sadly to me it looks like it's not really possible to avoid a (malicious)
> VMM getting us there. But we can certainly try to avoid a VMM accidentally
> ending up in the situation.

What we need to avoid is a malicious VMM affecting the host kernel. If
the VMM wants to corrupt the guest, I think it has other ways already
even without MTE.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
