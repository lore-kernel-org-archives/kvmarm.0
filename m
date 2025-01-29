Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFC042A92
	for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 23:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738193146; cv=none; b=Jzj8eGS/D9LMrv4pMJMhr9lN0s/fVbLjoc1ylN+pom/mpa6oWSetIIdNDG63gBm7eWwm03+kNFVWxbZAYQSJ9pM+BF7KW9H2mIleW3ptdGfOLK7xJvSSlMBORG0Vk4tg7u611vtAMYaCIfJ18pTpunRseAPL+urrgPOIlyyCcGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738193146; c=relaxed/simple;
	bh=0UgWIfQDoFNmrDK8Ug80YFceOpeSiZcg5ysiEeDCjiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ihu7rDxXUDhUFE4oXQ88wCcflIdbBWOFf8erYQwh2EKyKUWSDwTSs90tX9Gihxjtq4C71dTNTF2bTflfu4eViDFsj0FbUUgOg7xrDkXojlPsPye+CKUEOQb1V9FH+9L5GO2AB8nci0thOj5DwyqO8Cs+eqnKwU4Uqc1sF4LzAZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aU4WIDcu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aU4WIDcu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738193143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4SasUhMaDspkeR/loVnro/pwr7VjtNFICuRD8ENV0kU=;
	b=aU4WIDcuUBnebZrAiOwzRByltYG7ztQtDH79hzObCpeOlvn0tIWCMgqMm+y3xjoxspuC1O
	+oUjheYkD//1s+MXEZpvqFjRJPbALUOmmxiMghUsSyausLSWFPQvwGpJcMQnWCtNkNxarB
	t6a+nBQDSTRU0L5RV/10KmplEMPWliQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-kHXnLSXpOdGvMaWz0oPpNQ-1; Wed, 29 Jan 2025 18:25:41 -0500
X-MC-Unique: kHXnLSXpOdGvMaWz0oPpNQ-1
X-Mimecast-MFC-AGG-ID: kHXnLSXpOdGvMaWz0oPpNQ
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-21661949f23so5252665ad.3
        for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 15:25:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738193140; x=1738797940;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4SasUhMaDspkeR/loVnro/pwr7VjtNFICuRD8ENV0kU=;
        b=upBcwJJgNugn0UTWz9Jp2yHIg3SneWPhQkVeZUfGma0692GsPa+EnaBh4wzJVLnR4o
         6cCRgxSuY+LULHajtx7KHu11HQwLq1MsfM1cyRS9XgjBWvIA9njpcJaqIYwZXCWd3co1
         SLfVr0MkoBfdolF4UO1wZ0D12t4pJr4N+RvOhe44pi8lKUh8qgine2z7blQgKMy3RfRv
         1qY6Yy8dI6Ei9YOH3TkBZK34NSNflv0uN6/PcR/rDcLFPRfEwBHx4yM2DbQBgxoLtpTb
         VD/P83id9lBo8s1tqWRYCk+YezLIRQ/zzdsBQo0hBFaG/0DfbWHXPXKI3nN33Y/NoB4L
         urCQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0fUR7sjjpMW8WabhaaUkxsmQbxguy1OAryQlaCOHMju125Pn2NPXrLPV8oGeN0qiG1K2vPTk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzB2rWprTDh8TAEFPhSqhtTC3cH9JFI2DoXu8tDO8JhDU7wL/h/
	Cx747rOx7FSCG+kRClkRGedyGgaMmMijJYlSsBJ2YRxdERkFofvVFFWJyrTDTZ02r/JYXMUiXQQ
	HKkhYYL4JhSYZrmgh85T9t/SJGcamkARn38Rm1d48/fEIXCuJJJKC9w==
X-Gm-Gg: ASbGncumKVzk5tz1P+hrvW+rCv1aS5+M2padbRE1RkZnvpvfyusAYILQO/KfRBQ3/BD
	jR4hZ3vmCm00sKYMYpVYpkyeAsox3PauQJaypUgyQbfGb7kgBjECLHMQl3G5ig+bR7/12YhtxJB
	Z1C20VfgOAmTZ4kDmJUDnZ30eBrLDQU/JG3jfozWY+l9d0hhCo7CQu+G0Vkhk5p+bP+EPQvw8s1
	vNBsqLgnallLHoGxtKzkHvZqawUZUTPnlKQjOXp4NB2CxYa0i+Zv2ps+bBVegB2wGFmQzd7di1Y
	gtj+8w==
