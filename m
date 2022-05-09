Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AEEC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 16:48:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 627164B2E9;
	Mon,  9 May 2022 12:48:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OJlYRLnd-CAZ; Mon,  9 May 2022 12:48:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06DDD4B2F5;
	Mon,  9 May 2022 12:48:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC84E4B2E9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:48:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8qMqlUi6ivmA for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 12:48:18 -0400 (EDT)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 079A84B2DE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:48:17 -0400 (EDT)
Received: by mail-pg1-f171.google.com with SMTP id l11so6959310pgt.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 09:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=gr9sMVs6ZdL8g3tPzoqOfbfxtZ+VfAYj0GG/Lu5p3Do=;
 b=OjZ2kHgAm+ILSkIUJhTMWyTvLuftdyN9Kyi5pPlToUr2VbBgQzqMUvubbcjgcNoEKY
 MXYEnQTNZicEPklzohiMYBm+qP9+SYEduyruz2LNwSpo+USrM27as+qWNBIgYtxEZv5E
 WCmCreQKrqgSdfsvR/pMxVBm6RrS8hxwl8b9+Cjrp61ynKE00Ia3w6w1K1uFIobv4dQQ
 aIQZvwYL+FUa1nMowwvnlDaTET5kDXKgRwzA5TOMmAPfdQZPb2aF9agEBMF5V2C8abWU
 PvaYjtBfEYbtDRS/ZncAjUhNAsBBXlyVm4pIymLVH7kh51QXIiMLGjEHljjUysN1gQ0O
 g5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gr9sMVs6ZdL8g3tPzoqOfbfxtZ+VfAYj0GG/Lu5p3Do=;
 b=O48qXns2Jfo9CDC47Cilhf2WtTo7R9x2mte1wN1ikQeX7mvw+Cc1i2y72DhskGIRwA
 CT33MUJtWxPb+bxnoRGR/GdBu6QU9gryX9xDMCTlKIFTHBg65lSYr11tiWvm4PscQUrz
 LmFnFtO7g1jLMKRqZU4IbxBztgqB48fkTtDdk0c4VkIImgMa/5pQpgM5vIAzXDgmasZl
 SvB5utLN3z2/Xs+yF5etRmItQ+/ewkFKbIzKhiKVWfvxuX+7m1hv8RDDrqGX81gUISYj
 2mimEqgkuNBemlP2Ed5c4PYJu8kc40j+X+d3G7MuXoy7VHyOwI02lOOQRj0Kn7sVE3oL
 13tQ==
X-Gm-Message-State: AOAM531ZRU9KNUnLiF1mcf9UXRbgWs14vq4JNYjMamLIP1k7yHzzDLvO
 DRDJxZGTKcjXkHvVsX9vPlVVGQ==
X-Google-Smtp-Source: ABdhPJx215vrOO009vGUpGxw2kjUjvEvzUv6r8zkab3Hrf61cs9pR1cmpHEArZYDJKlr8poCIJHRbg==
X-Received: by 2002:a05:6a00:1391:b0:50d:e125:e3c with SMTP id
 t17-20020a056a00139100b0050de1250e3cmr16967062pfg.75.1652114896725; 
 Mon, 09 May 2022 09:48:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 r7-20020a17090b050700b001d2bff34228sm12911467pjz.9.2022.05.09.09.48.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 09:48:16 -0700 (PDT)
Date: Mon, 9 May 2022 16:48:12 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 20/20] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
Message-ID: <YnlFzMpJZNfFuFic@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-21-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-21-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Fri, Apr 22, 2022, David Matlack wrote:
> +static bool need_topup_split_caches_or_resched(struct kvm *kvm)
> +{
> +	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> +		return true;
> +
> +	/*
> +	 * In the worst case, SPLIT_DESC_CACHE_CAPACITY descriptors are needed
> +	 * to split a single huge page. Calculating how many are actually needed
> +	 * is possible but not worth the complexity.
> +	 */
> +	return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_CAPACITY) ||
> +		need_topup(&kvm->arch.split_page_header_cache, 1) ||
> +		need_topup(&kvm->arch.split_shadow_page_cache, 1);

Uber nit that Paolo will make fun of me for... please align indentiation

	return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_CAPACITY) ||
	       need_topup(&kvm->arch.split_page_header_cache, 1) ||
	       need_topup(&kvm->arch.split_shadow_page_cache, 1);

