Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9DF1FB3
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 09:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677835109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sH2JqYPZ72K/fD4ADkmh64fq850ONlMkcsoAn8MjRKo=;
	b=bWQM89FgGywhLzt5mcQVaYXE4zaovgpdf7fqr7fbzcNRTD2H5bCWjKdjl2NOjQ3vfBMHGy
	hc1e4xbxl0fVNxujGI256x54r6GoF31Wxiy6Kg8BvzsaXLS+/S6uh2kdFO3aUrWmwYEW9i
	HvV2vUArwycUyAJMbgptn48B6S6Mcvg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-p4FIRYTbOumbufbcVjDiFQ-1; Fri, 03 Mar 2023 04:18:28 -0500
X-MC-Unique: p4FIRYTbOumbufbcVjDiFQ-1
Received: by mail-qk1-f199.google.com with SMTP id s21-20020a05620a0bd500b0074234f33f24so1008286qki.3
        for <kvmarm@lists.linux.dev>; Fri, 03 Mar 2023 01:18:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677835108;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sH2JqYPZ72K/fD4ADkmh64fq850ONlMkcsoAn8MjRKo=;
        b=8JUriUwGsu/la7VRUqQjOpfyucswWpnA3Ur+GDzBgdA/7jNea2GwUazGjulCKLf8UX
         6E68Zn6PA4dhkhcYPqQPNZh18f8sj03Ei14zLhla9Wl4PgYdSdyJf3z36Ocn0gV17c37
         FeVNAXsKEIaxnepCPFu1C6kj28Hzlf/+GPTnhP2suULBlUzEARyXQlgWPHzlwINQA4Ym
         T4r5avsGe4kiGq/+d7+f3WcWZiMNikoJgIn/kZtYwX+QYB5NLh7Giwom8MoRVIZLs6H9
         jd13gpgqdhvV9JXClN+i9R9o8MlmrP9rz6ueu25ILWat8ynOfFRfOmi51nGAlcMhfVp0
         9zKQ==
X-Gm-Message-State: AO0yUKXg905Q25Y+xMBEj4SGHd0OSbOpJEjH+6iwqev6ayRdBN1ZcZZY
	VzvQ/0cUhpGPPwd1sksAR9ERAQe+cyL1hhPTW9nc4iSjdmfuLJnxOXvezaSX2ZosSw1759CLGTC
	hdA3IIHLh4bVCRJ9q
X-Received: by 2002:ac8:5b08:0:b0:3bf:cc1b:9512 with SMTP id m8-20020ac85b08000000b003bfcc1b9512mr1807998qtw.1.1677835108050;
        Fri, 03 Mar 2023 01:18:28 -0800 (PST)
X-Google-Smtp-Source: AK7set907rpSPywLzRpF47/fD9+RrDG35FFSi83hXF2iJFEg18XVxS5nbEcBZ1bh2eQHXn1YtqLZmw==
X-Received: by 2002:ac8:5b08:0:b0:3bf:cc1b:9512 with SMTP id m8-20020ac85b08000000b003bfcc1b9512mr1807968qtw.1.1677835107786;
        Fri, 03 Mar 2023 01:18:27 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v25-20020ac87499000000b003bfc0cca1b7sm1385309qtq.49.2023.03.03.01.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:18:27 -0800 (PST)
