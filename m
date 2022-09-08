Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97384C6FA86
	for <kvmarm@archiver.kernel.org>; Thu,  8 Sep 2022 16:40:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FCB44CC16;
	Thu,  8 Sep 2022 12:40:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ut7ycI0uzDfI; Thu,  8 Sep 2022 12:40:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D57A24CBEE;
	Thu,  8 Sep 2022 12:40:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6DD34CBEE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2022 12:40:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZF7+60pwelyq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Sep 2022 12:40:23 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8468B4CB3A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2022 12:40:23 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id
 n65-20020a17090a5ac700b001fbb4fad865so3041763pji.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Sep 2022 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=44f96G3kCRZjV7Y8+rtld0XE0LiSAJByVTyxhZXDjtw=;
 b=fl0OF4gPksEMzbO6l5ojcJJdCc+d34Eu6l34U9JHsmWZmYqMRhxCjrXQimUdVzxZ4Z
 h+tlSUaFHV90shVtftbvG5kp6jvxSzUOEKtBj2Y5ndd7aK8uDUqK0mMDgxzuYabkB9X/
 yLPxRKLVx4lqp802+KHlONlx8+g7D2gfQV2FY9nkD/vJPTNBj3IQoZeW2yJ8c5KuVD4P
 2btMsSs/jWYhOpHZVxep5SkPu3rK/BKMxCFCG1Re+YjZWo6eWO6o4IG7Gq8pQN42LiJO
 BGDLDtAidqsf49nSAQ+Iw8owS4IsNHK1io4In3hBdCVR0VwpuFEt11DTABFzWzxxrKt4
 uuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=44f96G3kCRZjV7Y8+rtld0XE0LiSAJByVTyxhZXDjtw=;
 b=7JfvNudJzeyQ4IwhWkoZSX1r8Lk8/2mjOJ5XlK5oH09HidNCTyenavNBfIJANyacLB
 PmdUjPBEA+x5QAwmEJFfHEuOyRn2tGJO2HkV3H4FlVrMGPRD648ul9kcCZMJVHN2KeeV
 epvE5eTGq9hOGHUQS7hAFgJM+IuYQ6n6yI96seIGSrNr7Wezzc1UTnZep8Lk5S94D9Wj
 zhB8Xvs/hvSxndMQOuZNLQB1tkqzrbUGeDaR0utyqKIVFLeMVP8Ulj8f9LKE8mztDlAF
 VJsvETgRyYnogQC5vvimW8lI9uqu52VnXuJ+KUuS4ti1Ft2IoQ+eELBVV2Cb1mpCV20v
 KMMA==
X-Gm-Message-State: ACgBeo2936r+hOgeZ434udfJG0b0vH1DbGWLJMl7Lp5MIO0bxKJZvhTK
 4nfQN0nxKHBFTSW+5BMJ+fWEZw==
X-Google-Smtp-Source: AA6agR6OtvAZQ1VlqtdckX4M37HUd6tnzFOMxCB7aH5ZyWfFq8tToKkiSh7ojqXsfhbd+jx/tPhW7w==
X-Received: by 2002:a17:90a:588c:b0:1fd:a1bc:ff71 with SMTP id
 j12-20020a17090a588c00b001fda1bcff71mr4945546pji.134.1662655222365; 
 Thu, 08 Sep 2022 09:40:22 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com.
 [34.125.103.223]) by smtp.gmail.com with ESMTPSA id
 w24-20020aa79558000000b0053725e331a1sm14927604pfq.82.2022.09.08.09.40.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Sep 2022 09:40:21 -0700 (PDT)
Date: Thu, 8 Sep 2022 09:40:16 -0700
From: David Matlack <dmatlack@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 09/14] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <Yxoa8AQozMWuayTD@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-10-oliver.upton@linux.dev>
 <YxkUciuwLFvByLOu@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YxkUciuwLFvByLOu@google.com>
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

