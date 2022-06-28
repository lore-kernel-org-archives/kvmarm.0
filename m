Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2C5C43334
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jun 2022 17:58:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FA804B431;
	Tue, 28 Jun 2022 13:58:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TT1gy6tgprw9; Tue, 28 Jun 2022 13:58:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08CA04B47E;
	Tue, 28 Jun 2022 13:58:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FBFB4B431
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2022 13:58:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZqFqoEJKXVhj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2022 13:58:02 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EC504B21A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2022 13:58:01 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 136D161A01;
 Tue, 28 Jun 2022 17:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F616C3411D;
 Tue, 28 Jun 2022 17:57:57 +0000 (UTC)
Date: Tue, 28 Jun 2022 18:57:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Message-ID: <YrtBIX0/0jyAdgnz@arm.com>
References: <20220623234944.141869-1-pcc@google.com> <YrXu0Uzi73pUDwye@arm.com>
 <CAMn1gO7-qVzZrAt63BJC-M8gKLw4=60iVUo6Eu8T_5y3AZnKcA@mail.gmail.com>
 <YrmXzHXv4babwbNZ@arm.com>
 <CAMn1gO5s2m-AkoYpY0dcLkKVyEAGeC2borZfgT09iqc=w_LZxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMn1gO5s2m-AkoYpY0dcLkKVyEAGeC2borZfgT09iqc=w_LZxQ@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andy Lutomirski <luto@amacapital.net>, Evgenii Stepanov <eugenis@google.com>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Mon, Jun 27, 2022 at 11:16:17AM -0700, Peter Collingbourne wrote:
> On Mon, Jun 27, 2022 at 4:43 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Fri, Jun 24, 2022 at 02:50:53PM -0700, Peter Collingbourne wrote:
> > > On Fri, Jun 24, 2022 at 10:05 AM Catalin Marinas
> > > <catalin.marinas@arm.com> wrote:
> > > > + Steven as he added the KVM and swap support for MTE.
> > > >
> > > > On Thu, Jun 23, 2022 at 04:49:44PM -0700, Peter Collingbourne wrote:
> > > > > Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
> > > > > depend on being able to map guest memory as MAP_SHARED. The current
> > > > > restriction on sharing MAP_SHARED pages with the guest is preventing
> > > > > the use of those features with MTE. Therefore, remove this restriction.
> > > >
> > > > We already have some corner cases where the PG_mte_tagged logic fails
> > > > even for MAP_PRIVATE (but page shared with CoW). Adding this on top for
> > > > KVM MAP_SHARED will potentially make things worse (or hard to reason
> > > > about; for example the VMM sets PROT_MTE as well). I'm more inclined to
> > > > get rid of PG_mte_tagged altogether, always zero (or restore) the tags
> > > > on user page allocation, copy them on write. For swap we can scan and if
> > > > all tags are 0 and just skip saving them.
> > >
> > > A problem with this approach is that it would conflict with any
> > > potential future changes that we might make that would require the
> > > kernel to avoid modifying the tags for non-PROT_MTE pages.
> >
> > Not if in all those cases we check VM_MTE_ALLOWED. We seem to have the
> > vma available where it matters. We can keep PG_mte_tagged around but
> > always set it on page allocation (e.g. when zeroing or CoW) and check
> > VM_MTE_ALLOWED rather than VM_MTE.
> 
> Right, but for avoiding tagging we would like that to apply to as many
> pages as possible. If we check VM_MTE_ALLOWED then the heap pages of
> those processes that are not using MTE would not be covered, which on
> a mostly non-MTE system would be a majority of pages.

By non-MTE system, I guess you mean a system that supports MTE but most
of the user apps don't use it. That's why it would be interesting to see
the effect of using DC GZVA instead of DC ZVA for page zeroing.

I suspect on Android you'd notice the fork() penalty a bit more with all
the copy-on-write having to copy tags. But we can't tell until we do
some benchmarks. If the penalty is indeed significant, we'll go back to
assessing the races here.

Another thing that won't happen for PG_mte_tagged currently is KSM page
merging. I had a patch to allow comparing the tags but eventually
dropped it (can dig it out).

> Over the weekend I thought of another policy, which would be similar
> to your original one. We can always tag pages which are mapped as
> MAP_SHARED. These pages are much less common than private pages, so
> the impact would be less. So the if statement in
> alloc_zeroed_user_highpage_movable would become:
> 
> if ((vma->vm_flags & VM_MTE) || (system_supports_mte() &&
>				   (vma->vm_flags & VM_SHARED)))
> 
> That would allow us to put basically any shared mapping in the guest
> address space without needing to deal with races in sanitise_mte_tags.

It's not just about VM_SHARED. A page can be effectively shared as a
result of a fork(). It is read-only in all processes but still shared
and one task may call mprotect(PROT_MTE).

Another case of sharing is between the VMM and the guest though I think
an mprotect() in the VMM would trigger the unmapping of the guest
address and pages mapped into guests already have PG_mte_tagged set.

We probably need to draw a state machine of all the cases. AFAICT, we
need to take into account a few of the below (it's probably incomplete;
I've been with Steven through most of them IIRC):

1. Private mappings with mixed PROT_MTE, CoW sharing and concurrent
   mprotect(PROT_MTE). That's one of the things I dislike is that a late
   tag clearing via set_pte_at() can happen without breaking the CoW
   mapping. It's a bit counter-intuitive if you treat the tags as data
   (rather than some cache), you don't expect a read-only page to have
   some (tag) updated.

2. Shared mappings with concurrent mprotect(PROT_MTE).

3. Shared mapping restoring from swap.

4. Private mapping restoring from swap into CoW mapping.

5. KVM faults.

6. Concurrent ptrace accesses (or KVM tag copying)

What currently risks failing I think is breaking a CoW mapping with
concurrent mprotect(PROT_MTE) - we set PG_mte_tagged before zeroing the
tags. A concurrent copy may read stale tags. In sanitise_mte_tags() we
do this the other way around - clear tags first and then set the flag.

I think using another bit as a lock may solve most (all) of these but
another option is to treat the tags as data and make sure they are set
before mapping.

> We may consider going further than this and require all pages mapped
> into guests with MTE enabled to be PROT_MTE.

We discussed this when upstreaming KVM support and the idea got pushed
back. The main problem is that the VMM may use MTE for itself but can no
longer access the guest memory without the risk of taking a fault. We
don't have a match-all tag in user space and we can't teach the VMM to
use the PSTATE.TCO bit since driver emulation can be fairly generic.
And, of course, there's also the ABI change now.

> I think it would allow
> dropping sanitise_mte_tags entirely. This would not be a relaxation of
> the ABI but perhaps we can get away with it if, as Cornelia mentioned,
> QEMU does not currently support MTE, and since crosvm doesn't
> currently support it either there's no userspace to break AFAIK. This
> would also address a current weirdness in the API where it is possible
> for the underlying pages of a MAP_SHARED file mapping to become tagged
> via KVM, said tags are exposed to the guest and are discarded when the
> underlying page is paged out.

Ah, good point, shared file mappings is another reason we did not allow
MAP_SHARED and MTE for guest memory.

BTW, in user_mem_abort() we should probably check for VM_MTE_ALLOWED
irrespective of whether we allow MAP_SHARED or not.

> We can perhaps accomplish it by dropping
> support for KVM_CAP_ARM_MTE in the kernel and introducing something
> like a KVM_CAP_ARM_MTE_V2 with the new restriction.

That's an option for the ABI upgrade but we still need to solve the
potential races.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
