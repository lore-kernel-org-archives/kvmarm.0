Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0F938F93B
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 12:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785934034; cv=none; b=aQS7JH1RtFBfcovx8ZQXcmBiFBz5onHwl7/MV/CSRctzyQpXUljJ6vR48fw4OGuLwFj36sHcEmkWAmttezyPRuMEbF9PtUIoS7NGev1KUVQL1BNAI68lAb07dm5VTNTqpc+s3L2zlqWaSVVmAWsd5dwiL+gAWRupjDNRWG8uh1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785934034; c=relaxed/simple;
	bh=i6MiAQO2W3J8sXVcrnpitQrYRmdGuWqp7QnXGb4Whp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GXRAzeMAq47rfhxnwX9KbaCtZtjhkMLeY/9j4WT67NZEgPqqbzzBJhg+MQJFNaBQ/piBhHUAp5orfnYy9HRO+RYgNSFPZANO+bln2oOXF2oV2Ndd4ZXm+48UbjjlAZp29M0W9yANVgGjeg/u1rAA43NwZ+BQ+z4W5CTZsjIH4TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EXqQ9XJL; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EXqQ9XJL"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69fec8b4638so11018a12.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Aug 2026 05:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785934029; x=1786538829; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XWYvdwwhHXOZMdpKG9po4fGYOA5/a+2jpomAjIrH0/E=;
        b=EXqQ9XJLyENPdDzVB1T+opLoZrn41MpwW+BAronQBhn/fFVrHWbOp8aetwHZWe58Uo
         SWH1rS9Om39rriTEK/yNOIFC4sYPWRYPYZYNPpVXUAdtKdM1/CtkwUkv5jBVUknIr2cW
         3ryoXmRaCPyB5GvLqxl9x4MolZPSw3lXbPa5Cs8RRvfzLPTuNMq9lb7Vekn18lW18psh
         bvhc4A7xm73Ip3wX1YIQVpIOagM43osF4T3nQ1v3+fGON+t1YpmxpdLs6DDoMAEgjB1A
         b1EeZWASpsFLbvqIoGHCRnI9g+H6XrgiJ2cuaJoTiZ0rTn6ghn7lSLzKPOjGP2YBxpUw
         tFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785934029; x=1786538829;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XWYvdwwhHXOZMdpKG9po4fGYOA5/a+2jpomAjIrH0/E=;
        b=dAeV0plcbHrnTTepLnhvSlXzNkcxluX2o6mUyuYwOHR8jPYRnSUWdxf7yl/RGGjAN0
         Th5Vu3cvd30X3zbspjPWlCTm5G7hZZE9wa1UnVhRRRQT5q5OanmKYUs+bf+LsxbLrc5L
         70NvTx2LSx+NidDCmCH8u4Odjk1N29EMghSzwtE+ruuaf+1W4tLUBgNoqb6dL5f9W1sr
         LSex1ZdMFrqWNFXIRZL+zspcx1qOY+rewYFDMRJEANX+suyhm6HJlspDSVtOH9F0yW/h
         mE7URnORbSlMI7l5w4sMIJqHJO+buXBRbdNJEtSqwCz6lyVK+o0YsMMXVRoDk4u8f0RH
         JqdQ==
X-Forwarded-Encrypted: i=1; AHgh+RrMfxcK0uec4In/4z75KFMqLTXeolzJgXBmb1m2vYSLV9GIwEDi9nqx9EZMO3ogXKrbB1MmGiE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/LFDfw+Lmu39HVy6g/0RFjyijAo78rO4AQupIfHlAUU12e6YV
	bRBVzdSSAyBnwwHVMV2pz/XKmCSWaiuD0OSc5ICxZcNLfPtUvPzNdT0guf5ID72hAA==
