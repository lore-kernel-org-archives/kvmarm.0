Return-Path: <SRS0=SY/6=AE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51E7C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jun 2020 17:48:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 559CF20774
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jun 2020 17:48:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 559CF20774
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F02DA4B157;
	Tue, 23 Jun 2020 13:48:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e1so9NJbIYfB; Tue, 23 Jun 2020 13:48:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DE2B4B15A;
	Tue, 23 Jun 2020 13:48:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD1494B158
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2020 13:48:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lvJoahFM4Gqx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jun 2020 13:48:13 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C3114B157
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2020 13:48:13 -0400 (EDT)
Received: from gaia (unknown [2.26.170.173])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3E85D206D4;
 Tue, 23 Jun 2020 17:48:10 +0000 (UTC)
Date: Tue, 23 Jun 2020 18:48:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [RFC PATCH 0/2] MTE support for KVM guest
Message-ID: <20200623174807.GD5180@gaia>
References: <20200617123844.29960-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200617123844.29960-1-steven.price@arm.com>
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

Hi Steven,

On Wed, Jun 17, 2020 at 01:38:42PM +0100, Steven Price wrote:
> These patches add support to KVM to enable MTE within a guest. It is
> based on Catalin's v4 MTE user space series[1].
> 
> [1] http://lkml.kernel.org/r/20200515171612.1020-1-catalin.marinas%40arm.com
> 
> Posting as an RFC as I'd like feedback on the approach taken. First a
> little background on how MTE fits within the architecture:
> 
> The stage 2 page tables have limited scope for controlling the
> availability of MTE. If a page is mapped as Normal and cached in stage 2
> then it's the stage 1 tables that get to choose whether the memory is
> tagged or not. So the only way of forbidding tags on a page from the
> hypervisor is to change the cacheability (or make it device memory)
> which would cause other problems.  Note this restriction fits the
> intention that a system should have all (general purpose) memory
> supporting tags if it support MTE, so it's not too surprising.
> 
> However, the upshot of this is that to enable MTE within a guest all
> pages of memory mapped into the guest as normal cached pages in stage 2
> *must* support MTE (i.e. we must ensure the tags are appropriately
> sanitised and save/restore the tags during swap etc).
> 
> My current approach is that KVM transparently upgrades any pages
> provided by the VMM to be tag-enabled when they are faulted in (i.e.
> sets the PG_mte_tagged flag on the page) which has the benefit of
> requiring fewer changes in the VMM. However, save/restore of the VM
> state still requires the VMM to have a PROT_MTE enabled mapping so that
> it can access the tag values. A VMM which 'forgets' to enable PROT_MTE
> would lose the tag values when saving/restoring (tags are RAZ/WI when
> PROT_MTE isn't set).
> 
> An alternative approach would be to enforce the VMM provides PROT_MTE
> memory in the first place. This seems appealing to prevent the above
> potentially unexpected gotchas with save/restore, however this would
> also extend to memory that you might not expect to have PROT_MTE (e.g. a
> shared frame buffer for an emulated graphics card). 

As you mentioned above, if memory is mapped as Normal Cacheable at Stage
2 (whether we use FWB or not), the guest is allowed to turn MTE on via
Stage 1. There is no way for KVM to prevent a guest from using MTE other
than the big HCR_EL2.ATA knob.

This causes potential issues since we can't guarantee that all the
Cacheable memory slots allocated by the VMM support MTE. If they do not,
the arch behaviour is "unpredictable". We also can't trust the guest to
not enable MTE on such Cacheable mappings.

On the host kernel, mmap'ing with PROT_MTE is only allowed for anonymous
mappings and shmem. So requiring the VMM to always pass PROT_MTE mapped
ranges to KVM, irrespective of whether it's guest RAM, emulated device,
virtio etc. (as long as they are Cacheable), filters unsafe ranges that
may be mapped into guest.

Note that in the next revision of the MTE patches I'll drop the DT
memory nodes checking and rely only on the CPUID information (arch
updated promised by the architects).

I see two possible ways to handle this (there may be more):

1. As in your current patches, assume any Cacheable at Stage 2 can have
   MTE enabled at Stage 1. In addition, we need to check whether the
   physical memory supports MTE and it could be something simple like
   pfn_valid(). Is there a way to reject a memory slot passed by the
   VMM?

2. Similar to 1 but instead of checking whether the pfn supports MTE, we
   require the VMM to only pass PROT_MTE ranges (filtering already done
   by the host kernel). We need a way to reject the slot and return an
   error to the VMM.

I think rejecting a slot at the Stage 2 fault time is very late. You
probably won't be able to do much other than killing the guest.

Both 1 and 2 above risk breaking existing VMMs just because they happen
to start on an MTE-capable machine. So, can we also require the VMM to
explicitly opt in to MTE support in guests via some ioctl()? This in
turn would enable the additional checks in KVM for the MTE capability of
the memory slots (1 or 2 above).

An alternative to an MTE enable ioctl(), if all the memory slots are set
up prior to the VM starting, KVM could check 1 or 2 above and decide
whether to expose MTE to guests (HCR_EL2.ATA).

More questions than solutions above, mostly for the KVM and Qemu
maintainers.

Thanks.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
