Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C89248B363
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 13:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782912718; cv=none; b=oFR7yhzQZuE8CAtbfcbewV2Eh8Qs8EMVjWI2GInrI6aY+TfrE9z1iZWGCfDLwL8kezJKbEOjJaVNzRNkY0u742k0ydmQttOXSutG5BNQxi3XmNNgyr3LUVbzpsTqAVBktWMCVlfGFMVlfFbvlMFBlQ6N9Bqhm/9KzzwWz+UMGks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782912718; c=relaxed/simple;
	bh=cHQGDBv2YgRqGgNgwPodZeLX7f0kk1ApLtscbK58jOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUab5/FAGhsJYH4/aEYOyXGwpwCU99iCrQUKb8vWxktEiHMqMLwm71FDaOkwHTfVmOpI6bscBIp3xXV/IN5smjfKZvNchw22mWiDgMfp5urQkWKejJ6Zwa549qSN6nVPdoe8tH+FoP2Xp3PWeIjBKRDYWfFPVMrZLJULOkQwpys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lsz8ol6z; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lsz8ol6z"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4758b2a9e2aso431720f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 01 Jul 2026 06:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782912714; x=1783517514; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=54H8ja6qkwc+zSll+xVZzhQ87dmwI3XRpSBDJRGLWNs=;
        b=lsz8ol6zMFog423vrWPLvi4Ve5GV4pHMl0vHEQUsiRa7tjT1JddTwrvwdPZohOMRr8
         54fW5l1T0+ItMtSp1nQTlJwJeVShWd83lXb60NYQWb/OLD4lUUrDw1xxwaaGaKR2bhoX
         GER/N7gFJdf15vaX7zH7ugi4LmflW2Z5RZVEJqEYTk69P3t0jjARSmTT9UzFegiCw5RG
         Wq3Z3qD6xWhvbLSx8OwRY6ZE60gmBb8NZVzCGAG0krB8oH22KNB8YmG9NtZNzOUvc20m
         VuzstomEdpN/quQwuXmNZM6WXNu8N5g/Msxd99n+gQZP2QiZDKF/Xe8aNfJMVPbrgutj
         oodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782912714; x=1783517514;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=54H8ja6qkwc+zSll+xVZzhQ87dmwI3XRpSBDJRGLWNs=;
        b=o/IEQ2Df/LV6V7tRW89Jh1P1Qi8TGQ87AStn3uhWG7Vq0PP3uEWaJpWGTBJx3Ku7CM
         Z1JD+XZYtdit8zR2rBxsMMO2CSI7pi0PfqiOSusBGTbbgglYt7p9T7UjcMH5a0jhGek7
         95cZWvV1H1Rv9S92kDEtzCpXCMHMGjlkwOxUXNlCVymlmRdgh9eMqETGlC/bF+63TI1c
         cO3PXbBsRF1Hl1rnBEeXwXmpqDF7u0Z98vn3daKsYmVCOpWhlHN/0N6B3S1MngVFirN5
         RthM9ad9AdwpiBPWAo5Q3mgaLTRgqsUTa87ud+aP1n/iCZtpOGhn2xvFPlN/5QTH5DkU
         rJaw==
X-Forwarded-Encrypted: i=1; AHgh+Rqfor1IxSr2R2LoziQGrBJiyftErqMLZDNPYb1wR8GR/Y5EhpZw9LnwLgtT1u8hkvjkAmrZxUI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzlUJ4EsBGY+LrIDl1GMISVNj/QYbGVzZ6IThK/9HUKyG0bdQuz
	oAjiMr/Ra+dk92bAqi6mpO4QXIXUCQenq9gKScKrOVCK4Nr9wJPo0k+S8X3LcsoL6A==
X-Gm-Gg: AfdE7cmR1hBarvrI+xl10RDzWjM0cVZAyvcL5N8komsVVBBk6P2OzacTLas+Pic3sOX
	sxHU3AxbNNDgy07IKzyA7KxhyQgCHvJ7VmzLFIh8fwnd8Yb3Brhzu+13X2+WekYI2RbvKyE/KwN
	Thxl0MgOy3pCKzAajxlDT1nmLkIoSzFteQFdLDhq48LAUZWB7wR5Ib/2W7WAjd2cVNN9Ax8w4gP
	PMf4QIxwgrARv0743BswZ4Kvhf5Gvnkzi0QRyMDizt+0RDKNpFYq1pVMBsJ2/gG/dAUyp1M+ohG
	1Lgq2/gFx0Zg/w+F+D9YN/K3yqoRKneQM9U7ex9jCy14TKRLpm9/RQBGnjOTw3bLhbMugLii+wL
	6JGWIbQhkSA/tbQAa7Fh0DzxQ86hx5zrujiIH7lo7fkMFctH3JOkgzM861KREaMzB0o9ZaGGQnm
	/FGhsIyyhovj7zGHhOERKqg5fIlDBzywyNB0oZJ8+74oKDXL4NOoPQJ065HnX8gw==
X-Received: by 2002:a05:6000:29db:b0:475:f0c2:5b02 with SMTP id ffacd0b85a97d-4775b45b05emr2137424f8f.56.1782912713855;
        Wed, 01 Jul 2026 06:31:53 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-475641e4542sm18270184f8f.10.2026.07.01.06.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 06:31:52 -0700 (PDT)
Date: Wed, 1 Jul 2026 14:31:49 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Bradley Morgan <include@grrlz.net>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
	Gavin Shan <gshan@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] KVM: arm64: skip pKVM cache flushes for non
 cacheable mappings
