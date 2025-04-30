Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE3321D3D0
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 11:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746013109; cv=none; b=FcUm4WZcM1NOpmpE1RUXMdGKnagS2Jv0fQ6UOv5QnEfE4ILN7ne8dk9hr8sWGn6CoYve5YBWAoCGCYtDh3nF0DYq7ComMbTibkTjAGY+C6NUWYRKrCZ8Pu4KvQ7XtNwPgT43FF8Y7fcXxppE+S/j6P6Qs7ndQk7jK/y9+NqYsRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746013109; c=relaxed/simple;
	bh=eCuZru9vjQox/ZY5sGSMrZEFL8lafAjIHX4t40oeQ9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lEysREuepZKZ7KglASGum+QSqcON/16Jp3ZLGdA3jp7v0/wOHrENB4+y5Tptsa/ShW8n2ijjVJr9brLDlzdR8kZGkTY6h8mxvIRyf8ZMJXdIdiTeORIvSumBppV9YN7D1xMnqwvpX5xr0jfWbD87a8qlv+zUNIW7khDicV1AAbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZBc+6CdZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZBc+6CdZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746013106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qfLgZR7XQCap9uKH4tNWHt1CXKoJGpcYeDWwUUvdD3s=;
	b=ZBc+6CdZ9FN/KC13KSxchkKEWbkrsnP1+V7TStW4hdrKVdg2EJFREit1ruNZv0fvp3But0
	kkigoQRj+IY5lUVADB6C4dpoPgi8augoVOn9boK8lizNihcYiXULGv2z0aZCV4OjcLluh9
	pOIQhSJTWVrb3VuF/doN+V1oeWJWgCA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-faTytJ8FN4WVcaDaQOAOOQ-1; Wed, 30 Apr 2025 07:38:25 -0400
X-MC-Unique: faTytJ8FN4WVcaDaQOAOOQ-1
X-Mimecast-MFC-AGG-ID: faTytJ8FN4WVcaDaQOAOOQ_1746013104
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22406ee0243so48986265ad.3
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 04:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746013104; x=1746617904;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qfLgZR7XQCap9uKH4tNWHt1CXKoJGpcYeDWwUUvdD3s=;
        b=UspeUAz/5ygjno0Zaeq1FJYxvf4uSaoB+F4KF66U/vWp1BQem6Rs6+SXHpvsYDPfOs
         Nwfum+U7F2pYLiUwx2/rC2+VGm9oOVbgpfgcK8A5dupWARbKPheBy1XxDhbGg0dCeiKz
         o7G7d4ZK8HH+rRRcaOw89JC4SA25G0MRBxlu/TVTK03P/JlgjnhiHZe9dD9tfnGp+jWb
         sT+u4mlP9w1ym6cyNoTmWWcDnNLJaposoM6flYAAKrrE+GKx5G57+CJm2IYFp/dtuHZk
         vjzf/CbON0ixTT+fCg6rjrKccjYVPZ8Fcqy1BIsXLswvxJUriAApJfaz7B92+Dgx+5hu
         3yuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqN9hYENI6sKCHaEvmPg69L4UEMRAUZ8oXLA6l3dURrClxcHlP/kTdNI5N5wICedtUjqUuCLc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDgPN+ofhfVinQjmei7mLpPXfQSLqTPMDyIMvQTWelsw5xzJU4
	tPB7nbU9IMsvgSeVwVbLXAClEXMipTpDgldwfFADPNIei6kN7xHk5HKmCanxAa8Hwu8ilgFaWgC
	DhDwSqsue5FNMkTFmvDu2VT1Nn2ETHnQm2kWnhBgRRsJeTpO756O15A==
X-Gm-Gg: ASbGnct3jan2E8EHO2jJO6un65AClPFQ6ZAOa5H2Kmku/xMd8iUIPpbWOWMnqSj/ghD
	aad9B80qjui77b+CDzbICOjaAViowlQh/zaacpScbCgdpnKpcZh2p3ffO3/N7YyttLWYaGad4oI
	6L+3WtTL5bCyBr4IEFSj55rbfEOqNc8YLDzUDeooa0ExwErdoEyzHMrWNFjTjXimuzXtn0FrkL0
	Ik8J6oFu4u5kHD/PNCgA0XW1cE6WLSPC8BPVklGrnSfF0tmJoTKnrGqcGGeOETuY6VC2SVPQXaL
	Q0ULQgR2hYcS
