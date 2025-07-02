Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFFA15687D
	for <kvmarm@lists.linux.dev>; Wed,  2 Jul 2025 01:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751418302; cv=none; b=uBtH8Q/k8PClMzKhl4UiGf5nTKIGNZkbIcaj7vLaCICrbnGIuQkLySOoesdJgO6bd7m/8al76uXNvkeeTHsGN5QD3XolDKLlHOruu7rHPWiNCp1zFq40qYQSbEN6dlJTcMPNsqr3POgjHXHQWRn+Yk4xKL1RgPtuJ2v9zbKe5ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751418302; c=relaxed/simple;
	bh=HAi8XTCbUi9ctG7s2cBfvBed60TDj55oXZJqKL1myWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NMWN1n01Gs39TQCoXHos7NRvyQ2Zxce1sH50QPUz1DHLcmryS2rZNTpBoKj5uTqHsRSKnBMRgichbRwNRXgqE/vjXYtH4JMxEgDNz5oL9+t6QnuAY8hukndC0/P0ZT2ON2vo8D9PpnSjQc/fiUiZi+3PgaWErAtjt2OkBdB5Vbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DPr2U/fj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DPr2U/fj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751418299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y7e2iNuz6UMxuCJt+XXUmdNcGsesfcYP95Zgq3Kiu+4=;
	b=DPr2U/fj0ENukOHUYXc5ciSzX6NwF+fw3dFAS1OR+4pEZwupSFzY3jxcqQoCgxCDd66lTe
	oseDQYZRZpzaI7g0qFbuRBjBkOWT86NHfgPPfY0QZDEctkhLpwN5vWb+w4M4r0BbO65m7V
	lnOEWjaLGJwjbKE4Qqqgsx9MXaCFnvg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-eMnKj60_PgSEUV6fTWNUAw-1; Tue, 01 Jul 2025 21:04:57 -0400
X-MC-Unique: eMnKj60_PgSEUV6fTWNUAw-1
X-Mimecast-MFC-AGG-ID: eMnKj60_PgSEUV6fTWNUAw_1751418296
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2363bb41664so47005305ad.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Jul 2025 18:04:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751418296; x=1752023096;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7e2iNuz6UMxuCJt+XXUmdNcGsesfcYP95Zgq3Kiu+4=;
        b=o/ien3jtVWHo19UHCyaZY/9/4ldwhwZaPZnlGLEFFEO1EQywXnczYj6/cLhAD+ZvUH
         M2r7pqSe5BRKkzgiwNAkbeIwtC69yQ5B3QzLCX+4Q9qbI7SMFksndPoMC6Jkn9ezkmbr
         YM1vwCi+fLPd66nyxn+J/A/P/M75+clu7dbZtaU5uh7KFMo9Pyktjx95DBkF0Cuis+l+
         Tj1geKK0XX/7mdXske6JuB/B+4qb4zi65J55Nj6sXHrSzrnMO2MEuDShL0FacoHErSWI
         KIwD6+7Oe/8IVpEB++vvMz7UEvxf3hqZrM+IoUYWNWrAE6DE1UrlGiFfmo/36nLc+mub
         IsYg==
X-Forwarded-Encrypted: i=1; AJvYcCU5TF87s3a7oOC1AGXsO27TdeVlbjJpkBSKHjj58T3GJ+LSrH5WemBKcOEIgO0rO7lQriOymwg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyc9mIHjhJLeOstLA04nsd1qIpqF/0nrsnyNIUloTo0F4BOexnB
	KNGy6720SZ7vgSaDJO0KWsi8plV4CFIP/yyCi/bTq2BnNSUwoFR3XsDVzhYKY4n9hMQe77WvwVN
	MjvMQ2PzpYpvyyG3zmNOwqrLFTB+uTdZtDwst58dbU+Od4nrh8dAzncoukw==
X-Gm-Gg: ASbGncszppdmHkWUj10i5CAzSmThZth1FaQrua8JwW65TLxXN0LFbrgEchMkKWq2mHX
	JW1qI5H4RJzJ2DNcSBTD6QNlXzYwqS9t9CzgwvFMdND8RIx06ghoxlTehlREaaT2IIz1oc6RnLX
	wl48xQ/Ya36iVw15/V0wXx4k1/bNvVjKSLxfcfFjRW2XDVzRoyEhrpC1t3C34Zyq0q29qckHV44
	e7ic0ygPISMKgttMBb8FuWCz8ppoI147XWs8hNq+AjVPGc/OkfDYHJ1LF2wzoHVCkBFVS0I6pKC
	jAtROdpUCPRKZ6S1TpZc92/mWffZ7Fr2zF81Kcxkx3dAOuyN3Ga96gV4MYevzQ==
