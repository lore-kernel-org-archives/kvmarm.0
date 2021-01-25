Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED9AC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 21:03:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21DD1207B1
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 21:03:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21DD1207B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 827D74B0F5;
	Mon, 25 Jan 2021 16:03:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id soe9ToE1n-E1; Mon, 25 Jan 2021 16:03:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06CB54B13B;
	Mon, 25 Jan 2021 16:03:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E3924B1F5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 13:35:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 67nXRywFUiap for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 13:35:17 -0500 (EST)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF0354B0E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 13:35:16 -0500 (EST)
Received: by mail-pl1-f170.google.com with SMTP id t6so8217176plq.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 10:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=5li4BVEipLZX5zx8rH4Z99dY7w+ascZy4Y8R2o+aUH8=;
 b=ntnqgqJh8GrmgSLeIUVSOeq5ocf777yPSTQ/ma0WIPO30h+DKcbkCeMBXaDyu+II4o
 UMpCUfTJekTMY3vCJYPmquE6msvyiqLQUxnv+Qa3r6AZbHT7+VpLvX6r5Q+OjazjvunH
 NLPdZTZMV6N7ne6Bxo+VqIYyDyy37rGuL2RgVYOhrRNmdtspPcsGocvHDflOGXXNcL3S
 m0VpqdXFHPlf1Rbm1QxZIvYNZoPDXUlGf3MUk88oOAMT/kUr0DXhL6pFdWc9nb/CDbjA
 eukcfxn0wDeFNZPSqccJmj4nhOmZ8T+LYGGk8Gq334rQrt7MJTlhmWa0vzSCOkusKDUq
 5qfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5li4BVEipLZX5zx8rH4Z99dY7w+ascZy4Y8R2o+aUH8=;
 b=qG0Wuwi9TN7rALYC/yGXIpjp2i2PP1llzZuRmVL3x7En8KHxzgO6jveTW4eRpvSHuJ
 xY9ogwHhuYVfmzDhHAfRzcB3xv0TlKEuUBBPCT68TVzswP6vR+vXQyvcSJI25260KWhM
 XSdYzsZG4fhz3tYeQNFMF4KVdW93It06ve7QJs8aZqclO/G6tm+WVxhGr5yQTKsGHYvf
 2KPx4u80QsGltWOYXE1m/1+kV9/fYIaTZycfn1vfbssVM45Aptw9CyJlEJtN9Wq7+yFE
 QTOMdo/0RI4rO4NiOgUpQ5PxwYsptj+lQjXrs0sCnp38NE38R7F+8koeXiH9MD3j6J29
 i8Ww==
X-Gm-Message-State: AOAM533nHoIgkTnCAB2CFi/SXKdRJiMC2xJsyV0pjQpqJa3XMrHkprqF
 e+4vp+T9pJCVMzjS/1jt/hfbFg==
X-Google-Smtp-Source: ABdhPJxgVscQHSmbku17rqN6Nk67IT0OKp5oZGNz41Gx1gtHDQegyJuNc0/nvJi9Q+6qG60UzNty/w==
X-Received: by 2002:a17:90a:d305:: with SMTP id
 p5mr1634140pju.33.1611599715885; 
 Mon, 25 Jan 2021 10:35:15 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 by smtp.gmail.com with ESMTPSA id n128sm18157528pga.55.2021.01.25.10.35.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Jan 2021 10:35:15 -0800 (PST)
Date: Mon, 25 Jan 2021 10:35:08 -0800
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH] KVM: x86/mmu: consider the hva in mmu_notifer retry
Message-ID: <YA8PXCEVukW0UzC5@google.com>
References: <20210125064234.2078146-1-stevensd@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210125064234.2078146-1-stevensd@google.com>
X-Mailman-Approved-At: Mon, 25 Jan 2021 16:03:31 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

+Cc the other architectures, I'm guessing this would be a helpful optimization
for all archs.

Quite a few comments, but they're all little more than nits.  Nice!

On Mon, Jan 25, 2021, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Use the range passed to mmu_notifer's invalidate_range_start to prevent

s/mmu_notifer/mmu_notifier.  

