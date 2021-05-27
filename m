Return-Path: <SRS0=LQ+R=KW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B261BC4707F
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 13:09:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 30EEC613AC
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 13:09:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30EEC613AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABC62409DD;
	Thu, 27 May 2021 09:09:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3KvuCIG-mrlV; Thu, 27 May 2021 09:08:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B32B249E50;
	Thu, 27 May 2021 09:08:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30C2740CF9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 09:08:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mbis-+GT1nva for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 May 2021 09:08:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E092A409DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 09:08:54 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 107246128B;
 Thu, 27 May 2021 13:08:50 +0000 (UTC)
Date: Thu, 27 May 2021 14:08:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v12 7/8] KVM: arm64: ioctl to fetch/store tags in a guest
Message-ID: <20210527130848.GA8661@arm.com>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-8-steven.price@arm.com>
 <20210520120556.GC12251@arm.com>
 <dd5ab3a0-5a74-b145-2485-d6d871be945b@arm.com>
 <20210520172713.GF12251@arm.com>
 <5eec330f-63c0-2af8-70f8-ba9b643e2558@arm.com>
 <20210524181129.GI14645@arm.com>
 <58345eca-6e5f-0faa-e47d-e9149d73f6c5@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <58345eca-6e5f-0faa-e47d-e9149d73f6c5@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
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

On Thu, May 27, 2021 at 08:50:30AM +0100, Steven Price wrote:
> On 24/05/2021 19:11, Catalin Marinas wrote:
> > I had some (random) thoughts on how to make things simpler, maybe. I
> > think most of these races would have been solved if we required PROT_MTE
> > in the VMM but this has an impact on the VMM if it wants to use MTE
> > itself. If such requirement was in place, all KVM needed to do is check
> > PG_mte_tagged.
> > 
> > So what we actually need is a set_pte_at() in the VMM to clear the tags
> > and set PG_mte_tagged. Currently, we only do this if the memory type is
> > tagged (PROT_MTE) but it's not strictly necessary.
> > 
> > As an optimisation for normal programs, we don't want to do this all the
> > time but the visible behaviour wouldn't change (well, maybe for ptrace
> > slightly). However, it doesn't mean we couldn't for a VMM, with an
> > opt-in via prctl(). This would add a MMCF_MTE_TAG_INIT bit (couldn't
> > think of a better name) to mm_context_t.flags and set_pte_at() would
> > behave as if the pte was tagged without actually mapping the memory in
> > user space as tagged (protection flags not changed). Pages that don't
> > support tagging are still safe, just some unnecessary ignored tag
> > writes. This would need to be set before the mmap() for the guest
> > memory.
> > 
> > If we want finer-grained control we'd have to store this information in
> > the vma flags, in addition to VM_MTE (e.g. VM_MTE_TAG_INIT) but without
> > affecting the actual memory type. The easiest would be another pte bit,
> > though we are short on them. A more intrusive (not too bad) approach is
> > to introduce a set_pte_at_vma() and read the flags directly in the arch
> > code. In most places where set_pte_at() is called on a user mm, the vma
> > is also available.
> > 
> > Anyway, I'm not saying we go this route, just thinking out loud, get
> > some opinions.
> 
> Does get_user_pages() actually end up calling set_pte_at() normally?

Not always, at least as how it's called from hva_to_pfn(). My reading of
the get_user_page_fast_only() is that it doesn't touch the pte, just
walks the page tables and pins the page. Of course, it expects a valid
pte to have been set in the VMM already, otherwise it doesn't pin any
page and the caller falls back to the slow path.

The slow path, get_user_pages_unlocked(), passes FOLL_TOUCH and
set_pte_at() will be called either in follow_pfn_pte() if it was valid
or via faultin_page() -> handle_mm_fault().

> If not then on the normal user_mem_abort() route although we can
> easily check VM_MTE_TAG_INIT there's no obvious place to hook in to
> ensure that the pages actually allocated have the PG_mte_tagged flag.

I don't think it helps if we checked such vma flag in user_mem_abort(),
we'd still have the race with set_pte_at() on the page flags. What I was
trying to avoid is touching the page flags in too many places, so
deferring this always to set_pte_at() in the VMM.

> I'm also not sure how well this would work with the MMU notifiers path
> in KVM. With MMU notifiers (i.e. the VMM replacing a page in the
> memslot) there's not even an obvious hook to enforce the VMA flag. So I
> think we'd end up with something like the sanitise_mte_tags() function
> to at least check that the PG_mte_tagged flag is set on the pages
> (assuming that the trigger for the MMU notifier has done the
> corresponding set_pte_at()). Admittedly this might close the current
> race documented there.

If we kept this check to the VMM set_pte_at(), I think we can ignore the
notifiers.

> It also feels wrong to me to tie this to a process with prctl(), it
> seems much more normal to implement this as a new mprotect() flag as
> this is really a memory property not a process property. And I think
> we'll find some scary corner cases if we try to associate everything
> back to a process - although I can't instantly think of anything that
> will actually break.

I agree, tying it to the process looks wrong, only that it's less
intrusive. I don't think it would break anything, only potential
performance regression. A process would still need to pass PROT_MTE to
be able to get tag checking. That's basically what I had in an early MTE
implementation with clear_user_page() always zeroing the tags.

I agree with you that a vma flag would be better but it's more
complicated without an additional pte bit. We could also miss some
updates as mprotect() for example checks for pte_same() before calling
set_pte_at() (it would need to check the updated vma flags).

I'll review the latest series but I'm tempted to move the logic in
santise_mte_tags() to mte.c and take the big lock in there if
PG_mte_tagged is not already set. If we hit performance issues, we can
optimise this later to have the page flag set already on creation (new
PROT flag, prctl etc.).

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