On Wed, Sep 07, 2022 at 03:00:18PM -0700, David Matlack wrote:
> On Tue, Aug 30, 2022 at 07:41:27PM +0000, Oliver Upton wrote:
> > There is no real urgency to free a stage-2 subtree that was pruned.
> > Nonetheless, KVM does the tear down in the stage-2 fault path while
> > holding the MMU lock.
> > 
> > Free removed stage-2 subtrees after an RCU grace period. To guarantee
> > all stage-2 table pages are freed before killing a VM, add an
> > rcu_barrier() to the flush path.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/mmu.c | 35 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 34 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 91521f4aab97..265951c05879 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -97,6 +97,38 @@ static void *stage2_memcache_zalloc_page(void *arg)
> >  	return kvm_mmu_memory_cache_alloc(mc);
> >  }
> >  
> > +#define STAGE2_PAGE_PRIVATE_LEVEL_MASK	GENMASK_ULL(2, 0)
> > +
> > +static inline unsigned long stage2_page_private(u32 level, void *arg)
> > +{
> > +	unsigned long pvt = (unsigned long)arg;
> > +
> > +	BUILD_BUG_ON(KVM_PGTABLE_MAX_LEVELS > STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> > +	WARN_ON_ONCE(pvt & STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> > +
> > +	return pvt | level;
> > +}
> > +
> > +static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
> > +{
> > +	struct page *page = container_of(head, struct page, rcu_head);
> > +	unsigned long pvt = page_private(page);
> > +	void *arg = (void *)(pvt & ~STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> > +	u32 level = (u32)(pvt & STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> > +	void *pgtable = page_to_virt(page);
> > +
> > +	kvm_pgtable_stage2_free_removed(pgtable, level, arg);
> > +}
> > +
> > +static void stage2_free_removed_table(void *pgtable, u32 level, void *arg)
> > +{
> > +	unsigned long pvt = stage2_page_private(level, arg);
> > +	struct page *page = virt_to_page(pgtable);
> > +
> > +	set_page_private(page, (unsigned long)pvt);
> > +	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
> > +}
> > +
> >  static void *kvm_host_zalloc_pages_exact(size_t size)
> >  {
> >  	return alloc_pages_exact(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > @@ -627,7 +659,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
> >  	.zalloc_page		= stage2_memcache_zalloc_page,
> >  	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
> >  	.free_pages_exact	= free_pages_exact,
> > -	.free_removed_table	= kvm_pgtable_stage2_free_removed,
> > +	.free_removed_table	= stage2_free_removed_table,
> >  	.get_page		= kvm_host_get_page,
> >  	.put_page		= kvm_host_put_page,
> >  	.page_count		= kvm_host_page_count,
> > @@ -770,6 +802,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
> >  	if (pgt) {
> >  		kvm_pgtable_stage2_destroy(pgt);
> >  		kfree(pgt);
> > +		rcu_barrier();
> 
> A comment here would be useful to document the behavior. e.g.
> 
>         /*
>          * Wait for all stage-2 page tables that are being freed
>          * asynchronously via RCU callback because ...
>          */
> 
> Speaking of, what's the reason for this rcu_barrier()? Is there any
> reason why KVM can't let in-flight stage-2 freeing RCU callbacks run at
> the end of the next grace period?

After thinking about this more I have 2 follow-up questions:

1. Should the RCU barrier come before kvm_pgtable_stage2_destroy() and
   kfree(pgt)? Otherwise an RCU callback running
   kvm_pgtable_stage2_free_removed() could access the pgt after it has
   been freed?

2. In general, is it safe for kvm_pgtable_stage2_free_removed() to run
   outside of the MMU lock? Yes the page tables have already been
   disconnected from the tree, but kvm_pgtable_stage2_free_removed()
   also accesses shared data structures likstruct kvm_pgtable. I *think*
   it might be safe after you fix (1.) but it would be more robust to
   avoid accessing shared data structures at all outside of the MMU lock
   and just do the page table freeing in the RCU callback.

> 
> >  	}
> >  }
> >  
> > -- 
> > 2.37.2.672.g94769d06f0-goog
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
