Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6969E40A933
	for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785252558; cv=none; b=pcbPvgex29raFDoCFc0tT5Mklr7qkTqNymtcIO4VCOiQSPRv4M/Ir3VdCXop0jnxlz/4PKrT0qKsLD3fyIXla9naeuKr2OnEYFFZ9cyFIqoYGkMp6XxEWkm6T4cYlnFizedHBLhO/+4yH1smm3tXLFNrrq4K1CIZaHRemyLj/DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785252558; c=relaxed/simple;
	bh=d/HXh2+wtAy2KgKzzcueLfPbIzbvZiij/RnpXK41M/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+e8tcZtJQF8tVQn3wEz/eTm8QPcI+jaBfH2ihvwr545DkM1d5HIaMdNk04E8DYxEn8BarOVqQxbXatL00B3Z/3dZ+BJTRt7cKtBDuSVrHyVcti0+LZTa0aLc3tcdxs0aleoYIlCGYRGMDhjoGQALAVdaA5ebDok7/jTqznYom4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RKZeuinR; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RKZeuinR"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c15dd4b9132so583168666b.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 08:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785252555; x=1785857355; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F8oFJfNXcX3rvNozL61a5flKxGo2/aiCWCnQ35Drmb0=;
        b=RKZeuinRtY6/KDPCos2BW+zwyZE1vHUXrUjiuUBpO5BcwgoydwfUWJaal0KrDgjW3+
         i6YteSPX3kMha5YK0u7MQJSi7v9Q4lT16MkFRtD++naQ3hrtHBpxurj8KZKDwhO4nHKV
         uD5KYCsqlqPFfPewzvQi1LNZvLjXynspI53Vk2Pbh2CzWk5J53ZLLj3YnYduuKMBxstv
         RmaHv3IANFsI3oUGUJBFuc2sjblPhoGjyWNjoBRKkBWLMzTuRP8h4Gc9CyU6Rc3B/lZY
         8dsO5ZlkgbmJ9+LDp7c2TLo0ej49/DIOBVLYXS6RcvO/UpkoxJO+Hq/ZZ78JRlGxjZzF
         uxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785252555; x=1785857355;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F8oFJfNXcX3rvNozL61a5flKxGo2/aiCWCnQ35Drmb0=;
        b=be7DPH5XP7WQxTduyYnrhVc+Rk+OAC4esM3Ue7w/TSuDXoasIVVwNs2TyUcz30cnCq
         iMMiaJL+INPt79k3AKhteV35ZnVKN3LkSBEvNizHoZ1sNArbw1tO9sgDdq6A9r0ulvlH
         fMyCbA6ZXudJ18ARg59yyhqj2CHEQc8DrcuD6WxlPS+PNigrvbj1nhtuLI5m5SC05GWS
         wru5sTafOHa2wuWjJNbhKJQyfgBxRCrgyIkPDRHvbH1KT9wQUZTdKAAsdeqCkApRZnd9
         dHRhyfSEMD6CIbWDdv7d7+FcJzwWkKAdR9h7dy96IWuH1PNp6wGBYt8zcPvGPJNQKlKI
         PjnA==
X-Forwarded-Encrypted: i=1; AHgh+RrWD7oxqDLAYtZMcmXZyyx9oII3WKpEmp+Uyu95vAntOOUrlEVrqEc2LcHEfzzNWnTClfpUy/A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxA+169hDaxE9AJP59POJCzAvaQ64yoGmWiBvdagR9CkcFknMBh
	DaCx+muRjfik+nFsEn71sqaWmcPz41x80wk8+bkyi7TcF0kEg8qEB2nmPlvLPdEzTw==
X-Gm-Gg: AR+sD109RoVyDaoXp9YJctWjC033nQmoLz6N6OTApe25nd2oKo2yPjxVuu1/98e2LfI
	A3LZP2QJoFygcCQLwartD52jejIOMU3Z10XxRNKqCemjFzosZZD0c1h6uJGggB2dIBebTVPCcrA
	n2CKd1C/1/etlMBY4SmcMvGPYtpxDzm+Xa18AbStwhr9H0gHNWqBl0jDB+uFPuglhVu5TYIaxxw
	2jRIhmswBkZudVJ4NNjqAD2e1ySom67Ay6IUr6kqRcCY1XxEhNd+HZ9SpyTzN/WzF56BuRiiNIW
	MoTDfGRMQo9hysozEUgPOZ0GtqRWhWyJdJ5lswSEEambbVxXysaM82NnO2kaZeiIaRIrTHs/y8n
	b7zT0cKnCIeKs4rbAKtoCvrZ9pnfCUnPtUiwF7ZNnRfq+hbYQL289H0XUkU48+o2j+rcpAi+44M
	m9gGnUtUju3DBo7MKuc6Gj87oNqYpU4XndHWZInnWqTCnS6DzAx/qBNtQ9