> +static void nested_mmu_split_huge_page(struct kvm *kvm,
> +				       const struct kvm_memory_slot *slot,
> +				       u64 *huge_sptep)
> +
> +{
> +	struct kvm_mmu_memory_cache *cache = &kvm->arch.split_desc_cache;
> +	u64 huge_spte = READ_ONCE(*huge_sptep);
> +	struct kvm_mmu_page *sp;
> +	bool flush = false;
> +	u64 *sptep, spte;
> +	gfn_t gfn;
> +	int index;
> +
> +	sp = nested_mmu_get_sp_for_split(kvm, huge_sptep);
> +
> +	for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
> +		sptep = &sp->spt[index];
> +		gfn = kvm_mmu_page_get_gfn(sp, index);
> +
> +		/*
> +		 * The SP may already have populated SPTEs, e.g. if this huge
> +		 * page is aliased by multiple sptes with the same access
> +		 * permissions. These entries are guaranteed to map the same
> +		 * gfn-to-pfn translation since the SP is direct, so no need to
> +		 * modify them.
> +		 *
> +		 * However, if a given SPTE points to a lower level page table,
> +		 * that lower level page table may only be partially populated.
> +		 * Installing such SPTEs would effectively unmap a potion of the
> +		 * huge page, which requires a TLB flush.

Maybe explain why a TLB flush is required?  E.g. "which requires a TLB flush as
a subsequent mmu_notifier event on the unmapped region would fail to detect the
need to flush".

> +static bool nested_mmu_skip_split_huge_page(u64 *huge_sptep)

"skip" is kinda odd terminology.  It reads like a command, but it's actually
querying state _and_ it's returning a boolean, which I've learned to hate :-)

I don't see any reason for a helper, there's one caller and it can just do
"continue" directly.

> +static void kvm_nested_mmu_try_split_huge_pages(struct kvm *kvm,
> +						const struct kvm_memory_slot *slot,
> +						gfn_t start, gfn_t end,
> +						int target_level)
> +{
> +	int level;
> +
> +	/*
> +	 * Split huge pages starting with KVM_MAX_HUGEPAGE_LEVEL and working
> +	 * down to the target level. This ensures pages are recursively split
> +	 * all the way to the target level. There's no need to split pages
> +	 * already at the target level.
> +	 */
> +	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {

Unnecessary braces.
> +		slot_handle_level_range(kvm, slot,
> +					nested_mmu_try_split_huge_pages,
> +					level, level, start, end - 1,
> +					true, false);

IMO it's worth running over by 4 chars to drop 2 lines:

	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--)
		slot_handle_level_range(kvm, slot, nested_mmu_try_split_huge_pages,
					level, level, start, end - 1, true, false);
> +	}
> +}
> +
>  /* Must be called with the mmu_lock held in write-mode. */

Add a lockdep assertion, not a comment.

>  void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
>  				   const struct kvm_memory_slot *memslot,
>  				   u64 start, u64 end,
>  				   int target_level)
>  {
> -	if (is_tdp_mmu_enabled(kvm))
> -		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end,
> -						 target_level, false);
> +	if (!is_tdp_mmu_enabled(kvm))
> +		return;
> +
> +	kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level,
> +					 false);
> +
> +	if (kvm_memslots_have_rmaps(kvm))
> +		kvm_nested_mmu_try_split_huge_pages(kvm, memslot, start, end,
> +						    target_level);
>  
>  	/*
>  	 * A TLB flush is unnecessary at this point for the same resons as in
> @@ -6051,10 +6304,19 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
>  	u64 start = memslot->base_gfn;
>  	u64 end = start + memslot->npages;
>  
> -	if (is_tdp_mmu_enabled(kvm)) {
> -		read_lock(&kvm->mmu_lock);
> -		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
> -		read_unlock(&kvm->mmu_lock);
> +	if (!is_tdp_mmu_enabled(kvm))
> +		return;
> +
> +	read_lock(&kvm->mmu_lock);
> +	kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level,
> +					 true);

Eh, let this poke out.

> +	read_unlock(&kvm->mmu_lock);
> +
> +	if (kvm_memslots_have_rmaps(kvm)) {
> +		write_lock(&kvm->mmu_lock);
> +		kvm_nested_mmu_try_split_huge_pages(kvm, memslot, start, end,
> +						    target_level);
> +		write_unlock(&kvm->mmu_lock);

Super duper nit: all other flows do rmaps first, than TDP MMU.  Might as well keep
that ordering here, otherwise it suggests there's a reason to be different.

>  	}
>  
>  	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ab336f7c82e4..e123e24a130f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12161,6 +12161,12 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  		 * page faults will create the large-page sptes.
>  		 */
>  		kvm_mmu_zap_collapsible_sptes(kvm, new);
> +
> +		/*
> +		 * Free any memory left behind by eager page splitting. Ignore
> +		 * the module parameter since userspace might have changed it.
> +		 */
> +		free_split_caches(kvm);
>  	} else {
>  		/*
>  		 * Initially-all-set does not require write protecting any page,
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