X-Received: by 2002:a17:903:3d0f:b0:215:b1e3:c051 with SMTP id d9443c01a7336-23c6e7849e6mr8884285ad.11.1751418295536;
        Tue, 01 Jul 2025 18:04:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHOXu/xZ6csxfliZUO8Wh+5iggHLkbPkDpGniLYRwXHCeihkHJH2+rb6i8+X+baqZXhpUZaA==
X-Received: by 2002:a17:903:3d0f:b0:215:b1e3:c051 with SMTP id d9443c01a7336-23c6e7849e6mr8883735ad.11.1751418294924;
        Tue, 01 Jul 2025 18:04:54 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c6e09sm115339825ad.227.2025.07.01.18.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 18:04:54 -0700 (PDT)
Message-ID: <bb75b5fd-7186-4c93-80ff-0a398dc6c78d@redhat.com>
Date: Wed, 2 Jul 2025 11:04:46 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 20/43] arm64: RME: Runtime faulting of memory
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-21-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-21-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p60fiqnJ84efJk47vVjo3hjRO9A6GbR7xW6gYMe7yLE_1751418296
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 8:48 PM, Steven Price wrote:
> At runtime if the realm guest accesses memory which hasn't yet been
> mapped then KVM needs to either populate the region or fault the guest.
> 
> For memory in the lower (protected) region of IPA a fresh page is
> provided to the RMM which will zero the contents. For memory in the
> upper (shared) region of IPA, the memory from the memslot is mapped
> into the realm VM non secure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v8:
>   * Propagate the may_block flag.
>   * Minor comments and coding style changes.
> Changes since v7:
>   * Remove redundant WARN_ONs for realm_create_rtt_levels() - it will
>     internally WARN when necessary.
> Changes since v6:
>   * Handle PAGE_SIZE being larger than RMM granule size.
>   * Some minor renaming following review comments.
> Changes since v5:
>   * Reduce use of struct page in preparation for supporting the RMM
>     having a different page size to the host.
>   * Handle a race when delegating a page where another CPU has faulted on
>     a the same page (and already delegated the physical page) but not yet
>     mapped it. In this case simply return to the guest to either use the
>     mapping from the other CPU (or refault if the race is lost).
>   * The changes to populate_par_region() are moved into the previous
>     patch where they belong.
> Changes since v4:
>   * Code cleanup following review feedback.
>   * Drop the PTE_SHARED bit when creating unprotected page table entries.
>     This is now set by the RMM and the host has no control of it and the
>     spec requires the bit to be set to zero.
> Changes since v2:
>   * Avoid leaking memory if failing to map it in the realm.
>   * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>   * Adapt to changes in previous patches.
> ---
>   arch/arm64/include/asm/kvm_emulate.h |  10 ++
>   arch/arm64/include/asm/kvm_rme.h     |  10 ++
>   arch/arm64/kvm/mmu.c                 | 133 ++++++++++++++++++++-
>   arch/arm64/kvm/rme.c                 | 165 +++++++++++++++++++++++++++
>   4 files changed, 312 insertions(+), 6 deletions(-)
> 

With @may_block set to true in kvm_free_stage2_pgd(), as commented previously.
With below nitpicks addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 302a691b3723..126c98cded90 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -709,6 +709,16 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>   	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>   }
>   
> +static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t ipa)
> +{
> +	if (kvm_is_realm(kvm)) {
> +		struct realm *realm = &kvm->arch.realm;
> +
> +		return ipa & ~BIT(realm->ia_bits - 1);
> +	}
> +	return ipa;
> +}
> +

It may be more clearer with something like below. Note non-coco VM is still
preferred than coco VM.