X-Received: by 2002:a17:902:ee53:b0:217:89da:fd54 with SMTP id d9443c01a7336-21dd7dccf9emr62582255ad.33.1738193139986;
        Wed, 29 Jan 2025 15:25:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHTrr8fQwKpMD1F4TidKTyIGPYSUiMwDbr9pvLpxC9WvzBzaEQzINw/7jqh/Ui9FHKmNNQ/tg==
X-Received: by 2002:a17:902:ee53:b0:217:89da:fd54 with SMTP id d9443c01a7336-21dd7dccf9emr62581855ad.33.1738193139334;
        Wed, 29 Jan 2025 15:25:39 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de331eb69sm1383885ad.211.2025.01.29.15.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 15:25:38 -0800 (PST)
Message-ID: <4c1c507d-25ae-488f-88d3-fd6ffe337d0d@redhat.com>
Date: Thu, 30 Jan 2025 09:25:29 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 16/43] arm64: RME: Allow VMM to set RIPAS
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-17-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-17-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RLLFR_X6of6zpJCRWDlLEJpnLAK_y6EjPZ2XWj-e7-I_1738193140
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> Each page within the protected region of the realm guest can be marked
> as either RAM or EMPTY. Allow the VMM to control this before the guest
> has started and provide the equivalent functions to change this (with
> the guest's approval) at runtime.
> 
> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
> unmapped from the guest and undelegated allowing the memory to be reused
> by the host. When transitioning to RIPAS RAM the actual population of
> the leaf RTTs is done later on stage 2 fault, however it may be
> necessary to allocate additional RTTs to allow the RMM track the RIPAS
> for the requested range.
> 
> When freeing a block mapping it is necessary to temporarily unfold the
> RTT which requires delegating an extra page to the RMM, this page can
> then be recovered once the contents of the block mapping have been
> freed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v5:
>   * Adapt to rebasing.
>   * Introduce find_map_level()
>   * Rename some functions to be clearer.
>   * Drop the "spare page" functionality.
> Changes from v2:
>   * {alloc,free}_delegated_page() moved from previous patch to this one.
>   * alloc_delegated_page() now takes a gfp_t flags parameter.
>   * Fix the reference counting of guestmem pages to avoid leaking memory.
>   * Several misc code improvements and extra comments.
> ---
>   arch/arm64/include/asm/kvm_rme.h |  17 ++
>   arch/arm64/kvm/mmu.c             |   8 +-
>   arch/arm64/kvm/rme.c             | 411 +++++++++++++++++++++++++++++++
>   3 files changed, 433 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index be64b749fcac..4e7758f0e4b5 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -92,6 +92,15 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
>   int kvm_create_rec(struct kvm_vcpu *vcpu);
>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
> +void kvm_realm_unmap_range(struct kvm *kvm,
> +			   unsigned long ipa,
> +			   u64 size,
> +			   bool unmap_private);
> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> +			unsigned long addr, unsigned long end,
> +			unsigned long ripas,
> +			unsigned long *top_ipa);
> +

The declaration of realm_set_ipa_state() is unnecessary since its scope has
been limited to rme.c

>   #define RMM_RTT_BLOCK_LEVEL	2
>   #define RMM_RTT_MAX_LEVEL	3
>   
> @@ -110,4 +119,12 @@ static inline unsigned long rme_rtt_level_mapsize(int level)
>   	return (1UL << RMM_RTT_LEVEL_SHIFT(level));
>   }
>   
> +static inline bool realm_is_addr_protected(struct realm *realm,
> +					   unsigned long addr)
> +{
> +	unsigned int ia_bits = realm->ia_bits;
> +
> +	return !(addr & ~(BIT(ia_bits - 1) - 1));
> +}
> +
>   #endif

The check on the specified address to determine its range seems a bit complicated
to me, it can be simplified like below. Besides, it may be a good idea to rename
it to have the prefix "kvm_realm_".

static inline bool kvm_realm_is_{private | protected}_address(struct realm *realm,
						  unsigned long addr)
{
	return !(addr & BIT(realm->ia_bits - 1));
}