And maybe avoid calling out invalidate_range_start() by name?  It took me a few
reads to understand it's referring to the function, i.e. the start of the
invalidation, not the start of the range.

> spurious page fault retries due to changes in unrelated host virtual
> addresses.

This needs to elaborate on the exact scenario this is handling, as is it sounds
like KVM is tracking the history of invalidations or something.  Understanding
this patch requires a priori knowledge of mmu_notifier_count.  Something like:

  Track the range being invalidated by mmu_notifier and skip page fault
  retries if the fault address is not affected by the in-progress
  invalidation.  Disable the optimization if multiple invalidations are
  in-progress to keep things simple, as tracking multiple ranges has
  diminishing returns.

> This has the secondary effect of greatly reducing the likelihood of extreme

Out of curiosity, is this really the _secondary_ effect?  I would expect this
change to primarily benefit scenarios where the invalidation has gotten
waylaid for whatever reason.

> latency when handing a page fault due to another thread having been preempted
> while modifying host virtual addresses.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---

...

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d16481aa29d..79166288ed03 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3658,8 +3658,8 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  }
>  
>  static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
> -			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
> -			 bool *writable)
> +			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
> +			 bool write, bool *writable)

Side topic, I'm all for creating a 'struct kvm_page_fault' or whatever to hold
all these variables.  The helper functions stacks are getting unwieldy.
Definitely doesn't need to be addressed here, this just reminded of how ugly
these stacks are.