static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t ipa)
{
	if (!kvm_is_realm(kvm)
		return ipa;

	return ipa & ~BIT(kvm->arch.realm->ia_bits -1);		
}

>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>   {
>   	if (static_branch_unlikely(&kvm_rme_is_available))
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 321970779669..df88ae51b7c9 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -110,6 +110,16 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>   			   unsigned long size,
>   			   bool unmap_private,
>   			   bool may_block);
> +int realm_map_protected(struct realm *realm,
> +			unsigned long base_ipa,
> +			kvm_pfn_t pfn,
> +			unsigned long size,
> +			struct kvm_mmu_memory_cache *memcache);
> +int realm_map_non_secure(struct realm *realm,
> +			 unsigned long ipa,
> +			 kvm_pfn_t pfn,
> +			 unsigned long size,
> +			 struct kvm_mmu_memory_cache *memcache);
>   
>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>   						unsigned long addr)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 37403eaa5699..1dc644ea26ce 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -338,8 +338,14 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   	WARN_ON(size & ~PAGE_MASK);
> -	WARN_ON(stage2_apply_range(mmu, start, end, KVM_PGT_FN(kvm_pgtable_stage2_unmap),
> -				   may_block));
> +
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, start, size, !only_shared,
> +				      may_block);
> +	else
> +		WARN_ON(stage2_apply_range(mmu, start, end,
> +					   KVM_PGT_FN(kvm_pgtable_stage2_unmap),
> +					   may_block));
>   }
>  

{} is needed here.
  
>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
> @@ -359,7 +365,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
>   	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>   	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>   
> -	kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, addr, end - addr, false, true);
> +	else
> +		kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>   }
>   
>   /**
> @@ -1053,6 +1062,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>   	struct kvm_memory_slot *memslot;
>   	int idx, bkt;
>   
> +	/* For realms this is handled by the RMM so nothing to do here */
> +	if (kvm_is_realm(kvm))
> +		return;
> +
>   	idx = srcu_read_lock(&kvm->srcu);
>   	mmap_read_lock(current->mm);
>   	write_lock(&kvm->mmu_lock);
> @@ -1078,6 +1091,9 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   	if (kvm_is_realm(kvm) &&
>   	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>   	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> +		struct realm *realm = &kvm->arch.realm;
> +
> +		kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), false);
>   		write_unlock(&kvm->mmu_lock);
>   		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>   
> @@ -1486,6 +1502,85 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>   	return vma->vm_flags & VM_MTE_ALLOWED;
>   }
>   
> +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
> +			 kvm_pfn_t pfn, unsigned long map_size,
> +			 enum kvm_pgtable_prot prot,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	/*
> +	 * Write permission is required for now even though it's possible to
> +	 * map unprotected pages (granules) as read-only. It's impossible to
> +	 * map protected pages (granules) as read-only.
> +	 */
> +	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
> +		return -EFAULT;
> +
> +	ipa = ALIGN_DOWN(ipa, PAGE_SIZE);
> +

Empty line can be dropped.

