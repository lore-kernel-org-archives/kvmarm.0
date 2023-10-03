Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC06A29415
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696352076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ySMhh2qWkf/GSdMB7Wvp6braZW+Sa/U1ZFAR1yoSqk=;
	b=jDeXWcU8EdMQJzZMxFtHSmiNIiN0S4fPo/lLw/ebA9Y63KRCjzVBrd2OisEllvK44InVEU
	8iZxPeiQUAvOtpgTFOMO+NUepyS4wfY1J/UM9+k77DAvdaF8Mjzx/ZlwiNej5o+oAEl+pI
	FAw5YD29Aa7IaGPQ4zPAA69mWH2rC3I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-4kh01XsWOCaEhMoWuu4Lmw-1; Tue, 03 Oct 2023 12:54:35 -0400
X-MC-Unique: 4kh01XsWOCaEhMoWuu4Lmw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32686c75f8fso963291f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Oct 2023 09:54:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696352074; x=1696956874;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5ySMhh2qWkf/GSdMB7Wvp6braZW+Sa/U1ZFAR1yoSqk=;
        b=pwo6Gy+5oh2DSHCDViLR53YhwNirsWl8Nl6ww9eG7jINDl9jLNu7e45eEck8EFAfJ+
         tRu5LWOpybW+LTBDM0Or+N4YZcwO0D1YOewSy4mvFkkRWnEsJ+x8dXdXYpc0yimEv1Fb
         rnpWgA6x69cRqd9JWVgWvBtYKbfNMPhaJQUR1Jhd9/85Nt8w5Zr+WOhNPw0cw2LZWB67
         QEKRczCyTX1nlcrJHSJccHp00NcVTaKAvn/O7EOSruRuNnwgo5Vq88tySAfc0A0NQevG
         wK6c9R9pYAjFwEtVa0H0Gref4977GlC/4sG6ab+Z8ZO6mOXqXa8Jg0iYHyG1Hip9zwJK
         5BRw==
X-Gm-Message-State: AOJu0YwMtezlh7Byw5IyQG54716AgyArLanYKgmEdbjBZkPgNADgBXTx
	gZ4tCt8NbydbaKUSEZN/8HY0YsIUoy5ULJzCdT2kGTGgYaYVN/UAjRx2u5wP1GRzw45C8sEss20
	Fo0xn/5ww90YcJ7TSA/WbDAi3
X-Received: by 2002:a5d:4fd1:0:b0:31f:dcbb:f81c with SMTP id h17-20020a5d4fd1000000b0031fdcbbf81cmr12718564wrw.10.1696352073874;
        Tue, 03 Oct 2023 09:54:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEwvH8gObzsBVX45NgjQVHWBMhCU6zlXcQo629oLHGTAwvU89+cBwM6NvJRUkB06ucTq1hdw==
X-Received: by 2002:a5d:4fd1:0:b0:31f:dcbb:f81c with SMTP id h17-20020a5d4fd1000000b0031fdcbbf81cmr12718545wrw.10.1696352073382;
        Tue, 03 Oct 2023 09:54:33 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id j10-20020a5d464a000000b00317a04131c5sm1972144wrs.57.2023.10.03.09.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 09:54:33 -0700 (PDT)
Message-ID: <91b97ed81a70c778352b2f569001820ea8b1c48b.camel@redhat.com>
Subject: Re: [PATCH v9 3/6] KVM: mmu: Improve handling of non-refcounted pfns
From: Maxim Levitsky <mlevitsk@redhat.com>
To: David Stevens <stevensd@chromium.org>, Sean Christopherson
	 <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata
	 <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 03 Oct 2023 19:54:31 +0300
In-Reply-To: <20230911021637.1941096-4-stevensd@google.com>
References: <20230911021637.1941096-1-stevensd@google.com>
	 <20230911021637.1941096-4-stevensd@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