Message-ID: <akUWxY_irosuTF4L@google.com>
References: <20260624160028.15591-1-include@grrlz.net>
 <20260624160028.15591-2-include@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624160028.15591-2-include@grrlz.net>

On Wed, Jun 24, 2026 at 04:00:26PM +0000, Bradley Morgan wrote:
> pKVM keeps its own mapping list for stage 2 operations. Its flush path
> uses that list directly, so it lost the PTE attribute check done by the
> generic stage 2 walker.
> 
> Record whether a mapping is cacheable and skip cache maintenance for
> mappings that are not cacheable.
> 
> Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
> Signed-off-by: Bradley Morgan <include@grrlz.net>
> ---
>  arch/arm64/kvm/pkvm.c | 51 ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 41 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 428723b1b0f5..ca6e823028c2 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -302,9 +302,32 @@ static u64 __pkvm_mapping_start(struct pkvm_mapping *m)
>  	return m->gfn * PAGE_SIZE;
>  }
>  
> +#define PKVM_MAPPING_NR_PAGES_MASK	GENMASK_ULL(47, 0)
> +#define PKVM_MAPPING_CACHEABLE		BIT_ULL(48)

Probably better to make it "_NC". Protected VMs only support cacheable and they
also use struct pkvm_mapping. 

> +
> +static u64 pkvm_mapping_nr_pages(struct pkvm_mapping *m)
> +{
> +	return m->nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
> +}
> +
> +static bool pkvm_mapping_is_cacheable(struct pkvm_mapping *m)
> +{
> +	return m->nr_pages & PKVM_MAPPING_CACHEABLE;
> +}
> +
> +static void pkvm_mapping_set_nr_pages(struct pkvm_mapping *m, u64 nr_pages,
> +				      bool cacheable)
> +{
> +	WARN_ON_ONCE(nr_pages & ~PKVM_MAPPING_NR_PAGES_MASK);
> +
> +	m->nr_pages = nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
> +	if (cacheable)
> +		m->nr_pages |= PKVM_MAPPING_CACHEABLE;
> +}
> +
>  static u64 __pkvm_mapping_end(struct pkvm_mapping *m)
>  {
> -	return (m->gfn + m->nr_pages) * PAGE_SIZE - 1;
> +	return (m->gfn + pkvm_mapping_nr_pages(m)) * PAGE_SIZE - 1;
>  }

Perhaps using a bitfield would heavily simplify this code?

struct pkvm_mapping {
  ...
  u64 nr_pages : 63
  u64 flags : 1
}

Or alternatively, could just make nr_pages u32 and flags u32. nr_pages will not
exceed PMD_SIZE / PAGE_SIZE, which is at worst 8192 on 64K systems.

>  
>  INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
> @@ -350,7 +373,7 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
>  			continue;
>  
>  		page = pfn_to_page(mapping->pfn);
> -		WARN_ON_ONCE(mapping->nr_pages != 1);
> +		WARN_ON_ONCE(pkvm_mapping_nr_pages(mapping) != 1);
>  		unpin_user_pages_dirty_lock(&page, 1, true);
>  		account_locked_vm(kvm->mm, 1, false);
>  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> @@ -369,7 +392,7 @@ static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64
>  
>  	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
>  		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
> -					mapping->nr_pages);
> +					pkvm_mapping_nr_pages(mapping));
>  		if (WARN_ON(ret))
>  			return ret;
>  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> @@ -448,7 +471,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		 * permission faults are handled in the relax_perms() path.
>  		 */
>  		if (mapping) {
> -			if (size == (mapping->nr_pages * PAGE_SIZE))
> +			if (size == (pkvm_mapping_nr_pages(mapping) * PAGE_SIZE))
>  				return -EAGAIN;
>  
>  			/*
> @@ -472,7 +495,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	swap(mapping, cache->mapping);
>  	mapping->gfn = gfn;
>  	mapping->pfn = pfn;
> -	mapping->nr_pages = size / PAGE_SIZE;
> +	pkvm_mapping_set_nr_pages(mapping, size / PAGE_SIZE,
> +				  !(prot & (KVM_PGTABLE_PROT_DEVICE |
> +					    KVM_PGTABLE_PROT_NORMAL_NC)));
>  	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
>  
>  	return ret;
> @@ -503,7 +528,7 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  	lockdep_assert_held(&kvm->mmu_lock);
>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
>  		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
> -					mapping->nr_pages);
> +					pkvm_mapping_nr_pages(mapping));
>  		if (WARN_ON(ret))
>  			break;
>  	}
> @@ -517,9 +542,13 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  	struct pkvm_mapping *mapping;
>  
>  	lockdep_assert_held(&kvm->mmu_lock);
> -	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
> +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> +		if (!pkvm_mapping_is_cacheable(mapping))
> +			continue;
> +
>  		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
> -					  PAGE_SIZE * mapping->nr_pages);
> +					  PAGE_SIZE * pkvm_mapping_nr_pages(mapping));
> +	}
>  
>  	return 0;
>  }
> @@ -536,8 +565,10 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
>  
>  	lockdep_assert_held(&kvm->mmu_lock);
>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
> -		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
> -					   mapping->nr_pages, mkold);
> +		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest,
> +					   handle, mapping->gfn,
> +					   pkvm_mapping_nr_pages(mapping),
> +					   mkold);
>  
>  	return young;
>  }
> -- 
> 2.53.0
> 
