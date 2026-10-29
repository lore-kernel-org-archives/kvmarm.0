Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290458;
	b=R9AhtihwUIW+Lbl+gDV2kzyaS8uzsHVDjG4gb/Jjn/tCBIKUieDJZi6QYSeDAIqXwPhW
	 QUUKgsZS5itNAHp2yh+5nUGBQzjgUIrn/xQjZ7abnrRcUN3yAPjhMAVR9ZRX19b2KyAsQ
	 wRxkOf+Oq4O1RcdtjqMxjHg6X9pe7BeJK32G/ZxJfNxXMVuFjspxu9aRTLItDLkVfNqy4
	 odoHmFK1qC8LwCtVn03761UjK3Hrc6Drc23ub74/OimfC3bgCSW23ZB5KyuEaTs9udQ1v
	 FT1WzSMnVYqcs5AbKF7YmnewSmI6EUYmAykmo72hIxXVmMp+eiMt4MMnACehWxdtVCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290458;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=PoVbrwCfEjEF6sp4WaMxqKx0B+uh55PhpThxxt4vZZ4=;
	b=R5UUBQJo7QxK1eqn5xZteFvsLi2eTYGcg3oVe2/LlOKiBHVp+jSnHJg/4gYbJ40BKV2f
	 UDU/VVN4Tgs8DXBYbleWcn05kS0AWgqLdKcOpMdeKFMtvfnn7lu2ta9Jq8Un/7QWubOYG
	 Jzg6c0/suE3uH/6Yu2CkLmFhTLkajGlkAOC6X46TLhRmwqK2rEf7p1q+fvYMYgDFbfWvA
	 mwxOEEGAHM7Dri4nGA+7wr8MWPBMkDRfSRoCR7etXUiFw5xFE3wS1dVUhpGVTRu3L5e1n
	 ELVIIMiVQr+9aXVvLC06yISwP4YXKu3IKR0DqcYn/4M7+zrVbk6JQKo9O+1haotSq+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=N2iJzd2X;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50808606A31A
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 16:14:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50808606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=N2iJzd2X
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so25984255e9.2
        for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 09:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793290457; x=1793895257; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PoVbrwCfEjEF6sp4WaMxqKx0B+uh55PhpThxxt4vZZ4=;
        b=N2iJzd2XjGTIbQrbp0fFLvz6s4jUJSDsFgVG11hGEqqeV9HS9vSHoResEJdJETv8KU
         cQgOmR/1xS9qk1nD/uqUFgfyXNye3tOmKZGOcqjq9qMByFQ3D4mhzi6lej4BZsv8susQ
         50vymkDJ21i8Bp43/oslpqiejNU8hYAtNJ2Uztq2swJvCqSjC/eeemAIis58aBW4lZ3k
         Ylbvsrb5aO5s9Z5ony5tGqR2QuSjUr+ViY0WhM3rayv88O0iCrx9UShogcaitZRDwFYo
         3clbcYVa0oWy/83+u7eEwjE24r2h+Gva17V/VwSpuaA9HKHhwtseXRbiQap52i2wbO24
         TJUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793290457; x=1793895257;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PoVbrwCfEjEF6sp4WaMxqKx0B+uh55PhpThxxt4vZZ4=;
        b=kNIbp3WODV4OgSWAVp+BVi4raJqjI6BIUxjnXnRYQ/dpVdoxbySZ/r0OQ/2RdZNTdi
         DEUSp1zumUmOdZAXKtBxreZFicXQZimRxNoP8itHL+tozbkfxznZFxaSn+/iqky77qGB
         oufLszP9ARsI0CRxnVNNJA7sLlxiLxK2/xkGHXqUNQRVYnh6b2L848RE/Cgctdx4jetm
         tSqoPQCtNca4aopQUgXA7QjijMSihfaXVXNqqiYmhp4CNaxnGU+Uo1YU+DSCQJomdi0t
         djHWLqyADjXpFt6XyYJ4jEEBgRFu0gUFbwEqTTmYLBIcXe9GcNit3XSoJYJXEs2VN9GO
         G+iQ==
X-Forwarded-Encrypted: i=1; AKwUvBxGvY5eeUvtBfGsOSjpIU1nHhj33wiPBYITUxvRrrcjaiH3iwJ/IZqEhGWrxGSVobTG8R5irH0=@lists.linux.dev
X-Gm-Message-State: AFq9FYIifW//9+56FBBrqZ1t3OapG/KIEFf86MfUnL61ooWOkyY3iK2T
	jrXCDjyboXSQkVwMJLctYfNUeyVaXAqGddx7viogqRTeNlY9dXqOMAq3xEshv7RexSh27RpEKoD
	A1+hhEQ==
X-Gm-Gg: AYBFou0PcxbiI6hKOjQJ/85U4s/MxGYVGCaxmw0Y8PBi1+qD2NcJQgvcmfb0Q019WIW
	8SKTyx0KnNmefdCl1v4qL2zi8+4cjTvjgR7MIntoiIPgO3CTex0VZx6yd0xwYMX8Hmyyct5D1O8
	lHqxFLd/VOOuJIRVJt3I7dzFoGJkEckG3vKx7V8l40hKoHUwqvT8opbQYJqpk7EM5F5WgU7N4JP
	M0GnFx28XoVPPKDsWz3S/A+9iW7ZKhVCQTHozNKuMbNud8VgbwDlxARpfFvl68EHqGL+7F7qrQi
	vNDeZ3I+1wqP1ONEFH47oNnLc7YH1P9pxXumgtYJFrDlbKAmU5rPeoeYtfsMtVl/24GocwL3ed1
	++nA2Q1dvm6DKtqJ8b89wb/GQjzaOZRqAD4fiFSqqEL0+gtaxhEEg1RFh1en8srWzlykp5R1WlT
	LzQAud9cQhuzqeh0RYftjt7ANROZQzjVdgGDH7yC60e1QWCGV5o/kGpLbfQvBBccS9qdd9v+mjf
	fSIoeeSbGjmbfJoO0iaTY4j993MAECf1BX7xCcFcOxOu6GV/hCAfvGJjyuL4CGX5bay84vCc0Tl
	/jOMqvZR8fwAlEigfYuua6LbajBVMMVIYjceBsVszfmFMyeQRkHun1AzLmZLZcCXVw==