У пн, 2023-09-11 у 11:16 +0900, David Stevens пише:
> From: David Stevens <stevensd@chromium.org>
> 
> KVM's handling of non-refcounted pfns has two problems:
> 
>  - struct pages without refcounting (e.g. tail pages of non-compound
>    higher order pages) cannot be used at all, as gfn_to_pfn does not
>    provide enough information for callers to handle the refcount.
>  - pfns without struct pages can be accessed without the protection of a
>    mmu notifier. This is unsafe because KVM cannot monitor or control
>    the lifespan of such pfns, so it may continue to access the pfns
>    after they are freed.
> 
> This patch extends the __kvm_follow_pfn API to properly handle these
> cases. 


> First, it adds a is_refcounted_page output parameter so that
> callers can tell whether or not a pfn has a struct page that needs to be
> passed to put_page. 


> Second, it adds a guarded_by_mmu_notifier parameter
> that is used to avoid returning non-refcounted pages when the caller
> cannot safely use them.
> 
> Since callers need to be updated on a case-by-case basis to pay
> attention to is_refcounted_page, the new behavior of returning
> non-refcounted pages is opt-in via the allow_non_refcounted_struct_page
> parameter. Once all callers have been updated, this parameter should be
> removed.

Small note: since these new parameters are critical for understanding the patch,
Maybe it makes sense to re-order their description to match the order in the struct 
(or at least put the output parameter at the end of the description),
and give each a separate paragraph as I did above.

> 
> The fact that non-refcounted pfns can no longer be accessed without mmu
> notifier protection is a breaking change. Since there is no timeline for
> updating everything in KVM to use mmu notifiers, this change adds an
> opt-in module parameter called allow_unsafe_mappings to allow such
> mappings. Systems which trust userspace not to tear down such unsafe
> mappings while KVM is using them can set this parameter to re-enable the
> legacy behavior.

Do you have a practical example of a VM that can break with this change?
E.g will a normal VM break? will a VM with VFIO devices break? Will a VM with
hugepages mapped into it break?

Will the trick of limiting the kernel memory with 'mem=X', and then use the 
extra 'upper memory' for VMs still work?

> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  include/linux/kvm_host.h | 21 ++++++++++
>  virt/kvm/kvm_main.c      | 84 ++++++++++++++++++++++++----------------
>  virt/kvm/pfncache.c      |  1 +
>  3 files changed, 72 insertions(+), 34 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c2e0ddf14dba..2ed08ae1a9be 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1185,10 +1185,31 @@ struct kvm_follow_pfn {
>  	bool atomic;
>  	/* Try to create a writable mapping even for a read fault */
>  	bool try_map_writable;
> +	/* Usage of the returned pfn will be guared by a mmu notifier. */
> +	bool guarded_by_mmu_notifier;
> +	/*
> +	 * When false, do not return pfns for non-refcounted struct pages.
> +	 *
> +	 * TODO: This allows callers to use kvm_release_pfn on the pfns
> +	 * returned by gfn_to_pfn without worrying about corrupting the
> +	 * refcounted of non-refcounted pages. Once all callers respect
Typo: refcount.
> +	 * is_refcounted_page, this flag should be removed.
> +	 */
> +	bool allow_non_refcounted_struct_page;
>  
>  	/* Outputs of __kvm_follow_pfn */
>  	hva_t hva;
>  	bool writable;
> +	/*
> +	 * True if the returned pfn is for a page with a valid refcount. False
> +	 * if the returned pfn has no struct page or if the struct page is not
> +	 * being refcounted (e.g. tail pages of non-compound higher order
> +	 * allocations from IO/PFNMAP mappings).
> 
Aren't all tail pages not-refcounted (e.g tail page of a hugepage?)
I haven't researched this topic yet.

> +	 *
> +	 * When this output flag is false, callers should not try to convert
> +	 * the pfn to a struct page.
> +	 */
> +	bool is_refcounted_page;
>  };
>  
>  kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9b33a59c6d65..235c5cb3fdac 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -96,6 +96,10 @@ unsigned int halt_poll_ns_shrink;
>  module_param(halt_poll_ns_shrink, uint, 0644);
>  EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
>  
> +/* Allow non-struct page memory to be mapped without MMU notifier protection. */
> +static bool allow_unsafe_mappings;
> +module_param(allow_unsafe_mappings, bool, 0444);
> +
>  /*
>   * Ordering of locks:
>   *
> @@ -2507,6 +2511,15 @@ static inline int check_user_page_hwpoison(unsigned long addr)
>  	return rc == -EHWPOISON;
>  }
>  
> +static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll,
> +					   struct page *page)
> +{
> +	kvm_pfn_t pfn = page_to_pfn(page);
> +
> +	foll->is_refcounted_page = true;
> +	return pfn;
> +}

Just a matter of taste but to me this function looks confusing.
IMHO, just duplicating these two lines of code is better.
However if you prefer I won't argue over this.

> +
>  /*
>   * The fast path to get the writable pfn which will be stored in @pfn,
>   * true indicates success, otherwise false is returned.  It's also the
> @@ -2525,7 +2538,7 @@ static bool hva_to_pfn_fast(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
>  		return false;
>  
>  	if (get_user_page_fast_only(foll->hva, FOLL_WRITE, page)) {
> -		*pfn = page_to_pfn(page[0]);
> +		*pfn = kvm_follow_refcounted_pfn(foll, page[0]);

Yep, here just 'foll->is_refcounted_page = true;' looks more readable to me.

>  		foll->writable = true;
>  		return true;
>  	}
> @@ -2561,7 +2574,7 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
>  			page = wpage;
>  		}
>  	}
> -	*pfn = page_to_pfn(page);
> +	*pfn = kvm_follow_refcounted_pfn(foll, page);
Same here and probably in other places.
>  	return npages;
>  }
>  
> @@ -2576,16 +2589,6 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
>  	return true;
>  }
>  
> -static int kvm_try_get_pfn(kvm_pfn_t pfn)
> -{
> -	struct page *page = kvm_pfn_to_refcounted_page(pfn);
> -
> -	if (!page)
> -		return 1;
> -
> -	return get_page_unless_zero(page);
> -}
> -
>  static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  			       struct kvm_follow_pfn *foll, kvm_pfn_t *p_pfn)
>  {
> @@ -2594,6 +2597,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  	pte_t pte;
>  	spinlock_t *ptl;
>  	bool write_fault = foll->flags & FOLL_WRITE;
> +	struct page *page;
>  	int r;
>  
>  	r = follow_pte(vma->vm_mm, foll->hva, &ptep, &ptl);
> @@ -2618,37 +2622,39 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  
>  	pte = ptep_get(ptep);
>  
> +	foll->writable = pte_write(pte);
> +	pfn = pte_pfn(pte);
> +
> +	page = kvm_pfn_to_refcounted_page(pfn);
> +
>  	if (write_fault && !pte_write(pte)) {
>  		pfn = KVM_PFN_ERR_RO_FAULT;
>  		goto out;
>  	}
>  
> -	foll->writable = pte_write(pte);
> -	pfn = pte_pfn(pte);
> +	if (!page)
> +		goto out;
>  
> -	/*
> -	 * Get a reference here because callers of *hva_to_pfn* and
> -	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
> -	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
> -	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
> -	 * simply do nothing for reserved pfns.
> -	 *
> -	 * Whoever called remap_pfn_range is also going to call e.g.
> -	 * unmap_mapping_range before the underlying pages are freed,
> -	 * causing a call to our MMU notifier.
> -	 *
> -	 * Certain IO or PFNMAP mappings can be backed with valid
> -	 * struct pages, but be allocated without refcounting e.g.,
> -	 * tail pages of non-compound higher order allocations, which
> -	 * would then underflow the refcount when the caller does the
> -	 * required put_page. Don't allow those pages here.
> -	 */

Why the comment is removed? as far as I see the code still grabs a reference to the page.

