Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453711AA8B
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 22:13:30 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bb982d2572so22438295ad.0
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 15:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691187209; x=1691792009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLXEZoOUsnNHXqyjOtZVO1kviAvs7+VEh7RjIbw2pVY=;
        b=JGKdP0TBOoAh4OTz3MaM2IVM7DNxpwffVrtvvm9L1o79RXyJJAtpHpBOvSgcwNdZX2
         vHXD6HINgJiiuqhmdNnnwrsvRAC5uXwbr4/yFPm5W55eHiXmAAQ+azo922WuaMeEHnwD
         GcFXe8chvE/OJA1hk3iiLxhDb/q7nW0Opovw9JghaSBACG/CIL++au9Wf+Sy6uFggGsS
         74vZWjiO8jTtvZQNWHk13gz+ww0O0agOHpetcqnEEQg/505syvmAKoAo9UvZQ01kgz/A
         ieoG4BvFz3Fl52WQpDm7sIF/AxiRpURNb8XYluL3Y4LD+4Ket+eZh1V3em5Ru9tcVeVD
         Cscg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691187209; x=1691792009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bLXEZoOUsnNHXqyjOtZVO1kviAvs7+VEh7RjIbw2pVY=;
        b=e1Pby6lUrs29GIjEtqGcZryDHqGmpxsddHC0uwqjyM1WNPb+AXdtpPtKCG1qy1B/fB
         nPDRb2S8psd7RrnUHtiy2SKnPzSrpVdWTxPh5smsQCRl48wkQEUJXk+eCKI0jSe3yFQE
         XXK4qradjWyXZpSSgbH1p+Dg0BadVV/HUDYUxJlznzVckXrj6DyjQPvORmhCFkTvsJXW
         zeAHCjdsGJNGnavFIg+UWyW3dCHzHvrHMnWBa32zNyFkFRDtk6AmZWlLkxVS66lvCuO7
         n1WFgsHEYZ01DD0f46U1aia2I6ulGcx0peCyMn4AZFWjc7Dbd/9tTHtHmGLZUn3fV2ss
         rAUg==
X-Gm-Message-State: AOJu0Yxtfnj2BEYWQvm+MC/HTSSc3+bsJ/IAva8Z92M8mUD2a67zrw/t
	4MteXZ1SqbHu9XnVv9WdmHgWJjLqfR8=
X-Google-Smtp-Source: AGHT+IFFa6OQWPgXCVghPOvFrLXoLg027dv5kKy0zEJuMmkaxG1AU5Kgm6Ipp0dVxLufrqFjcx7hU8Umd6E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2448:b0:1b8:3c5e:2289 with SMTP id
 l8-20020a170903244800b001b83c5e2289mr9543pls.2.1691187209565; Fri, 04 Aug
 2023 15:13:29 -0700 (PDT)
Date: Fri, 4 Aug 2023 15:13:28 -0700
In-Reply-To: <20230704075054.3344915-3-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-3-stevensd@google.com>
Message-ID: <ZM14CHeY4DvjAlqG@google.com>
Subject: Re: [PATCH v7 2/8] KVM: Introduce __kvm_follow_pfn function
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 04, 2023, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Introduce __kvm_follow_pfn, which will replace __gfn_to_pfn_memslot.
> __kvm_follow_pfn refactors the old API's arguments into a struct and,
> where possible, combines the boolean arguments into a single flags
> argument.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  include/linux/kvm_host.h |  16 ++++
>  virt/kvm/kvm_main.c      | 171 ++++++++++++++++++++++-----------------
>  virt/kvm/kvm_mm.h        |   3 +-
>  virt/kvm/pfncache.c      |   8 +-
>  4 files changed, 122 insertions(+), 76 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9d3ac7720da9..ef2763c2b12e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -97,6 +97,7 @@
>  #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
>  #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
>  #define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
> +#define KVM_PFN_ERR_NEEDS_IO	(KVM_PFN_ERR_MASK + 4)

Hmm, ideally KVM_PFN_ERR_NEEDS_IO would be introduced in a separate prep patch,
e.g. by changing "bool *async" to "bool no_wait".  At a glance, I can't tell if
that's feasible though, so consider it more of a "wish" than a request.

> @@ -2572,23 +2561,23 @@ static int kvm_try_get_pfn(kvm_pfn_t pfn)
>  	return get_page_unless_zero(page);
>  }
>  
> -static int hva_to_pfn_remapped(struct vm_area_struct *vma,
> -			       unsigned long addr, bool write_fault,
> -			       bool *writable, kvm_pfn_t *p_pfn)
> +static int hva_to_pfn_remapped(struct vm_area_struct *vma, struct kvm_follow_pfn *foll,
> +			       kvm_pfn_t *p_pfn)

Please wrap.  KVM still honors the 80 char soft limit unless there's a reason not
to, and in this case it's already wrapping

static int hva_to_pfn_remapped(struct vm_area_struct *vma,
			       struct kvm_follow_pfn *foll, kvm_pfn_t *p_pfn)

> @@ -2606,8 +2595,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  		goto out;
>  	}
>  
> -	if (writable)
> -		*writable = pte_write(*ptep);
> +	foll->writable = pte_write(*ptep) && foll->allow_write_mapping;

Similar to feedback in my other response, don't condition this on try_map_writable,
i.e. just do:

	foll->writable = pte_write(...);

>  	pfn = pte_pfn(*ptep);
>  
>  	/*
> @@ -2652,24 +2640,22 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   * 2): @write_fault = false && @writable, @writable will tell the caller
>   *     whether the mapping is writable.
>   */
> -kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
> -		     bool *async, bool write_fault, bool *writable)
> +kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *foll)
>  {
>  	struct vm_area_struct *vma;
>  	kvm_pfn_t pfn;
>  	int npages, r;
>  
>  	/* we can do it either atomically or asynchronously, not both */
> -	BUG_ON(atomic && async);
> +	BUG_ON(foll->atomic && (foll->flags & FOLL_NOWAIT));
>  
> -	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
> +	if (hva_to_pfn_fast(foll, &pfn))
>  		return pfn;
>  
> -	if (atomic)
> +	if (foll->atomic)
>  		return KVM_PFN_ERR_FAULT;
>  
> -	npages = hva_to_pfn_slow(addr, async, write_fault, interruptible,
> -				 writable, &pfn);
> +	npages = hva_to_pfn_slow(foll, &pfn);
>  	if (npages == 1)
>  		return pfn;
>  	if (npages == -EINTR)
> @@ -2677,83 +2663,122 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
>  
>  	mmap_read_lock(current->mm);
>  	if (npages == -EHWPOISON ||
> -	      (!async && check_user_page_hwpoison(addr))) {
> +	      (!(foll->flags & FOLL_NOWAIT) && check_user_page_hwpoison(foll->hva))) {

Opportunistically align the indentation, as an added bonus that makes the line
length a few chars shorter, i.e.

	if (npages == -EHWPOISON ||
	    (!(foll->flags & FOLL_NOWAIT) && check_user_page_hwpoison(foll->hva))) {
		pfn = KVM_PFN_ERR_HWPOISON;
		goto exit;
	}