X-Received: by 2002:a17:902:d4c8:b0:224:912:153 with SMTP id d9443c01a7336-22df577e2famr35077255ad.5.1746013103861;
        Wed, 30 Apr 2025 04:38:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGylgVgaPOITy2MV2+GJ6GY0/Qhc284AdMuiZ+IVYMNTbanW8yo806/6iRNpD6/Eo2CD195FA==
X-Received: by 2002:a17:902:d4c8:b0:224:912:153 with SMTP id d9443c01a7336-22df577e2famr35076675ad.5.1746013103341;
        Wed, 30 Apr 2025 04:38:23 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5216c02sm119293605ad.211.2025.04.30.04.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 04:38:22 -0700 (PDT)
Message-ID: <cc2c5834-c942-4454-903d-11b53f8f5451@redhat.com>
Date: Wed, 30 Apr 2025 21:38:14 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 15/43] arm64: RME: Allow VMM to set RIPAS
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-16-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-16-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pgLKJTaLnUGGSrFp7WuHkIW3NJPHP-o3S1tTLH1hG2w_1746013104
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
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
> Changes from v7:
>   * Replace use of "only_shared" with the upstream "attr_filter" field
>     of struct kvm_gfn_range.
>   * Clean up the logic in alloc_delegated_granule() for when to call
>     kvm_account_pgtable_pages().
>   * Rename realm_destroy_protected_granule() to
>     realm_destroy_private_granule() to match the naming elsewhere. Also
>     fix the return codes in the function to be descriptive.
>   * Several other minor changes to names/return codes.
> Changes from v6:
>   * Split the code dealing with the guest triggering a RIPAS change into
>     a separate patch, so this patch is purely for the VMM setting up the
>     RIPAS before the guest first runs.
>   * Drop the useless flags argument from alloc_delegated_granule().
>   * Account RTTs allocated for a guest using kvm_account_pgtable_pages().
>   * Deal with the RMM granule size potentially being smaller than the
>     host's PAGE_SIZE. Although note alloc_delegated_granule() currently
>     still allocates an entire host page for every RMM granule (so wasting
>     memory when PAGE_SIZE>4k).
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
>   arch/arm64/include/asm/kvm_rme.h |   5 +
>   arch/arm64/kvm/mmu.c             |   8 +-
>   arch/arm64/kvm/rme.c             | 384 +++++++++++++++++++++++++++++++
>   3 files changed, 394 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 9bcad6ec5dbb..b916db8565a2 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -101,6 +101,11 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
>   int kvm_create_rec(struct kvm_vcpu *vcpu);
>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
> +void kvm_realm_unmap_range(struct kvm *kvm,
> +			   unsigned long ipa,
> +			   unsigned long size,
> +			   bool unmap_private);
> +
>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>   						unsigned long addr)
>   {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d80a9d408f71..71c04259e39f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -323,6 +323,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * @start: The intermediate physical base address of the range to unmap
>    * @size:  The size of the area to unmap
>    * @may_block: Whether or not we are permitted to block
> + * @only_shared: If true then protected mappings should not be unmapped
>    *
>    * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
>    * be called while holding mmu_lock (unless for freeing the stage2 pgd before
> @@ -330,7 +331,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * with things behind our backs.
>    */
>   static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
> -				 bool may_block)
> +				 bool may_block, bool only_shared)
>   {
>   	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>   	phys_addr_t end = start + size;
> @@ -344,7 +345,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>   			    u64 size, bool may_block)
>   {
> -	__unmap_stage2_range(mmu, start, size, may_block);
> +	__unmap_stage2_range(mmu, start, size, may_block, false);
>   }
>   
>   void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
> @@ -1975,7 +1976,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   
>   	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>   			     (range->end - range->start) << PAGE_SHIFT,
> -			     range->may_block);
> +			     range->may_block,
> +			     !(range->attr_filter & KVM_FILTER_PRIVATE));
>   
>   	kvm_nested_s2_unmap(kvm, range->may_block);
>   	return false;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 1239eb07aca6..33eb793d8bdb 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -87,6 +87,51 @@ static int get_start_level(struct realm *realm)
>   	return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
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
> +static phys_addr_t alloc_delegated_granule(struct kvm_mmu_memory_cache *mc)
> +{
> +	phys_addr_t phys;
> +	void *virt;
> +
> +	if (mc)
> +		virt = kvm_mmu_memory_cache_alloc(mc);
> +	else
> +		virt = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);


