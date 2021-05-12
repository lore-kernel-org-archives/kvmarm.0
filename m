Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BACC433ED
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 17:45:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5FC3F61412
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 17:45:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FC3F61412
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C06E94B347;
	Wed, 12 May 2021 13:45:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HJu1QJh3t4nT; Wed, 12 May 2021 13:45:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5523A4B468;
	Wed, 12 May 2021 13:45:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A65BA4B386
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 13:45:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MQYz3389ZEOr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 13:45:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 192AC4B347
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 13:45:10 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D1F9613DF;
 Wed, 12 May 2021 17:45:05 +0000 (UTC)
Date: Wed, 12 May 2021 18:45:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v11 2/6] arm64: kvm: Introduce MTE VM feature
Message-ID: <20210512174502.GC12391@arm.com>
References: <20210416154309.22129-1-steven.price@arm.com>
 <20210416154309.22129-3-steven.price@arm.com>
 <20210428170705.GB4022@arm.com>
 <c3293d47-a5f2-ea4a-6730-f5cae26d8a7e@arm.com>
 <YJGHApOCXl811VK3@arm.com>
 <329286e8-a8f3-ea1a-1802-58813255a4a5@arm.com>
 <20210507182538.GF26528@arm.com> <20210510183506.GA10910@arm.com>
 <c891d4eb-b388-1658-8c8a-e76477062463@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c891d4eb-b388-1658-8c8a-e76477062463@arm.com>
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

On Wed, May 12, 2021 at 04:46:48PM +0100, Steven Price wrote:
> On 10/05/2021 19:35, Catalin Marinas wrote:
> > On Fri, May 07, 2021 at 07:25:39PM +0100, Catalin Marinas wrote:
> > > On Thu, May 06, 2021 at 05:15:25PM +0100, Steven Price wrote:
> > > > On 04/05/2021 18:40, Catalin Marinas wrote:
> > > > > On Thu, Apr 29, 2021 at 05:06:41PM +0100, Steven Price wrote:
> > > > > > Given the changes to set_pte_at() which means that tags are restored from
> > > > > > swap even if !PROT_MTE, the only race I can see remaining is the creation of
> > > > > > new PROT_MTE mappings. As you mention an attempt to change mappings in the
> > > > > > VMM memory space should involve a mmu notifier call which I think serialises
> > > > > > this. So the remaining issue is doing this in a separate address space.
> > > > > > 
> > > > > > So I guess the potential problem is:
> > > > > > 
> > > > > >    * allocate memory MAP_SHARED but !PROT_MTE
> > > > > >    * fork()
> > > > > >    * VM causes a fault in parent address space
> > > > > >    * child does a mprotect(PROT_MTE)
> > > > > > 
> > > > > > With the last two potentially racing. Sadly I can't see a good way of
> > > > > > handling that.
[...]
> > Options:
> > 
> > 1. Change the mte_sync_tags() code path to set the flag after clearing
> >     and avoid reading stale tags. We document that mprotect() on
> >     MAP_SHARED may lead to tag loss. Maybe we can intercept this in the
> >     arch code and return an error.
> 
> This is the best option I've come up with so far - but it's not a good
> one! We can replace the set_bit() with a test_and_set_bit() to catch the
> race after it has occurred - but I'm not sure what we can do about it
> then (we've already wiped the data). Returning an error doesn't seem
> particularly useful at that point, a message in dmesg is about the best
> I can come up with.

What I meant about intercepting is on something like
arch_validate_flags() to prevent VM_SHARED and VM_MTE together but only
for mprotect(), not mmap(). However, arch_validate_flags() is currently
called on both mmap() and mprotect() paths.

We can't do much in set_pte_at() to prevent the race with only a single
bit.

> > 2. Figure out some other locking in the core code. However, if
> >     mprotect() in one process can race with a handle_pte_fault() in
> >     another, on the same shared mapping, it's not trivial.
> >     filemap_map_pages() would take the page lock before calling
> >     do_set_pte(), so mprotect() would need the same page lock.
> 
> I can't see how this is going to work without harming the performance of
> non-MTE work. Ultimately we're trying to add some sort of locking for
> two (mostly) unrelated processes doing page table operations, which will
> hurt scalability.

Another option is to have an arch callback to force re-faulting on the
pte. That means we don't populate it back after the invalidation in the
change_protection() path. We could do this only if the new pte is tagged
and the page doesn't have PG_mte_tagged. The faulting path takes the
page lock IIUC.

Well, at least for stage 1, I haven't thought much about stage 2.

> > 3. Use another PG_arch_3 bit as a lock to spin on in the arch code (i.e.
> >     set it around the other PG_arch_* bit setting).
> 
> This is certainly tempting, although sadly the existing
> wait_on_page_bit() is sleeping - so this would either be a literal spin,
> or we'd need to implement a new non-sleeping wait mechanism.

Yeah, it would have to be a custom spinning mechanism, something like:

	/* lock the page */
	while (test_and_set_bit(PG_arch_3, &page->flags))
		smp_cond_load_relaxed(&page->flags, !(VAL & PG_arch_3));
	...
	/* unlock the page */
	clear_bit(PG_arch_3, &page->flags);

> 4. Sledgehammer locking in mte_sync_page_tags(), add a spinlock only for
> the MTE case where we have to sync tags (see below). What the actual
> performance impact of this is I've no idea. It could certainly be bad
> if there are a lot of pages with MTE enabled, which sadly is exactly
> the case if KVM is used with MTE :(
> 
> --->8----
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index 0d320c060ebe..389ad40256f6 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -25,23 +25,33 @@
>  u64 gcr_kernel_excl __ro_after_init;
>  static bool report_fault_once = true;
> +static spinlock_t tag_sync_lock;
>  static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap,
>  			       bool pte_is_tagged)
>  {
>  	pte_t old_pte = READ_ONCE(*ptep);
> +	if (!is_swap_pte(old_pte) && !pte_is_tagged)
> +		return;
> +
> +	spin_lock_irqsave(&tag_sync_lock, flags);
> +
> +	/* Recheck with the lock held */
> +	if (test_bit(PG_mte_tagged, &page->flags))
> +		goto out;

Can we skip the lock if the page already has the PG_mte_tagged set?
That's assuming that we set the flag only after clearing the tags. The
normal case where mprotect() is called on a page already mapped with
PROT_MTE would not be affected.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
