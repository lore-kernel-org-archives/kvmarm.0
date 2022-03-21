Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86814C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Mar 2022 17:28:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D839A49ED1;
	Mon, 21 Mar 2022 13:28:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uEtFTBqYe3bX; Mon, 21 Mar 2022 13:28:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 507C340BE7;
	Mon, 21 Mar 2022 13:28:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E54D54012A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 13:28:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nzE5JOfE8Zmm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2022 13:28:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E66040096
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 13:28:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D02BB1042;
 Mon, 21 Mar 2022 10:28:48 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BBAE3F66F;
 Mon, 21 Mar 2022 10:28:47 -0700 (PDT)
Date: Mon, 21 Mar 2022 17:29:14 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v5 08/38] KVM: arm64: Unlock memslots after stage 2
 tables are freed
Message-ID: <Yji1z3Q9cd8njbwL@monolith.localdoman>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
 <20211117153842.302159-9-alexandru.elisei@arm.com>
 <0ce1011b-6e77-f00c-6d19-5b5394e0d0c2@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0ce1011b-6e77-f00c-6d19-5b5394e0d0c2@google.com>
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Thu, Mar 17, 2022 at 10:19:56PM -0700, Reiji Watanabe wrote:
> Hi Alex,
> 
> On 11/17/21 7:38 AM, Alexandru Elisei wrote:
> > Unpin the backing pages mapped at stage 2 after the stage 2 translation
> > tables are destroyed.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >   arch/arm64/kvm/mmu.c | 23 ++++++++++++++++++-----
> >   1 file changed, 18 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index cd6f1bc7842d..072e2aba371f 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1627,11 +1627,19 @@ int kvm_mmu_lock_memslot(struct kvm *kvm, u64 slot, u64 flags)
> >   	return ret;
> >   }
> > -static void unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
> > +static void __unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
> >   {
> >   	bool writable = memslot->arch.flags & KVM_MEMSLOT_LOCK_WRITE;
> >   	unsigned long npages = memslot->npages;
> > +	unpin_memslot_pages(memslot, writable);
> > +	account_locked_vm(current->mm, npages, false);
> > +
> > +	memslot->arch.flags &= ~KVM_MEMSLOT_LOCK_MASK;
> > +}
> > +
> > +static void unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
> > +{
> >   	/*
> >   	 * MMU maintenace operations aren't performed on an unlocked memslot.
> >   	 * Unmap it from stage 2 so the abort handler performs the necessary
> > @@ -1640,10 +1648,7 @@ static void unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
> >   	if (kvm_mmu_has_pending_ops(kvm))
> >   		kvm_arch_flush_shadow_memslot(kvm, memslot);
> > -	unpin_memslot_pages(memslot, writable);
> > -	account_locked_vm(current->mm, npages, false);
> > -
> > -	memslot->arch.flags &= ~KVM_MEMSLOT_LOCK_MASK;
> > +	__unlock_memslot(kvm, memslot);
> >   }
> >   int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags)
> > @@ -1951,7 +1956,15 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
> >   void kvm_arch_flush_shadow_all(struct kvm *kvm)
> >   {
> > +	struct kvm_memory_slot *memslot;
> > +
> >   	kvm_free_stage2_pgd(&kvm->arch.mmu);
> > +
> > +	kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
> > +		if (!memslot_is_locked(memslot))
> > +			continue;
> > +		__unlock_memslot(kvm, memslot);
> > +	}
> >   }
> 
> Perhaps it might be useful to manage the number of locked memslots ?
> (can be used in the fix for kvm_mmu_unlock_memslot in the patch-7 as well)

I don't think it's very useful to manage the number, as we usually want to
find all locked memslots, and there's absolutely no guarantee that the
locked memslot will be at the start of the list, in which case we would
have saved iterating over the last memslots.

In the case above, this is done when the VM is being destroyed, which is
not particularly performance sensitive. And certainly a few linked list
accesses won't make much of a difference.

In patch #7, KVM iterates through the memslots and calls
kvm_arch_flush_shadow_memslot(), which is several orders of magnitude
slower than iterating through a few extra memslots. Also, I don't think
userspace locking then unlocking a memslot before running any VCPUs is
something that will happen very often.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
