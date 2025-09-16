Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47739315D58
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 13:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758030219; cv=none; b=tBz8YtSo36cn3HmZ2lZR68ObXWhMB1cpX1dJxUQBiKB/4cUhOr8U/yL8a7SYXptedWszSwq8UpF9WjsoVW9fmOztmy57S6QlOymSbRL3+xEA9d/XsFjJHlBRea2MB/TCE5ZRG9Fw5T5mLGDbdpdPGovvR2KQq31dyOjYR4LaipM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758030219; c=relaxed/simple;
	bh=aG0N8krrxMi6bz+piP0pXqzq+j6GXftkDiR9JS3f4po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+JxamfhkgfrpowdwDv+G/iq5ePYBhuRmAcA07eVz9AqP9b3CasBPp8cUt9+x6sLDQEE/KXBVc5Smdh5WJG5aG/xGYP5jmXXlbO1mAt06qjm8d0dYqoqM/QDICdLWZIG2R/zVqXOvYSeC/S7PgPyt+HuBe8N/ce6vGrH6i6PrD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QdlhAGFN; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QdlhAGFN"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45f2f894632so52885e9.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 06:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758030215; x=1758635015; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SfWHeFBkMHYJw5QiRGsKUIxVRqYkPAcQ5KBzj6Wt0do=;
        b=QdlhAGFNxNoPspa+wXOztZkg7oPUzuUwv2vxPqNVwix7HiEEGyE1HJa9vmv3RbPTjd
         eYKQtlh/zVED67jUnwkVfk6H1z46y0Y6fJp6rVbkVIkDij2Qr7uX74huFs658SQgCy45
         5tb6pT1wdI0BS9itYynHFqzgACKH5/T9TczS5AzcBi+6ib4OH5NIYa7uYRYGtXq75rEb
         43OGz3SUQ2nEsJnU26S2qVmB44bMGqq1i3/pPtTzotSthxpOpX1osodMVD5rHR6WlHJa
         NvdO1U5ZbFa/hwDwRCC63PDY3dSkHql69bKmWv3Sqhjc6LHL+UKV8CNZJkkzzCaF8ue9
         zohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758030215; x=1758635015;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SfWHeFBkMHYJw5QiRGsKUIxVRqYkPAcQ5KBzj6Wt0do=;
        b=jRh7eJxh1ackhzQbbdf6v54/8PYON1gjP6Oo4aly589ui/B9Cb65CUyoY8e/3rtdvd
         CN58JF6AhUHQ4t/wIB2/NWCP2YtrdBD6dViMZPCoov8Gfg+rhRCGeanZ5jLH8shMdBKB
         kPQHSutEJQjvePQtu3Do1AMTkw/kusSXNfHD+ZW24kEJWH/RE4hyA2zI7wL7y13qYCOs
         88hujV1R4VrSaxePu1wih27d+HZpc3K2D7ZnLUxcXRUpLop11AtSm7GtyWgippWPJjcB
         s5fJ6LpKN6b7vlGWAhF9/PWn0vuUbzZ2gOdwvXJPJ/zGEqIyjG5gkxH2DJ4MIKiewD91
         fycg==
X-Forwarded-Encrypted: i=1; AJvYcCXo8M8Q7k45gPXuyZhnB/b4X1Gd1VMMz0Mz7LJ6ajzTSafKBEVVtUcqDJkofb9zZGr7yKmwaRQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOEcknHwYky9eo9YctcGmnav32TrFSqiChQlLdfCOO+DwPKx+5
	twQRUFUosljKXpWc3Zncymr0Qs++fRGDrxndQydqS+IdR/gf0YHkEKX0LVKT8GMuUg==
X-Gm-Gg: ASbGncuARCPv90rCOfUNMLEPjQoAqT6ca7ZPFH1hcP0iv3KPD12WuSMM4XCs3HNr2Of
	0ZkDBfm6wJfmhcrzF/v8AxWex3f3jlJsMTEwrnfVlbRUGsGFL8XgHb7JPCZcGJAcTN8ueNTe6jq
	+R40dxyz0FqZS4sg9jCsOqlUWt3WDigFGZPK6yeoD+QxY4DTiBbtqiBiiYnTuKEYPm0GzNkc5CI
	nLCAL6rBfYYLvU9PmNUIZUvVKRO0M+Nq2M6xF4zrFAWRXbuN+JaC707opd2Vf1jTAJC4V/lkzHx
	6CUpQckps/QCOgVLeGXeUL59upqfc4M16YgQqRRosv0WQWHB7iSvK1Ja0CtjWoTpjWIR8DfTUZa
	sARJ50sYwy9IH54fQqxzyWQAuEXDLenWgbECMD/FPeFTchaVXJlt2BPFxhPBmEtdGGfaUaw==
X-Google-Smtp-Source: AGHT+IHpXz7Rl+QKYOCiUh0stE/LvQiGqQu2cCoRgHmA+CQxnORb4ciGuF1F6j581pn63hwwkNtSVg==
X-Received: by 2002:a05:600c:a10d:b0:45f:2940:d194 with SMTP id 5b1f17b1804b1-4601d6b4da8mr520345e9.2.1758030214403;
        Tue, 16 Sep 2025 06:43:34 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e016b5a16sm223228305e9.12.2025.09.16.06.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 06:43:33 -0700 (PDT)
Date: Tue, 16 Sep 2025 13:43:30 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com
Subject: Re: [PATCH v4 02/28] KVM: arm64: Donate MMIO to the hypervisor
Message-ID: <aMlpghG9s3hl9G3Q@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-3-smostafa@google.com>
 <aMcoYCcJXjN64cOE@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aMcoYCcJXjN64cOE@google.com>