X-Received: by 2002:a05:600c:1913:b0:4a2:1655:87db with SMTP id 5b1f17b1804b1-4a96552db88mr133139285e9.0.1793290456110;
        Thu, 29 Oct 2026 09:14:16 -0700 (PDT)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a930a63eb3sm118585755e9.1.2026.10.29.09.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 09:14:14 -0700 (PDT)
Date: Thu, 29 Oct 2026 16:14:10 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com, weilin.chang@arm.com, tabba@google.com
Subject: Re: [PATCH v2 22/22] KVM: arm64: Stage-2 huge mappings for protected
 VMs
Message-ID: <auNw0iXzwKkOSJAa@google.com>
References: <20260911135053.146435-1-vdonnefort@google.com>
 <20260911135053.146435-23-vdonnefort@google.com>
 <20261029152959.3552746-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029152959.3552746-1-fuad.tabba@linux.dev>

On Thu, Oct 29, 2026 at 03:29:59PM +0000, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Fri, 11 Sep 2026 14:50:53 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
> [...]
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> [...]
> > @@ -513,17 +512,23 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> [...]
> > +                /*
> > +                 * If a huge mapping overlaps an existing PAGE_SIZE one,
> > +                 * then the VMM has played games with the stage-1. Abort.
> > +                 */
> > +                if (WARN_ON_ONCE(mapping && mapping->nr_pages == 1 && size > PAGE_SIZE))
> > +                        return -EFAULT;
> 
> A guest can hit this on its own, without the VMM touching its stage-1.
> I ran into it while porting your unposted v3 to android18-7.3, and v3
> has the same race. A pVM shares one page of a 2M block, and another
> vCPU touches the block during the split's break-before-make. The host
> sizes that fault at 2M from the THP, but under the mmu_lock it finds
> the split's PAGE_SIZE mappings.

Nice catch!

> 
> I made the following change in the android18-7.3 port. It maps just
> the faulting page, since retrying alone re-faults forever if the VMM
> puts a fresh THP behind a partly mapped block. If you're happy with it,
> can you fold it into v3?
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 70b002eb17e05..72fc2577f51cd 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1921,6 +1921,7 @@ static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  	struct mm_struct *mm = current->mm;
>  	struct kvm *kvm = vcpu->kvm;
>  	void *hyp_memcache;
> +	u64 size;
>  	int ret;
>  
>  	hyp_memcache = get_mmu_memcache(vcpu);
> @@ -1936,13 +1937,21 @@ static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  	if (ret)
>  		goto unpin;
>  
> +	size = s2vi.vma_pagesize;
>  	kvm_fault_lock(kvm);
>  	if (mmu_invalidate_retry(kvm, s2vi.mmu_seq)) {
>  		ret = -EAGAIN;
>  	} else {
> -		ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(s2vi.gfn), s2vi.vma_pagesize,
> +		ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(s2vi.gfn), size,
>  					      __pfn_to_phys(s2vi.pfn), KVM_PGTABLE_PROT_RWX,
>  					      hyp_memcache, 0);
> +		/* The block may hold PAGE_SIZE mappings from a split: map the page alone. */
> +		if (ret == -EAGAIN && size > PAGE_SIZE) {
> +			size = PAGE_SIZE;
> +			ret = pkvm_pgtable_stage2_map(pgt, ALIGN_DOWN(s2fd->fault_ipa, size), size,
> +						      page_to_phys(s2vi.page), KVM_PGTABLE_PROT_RWX,
> +						      hyp_memcache, 0);
> +		}

I do not believe the retry does anything, this would just hit the "if (mapping)"
path in pkvm_pgtable_stage2_map().

And in any case, the split will remap the entire range at PTE-level. This is
just transient and it is safe to return EAGAIN.

To keep the return -EFAULT, I could eventually mark the mapping as "split in
progress". 

-- 
Vincent

>  	}
>  	kvm_fault_unlock(kvm);
>  	if (ret) {
> @@ -1953,6 +1962,9 @@ static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  		goto unpin;
>  	}
>  
> +	if (size != s2vi.vma_pagesize)
> +		account_locked_vm(mm, (s2vi.vma_pagesize - size) / PAGE_SIZE, false);
> +
>  	return 0;
>  unpin:
>  	unpin_user_page(s2vi.page);
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8a74df9f9fec3..6b5df4595f6a6 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -650,14 +650,8 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  			return -EINVAL;
>  
>  		/*
> -		 * If a huge mapping overlaps an existing PAGE_SIZE one,
> -		 * then the VMM has played games with the stage-1. Abort.
> -		 */
> -		if (WARN_ON_ONCE(mapping && mapping->nr_pages == 1 && size > PAGE_SIZE))
> -			return -EFAULT;
> -
> -		/*
> -		 * We either raced with another vCPU or the guest PTE
> +		 * We either raced with another vCPU, a block overlaps the
> +		 * PAGE_SIZE mappings of a guest-driven split, or the guest PTE
>  		 * has been poisoned by an erroneous host access.
>  		 */
>  		if (mapping) {
> 
> Cheers,
> /fuad