> +	if (!kvm_realm_is_private_address(realm, ipa))
> +		return realm_map_non_secure(realm, ipa, pfn, map_size,
> +					    memcache);
> +
> +	return realm_map_protected(realm, ipa, pfn, map_size, memcache);
> +}
> +
> +static int private_memslot_fault(struct kvm_vcpu *vcpu,
> +				 phys_addr_t fault_ipa,
> +				 struct kvm_memory_slot *memslot)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	gpa_t gpa = kvm_gpa_from_fault(kvm, fault_ipa);
> +	gfn_t gfn = gpa >> PAGE_SHIFT;
> +	bool is_priv_gfn = kvm_mem_is_private(kvm, gfn);
> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +	struct page *page;
> +	kvm_pfn_t pfn;
> +	int ret;
> +	/*
> +	 * For Realms, the shared address is an alias of the private GPA with
> +	 * the top bit set. Thus is the fault address matches the GPA then it
> +	 * is the private alias.
> +	 */
> +	bool is_priv_fault = (gpa == fault_ipa);
> +
> +	if (is_priv_gfn != is_priv_fault) {
> +		kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
> +					      kvm_is_write_fault(vcpu), false,
> +					      is_priv_fault);
> +
> +		/*
> +		 * KVM_EXIT_MEMORY_FAULT requires an return code of -EFAULT,
> +		 * see the API documentation
> +		 */
> +		return -EFAULT;
> +	}
> +
> +	if (!is_priv_fault) {
> +		/* Not a private mapping, handling normally */
> +		return -EINVAL;
> +	}
> +
> +	ret = kvm_mmu_topup_memory_cache(memcache,
> +					 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> +	if (ret)
> +		return ret;
> +
> +	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> +	if (ret)
> +		return ret;
> +
> +	/* FIXME: Should be able to use bigger than PAGE_SIZE mappings */
> +	ret = realm_map_ipa(kvm, fault_ipa, pfn, PAGE_SIZE, KVM_PGTABLE_PROT_W,
> +			    memcache);
> +	if (!ret)
> +		return 1; /* Handled */
> +
> +	put_page(page);
> +	return ret;
> +}
> +
>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			  struct kvm_s2_trans *nested,
>   			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1513,6 +1608,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (fault_is_perm)
>   		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
>   	write_fault = kvm_is_write_fault(vcpu);
> +
> +	/*
> +	 * Realms cannot map protected pages read-only
> +	 * FIXME: It should be possible to map unprotected pages read-only
> +	 */
> +	if (vcpu_is_rec(vcpu))
> +		write_fault = true;
> +
>   	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>   	VM_BUG_ON(write_fault && exec_fault);
>   
> @@ -1630,7 +1733,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		ipa &= ~(vma_pagesize - 1);
>   	}
>   
> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = kvm_gpa_from_fault(kvm, ipa) >> PAGE_SHIFT;
>   	mte_allowed = kvm_vma_mte_allowed(vma);
>   
>   	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> @@ -1763,6 +1866,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		 */
>   		prot &= ~KVM_NV_GUEST_MAP_SZ;
>   		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
> +	} else if (kvm_is_realm(kvm)) {
> +		ret = realm_map_ipa(kvm, fault_ipa, pfn, vma_pagesize,
> +				    prot, memcache);
>   	} else {
>   		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
>   					     __pfn_to_phys(pfn), prot,
> @@ -1911,8 +2017,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		nested = &nested_trans;
>   	}
>   
> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
>   	memslot = gfn_to_memslot(vcpu->kvm, gfn);
> +
> +	if (kvm_slot_can_be_private(memslot)) {
> +		ret = private_memslot_fault(vcpu, ipa, memslot);
> +		if (ret != -EINVAL)
> +			goto out;
> +	}
> +
>   	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>   	write_fault = kvm_is_write_fault(vcpu);
>   	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
> @@ -1956,7 +2069,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		 * of the page size.
>   		 */
>   		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> -		ret = io_mem_abort(vcpu, ipa);
> +		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(vcpu->kvm, ipa));
>   		goto out_unlock;
>   	}
>   
> @@ -2004,6 +2117,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>   	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
>   						   range->start << PAGE_SHIFT,
>   						   size, true);
> @@ -2020,6 +2137,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>   	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
>   						   range->start << PAGE_SHIFT,
>   						   size, false);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index d7bb11583506..0fe55e369782 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -750,6 +750,171 @@ static int realm_create_protected_data_page(struct realm *realm,
>   	return -ENXIO;
>   }
>   
> +static int fold_rtt(struct realm *realm, unsigned long addr, int level)
> +{
> +	phys_addr_t rtt_addr;
> +	int ret;
> +
> +	ret = realm_rtt_fold(realm, addr, level, &rtt_addr);
> +	if (ret)
> +		return ret;
> +
> +	free_rtt(rtt_addr);
> +
> +	return 0;
> +}
> +
> +int realm_map_protected(struct realm *realm,
> +			unsigned long ipa,
> +			kvm_pfn_t pfn,
> +			unsigned long map_size,
> +			struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t phys = __pfn_to_phys(pfn);
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	unsigned long base_ipa = ipa;
> +	unsigned long size;
> +	int map_level = IS_ALIGNED(map_size, RMM_L2_BLOCK_SIZE) ?
> +			RMM_RTT_BLOCK_LEVEL : RMM_RTT_MAX_LEVEL;
> +	int ret = 0;
> +
> +	if (WARN_ON(!IS_ALIGNED(map_size, RMM_PAGE_SIZE) ||
> +		    !IS_ALIGNED(ipa, map_size)))
> +		return -EINVAL;
> +
> +	if (map_level < RMM_RTT_MAX_LEVEL) {
> +		/*
> +		 * A temporary RTT is needed during the map, precreate it,
> +		 * however if there is an error (e.g. missing parent tables)
> +		 * this will be handled below.
> +		 */
> +		realm_create_rtt_levels(realm, ipa, map_level,
> +					RMM_RTT_MAX_LEVEL, memcache);
> +	}
> +
> +	for (size = 0; size < map_size; size += RMM_PAGE_SIZE) {
> +		if (rmi_granule_delegate(phys)) {
> +			/*
> +			 * It's likely we raced with another VCPU on the same
> +			 * fault. Assume the other VCPU has handled the fault
> +			 * and return to the guest.
> +			 */
> +			return 0;
> +		}
> +
> +		ret = rmi_data_create_unknown(rd, phys, ipa);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			/* Create missing RTTs and retry */
> +			int level = RMI_RETURN_INDEX(ret);
> +
> +			WARN_ON(level == RMM_RTT_MAX_LEVEL);
> +

Unnecessary empty line.

> +			ret = realm_create_rtt_levels(realm, ipa, level,
> +						      RMM_RTT_MAX_LEVEL,
> +						      memcache);
> +			if (ret)
> +				goto err_undelegate;
> +
> +			ret = rmi_data_create_unknown(rd, phys, ipa);
> +		}
> +
> +		if (WARN_ON(ret))
> +			goto err_undelegate;
> +
> +		phys += RMM_PAGE_SIZE;
> +		ipa += RMM_PAGE_SIZE;
> +	}
> +
> +	if (map_size == RMM_L2_BLOCK_SIZE) {
> +		ret = fold_rtt(realm, base_ipa, map_level + 1);
> +		if (WARN_ON(ret))
> +			goto err;
> +	}
> +
> +	return 0;
> +
> +err_undelegate:
> +	if (WARN_ON(rmi_granule_undelegate(phys))) {
> +		/* Page can't be returned to NS world so is lost */
> +		get_page(phys_to_page(phys));
> +	}
> +err:
> +	while (size > 0) {
> +		unsigned long data, top;
> +
> +		phys -= RMM_PAGE_SIZE;
> +		size -= RMM_PAGE_SIZE;
> +		ipa -= RMM_PAGE_SIZE;
> +
> +		WARN_ON(rmi_data_destroy(rd, ipa, &data, &top));
> +
> +		if (WARN_ON(rmi_granule_undelegate(phys))) {
> +			/* Page can't be returned to NS world so is lost */
> +			get_page(phys_to_page(phys));
> +		}
> +	}
> +	return -ENXIO;
> +}
> +
> +int realm_map_non_secure(struct realm *realm,
> +			 unsigned long ipa,
> +			 kvm_pfn_t pfn,
> +			 unsigned long size,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	phys_addr_t phys = __pfn_to_phys(pfn);
> +	unsigned long offset;
> +	/* TODO: Support block mappings */
> +	int map_level = RMM_RTT_MAX_LEVEL;
> +	int map_size = rme_rtt_level_mapsize(map_level);
> +	int ret = 0;
> +
> +	if (WARN_ON(!IS_ALIGNED(size, RMM_PAGE_SIZE) ||
> +		    !IS_ALIGNED(ipa, size)))
> +		return -EINVAL;
> +
> +	for (offset = 0; offset < size; offset += map_size) {
> +		/*
> +		 * realm_map_ipa() enforces that the memory is writable,
> +		 * so for now we permit both read and write.
> +		 */
> +		unsigned long desc = phys |
> +				     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
> +				     KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R |
> +				     KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +		ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			/* Create missing RTTs and retry */
> +			int level = RMI_RETURN_INDEX(ret);
> +
> +			ret = realm_create_rtt_levels(realm, ipa, level,
> +						      map_level, memcache);
> +			if (ret)
> +				return -ENXIO;
> +
> +			ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
> +		}
> +		/*
> +		 * RMI_ERROR_RTT can be reported for two reasons: either the
> +		 * RTT tables are not there, or there is an RTTE already
> +		 * present for the address.  The above call to create RTTs
> +		 * handles the first case, and in the second case this
> +		 * indicates that another thread has already populated the RTTE
> +		 * for us, so we can ignore the error and continue.
> +		 */
> +		if (ret && RMI_RETURN_STATUS(ret) != RMI_ERROR_RTT)
> +			return -ENXIO;
> +
> +		ipa += map_size;
> +		phys += map_size;
> +	}
> +
> +	return 0;
> +}
> +
>   static int populate_region(struct kvm *kvm,
>   			   phys_addr_t ipa_base,
>   			   phys_addr_t ipa_end,

Thanks,
Gavin