On Sun, Sep 14, 2025 at 08:41:04PM +0000, Pranjal Shrivastava wrote:
> On Tue, Aug 19, 2025 at 09:51:30PM +0000, Mostafa Saleh wrote:
> > Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
> > drivers can use that to protect the MMIO of IOMMU.
> > The initial attempt to implement this was to have a new flag to
> > "___pkvm_host_donate_hyp" to accept MMIO. However that had many problems,
> > it was quite intrusive for host/hyp to check/set page state to make it
> > aware of MMIO and to encode the state in the page table in that case.
> > Which is called in paths that can be sensitive to performance (FFA, VMs..)
> > 
> > As donating MMIO is very rare, and we don’t need to encode the full state,
> > it’s reasonable to have a separate function to do this.
> > It will init the host s2 page table with an invalid leaf with the owner ID
> > to prevent the host from mapping the page on faults.
> > 
> > Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
> > stage-2 PTEs, as this can be triggered from recycle logic under memory
> > pressure. There is no code relying on this, as all ownership changes is
> > done via kvm_pgtable_stage2_set_owner()
> > 
> > For error path in IOMMU drivers, add a function to donate MMIO back
> > from hyp to host.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 64 +++++++++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c                  |  9 +--
> >  3 files changed, 68 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 52d7ee91e18c..98e173da0f9b 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -37,6 +37,8 @@ int __pkvm_host_share_hyp(u64 pfn);
> >  int __pkvm_host_unshare_hyp(u64 pfn);
> >  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
> >  int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot);
> > +int __pkvm_host_donate_hyp_mmio(u64 pfn);
> > +int __pkvm_hyp_donate_host_mmio(u64 pfn);
> >  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
> >  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
> >  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 861e448183fd..c9a15ef6b18d 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -799,6 +799,70 @@ int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot)
> >  	return ret;
> >  }
> >  
> > +int __pkvm_host_donate_hyp_mmio(u64 pfn)
> > +{
> > +	u64 phys = hyp_pfn_to_phys(pfn);
> > +	void *virt = __hyp_va(phys);
> > +	int ret;
> > +	kvm_pte_t pte;
> > +
> > +	host_lock_component();
> > +	hyp_lock_component();
> > +
> > +	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL);
> > +	if (ret)
> > +		goto unlock;
> > +
> > +	if (pte && !kvm_pte_valid(pte)) {
> > +		ret = -EPERM;
> > +		goto unlock;
> > +	}
> > +
> > +	ret = kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL);
> > +	if (ret)
> > +		goto unlock;
> > +	if (pte) {
> > +		ret = -EBUSY;
> > +		goto unlock;
> > +	}
> 
> I'm thinking of a situation where both of these checks might be
> necessary.. The first check seems to confirm if the page being donated
> isn't set up to trap in the hyp (i.e. the donor/host doesn't own the
> page anymore). 
> 
> However, the second check seems to check if the pfn is already mapped
> in the hyp's space. Is this check only to catch errorneous donations of
> a shared page or is there something else?

The first check confirms that the host kernel owns the page, so it can
donate it.
The second check checks that the hypervisor doesn't already have something
mapped at this point.

I can't find a case where this happens, I believe the second is mainly a
debug check (similar to __pkvm_host_donate/share_hyp for normal memory.


Thanks,
Mostafa
> 
> > +
> > +	ret = pkvm_create_mappings_locked(virt, virt + PAGE_SIZE, PAGE_HYP_DEVICE);
> > +	if (ret)
> > +		goto unlock;
> > +	/*
> > +	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
> > +	 * - host aborts: host_stage2_adjust_range() would fail for invalid non zero PTEs.
> > +	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would call
> > +	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid ptes (counted).
> > +	 * - other MMIO donation: Would fail as we check that the PTE is valid or empty.
> > +	 */
> > +	WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt, phys,
> > +				PAGE_SIZE, &host_s2_pool, PKVM_ID_HYP));
> > +unlock:
> > +	hyp_unlock_component();
> > +	host_unlock_component();
> > +
> > +	return ret;
> > +}
> > +
> > +int __pkvm_hyp_donate_host_mmio(u64 pfn)
> > +{
> > +	u64 phys = hyp_pfn_to_phys(pfn);
> > +	u64 virt = (u64)__hyp_va(phys);
> > +	size_t size = PAGE_SIZE;
> > +
> > +	host_lock_component();
> > +	hyp_lock_component();
> > +
> > +	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
> > +	WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt, phys,
> > +				PAGE_SIZE, &host_s2_pool, PKVM_ID_HOST));
> > +	hyp_unlock_component();
> > +	host_unlock_component();
> > +
> > +	return 0;
> > +}
> > +
> >  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
> >  {
> >  	return ___pkvm_host_donate_hyp(pfn, nr_pages, PAGE_HYP);
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index c351b4abd5db..ba06b0c21d5a 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1095,13 +1095,8 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
> >  	kvm_pte_t *childp = NULL;
> >  	bool need_flush = false;
> >  
> > -	if (!kvm_pte_valid(ctx->old)) {
> > -		if (stage2_pte_is_counted(ctx->old)) {
> > -			kvm_clear_pte(ctx->ptep);
> > -			mm_ops->put_page(ctx->ptep);
> > -		}
> > -		return 0;
> > -	}
> > +	if (!kvm_pte_valid(ctx->old))
> > +		return stage2_pte_is_counted(ctx->old) ? -EPERM : 0;
> >  
> >  	if (kvm_pte_table(ctx->old, ctx->level)) {
> >  		childp = kvm_pte_follow(ctx->old, mm_ops);
> > -- 
> 
> Thanks
> Praan
