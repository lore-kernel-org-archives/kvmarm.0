Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA6BED0
	for <kvmarm@lists.linux.dev>; Mon, 20 Feb 2023 07:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676876938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y+NIusBVR5WPnJjqL3gVXE1Znq2/WkEFPcx2YhQtugs=;
	b=jI68LyxY8MGjeIiZYDNdpKzLWpJTL7O03Jqb/LguToJVipn6UuuJnEpwkYQE5j2AcBrUyy
	uMIKXonYIyvWTEML4U1kBJtRUj6utkwcbY54wzK54XiMzFNiOGROMbyFLfmUuixian1z+p
	kd8ajoFhdHKQs+bt0KB82E89emJgoKo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-586-5yXW3_OWPEuSFhM3qVFKHw-1; Mon, 20 Feb 2023 02:08:56 -0500
X-MC-Unique: 5yXW3_OWPEuSFhM3qVFKHw-1
Received: by mail-pj1-f71.google.com with SMTP id b12-20020a17090a8c8c00b00230aa3c1350so637626pjo.2
        for <kvmarm@lists.linux.dev>; Sun, 19 Feb 2023 23:08:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676876935;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y+NIusBVR5WPnJjqL3gVXE1Znq2/WkEFPcx2YhQtugs=;
        b=M76lH9rBIVRkWfHWu01dIyq2yLEILAItVD+jso77n9WpE6/r7vFEQxSXACIp8ptjHu
         xe0AfLqb2RrU7t7BsoBiw1fAeEIQAejgT0aGF3Uo2i7GKz1Qlc5b8WQ9ZZYyCuwrO6Kz
         Ib3OBxcJICz+NtRtTH1lqTVmIIwUlJ3oCZgBJVoO8+z0hZcWeGjP1geuWWa4A1J4DKYG
         TownR1UFxnteRtUz/uzi0KHADzDn7Y7R4PyoPzTo5TfolJ4S/yk7DI/Wpvqk1FxBF9hy
         BU7Uy7SuYAlFkGJwgZnh/Dd8NUKv10BmuU+azgEf/TvR7S6UOlCFq8IeqtzX5IFD0dE+
         h7eA==
X-Gm-Message-State: AO0yUKXqHyok3EP5NDmN3C+71Ch/rh11Ogm1iGvsO4DjGsmSWb1bXNHG
	BhiBNJtXrTnfR90auL+aPpaYb1shZoZN6ovk2STWRNj8voYfnpRaQCU4Iy1f24rqSrUtPcv3QT3
	BbOOMT8uTQzryRxBB
X-Received: by 2002:a17:902:bb0f:b0:197:8e8e:f15 with SMTP id im15-20020a170902bb0f00b001978e8e0f15mr534271plb.6.1676876935576;
        Sun, 19 Feb 2023 23:08:55 -0800 (PST)
X-Google-Smtp-Source: AK7set918UkTJJbyh5nrdC9tTm21sb5cDjzI9osi6zEhbKTBBKaKS3/EYvUDUg4LCFV3nBjyWWb7YQ==
X-Received: by 2002:a17:902:bb0f:b0:197:8e8e:f15 with SMTP id im15-20020a170902bb0f00b001978e8e0f15mr534251plb.6.1676876935201;
        Sun, 19 Feb 2023 23:08:55 -0800 (PST)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f7c200b001993a1fce7bsm7053341plw.196.2023.02.19.23.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Feb 2023 23:08:54 -0800 (PST)
Message-ID: <90bcd4e5-bfa6-17fe-25f2-3c6b7aab9a4c@redhat.com>
Date: Mon, 20 Feb 2023 15:08:47 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230218032314.635829-1-ricarkol@google.com>
 <20230218032314.635829-5-ricarkol@google.com> <Y/BFz5uC+iL2+q2o@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <Y/BFz5uC+iL2+q2o@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/18/23 11:28, Ricardo Koller wrote:
> On Sat, Feb 18, 2023 at 03:23:06AM +0000, Ricardo Koller wrote:
>> Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
>> range of huge pages. This will be used for eager-splitting huge pages
>> into PAGE_SIZE pages. The goal is to avoid having to split huge pages
>> on write-protection faults, and instead use this function to do it
>> ahead of time for large ranges (e.g., all guest memory in 1G chunks at
>> a time).
>>
>> No functional change intended. This new function will be used in a
>> subsequent commit.
>>
>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>> ---
>>   arch/arm64/include/asm/kvm_pgtable.h |  30 +++++++
>>   arch/arm64/kvm/hyp/pgtable.c         | 113 +++++++++++++++++++++++++++
>>   2 files changed, 143 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index b8cde914cca9..6908109ac11e 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -657,6 +657,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
>>    */
>>   int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>>   
>> +/**
>> + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
>> + *				to PAGE_SIZE guest pages.
>> + * @pgt:	 Page-table structure initialised by kvm_pgtable_stage2_init().
>> + * @addr:	 Intermediate physical address from which to split.
>> + * @size:	 Size of the range.
>> + * @mc:		 Cache of pre-allocated and zeroed memory from which to allocate
>> + *		 page-table pages.
>> + * @mc_capacity: Number of pages in @mc.
>> + *
>> + * @addr and the end (@addr + @size) are effectively aligned down and up to
>> + * the top level huge-page block size. This is an example using 1GB
>> + * huge-pages and 4KB granules.
>> + *
>> + *                          [---input range---]
>> + *                          :                 :
>> + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
>> + *                          :                 :
>> + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
>> + *                          :                 :
>> + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
>> + *                          :                 :
>> + *
>> + * Return: 0 on success, negative error code on failure. Note that
>> + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
>> + * blocks in the input range as allowed by @mc_capacity.
>> + */
>> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
>> +			     void *mc, u64 mc_capacity);
>> +
>>   /**
>>    * kvm_pgtable_walk() - Walk a page-table.
>>    * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index 80f2965ab0fe..9f1c8fdd9330 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -1228,6 +1228,119 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>>   	return pgtable;
>>   }
>>   
>> +struct stage2_split_data {
>> +	struct kvm_s2_mmu		*mmu;
>> +	void				*memcache;
>> +	u64				mc_capacity;
>> +};
>> +
>> +/*
>> + * Get the number of page-tables needed to replace a block with a
>> + * fully populated tree, up to the PTE level, at particular level.
>> + */
>> +static inline int stage2_block_get_nr_page_tables(u32 level)
>> +{
>> +	if (WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
>> +			 level >= KVM_PGTABLE_MAX_LEVELS))
>> +		return -EINVAL;
>> +
>> +	switch (level) {
>> +	case 1:
>> +		return PTRS_PER_PTE + 1;
>> +	case 2:
>> +		return 1;
>> +	case 3:
>> +		return 0;
>> +	default:
>> +		return -EINVAL;
>> +	};
>> +}
> 
> Shaoqin,
> 
> "Is the level 3 check really needed?"
> 
> Regarding your question about the need for "case 3". You are right,
> it's not actually needed in this particular case (when called from
> stage2_split_walker()). However, it would be nice to reuse this
> function and so it should cover all functions.
> 
> Thanks,
> Ricardo
> 

Hi Ricardo,

Thanks for your explanation. And I'm wondering since 
stage2_block_get_nr_page_tables() is aimed to get how many pages needed 
to populate a new pgtable and replace the block mapping, and level 3 is 
the PTE, it can't be split. So is it still ok to put level 3 in this 
function, although put it here has no effect.

Shaoqin

>> +
>> +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
>> +			       enum kvm_pgtable_walk_flags visit)
>> +{
>> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>> +	struct stage2_split_data *data = ctx->arg;
>> +	kvm_pte_t pte = ctx->old, new, *childp;
>> +	enum kvm_pgtable_prot prot;
>> +	void *mc = data->memcache;
>> +	u32 level = ctx->level;
>> +	bool force_pte;
>> +	int nr_pages;
>> +	u64 phys;
>> +
>> +	/* No huge-pages exist at the last level */
>> +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
>> +		return 0;
>> +
>> +	/* We only split valid block mappings */
>> +	if (!kvm_pte_valid(pte))
>> +		return 0;
>> +
>> +	nr_pages = stage2_block_get_nr_page_tables(level);
>> +	if (nr_pages < 0)
>> +		return nr_pages;
>> +
>> +	if (data->mc_capacity >= nr_pages) {
>> +		/* Build a tree mapped down to the PTE granularity. */
>> +		force_pte = true;
>> +	} else {
>> +		/*
>> +		 * Don't force PTEs. This requires a single page of PMDs at the
>> +		 * PUD level, or a single page of PTEs at the PMD level. If we
>> +		 * are at the PUD level, the PTEs will be created recursively.
>> +		 */
>> +		force_pte = false;
>> +		nr_pages = 1;
>> +	}
>> +
>> +	if (data->mc_capacity < nr_pages)
>> +		return -ENOMEM;
>> +
>> +	phys = kvm_pte_to_phys(pte);
>> +	prot = kvm_pgtable_stage2_pte_prot(pte);
>> +
>> +	childp = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, phys,
>> +						    level, prot, mc, force_pte);
>> +	if (IS_ERR(childp))
>> +		return PTR_ERR(childp);
>> +
>> +	if (!stage2_try_break_pte(ctx, data->mmu)) {
>> +		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
>> +		mm_ops->put_page(childp);
>> +		return -EAGAIN;
>> +	}
>> +
>> +	/*
>> +	 * Note, the contents of the page table are guaranteed to be made
>> +	 * visible before the new PTE is assigned because stage2_make_pte()
>> +	 * writes the PTE using smp_store_release().
>> +	 */
>> +	new = kvm_init_table_pte(childp, mm_ops);
>> +	stage2_make_pte(ctx, new);
>> +	dsb(ishst);
>> +	data->mc_capacity -= nr_pages;
>> +	return 0;
>> +}
>> +
>> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
>> +			     void *mc, u64 mc_capacity)
>> +{
>> +	struct stage2_split_data split_data = {
>> +		.mmu		= pgt->mmu,
>> +		.memcache	= mc,
>> +		.mc_capacity	= mc_capacity,
>> +	};
>> +
>> +	struct kvm_pgtable_walker walker = {
>> +		.cb	= stage2_split_walker,
>> +		.flags	= KVM_PGTABLE_WALK_LEAF,
>> +		.arg	= &split_data,
>> +	};
>> +
>> +	return kvm_pgtable_walk(pgt, addr, size, &walker);
>> +}
>> +
>>   int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>>   			      struct kvm_pgtable_mm_ops *mm_ops,
>>   			      enum kvm_pgtable_stage2_flags flags,
>> -- 
>> 2.39.2.637.g21b0678d19-goog
>>
> 

-- 
Regards,
Shaoqin

