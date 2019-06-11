Return-Path: <SRS0=y8js=UK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A359C43218
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jun 2019 11:51:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC82B20673
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jun 2019 11:51:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC82B20673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28B1C4A50F;
	Tue, 11 Jun 2019 07:51:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iehfbgAXlXj9; Tue, 11 Jun 2019 07:51:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0B064A511;
	Tue, 11 Jun 2019 07:51:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2F494A4F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jun 2019 07:51:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PU6kr190uFTA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jun 2019 07:51:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7116C4A4EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jun 2019 07:51:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14D75344;
 Tue, 11 Jun 2019 04:51:34 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1A463F557;
 Tue, 11 Jun 2019 04:53:15 -0700 (PDT)
Date: Tue, 11 Jun 2019 13:51:32 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Reference count on pages held in secondary MMUs
Message-ID: <20190611115132.GB5318@e113682-lin.lund.arm.com>
References: <20190609081805.GC21798@e113682-lin.lund.arm.com>
 <3ca445bb-0f48-3e39-c371-dd197375c966@redhat.com>
 <20190609174024.GA4785@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190609174024.GA4785@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jerome Glisse <jglisse@redhat.com>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Sun, Jun 09, 2019 at 01:40:24PM -0400, Andrea Arcangeli wrote:
> Hello,
> 
> On Sun, Jun 09, 2019 at 11:37:19AM +0200, Paolo Bonzini wrote:
> > On 09/06/19 10:18, Christoffer Dall wrote:
> > > In some sense, we are thus maintaining a 'hidden', or internal,
> > > reference to the page, which is not counted anywhere.
> > > 
> > > I am wondering if it would be equally valid to take a reference on the
> > > page, and remove that reference when unmapping via MMU notifiers, and if
> > > so, if there would be any advantages/drawbacks in doing so?
> > 
> > If I understand correctly, I think the MMU notifier would not fire if
> > you took an actual reference; the page would be pinned in memory and
> > could not be swapped out.
> 
> MMU notifiers still fires, the refcount is simple and can be dropped
> also in the mmu notifier invalidate 

Sorry, what does this mean?  Do you mean that we can either do:

  on_vm_s2_fault() {
      page = gup();
      map_page_in_s2_mmu();
      put_page();
  }

  mmu_notifier_invalidate() {
      unmap_page_in_s2_mmu();
  }

or

  on_vm_s2_fault() {
      page = gup();
      map_page_in_s2_mmu();
  }

  mmu_notifier_invalidate() {
      unmap_page_in_s2_mmu();
      put_page();
  }


> and in fact Jerome also thinks
> like me that we should eventually optimize away the FOLL_GET and not
> take the refcount in the first place, 

So if I understood the above correct, the next point is that there are
advantages to avoiding keeping the extra reference on that page, because
we have problematic race conditions related to set_page_dirty(), and we
can reduce the problem of race conditions further by not getting a
reference on the page at all when going GUP as part of a KVM fault?

Can you explain, or provide a pointer to, the root cause of the
problem with holding a reference on the page and setting it dirty?

> but a whole different chapter is
> dedicated on the set_page_dirty_lock crash on MAP_SHARED mappings
> after long term GUP pins. So since you're looking into how to handle
> the page struct in the MMU notifier it's worth mentioning the issues
> related to set_page_dirty too.

Is there some background info on the "set_page_dirty_lock crash on
MAP_SHARED" ?  I'm having trouble following this without the background.

> 
> To achieve the cleanest writeback fix to avoid crashes in
> set_page_dirty_lock on long term secondary MMU mappings that supports
> MMU notifier like KVM shadow MMU, the ideal is to mark the page dirty
> before establishing a writable the mapping in the secondary MMU like
> in the model below.
> 
> The below solution works also for those secondary MMU that are like a
> TLB and if there are two concurrent invalidates on the same page
> invoked at the same time (a potential problem Jerome noticed), you
> don't know which come out first and you would risk to call
> set_page_dirty twice, which would be still potentially kernel crashing
> (even if only a theoretical issue like O_DIRECT).

Why is it problematic to call set_page_dirty() twice?  I thought that at
worst it would only lead to writing out data to disk unnecessarily ?

I am also not familiar with a problem related to KVM and O_DIRECT, so
I'm having trouble keeping up here as well :(


> So the below model
> will solve that and it's also valid for KVM/vhost accelleration,
> despite KVM can figure out how to issue a single set_page_dirty call
> for each spte that gets invalidated by concurrent invalidates on the
> same page because it has shadow pagetables and it's not just a TLB.
> 
>   access = FOLL_WRITE|FOLL_GET
> 
> repeat:
>   page = gup(access)
>   put_page(page)
> 
>   spin_lock(mmu_notifier_lock);
>   if (race with invalidate) {
>     spin_unlock..
>     goto repeat;
>   }
>   if (access == FOLL_WRITE)
>     set_page_dirty(page)
>   establish writable mapping in secondary MMU on page
>   spin_unlock
> 
> The above solves the crash in set_page_dirty_lock without having to
> modify any filesystem, it should work theoretically safer than the
> O_DIRECT short term GUP pin.

That is not exactly how we do things today on the arm64 side.  We do
something that looks like:

  /*
   * user_mem_abort is our function for a secondary MMU fault that
   * resolves to a memslot.
   */
  user_mem_abort() {
      page = gup(access, &writable);
      spin_lock(&kvm->mmu_lock);
      if (mmu_notifier_retry(kvm, mmu_seq))
          goto out; /* run the VM again and see what happens */

      if (writable)
          kvm_set_pfn_dirty(page_to_pfn(page));
      stage2_set_pte(); /* establish_writable mapping in secondary MMU on page */

  out:
      spin_unlock(&kvm_mmu_lock);
      put_page(page);
  }

Should we rework this to address the race you are refering to, and are
other architectures already safe against this?

> 
> With regard to KVM this should be enough, but we also look for a crash
> avoidance solution for those devices that cannot support the MMU
> notifier for short and long term GUP pins.

Sorry, can you define short and long term GUP pins, and do we have
current examples of both?


> 
> There's lots of work going on on linux-mm, to try to let those devices
> support writeback in a safe way (also with stable pages so all fs
> integrity checks will pass) using bounce buffer if a long term GUP pin
> is detected by the filesystem. In addition there's other work to make
> the short term GUP pin theoretically safe by delaying the writeback
> for the short window the GUP pin is taken by O_DIRECT, so it becomes
> theoretically safe too (currently it's only practically safe).
> 
> However I'm not sure if the long term GUP pins really needs to support
> writeback.
> 

I don't think I understand the distinction between a long term GUP pin
that supports writeback vs. a short term GUP pin.  My question was
whether or not the pin could be dropped at the time the mapping was torn
down, or if it has to be done at the same time the mapping is
established, for things to work properly wrt. the semantics of memory
behavior of the rest of the kernel.

I'm not sure if we're talking about the same thing here, or if you're
explaining a different scenario?


Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