It would be more safe to use (GFP_ATOMIC | __GFP_ZERO | __GFP_ACCOUNT), consistent
to the flags used by kvm_mmu_memory_cache_alloc().

> +
> +	if (!virt)
> +		return PHYS_ADDR_MAX;
> +
> +	phys = virt_to_phys(virt);
> +
> +	if (rmi_granule_delegate(phys)) {
> +		free_page((unsigned long)virt);
> +
> +		return PHYS_ADDR_MAX;
> +	}
> +
> +	kvm_account_pgtable_pages(virt, 1);
> +
> +	return phys;
> +}
> +
>   static void free_delegated_granule(phys_addr_t phys)
>   {
>   	if (WARN_ON(rmi_granule_undelegate(phys))) {
> @@ -99,6 +144,154 @@ static void free_delegated_granule(phys_addr_t phys)
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
> +static int realm_destroy_private_granule(struct realm *realm,
> +					 unsigned long ipa,
> +					 unsigned long *next_addr,
> +					 phys_addr_t *out_rtt)
> +{
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	unsigned long rtt_addr;
> +	phys_addr_t rtt;
> +	int ret;
> +
> +retry:
> +	ret = rmi_data_destroy(rd, ipa, &rtt_addr, next_addr);
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		if (*next_addr > ipa)
> +			return 0; /* UNASSIGNED */
> +		rtt = alloc_delegated_granule(NULL);
> +		if (WARN_ON(rtt == PHYS_ADDR_MAX))
> +			return -ENOMEM;
> +		/*
> +		 * ASSIGNED - ipa is mapped as a block, so split. The index
> +		 * from the return code should be 2 otherwise it appears
> +		 * there's a huge page bigger than KVM currently supports
> +		 */
> +		WARN_ON(RMI_RETURN_INDEX(ret) != 2);
> +		ret = realm_rtt_create(realm, ipa, 3, rtt);
> +		if (WARN_ON(ret)) {
> +			free_delegated_granule(rtt);
> +			return -ENXIO;
> +		}
> +		goto retry;
> +	} else if (WARN_ON(ret)) {
> +		return -ENXIO;
> +	}
> +
> +	ret = rmi_granule_undelegate(rtt_addr);
> +	if (WARN_ON(ret))
> +		return -ENXIO;
> +
> +	*out_rtt = rtt_addr;
> +
> +	return 0;
> +}
> +
> +static int realm_unmap_private_page(struct realm *realm,
> +				    unsigned long ipa,
> +				    unsigned long *next_addr)
> +{
> +	unsigned long end = ALIGN(ipa + 1, PAGE_SIZE);
> +	unsigned long addr;
> +	phys_addr_t out_rtt = PHYS_ADDR_MAX;
> +	int ret;
> +
> +	for (addr = ipa; addr < end; addr = *next_addr) {
> +		ret = realm_destroy_private_granule(realm, addr, next_addr,
> +						    &out_rtt);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (out_rtt != PHYS_ADDR_MAX)
> +		free_page((unsigned long)phys_to_virt(out_rtt));
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
> +
> +		cond_resched_rwlock_write(&kvm->mmu_lock);
> +	}
> +}
> +
>   /* Calculate the number of s2 root rtts needed */
>   static int realm_num_root_rtts(struct realm *realm)
>   {
> @@ -209,6 +402,40 @@ static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
>   	return ret;
>   }
>   
> +static int realm_create_rtt_levels(struct realm *realm,
> +				   unsigned long ipa,
> +				   int level,
> +				   int max_level,
> +				   struct kvm_mmu_memory_cache *mc)
> +{
> +	if (level == max_level)
> +		return 0;
> +
> +	while (level++ < max_level) {
> +		phys_addr_t rtt = alloc_delegated_granule(mc);
> +		int ret;
> +
> +		if (rtt == PHYS_ADDR_MAX)
> +			return -ENOMEM;
> +
> +		ret = realm_rtt_create(realm, ipa, level, rtt);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT &&
> +		    RMI_RETURN_INDEX(ret) == level) {
> +			/* The RTT already exists, continue */
> +			continue;
> +		}
> +		if (ret) {
> +			WARN(1, "Failed to create RTT at level %d: %d\n",
> +			     level, ret);
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
> @@ -299,6 +526,61 @@ static int realm_tear_down_rtt_range(struct realm *realm,
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
> @@ -306,6 +588,96 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
>   	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>   }
>   
> +static void realm_unmap_private_range(struct kvm *kvm,
> +				      unsigned long start,
> +				      unsigned long end)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned long next_addr, addr;
> +	int ret;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		ret = realm_unmap_private_page(realm, addr, &next_addr);
> +
> +		if (ret)
> +			break;
> +	}
> +
> +	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
> +			     start, end);
> +}
> +
> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
> +			   unsigned long size, bool unmap_private)
> +{

This function can be called by the MMU notifier to invalidate the mapping for
the specified IPA range. However, we're missing one parameter to indicate if
the request from the MMU notifier is blockable or not. We're having the imprecise
assumption that all requests are blockable, which isn't always true. With this
assumption, cond_resched_rwlock_write(&kvm->mmu_lock) is always called in
realm_unmap_shared_range().

Another issue is that cond_resched_rwlock_write(&kvm->mmu_lock) is missed if
the request is blockable in realm_unmap_private_page().

> +	unsigned long end = start + size;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	end = min(BIT(realm->ia_bits - 1), end);
> +
> +	if (realm->state == REALM_STATE_NONE)
> +		return;

	if (!kvm_realm_is_created(kvm)))
		return;