> -	if (!kvm_try_get_pfn(pfn))
> -		r = -EFAULT;
> +	if (get_page_unless_zero(page))
> +		WARN_ON_ONCE(kvm_follow_refcounted_pfn(foll, page) != pfn);

Once again, the kvm_follow_refcounted_pfn usage is confusing IMHO. 
It sets the 'foll->is_refcounted_page', and yet someone can think that it's only there for the WARN_ON_ONCE.

That IMHO would read better:

if (get_page_unless_zero(page))
	foll->is_refcounted_page = true;

WARN_ON_ONCE(page_to_pfn(page) != pfn);

Note that I moved the warn out of the 'get_page_unless_zero' condition
because I think that this condition should be true for non refcounted pages as well.

Also I don't understand why 'get_page_unless_zero(page)' result is ignored. As I understand it,
it will increase refcount of a page unless it is zero. 

If a refcount of a refcounted page is 0 isn't that a bug?

The page was returned from kvm_pfn_to_refcounted_page which supposed only to return pages that are refcounted.

I might not understand something in regard to 'get_page_unless_zero(page)' usage both in old and the new code.

>  
>  out:
>  	pte_unmap_unlock(ptep, ptl);
> -	*p_pfn = pfn;
> +
> +	/*
> +	 * TODO: Remove the first branch once all callers have been
> +	 * taught to play nice with non-refcounted struct pages.
> +	 */
> +	if (page && !foll->is_refcounted_page &&
> +	    !foll->allow_non_refcounted_struct_page) {
> +		r = -EFAULT;
> +	} else if (!foll->is_refcounted_page &&
> +		   !foll->guarded_by_mmu_notifier &&
> +		   !allow_unsafe_mappings) {
> +		r = -EFAULT;
> +	} else {
> +		*p_pfn = pfn;
> +	}
>  
>  	return r;
>  }
> @@ -2722,6 +2728,8 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *foll)
>  kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
>  {
>  	foll->writable = false;
> +	foll->is_refcounted_page = false;
> +
>  	foll->hva = __gfn_to_hva_many(foll->slot, foll->gfn, NULL,
>  				      foll->flags & FOLL_WRITE);
>  
> @@ -2749,6 +2757,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>  		.flags = 0,
>  		.atomic = atomic,
>  		.try_map_writable = !!writable,
> +		.allow_non_refcounted_struct_page = false,
>  	};
>  
>  	if (write_fault)
> @@ -2780,6 +2789,7 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>  		.gfn = gfn,
>  		.flags = write_fault ? FOLL_WRITE : 0,
>  		.try_map_writable = !!writable,
> +		.allow_non_refcounted_struct_page = false,
>  	};
>  	pfn = __kvm_follow_pfn(&foll);
>  	if (writable)
> @@ -2794,6 +2804,7 @@ kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
>  		.slot = slot,
>  		.gfn = gfn,
>  		.flags = FOLL_WRITE,
> +		.allow_non_refcounted_struct_page = false,
>  	};
>  	return __kvm_follow_pfn(&foll);
>  }
> @@ -2806,6 +2817,11 @@ kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gf
>  		.gfn = gfn,
>  		.flags = FOLL_WRITE,
>  		.atomic = true,
> +		/*
> +		 * Setting atomic means __kvm_follow_pfn will never make it
> +		 * to hva_to_pfn_remapped, so this is vacuously true.
> +		 */
> +		.allow_non_refcounted_struct_page = true,
>  	};
>  	return __kvm_follow_pfn(&foll);
>  }
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 86cd40acad11..6bbf972c11f8 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -149,6 +149,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  		.gfn = gpa_to_gfn(gpc->gpa),
>  		.flags = FOLL_WRITE,
>  		.hva = gpc->uhva,
> +		.allow_non_refcounted_struct_page = false,
>  	};
>  
>  	lockdep_assert_held(&gpc->refresh_lock);


Best regards,
	Maxim Levitsky