X-Gm-Gg: AR+sD12RG18RGeocAmauKYv2d4AstsUzjV0OUoG1gb2OwBo/XQyXSKczQRem2C+LiAm
	UMH3vMqskfGhT1414Tm4OJ5+DOSBng1U2s2cTqnOea/+4OKsj0mXhflZWDNSeBFh/uj57H7E/VC
	pDWf4YK6IeXg11DYTAId7OpPl4XBQ9Y5B47DXJJ/kUP1PWFhzwgReKCRf/QJI7ZidQ+HscGEnfg
	StKHj1cD2+B3NKBqlTiFa1v2L1gzF5SFN2OQTjdSQOQDjGmmxenBCCK66Z2lhViXEdv8jfJkuOV
	Cf+UpdqP4OCxcBgjJqdjSSonRK3GTQsUqgtJ6k73z5Q/+bANBy9uQBl17h1MeoqU93Wx8fy12G9
	6t9KTUhxQRG+lEyD/duCNxRGAiD/GfbPZ63F7G+EYGT8Z4aUHdbHn0I2gFNAbpq9f9RYwM5EiJj
	uUrE85+WhLUrf7hxyA3qsEpHuFn2Pcjc4KXzmex9PIvp4i1DPsa8hZd7YCFKN3BEuh+kC+W/qBp
	DNJAFb65YIoF9tKa4KndWhGhtc6KkNkzILOmrJ0iFQj
X-Received: by 2002:aa7:d747:0:b0:6a1:8b8f:bec4 with SMTP id 4fb4d7f45d1cf-6a18b8fc391mr1793a12.4.1785934028557;
        Wed, 05 Aug 2026 05:47:08 -0700 (PDT)
Received: from google.com (63.235.189.35.bc.googleusercontent.com. [35.189.235.63])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a1453d3825sm2028486a12.0.2026.08.05.05.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 05:47:07 -0700 (PDT)
Date: Wed, 5 Aug 2026 12:47:03 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, keirf@google.com
Subject: Re: [PATCH v7 02/24] KVM: arm64: Donate MMIO to the hypervisor
Message-ID: <anMwxy9gEEt_Wu6M@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-3-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260715115906.2664882-3-smostafa@google.com>