> +
> +	realm_unmap_shared_range(kvm, find_map_level(realm, start, end),
> +				 start, end);
> +	if (unmap_private)
> +		realm_unmap_private_range(kvm, start, end);
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

The readability would be better if the explicit 'continue' can be avoid, something
like below:

	switch (RMI_RETURN_STATUS(ret)) {
	case RMI_SUCCESS:
		ipa = next;
		break;
	case RMI_ERROR_RTT:
		:
		ret = realm_create_rtt_levels(realm, ipa, error_level, level, NULL);
		if (ret)
			return ret;
		break;
	default:
		WARN_ON(1);
		return -ENXIO;
	}

> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
> +				    struct arm_rme_init_ripas *args)
> +{
> +	gpa_t addr, end;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	addr = args->base;
> +	end = addr + args->size;
> +
> +	if (end < addr)
> +		return -EINVAL;

The check needs to cover 'end <= addr'. RMI_ERROR_INPUT is returned from RMM::smc_rtt_init_ripas()
if 'end' is equal to 'addr', but we're returning 0, inconsistent to that.

	if (end <= addr)
		return -EINVAL;

> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
> +		return -EPERM;

To keep the consistency, kvm_realm_is_created() can be used here.

	if (kvm_realm_is_created(kvm))
		return -EPERM;

> +
> +	return realm_init_ipa_state(realm, addr, end);
> +}
> +
>   /* Protects access to rme_vmid_bitmap */
>   static DEFINE_SPINLOCK(rme_vmid_lock);
>   static unsigned long *rme_vmid_bitmap;
> @@ -431,6 +803,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   	case KVM_CAP_ARM_RME_CREATE_REALM:
>   		r = kvm_create_realm(kvm);
>   		break;
> +	case KVM_CAP_ARM_RME_INIT_RIPAS_REALM: {
> +		struct arm_rme_init_ripas args;
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