A question related to the terms used in this series to describe a granule's state:
"protected" or "private", "unprotected" or "shared". Those terms are all used in
the function names of this series. I guess it would be nice to unify so that
"private" and "shared" to be used, which is consistent to the terms used by
guest-memfd. For example, kvm_realm_is_protected_address() can be renamed to
kvm_realm_is_private_address().

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 325b578c734d..b100d4b3aa29 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -310,6 +310,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * @start: The intermediate physical base address of the range to unmap
>    * @size:  The size of the area to unmap
>    * @may_block: Whether or not we are permitted to block
> + * @only_shared: If true then protected mappings should not be unmapped
>    *
>    * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
>    * be called while holding mmu_lock (unless for freeing the stage2 pgd before
> @@ -317,7 +318,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * with things behind our backs.
>    */
>   static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
> -				 bool may_block)
> +				 bool may_block, bool only_shared)
>   {
>   	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>   	phys_addr_t end = start + size;
> @@ -331,7 +332,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>   			    u64 size, bool may_block)
>   {
> -	__unmap_stage2_range(mmu, start, size, may_block);
> +	__unmap_stage2_range(mmu, start, size, may_block, false);
>   }
>   
>   void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
> @@ -1932,7 +1933,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   
>   	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>   			     (range->end - range->start) << PAGE_SHIFT,
> -			     range->may_block);
> +			     range->may_block,
> +			     range->only_shared);
>   
>   	kvm_nested_s2_unmap(kvm, range->may_block);
>   	return false;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 72778d8ab52b..e8ad04405ecd 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -62,6 +62,51 @@ static int get_start_level(struct realm *realm)
>   	return 4 - stage2_pgtable_levels(realm->ia_bits);
>   }
>   
> +static int find_map_level(struct realm *realm,
> +			  unsigned long start,
> +			  unsigned long end)
> +{
> +	int level = RMM_RTT_MAX_LEVEL;
> +
> +	while (level > get_start_level(realm)) {
> +		unsigned long map_size = rme_rtt_level_mapsize(level - 1);
> +
> +		if (!IS_ALIGNED(start, map_size) ||
> +		    (start + map_size) > end)
> +			break;
> +
> +		level--;
> +	}
> +
> +	return level;
> +}
> +
> +static phys_addr_t alloc_delegated_granule(struct kvm_mmu_memory_cache *mc,
> +					   gfp_t flags)
> +{
> +	phys_addr_t phys = PHYS_ADDR_MAX;
> +	void *virt;
> +
> +	if (mc)
> +		virt = kvm_mmu_memory_cache_alloc(mc);
> +	else
> +		virt = (void *)__get_free_page(flags);
> +
> +	if (!virt)
> +		goto out;
> +
> +	phys = virt_to_phys(virt);
> +
> +	if (rmi_granule_delegate(phys)) {
> +		free_page((unsigned long)virt);
> +
> +		phys = PHYS_ADDR_MAX;
> +	}
> +
> +out:
> +	return phys;
> +}
> +
>   static void free_delegated_granule(phys_addr_t phys)
>   {
>   	if (WARN_ON(rmi_granule_undelegate(phys))) {
> @@ -72,6 +117,132 @@ static void free_delegated_granule(phys_addr_t phys)
>   	free_page((unsigned long)phys_to_virt(phys));
>   }
>   
> +static int realm_rtt_create(struct realm *realm,
> +			    unsigned long addr,
> +			    int level,
> +			    phys_addr_t phys)
> +{
> +	addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
> +	return rmi_rtt_create(virt_to_phys(realm->rd), phys, addr, level);
> +}
> +
> +static int realm_rtt_fold(struct realm *realm,
> +			  unsigned long addr,
> +			  int level,
> +			  phys_addr_t *rtt_granule)
> +{
> +	unsigned long out_rtt;
> +	int ret;
> +
> +	ret = rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_rtt);
> +
> +	if (RMI_RETURN_STATUS(ret) == RMI_SUCCESS && rtt_granule)
> +		*rtt_granule = out_rtt;
> +
> +	return ret;
> +}
> +
> +static int realm_destroy_protected(struct realm *realm,
> +				   unsigned long ipa,
> +				   unsigned long *next_addr)
> +{
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	unsigned long addr;
> +	phys_addr_t rtt;
> +	int ret;
> +
> +loop:
> +	ret = rmi_data_destroy(rd, ipa, &addr, next_addr);
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		if (*next_addr > ipa)
> +			return 0; /* UNASSIGNED */
> +		rtt = alloc_delegated_granule(NULL, GFP_KERNEL);
> +		if (WARN_ON(rtt == PHYS_ADDR_MAX))
> +			return -1;
> +		/*
> +		 * ASSIGNED - ipa is mapped as a block, so split. The index
> +		 * from the return code should be 2 otherwise it appears
> +		 * there's a huge page bigger than KVM currently supports
> +		 */
> +		WARN_ON(RMI_RETURN_INDEX(ret) != 2);
> +		ret = realm_rtt_create(realm, ipa, 3, rtt);
> +		if (WARN_ON(ret)) {
> +			free_delegated_granule(rtt);
> +			return -1;
> +		}
> +		/* retry */
> +		goto loop;
> +	} else if (WARN_ON(ret)) {
> +		return -1;
> +	}
> +	ret = rmi_granule_undelegate(addr);
> +
> +	/*
> +	 * If the undelegate fails then something has gone seriously
> +	 * wrong: take an extra reference to just leak the page
> +	 */
> +	if (!WARN_ON(ret))
> +		put_page(phys_to_page(addr));
> +
> +	return 0;
> +}
> +
> +static void realm_unmap_shared_range(struct kvm *kvm,
> +				     int level,
> +				     unsigned long start,
> +				     unsigned long end)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	ssize_t map_size = rme_rtt_level_mapsize(level);
> +	unsigned long next_addr, addr;
> +	unsigned long shared_bit = BIT(realm->ia_bits - 1);
> +
> +	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
> +		return;
> +
> +	start |= shared_bit;
> +	end |= shared_bit;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		unsigned long align_addr = ALIGN(addr, map_size);
> +		int ret;
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		if (align_addr != addr || next_addr > end) {
> +			/* Need to recurse deeper */
> +			if (addr < align_addr)
> +				next_addr = align_addr;
> +			realm_unmap_shared_range(kvm, level + 1, addr,
> +						 min(next_addr, end));
> +			continue;
> +		}
> +
> +		ret = rmi_rtt_unmap_unprotected(rd, addr, level, &next_addr);
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (next_addr == addr) {
> +				/*
> +				 * There's a mapping here, but it's not a block
> +				 * mapping, so reset next_addr to the next block
> +				 * boundary and recurse to clear out the pages
> +				 * one level deeper.
> +				 */
> +				next_addr = ALIGN(addr + 1, map_size);
> +				realm_unmap_shared_range(kvm, level + 1, addr,
> +							 next_addr);
> +			}
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return;
> +		}
> +	}
> +}
> +
>   static int realm_create_rd(struct kvm *kvm)
>   {
>   	struct realm *realm = &kvm->arch.realm;
> @@ -161,6 +332,30 @@ static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
>   	return ret;
>   }
>   
> +static int realm_create_rtt_levels(struct realm *realm,
> +				   unsigned long ipa,
> +				   int level,
> +				   int max_level,
> +				   struct kvm_mmu_memory_cache *mc)
> +{
> +	if (WARN_ON(level == max_level))
> +		return 0;
> +
> +	while (level++ < max_level) {
> +		phys_addr_t rtt = alloc_delegated_granule(mc, GFP_KERNEL);
> +
> +		if (rtt == PHYS_ADDR_MAX)
> +			return -ENOMEM;
> +
> +		if (realm_rtt_create(realm, ipa, level, rtt)) {
> +			free_delegated_granule(rtt);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>   static int realm_tear_down_rtt_level(struct realm *realm, int level,
>   				     unsigned long start, unsigned long end)
>   {
> @@ -251,6 +446,61 @@ static int realm_tear_down_rtt_range(struct realm *realm,
>   					 start, end);
>   }
>   
> +/*
> + * Returns 0 on successful fold, a negative value on error, a positive value if
> + * we were not able to fold all tables at this level.
> + */
> +static int realm_fold_rtt_level(struct realm *realm, int level,
> +				unsigned long start, unsigned long end)
> +{
> +	int not_folded = 0;
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
> +		return -EINVAL;
> +
> +	map_size = rme_rtt_level_mapsize(level - 1);
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		phys_addr_t rtt_granule;
> +		int ret;
> +		unsigned long align_addr = ALIGN(addr, map_size);
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		ret = realm_rtt_fold(realm, align_addr, level, &rtt_granule);
> +
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			free_delegated_granule(rtt_granule);
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (level == RMM_RTT_MAX_LEVEL ||
> +			    RMI_RETURN_INDEX(ret) < level) {
> +				not_folded++;
> +				break;
> +			}
> +			/* Recurse a level deeper */
> +			ret = realm_fold_rtt_level(realm,
> +						   level + 1,
> +						   addr,
> +						   next_addr);
> +			if (ret < 0)
> +				return ret;
> +			else if (ret == 0)
> +				/* Try again at this level */
> +				next_addr = addr;
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return not_folded;
> +}
> +
>   void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
>   {
>   	struct realm *realm = &kvm->arch.realm;
> @@ -258,6 +508,155 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
>   	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>   }
>   
> +static void realm_unmap_private_range(struct kvm *kvm,
> +				      unsigned long start,
> +				      unsigned long end)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned long next_addr, addr;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		int ret;
> +
> +		ret = realm_destroy_protected(realm, addr, &next_addr);
> +
> +		if (WARN_ON(ret))
> +			break;
> +	}
> +
> +	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
> +			     start, end);
> +}
> +
> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start, u64 size,
> +			   bool unmap_private)
> +{
> +	unsigned long end = start + size;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	end = min(BIT(realm->ia_bits - 1), end);
> +
> +	if (realm->state == REALM_STATE_NONE)
> +		return;
> +
> +	realm_unmap_shared_range(kvm, find_map_level(realm, start, end),
> +				 start, end);
> +	if (unmap_private)
> +		realm_unmap_private_range(kvm, start, end);
> +}
> +
> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> +			unsigned long start,
> +			unsigned long end,
> +			unsigned long ripas,
> +			unsigned long *top_ipa)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +	phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +	unsigned long ipa = start;
> +	int ret = 0;
> +
> +	while (ipa < end) {
> +		unsigned long next;
> +
> +		ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			int walk_level = RMI_RETURN_INDEX(ret);
> +			int level = find_map_level(realm, ipa, end);
> +
> +			/*
> +			 * If the RMM walk ended early then more tables are
> +			 * needed to reach the required depth to set the RIPAS.
> +			 */
> +			if (walk_level < level) {
> +				ret = realm_create_rtt_levels(realm, ipa,
> +							      walk_level,
> +							      level,
> +							      memcache);
> +				/* Retry with RTTs created */
> +				if (!ret)
> +					continue;
> +			} else {
> +				ret = -EINVAL;
> +			}
> +
> +			break;
> +		} else if (RMI_RETURN_STATUS(ret) != RMI_SUCCESS) {
> +			WARN(1, "Unexpected error in %s: %#x\n", __func__,
> +			     ret);
> +			ret = -EINVAL;
> +			break;
> +		}
> +		ipa = next;
> +	}
> +
> +	*top_ipa = ipa;
> +
> +	if (ripas == RMI_EMPTY && ipa != start)
> +		realm_unmap_private_range(kvm, start, ipa);
> +
> +	return ret;
> +}
> +
> +static int realm_init_ipa_state(struct realm *realm,
> +				unsigned long ipa,
> +				unsigned long end)
> +{
> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +	int ret;
> +
> +	while (ipa < end) {
> +		unsigned long next;
> +
> +		ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			int err_level = RMI_RETURN_INDEX(ret);
> +			int level = find_map_level(realm, ipa, end);
> +
> +			if (WARN_ON(err_level >= level))
> +				return -ENXIO;
> +
> +			ret = realm_create_rtt_levels(realm, ipa,
> +						      err_level,
> +						      level, NULL);
> +			if (ret)
> +				return ret;
> +			/* Retry with the RTT levels in place */
> +			continue;
> +		} else if (WARN_ON(ret)) {
> +			return -ENXIO;
> +		}
> +
> +		ipa = next;
> +	}
> +
> +	return 0;
> +}
> +
> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
> +				    struct kvm_cap_arm_rme_init_ipa_args *args)
> +{
> +	gpa_t addr, end;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	addr = args->init_ipa_base;
> +	end = addr + args->init_ipa_size;
> +
> +	if (end < addr)
> +		return -EINVAL;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
> +		return -EINVAL;
> +
> +	return realm_init_ipa_state(realm, addr, end);
> +}
> +
>   /* Protects access to rme_vmid_bitmap */
>   static DEFINE_SPINLOCK(rme_vmid_lock);
>   static unsigned long *rme_vmid_bitmap;
> @@ -383,6 +782,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   	case KVM_CAP_ARM_RME_CREATE_RD:
>   		r = kvm_create_realm(kvm);
>   		break;
> +	case KVM_CAP_ARM_RME_INIT_IPA_REALM: {
> +		struct kvm_cap_arm_rme_init_ipa_args args;
> +		void __user *argp = u64_to_user_ptr(cap->args[1]);
> +
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +
> +		r = kvm_init_ipa_range_realm(kvm, &args);
> +		break;
> +	}
>   	default:
>   		r = -EINVAL;
>   		break;

Thanks,
Gavin