On Wed, Jul 15, 2026 at 11:58:43AM +0000, Mostafa Saleh wrote:
> Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
> drivers can protect and access the MMIO of IOMMUs.
> 
> As donating MMIO is very rare, and we don’t need to encode the full
> state, it’s reasonable to have a separate function to do this.
> It will init the host s2 page table with an invalid leaf with the owner ID
> to prevent the host from mapping the page on faults.
> 
> Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
> stage-2 PTEs, as this can be triggered from recycle logic under memory
> pressure. There is no code relying on this, as all ownership changes is
> done via kvm_pgtable_stage2_set_owner()
> 
> For the error path in IOMMU drivers, add a function to donate MMIO
> back from hyp to host. However, that leaks the hypervisor virtual
> address range which should be acceptable as this is quite rare and
> it matches the behaviour of fix_map/block.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  7 ++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 91 ++++++++++++++++++-
>  arch/arm64/kvm/hyp/pgtable.c                  | 11 +--
>  3 files changed, 102 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 29935c7da1de..51b0eb3844a9 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -36,6 +36,13 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
>  int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
>  int __pkvm_host_unshare_hyp(u64 pfn);
>  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
> +/*
> + * Donate MMIO range to the hypervisor, it will be mapped in the hypervisor's
> + * private range and unmapped from the host stage-2.
> + */
> +int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned long *haddr);
> +/* Remaps MMIO range in the host, typically used in error path. */
> +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size);
>  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 4e329e39a695..d803b3dd4cb4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -378,7 +378,11 @@ static int host_stage2_unmap_dev_all(void)
>  	u64 addr = 0;
>  	int i, ret;
>  
> -	/* Unmap all non-memory regions to recycle the pages */
> +	/*
> +	 * Unmap all non-memory regions to recycle the pages.
> +	 * That relies on kvm_pgtable_stage2_unmap() not clearing
> +	 * counted PTEs which include hypervisor MMIO.
> +	 */
>  	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
>  		reg = &hyp_memory[i];
>  		ret = kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
> @@ -1119,6 +1123,91 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
>  	return ret;
>  }
>  
> +int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned long *haddr)
> +{
> +	kvm_pte_t pte;
> +	u64 offset;
> +	int ret;
> +
> +	/* Only before de-privilege. */
> +	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> +		return -EPERM;
> +
> +	if (!PAGE_ALIGNED(addr | size) ||
> +	    !pfn_range_is_valid(hyp_phys_to_pfn(addr), size >> PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	ret = __pkvm_create_private_mapping(addr, size, PAGE_HYP_DEVICE, haddr);

> +	if (ret)
> +		return ret;
> +
> +	host_lock_component();
> +	for (offset = 0; offset < size; offset += PAGE_SIZE) {
> +		if (addr_is_memory(addr + offset)) {
> +			ret = -EINVAL;
> +			goto unlock;

If this fails we are left with the mapping inside the hyp because the unlock
doesn't destroy the private mapping. Is this intended ?

> +		}
> +		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
> +		if (ret)
> +			goto unlock;
> +		if (pte && !kvm_pte_valid(pte)) {
> +			ret = -EPERM;
> +			goto unlock;
> +		}
> +	}
> +	/*
> +	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
> +	 * - host aborts: host_stage2_adjust_range() would fail for invalid non zero PTEs.
> +	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would call
> +	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid ptes (counted).
> +	 * - other MMIO donation: Would fail as we check that the PTE is valid or empty.
> +	 */
> +	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> +			      addr, size, &host_s2_pool,
> +			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
> +			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
> +unlock:
> +	host_unlock_component();
> +	return ret;
> +}
> +
> +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size)

This function seems to only update the host stage-2 annotation but it
doesn't destroy the hyp mapping.

I was looking to make use of this patch in an upcoming posting for the
v2 ITS hardening but in my case I don't need the private VA range
creation.

Thanks,
Sebastian

> +{
> +	kvm_pte_t pte;
> +	u64 offset;
> +	int ret = 0;
> +
> +	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> +		return -EPERM;
> +
> +	if (!PAGE_ALIGNED(addr | size) ||
> +	    !pfn_range_is_valid(hyp_phys_to_pfn(addr), size >> PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	host_lock_component();
> +	for (offset = 0; offset < size; offset += PAGE_SIZE) {
> +		if (addr_is_memory(addr + offset)) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
> +		if (ret)
> +			goto unlock;
> +		if (!pte || kvm_pte_valid(pte)) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +		if (FIELD_GET(KVM_HOST_DONATION_PTE_OWNER_MASK, pte) != PKVM_ID_HYP) {
> +			ret = -EPERM;
> +			goto unlock;
> +		}
> +	}
> +	WARN_ON(host_stage2_idmap_locked(addr, size, PKVM_HOST_MMIO_PROT));
> +unlock:
> +	host_unlock_component();
> +	return ret;
> +}
> +
>  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
>  {
>  	u64 phys = hyp_pfn_to_phys(pfn);
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 91a7dfad6686..3073184cf6ad 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1161,13 +1161,12 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	kvm_pte_t *childp = NULL;
>  	bool need_flush = false;
>  
> -	if (!kvm_pte_valid(ctx->old)) {
> -		if (stage2_pte_is_counted(ctx->old)) {
> -			kvm_clear_pte(ctx->ptep);
> -			mm_ops->put_page(ctx->ptep);
> -		}
> +	/*
> +	 * That also ignores stage2_pte_is_counted() instead of clearing
> +	 * the PTE as the MMIO can be owned by the hypervisor.
> +	 */
> +	if (!kvm_pte_valid(ctx->old))
>  		return 0;
> -	}
>  
>  	if (kvm_pte_table(ctx->old, ctx->level)) {
>  		childp = kvm_pte_follow(ctx->old, mm_ops);
> -- 
> 2.55.0.141.g00534a21ce-goog
> 