>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  	bool async;
> @@ -3672,7 +3672,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  	}
>  
>  	async = false;
> -	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
> +	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async,
> +				    write, writable, hva);
>  	if (!async)
>  		return false; /* *pfn has correct page already */
>  
> @@ -3686,7 +3687,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  			return true;
>  	}
>  
> -	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable);
> +	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
> +				    write, writable, hva);
>  	return false;
>  }
>  
> @@ -3699,6 +3701,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	unsigned long mmu_seq;
>  	kvm_pfn_t pfn;
> +	hva_t hva;
>  	int r;
>  
>  	if (page_fault_handle_page_track(vcpu, error_code, gfn))
> @@ -3717,7 +3720,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
>  
> -	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
> +	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
> +			 write, &map_writable))
>  		return RET_PF_RETRY;
>  
>  	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
> @@ -3725,7 +3729,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  
>  	r = RET_PF_RETRY;
>  	spin_lock(&vcpu->kvm->mmu_lock);
> -	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
> +	if (mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
>  		goto out_unlock;
>  	r = make_mmu_pages_available(vcpu);
>  	if (r)
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 50e268eb8e1a..3171784139a4 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -790,6 +790,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  	struct guest_walker walker;
>  	int r;
>  	kvm_pfn_t pfn;
> +	hva_t hva;
>  	unsigned long mmu_seq;
>  	bool map_writable, is_self_change_mapping;
>  	int max_level;
> @@ -840,8 +841,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
>  
> -	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, write_fault,
> -			 &map_writable))
> +	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
> +			 write_fault, &map_writable))
>  		return RET_PF_RETRY;
>  
>  	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
> @@ -869,7 +870,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  
>  	r = RET_PF_RETRY;
>  	spin_lock(&vcpu->kvm->mmu_lock);
> -	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
> +	if (mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
>  		goto out_unlock;
>  
>  	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f3b1013fb22c..b70097685249 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -502,6 +502,8 @@ struct kvm {
>  	struct mmu_notifier mmu_notifier;
>  	unsigned long mmu_notifier_seq;
>  	long mmu_notifier_count;
> +	unsigned long mmu_notifier_range_start;
> +	unsigned long mmu_notifier_range_end;
>  #endif
>  	long tlbs_dirty;
>  	struct list_head devices;
> @@ -729,7 +731,7 @@ kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
>  kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
>  kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
>  			       bool atomic, bool *async, bool write_fault,
> -			       bool *writable);
> +			       bool *writable, hva_t *hva);
>  
>  void kvm_release_pfn_clean(kvm_pfn_t pfn);
>  void kvm_release_pfn_dirty(kvm_pfn_t pfn);
> @@ -1203,6 +1205,24 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
>  		return 1;
>  	return 0;
>  }
> +
> +static inline int mmu_notifier_retry_hva(struct kvm *kvm,
> +					 unsigned long mmu_seq,
> +					 unsigned long hva)
> +{
> +	/*
> +	 * Unlike mmu_notifier_retry, this function relies on
> +	 * kvm->mmu_lock for consistency.

mmu_notifier_retry is the outlier due to PPC behavior.  Maybe just add a lockdep
annonation and call it good?

> +	 */

This needs a comment to explicitly state that 'count > 1' cannot be done at
this time.  My initial thought is that it would be more intuitive to check for
'count > 1' here, but that would potentially check the wrong wrange when count
goes from 2->1.  The comment about persistence in invalidate_range_start() is a
good hint, but I think it's worth being explicit to avoid bad "cleanup" in the
future.

> +	if (unlikely(kvm->mmu_notifier_count)) {
> +		if (kvm->mmu_notifier_range_start <= hva &&
> +		    hva < kvm->mmu_notifier_range_end)

Combine these into a single statement?  I think the result is easier to read?

	if (unlikely(kvm->mmu_notifier_count) &&
	    kvm->mmu_notifier_range_start <= hva &&
	    hva < kvm->mmu_notifier_range_end)

> +			return 1;
> +	}
> +	if (kvm->mmu_notifier_seq != mmu_seq)
> +		return 1;
> +	return 0;
> +}
>  #endif
>  
>  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fa9e3614d30e..d6e1ef5cb184 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -483,6 +483,18 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>  	 * count is also read inside the mmu_lock critical section.
>  	 */
>  	kvm->mmu_notifier_count++;
> +	if (likely(kvm->mmu_notifier_count == 1)) {
> +		kvm->mmu_notifier_range_start = range->start;
> +		kvm->mmu_notifier_range_end = range->end;
> +	} else {
> +		/**
> +		 * Tracking multiple concurrent ranges has diminishing returns,
> +		 * so just use the maximum range. This persists until after all
> +		 * outstanding invalidation operations complete.
> +		 */
> +		kvm->mmu_notifier_range_start = 0;
> +		kvm->mmu_notifier_range_end = ULONG_MAX;

Hrm, I don't think there's a corner case in practice, but ULONG_MAX is a legal
virtual address and range_end is exclusive.  E.g. passing hva=-1ul would get a
false negative in mmu_notifier_retry_hva().  It's not an issue as written
because hva is generated from the gfn, and hva can't be a kernel address.  I'm
guessing mmu_notifier also doesn't fire on kernel addresses.  I assume that all
holds true for other architectures, and adding checks in mmu_notifier_retry_hva()
feels like a waste of cycles, but it still bugs me. :-)

Maybe zero out range_end and explicitly check for that, just to be paranoid?

	if (unlikely(kvm->mmu_notifier_count) &&
	    (!kvm->mmu_notifier_range_end ||
            (kvm->mmu_notifier_range_start <= hva &&
             hva < kvm->mmu_notifier_range_end))

> +	}
>  	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
>  					     range->flags);
>  	/* we've to flush the tlb before the pages can be freed */
> @@ -2010,9 +2022,11 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
>  
>  kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
>  			       bool atomic, bool *async, bool write_fault,
> -			       bool *writable)
> +			       bool *writable, hva_t *hva)

Hrm, it feels like we should really split gfn->hva and hva->pfn into separate
operations, but pretty much every arch needs the hva error handling.  Splitting
it would probably do more harm than good, at least not without a lot of
additional refactoring.  Bummer.

>  {
>  	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);

Newline here.

> +	if (hva)
> +		*hva = addr;
>  
>  	if (addr == KVM_HVA_ERR_RO_BAD) {
>  		if (writable)
> @@ -2041,19 +2055,19 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>  		      bool *writable)
>  {
>  	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
> -				    write_fault, writable);
> +				    write_fault, writable, NULL);
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
>  
>  kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> -	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL);
> +	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
>  
>  kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> -	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL);
> +	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
>  
> -- 
> 2.30.0.280.ga3ce27912f-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