X-Received: by 2002:a17:907:73cd:b0:c15:d0ef:a0c3 with SMTP id a640c23a62f3a-c1f7221d235mr160291866b.32.1785252553743;
        Tue, 28 Jul 2026 08:29:13 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83cde4dbsm685366b.15.2026.07.28.08.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 08:29:12 -0700 (PDT)
Date: Tue, 28 Jul 2026 16:29:08 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Gavin Shan <gshan@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Bradley Morgan <include@grrlz.net>, Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/7] KVM: arm64: Skip cache maintenance for
 non-cacheable pKVM mappings
Message-ID: <amjKxDd9expCNBwL@google.com>
References: <20260717130317.1953574-1-fuad.tabba@linux.dev>
 <20260717130317.1953574-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717130317.1953574-2-fuad.tabba@linux.dev>

On Fri, Jul 17, 2026 at 02:03:11PM +0100, Fuad Tabba wrote:
> From: Bradley Morgan <include@grrlz.net>
> 
> The pKVM flush path walks its own pkvm_mappings list and cleans the
> data cache for every mapping, unlike the generic stage-2 walker it
> shadows, which skips non-cacheable leaves. Cleaning the cacheable
> alias of a non-cacheable mapping is pointless and can corrupt a
> device endpoint. Record whether a mapping is non-cacheable in spare
> bits of nr_pages and skip cache maintenance for it.
> 
> Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Bradley Morgan <include@grrlz.net>
> [tabba: use Marc's anonymous bitfield in place of the open-coded mask and helpers]
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/include/asm/kvm_pkvm.h |  5 ++++-
>  arch/arm64/kvm/pkvm.c             | 15 +++++++++------
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 74fedd9c5ff0..57afb07d6b13 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -195,7 +195,10 @@ struct pkvm_mapping {
>  	struct rb_node node;
>  	u64 gfn;
>  	u64 pfn;
> -	u64 nr_pages;
> +	struct {
> +		u64 nr_pages:48;
> +		u64 nc:1;
> +	};
>  	u64 __subtree_last;	/* Internal member for interval tree */
>  };
>  
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 053e4f733e4b..f70c601dcf4c 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -369,7 +369,7 @@ static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64
>  
>  	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
>  		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
> -					mapping->nr_pages);
> +					(u64)mapping->nr_pages);
>  		if (WARN_ON(ret))
>  			return ret;
>  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> @@ -473,6 +473,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	mapping->gfn = gfn;
>  	mapping->pfn = pfn;
>  	mapping->nr_pages = size / PAGE_SIZE;
> +	mapping->nc = !!(prot & (KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC));
>  	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
>  
>  	return ret;
> @@ -503,7 +504,7 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  	lockdep_assert_held(&kvm->mmu_lock);
>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
>  		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
> -					mapping->nr_pages);
> +					(u64)mapping->nr_pages);
>  		if (WARN_ON(ret))
>  			break;
>  	}
> @@ -517,9 +518,11 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  	struct pkvm_mapping *mapping;
>  
>  	lockdep_assert_held(&kvm->mmu_lock);
> -	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
> -		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
> -					  PAGE_SIZE * mapping->nr_pages);
> +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> +		if (!mapping->nc)
> +			__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
> +						  PAGE_SIZE * mapping->nr_pages);
> +	}
>  
>  	return 0;
>  }
> @@ -537,7 +540,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
>  	lockdep_assert_held(&kvm->mmu_lock);
>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
>  		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
> -					   mapping->nr_pages, mkold);
> +					   (u64)mapping->nr_pages, mkold);
>  
>  	return young;
>  }
> -- 
> 2.39.5
> 

-- 
-- 
Vincent