Message-ID: <82a94e5a-42c4-39ed-7751-d6d6da60d920@redhat.com>
Date: Fri, 3 Mar 2023 17:18:19 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 09/12] KVM: arm64: Split huge pages when dirty logging
 is enabled
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-10-ricarkol@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-10-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/23 05:09, Ricardo Koller wrote:
> Split huge pages eagerly when enabling dirty logging. The goal is to
> avoid doing it while faulting on write-protected pages, which
> negatively impacts guest performance.
> 
> A memslot marked for dirty logging is split in 1GB pieces at a time.
> This is in order to release the mmu_lock and give other kernel threads
> the opportunity to run, and also in order to allocate enough pages to
> split a 1GB range worth of huge pages (or a single 1GB huge page).
> Note that these page allocations can fail, so eager page splitting is
> best-effort.  This is not a correctness issue though, as huge pages
> can still be split on write-faults.
> 
> The benefits of eager page splitting are the same as in x86, added
> with commit a3fe5dbda0a4 ("KVM: x86/mmu: Split huge pages mapped by
> the TDP MMU when dirty logging is enabled"). For example, when running
> dirty_log_perf_test with 64 virtual CPUs (Ampere Altra), 1GB per vCPU,
> 50% reads, and 2MB HugeTLB memory, the time it takes vCPUs to access
> all of their memory after dirty logging is enabled decreased by 44%
> from 2.58s to 1.42s.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/mmu.c | 118 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 116 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e2ada6588017..20458251c85e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -31,14 +31,21 @@ static phys_addr_t hyp_idmap_vector;
>   
>   static unsigned long io_map_base;
>   
> -static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> +static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
> +					   phys_addr_t size)
>   {
> -	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
>   	phys_addr_t boundary = ALIGN_DOWN(addr + size, size);
>   
>   	return (boundary - 1 < end - 1) ? boundary : end;
>   }
>   
> +static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> +{
> +	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
> +
> +	return __stage2_range_addr_end(addr, end, size);
> +}
> +
>   /*
>    * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
>    * we may see kernel panics with CONFIG_DETECT_HUNG_TASK,
> @@ -71,6 +78,77 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
>   	return ret;
>   }
>   
> +static bool need_topup_split_page_cache_or_resched(struct kvm *kvm, uint64_t min)
> +{
> +	struct kvm_mmu_memory_cache *cache;
> +
> +	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> +		return true;
> +
> +	cache = &kvm->arch.mmu.split_page_cache;
> +	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
> +}
> +
> +/*
> + * Get the maximum number of page-tables needed to split a range of
> + * blocks into PAGE_SIZE PTEs. It assumes the range is already mapped
> + * at the PMD level, or at the PUD level if allowed.
> + */
> +static int kvm_mmu_split_nr_page_tables(u64 range)
> +{
> +	int n = 0;
> +
> +	if (KVM_PGTABLE_MIN_BLOCK_LEVEL < 2)
> +		n += DIV_ROUND_UP_ULL(range, PUD_SIZE);
> +	n += DIV_ROUND_UP_ULL(range, PMD_SIZE);
> +	return n;
> +}
> +
> +static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
> +				    phys_addr_t end)
> +{
> +	struct kvm_mmu_memory_cache *cache;
> +	struct kvm_pgtable *pgt;
> +	int ret;
> +	u64 next;
> +	u64 chunk_size = kvm->arch.mmu.split_page_chunk_size;
> +	int cache_capacity = kvm_mmu_split_nr_page_tables(chunk_size);
> +
> +	if (chunk_size == 0)
> +		return 0;
> +
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	cache = &kvm->arch.mmu.split_page_cache;
> +
> +	do {
> +		if (need_topup_split_page_cache_or_resched(kvm,
> +							   cache_capacity)) {
> +			write_unlock(&kvm->mmu_lock);
> +			cond_resched();
> +			/* Eager page splitting is best-effort. */
> +			ret = __kvm_mmu_topup_memory_cache(cache,
> +							   cache_capacity,
> +							   cache_capacity);
> +			write_lock(&kvm->mmu_lock);
> +			if (ret)
> +				break;
> +		}
> +
> +		pgt = kvm->arch.mmu.pgt;
> +		if (!pgt)
> +			return -EINVAL;
> +
> +		next = __stage2_range_addr_end(addr, end, chunk_size);
> +		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr,
> +					       cache, cache_capacity);
> +		if (ret)
> +			break;
> +	} while (addr = next, addr != end);
> +
> +	return ret;
> +}
> +
>   #define stage2_apply_range_resched(kvm, addr, end, fn)			\
>   	stage2_apply_range(kvm, addr, end, fn, true)
>   
> @@ -772,6 +850,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   void kvm_uninit_stage2_mmu(struct kvm *kvm)
>   {
>   	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>   }
>   
>   static void stage2_unmap_memslot(struct kvm *kvm,
> @@ -999,6 +1078,31 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>   	stage2_wp_range(&kvm->arch.mmu, start, end);
>   }
>   
> +/**
> + * kvm_mmu_split_memory_region() - split the stage 2 blocks into PAGE_SIZE
> + *				   pages for memory slot
> + * @kvm:	The KVM pointer
> + * @slot:	The memory slot to split
> + *
> + * Acquires kvm->mmu_lock. Called with kvm->slots_lock mutex acquired,
> + * serializing operations for VM memory regions.
> + */
> +static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
> +{
> +	struct kvm_memslots *slots = kvm_memslots(kvm);
> +	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
> +	phys_addr_t start, end;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	start = memslot->base_gfn << PAGE_SHIFT;
> +	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
> +
> +	write_lock(&kvm->mmu_lock);
> +	kvm_mmu_split_huge_pages(kvm, start, end);
> +	write_unlock(&kvm->mmu_lock);
> +}
> +
>   /*
>    * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
>    * dirty pages.
> @@ -1790,6 +1894,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   			return;
>   
>   		kvm_mmu_wp_memory_region(kvm, new->id);
> +		kvm_mmu_split_memory_region(kvm, new->id);
> +	} else {
> +		/*
> +		 * Free any leftovers from the eager page splitting cache. Do
> +		 * this when deleting, moving, disabling dirty logging, or
> +		 * creating the memslot (a nop). Doing it for deletes makes
> +		 * sure we don't leak memory, and there's no need to keep the
> +		 * cache around for any of the other cases.
> +		 */
> +		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>   	}
>   }
>   

-- 
Shaoqin

