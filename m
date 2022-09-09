Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4AFECAAD3
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 09:56:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 589394CA05;
	Fri,  9 Sep 2022 05:56:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X8aTp47xgzNn; Fri,  9 Sep 2022 05:56:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D100A4C9F9;
	Fri,  9 Sep 2022 05:56:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91ABD4C9F9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 05:56:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I7ai6a8WLB04 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 05:56:09 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3B5B4C97B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 05:56:09 -0400 (EDT)
Date: Fri, 9 Sep 2022 10:55:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1662717368;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=lDpC67NopcBY3WkfHCdst9Y40eb0+fWa3aZaj8C1P74=;
 b=LVUcgLVEKlJeyJh274QBbSm2SunUsd/+Fnhi8Oa83s4LnsBzI0E2D1UEwYFcXtQEulUU+W
 LVnoIby+wN2xFlyIPs/26HCtShwG9QsGAppu7ff2QUan911DOy14slnZlOYJWqyTLNYjZD
 NI3YBiakBpwSB/KZjauRUKa3/8sbkjE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 08/14] KVM: arm64: Protect page table traversal with RCU
Message-ID: <YxsNr+79UUm5Go9x@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-9-oliver.upton@linux.dev>
 <YxkRXLsLuhjBNanT@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YxkRXLsLuhjBNanT@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Sep 07, 2022 at 02:47:08PM -0700, David Matlack wrote:
> On Tue, Aug 30, 2022 at 07:41:26PM +0000, Oliver Upton wrote:
> > The use of RCU is necessary to change the paging structures in parallel.
> > Acquire and release an RCU read lock when traversing the page tables.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 19 ++++++++++++++++++-
> >  arch/arm64/kvm/hyp/pgtable.c         |  7 ++++++-
> >  2 files changed, 24 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 78fbb7be1af6..7d2de0a98ccb 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -578,9 +578,26 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
> >   */
> >  enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
> >  
> > +#if defined(__KVM_NVHE_HYPERVISOR___)
> > +
> 
> Future readers will wonder why NVHE stubs out RCU support and how that
> is even correct. Some comments here would be useful explain it.

Good point.

> > +static inline void kvm_pgtable_walk_begin(void) {}
> > +static inline void kvm_pgtable_walk_end(void) {}
> > +
> > +#define kvm_dereference_ptep rcu_dereference_raw
> 
> How does NVHE have access rcu_dereference_raw()?

rcu_dereference_raw() is inlined and simply recasts the pointer into the
kernel address space.

Perhaps it is less confusing to template this on kvm_pte_read() to avoid
polluting nVHE with an otherwise benign reference to RCU.

> > +
> > +#else	/* !defined(__KVM_NVHE_HYPERVISOR__) */
> > +
> > +#define kvm_pgtable_walk_begin	rcu_read_lock
> > +#define kvm_pgtable_walk_end	rcu_read_unlock
> > +#define kvm_dereference_ptep	rcu_dereference
> > +
> > +#endif	/* defined(__KVM_NVHE_HYPERVISOR__) */
> > +
> >  static inline kvm_pte_t kvm_pte_read(kvm_pte_t *ptep)
> >  {
> > -	return READ_ONCE(*ptep);
> > +	kvm_pte_t __rcu *p = (kvm_pte_t __rcu *)ptep;
> > +
> > +	return READ_ONCE(*kvm_dereference_ptep(p));
> 
> What about all the other places where page table memory is accessed?
> 
> If RCU is going to be used to protect page table memory, then all
> accesses have to go under an RCU critical section. This means that page
> table memory should only be accessed through __rcu annotated pointers
> and dereferenced with rcu_dereference().

Let me play around with this a bit, as the annoying part is trying to
sprinkle in RCU annotations w/o messing with nVHE. 

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
