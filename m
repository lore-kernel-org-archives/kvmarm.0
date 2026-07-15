Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDF2446C19
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 18:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141024; cv=none; b=Ijmk2t7LJRZ9zntKDrsHm0v6VAiTQ0LbiiBPQshGm9NmmQ8V82ZcxRQB1h5RezO4Hxjsnv/S3ArgHdofECTJfnnJ6YRP36WrojXd45DdqiCr4hZ1ZV3Ab2ocTgV9vde/Sc16qKAFK6k4bxrMa/i0jNWjTyJJ0iuOMpi4tkC+6CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141024; c=relaxed/simple;
	bh=vrkkyP98rQHenSpfx7wBuzH0PFQjBLdF0aw4z7GFrdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvXGjcJFT5giJKSOq7DQvH3309hgr90zIjvLrWtXcx1aoyD7PLcbOXlTh6zpQ13GHvEE16cDcPv9keMEwZ1KtrSnzkyeZZ0MEo21FVLnGyuX7ZUKJZqKP/1MkOutx05AfOh4i+4BsL851tsGHvVv4RSpAK4+N6uLSpvLy9jPgpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kXWxi4lg; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kXWxi4lg"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493c556ada3so9015e9.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784141006; x=1784745806; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ONrkZYCh5Okv7WFSmS8LJPVH6J3l7WkmLNTE/oBXpcg=;
        b=kXWxi4lgPeJHP0Ig3C1Lntc1maPXenFEM+/cI5G4t9mfmgjjOZnlaHcWDFxEn4Z5af
         edbPRGBBfvr3YqGY/AZkAfIuDUDlYJdwWH0FCPpVlklM9NxIHkiA3RsvvV0BDnMU3qDy
         kNfpnzMGzTtxFGGYcNl4D13JWT9PQViLfL0I4LVPt//JJ2I7nhtJn1RK4W00vovFnsYc
         /yRgQ+Aq2PAaJo3XSqh1j9/YxtPxoOst9iM3cnEqfAUCk5T2sLf5FlJZf1eOBZzS1WZ1
         OxuXSOP9KV8hFmn6FlxMvEqN2Kdr7WVBagDLTKiiKnVw9CO6mS4jLDgYCXVgLyhx+DxF
         bJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784141006; x=1784745806;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ONrkZYCh5Okv7WFSmS8LJPVH6J3l7WkmLNTE/oBXpcg=;
        b=NjjOVc9QyRF3RniqaoyRd8KDsupOzdL0DYA6JwjA08boAXX7voLLSMFJy9UuXh+YR7
         TJkPkPuaeV60LGym9m7Fqe6n8hW9F4CQ99g0PwEVpeQCUpx7LO7MgAe8R9PyLEbvj9Tp
         5xLsKQ1xfS4QJW43UcdZ2skVQiRJF4rK4dIrcS1NhI27wHWVYRBrfEVyr0tC/EuFJzEY
         UegLTgLySDUtJsX6XNVLRVa5MtU90GLhV5YXRr9lMoCob+jOd/KSDB6ajvinQRMtEpkE
         h7SY8eaFIDrvWJLqubhNMCfZkydfakdyyRUho6Rof749vDF0PDHMEZFQznfMiIJw3RxG
         iJSg==
X-Forwarded-Encrypted: i=1; AHgh+RpHJgC+G4296sM5Fraa5VBUpfjAlINSE4Rqh/JOMN+99Y5xzNTY4PFLuzDiGgTgCB+KJpQUfEg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwB07kXZ3Zz++OTEg8QEzL2hyLuH7q55QmKfN2AJ7G+KpdwLhD
	8zeRJ52zLd/URF2upeI++/7AhqUogXmhOsSeAYwPOdQMg9S25Nz66RwhMNYaagxY3Q==
X-Gm-Gg: AfdE7ck5QDvmBEvRg9wphMEgVyIEAYHr4n4sNdqKvuRlcRGaRJeg4s7ALdc+fCZORCJ
	5Kp9HxIlwvIzGdPG7yUcqv3m3/HoDFgOj9+qZP5pvMrV/4kqXHfUoU1h/4bK3SruDdmkdejirjd
	MkhZVi6h+Hkx/xerhjbYV5dOhGPUUxODZhQVgVK2EKQYbjfS7YmLB4mS8u922+9G4DdfvKYM3YO
	z1i6tVlVHtw8Reaf5+nXij13nxAPN2+vO71gmRidysBko+ZuUF+ARqSg8vnPV+utk1RRK8tERCU
	nFPI88TsjDDK3BFbBhOjZETflR0cy36kkJnqcvov+PsUhiEb0B99JrymiTMvyi6r3/ywjDVxF97
	o6hpgovXR4mNcJ5EzPEoNR+T2ykHIB+FqDaoI4URQrIPqRlem6hWTdJ1d5m1lV/c2cMAvJJ+Myf
	RaonaC//EPp9QcIoBNbBvcIq/Ja8dsR7WaHJy9TIdM9TIOJTRUlB7VMmV94Uw=
X-Received: by 2002:a05:600c:605a:b0:490:b2ae:44ca with SMTP id 5b1f17b1804b1-49541e9a8ccmr10545e9.5.1784141005664;
        Wed, 15 Jul 2026 11:43:25 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4953c704bfasm77694915e9.2.2026.07.15.11.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:43:24 -0700 (PDT)
Date: Wed, 15 Jul 2026 18:43:21 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v7 07/24] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <alfUyfyAIFURy39W@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-8-smostafa@google.com>
 <alfJ0cLRSw-qmCrP@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alfJ0cLRSw-qmCrP@google.com>

On Wed, Jul 15, 2026 at 06:56:33PM +0100, Vincent Donnefort wrote:
> On Wed, Jul 15, 2026 at 11:58:48AM +0000, Mostafa Saleh wrote:
> > Create a page-table for the IOMMU that shadows the host CPU stage-2
> > to establish DMA isolation.
> > 
> > An initial snapshot is created after the driver init, then
> > on every permission change a callback would be called for
> > the IOMMU driver to update the page table.
> > 
> > There are 3 different ways to add the callback:
> > 1) In the high level memory transitions: (__pkvm_host_donate_hyp(),
> >   __pkvm_host_donate_guest()...
> > 
> > 2) In Lower level functions covering all transitions
> >   - host_stage2_set_owner_metadata_locked() which covers:
> >    - __pkvm_host_donate_hyp()
> >    - __pkvm_host_donate_guest()
> >    - __pkvm_host_donate_hyp()
> >    - __pkvm_guest_unshare_host()
> >   - host_stage2_set_owner_locked() only for ID_HOST which covers:
> >    - __pkvm_hyp_donate_host()
> >    - __pkvm_host_force_reclaim_page_guest()
> >    - __pkvm_host_reclaim_page_guest()
> >   - __pkvm_guest_share_host()
> > 
> > 3) In the lowest level function __host_update_page_state(), which
> >    requires only one callback. However, in that case the page state
> >    is not enough as we might need to know the old state also.
> > 
> > Option #2 was implemented here.
> > 
> > For some cases, an SMMUv3 may be able to share the same page-table
> > used with the host CPU stage-2 directly.
> > 
> > However, this is too strict and requires changes to the core hypervisor
> > page-table code, plus it would require the hypervisor to handle IOMMU
> > page-faults. This can be added later as an optimization for SMMUV3.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/iommu.h       |   4 +
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   1 +
> >  arch/arm64/kvm/hyp/nvhe/iommu.c               | 129 +++++++++++++++++-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  27 ++--
> >  4 files changed, 145 insertions(+), 16 deletions(-)
[...]
> > +
> > +/*
> > + * IOMMU page tables are shadowed and not shared, that is mainly because:
> > + * - Possible inconsistency between IOMMU and CPU features or format.
> > + * - KVM relies on handling in page faults (BBM, lazy mapping).
> > + */
> > +static int __snapshot_host_stage2(const struct kvm_pgtable_visit_ctx *ctx,
> > +				  enum kvm_pgtable_walk_flags visit)
> > +{
> > +	u64 start = ctx->addr;
> > +	u64 block_end = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level)) +
> > +			kvm_granule_size(ctx->level);
> 
> nit: I believe that for more complex init like that we should just put it after
> the declarations.

I see, I will fix it.

> 
> > +	u64 end = min(ctx->end, block_end);
> > +	kvm_pte_t pte = *ctx->ptep;
> > +	bool is_memory = *(bool *)ctx->arg;
> > +	int prot;
> > +
> > +	/*
> > +	 * Keep annotated PTEs unmapped, and map everything else even lazily
> > +	 * mapped PTEs(0), as the IOMMU can't handle page faults.
> > +	 * That maps the whole address space which can be large, but that doesn't
> > +	 * use a lot of memory as it will be mostly large block (1 GB with 4kb pages)
> > +	 */
> > +	if (pte && !kvm_pte_valid(pte))
> >  		return 0;
> >  
> > -	return pkvm_iommu_ops->init();
> > +	if (kvm_pte_valid(pte))
> > +		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
> > +	else
> > +		prot = IOMMU_READ | IOMMU_WRITE;
> > +
> > +	if (!is_memory)
> > +		prot |= IOMMU_MMIO;
> > +
> > +	return pkvm_iommu_ops->host_stage2_idmap(start, end, prot);
> > +}
> > +
> > +static int pkvm_iommu_snapshot_host_stage2(void)
> > +{
> > +	struct kvm_pgtable *pgt = &host_mmu.pgt;
> > +	bool is_memory;
> > +	struct kvm_pgtable_walker walker = {
> > +		.cb	= __snapshot_host_stage2,
> > +		.flags	= KVM_PGTABLE_WALK_LEAF,
> > +		.arg	= &is_memory,
> > +	};
> > +	int ret = 0, i;
> > +	u64 start = 0;
> > +
> > +	hyp_spin_lock(&host_mmu.lock);
> > +	for (i = 0; i < hyp_memblock_nr; i++) {
> > +		struct memblock_region *reg = &hyp_memory[i];
> > +
> > +		if (start < reg->base) {
> > +			is_memory = false;
> > +			ret = kvm_pgtable_walk(pgt, start, reg->base - start, &walker);
> 
> nit: You could have a helper? So is_memory isn't passed as a reference.
> 
> __snapshot_host_stage2(u64 start, u64 end, bool is_memory)

Not sure I understand, the function signature is defined by the walker,
or do you mean __snapshot_host_stage2() should call another function
were we pass is_memory? That does not seem necessary, the function
is small already.

> > +			if (ret)
> > +				goto out_unlock;
> > +		}
> > +
> > +		is_memory = true;
> > +		ret = kvm_pgtable_walk(pgt, reg->base, reg->size, &walker);
> > +		if (ret)
> > +			goto out_unlock;
> > +
> > +		start = reg->base + reg->size;
> > +	}
> > +
> > +	if (start < BIT(pgt->ia_bits)) {
> > +		is_memory = false;
> > +		ret = kvm_pgtable_walk(pgt, start, BIT(pgt->ia_bits) - start, &walker);
> > +		if (ret)
> > +			goto out_unlock;
> > +	}
> > +
> > +	pkvm_idmap_initialized = true;
> > +
> > +out_unlock:
> > +	hyp_spin_unlock(&host_mmu.lock);
> > +	return ret;
> > +}
> > +
> > +int pkvm_iommu_init(void)
> > +{
> > +	int ret;
> > +
> > +	/* Keep DMA isolation optional. */
> > +	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init ||
> > +	    !pkvm_iommu_ops->host_stage2_idmap)
> > +		return 0;
> > +
> > +	ret = pkvm_iommu_ops->init();
> > +	if (ret)
> > +		return ret;
> > +
> > +	return pkvm_iommu_snapshot_host_stage2();
> > +}
> > +
> > +int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
> > +				enum kvm_pgtable_prot prot)
> > +{
> > +	hyp_assert_lock_held(&host_mmu.lock);
> > +
> > +	if (!pkvm_idmap_initialized)
> > +		return 0;
> > +
> > +	return pkvm_iommu_ops->host_stage2_idmap(start, end, pkvm_to_iommu_prot(prot));
> 
> Out of curiosity, why is it "host_stage2_idmap" and not just "idmap" ?
> 

Well it's a host stage-2 idmap :), maybe one day we support guests also!

> >  }
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index d803b3dd4cb4..ce610274bda0 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -17,6 +17,7 @@
> >  
> >  #include <nvhe/arm-smccc.h>
> >  #include <nvhe/gfp.h>
> > +#include <nvhe/iommu.h>
> >  #include <nvhe/memory.h>
> >  #include <nvhe/mem_protect.h>
> >  #include <nvhe/mm.h>
> > @@ -596,16 +597,15 @@ static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
> >  	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> >  			      addr, size, &host_s2_pool,
> >  			      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
> > -	if (!ret) {
> > -		/*
> > -		 * After stage2 maintenance has happened, but before the page
> > -		 * owner has changed.
> > -		 */
> > -		pkvm_sme_dvmsync_fw_call();
> > -		__host_update_page_state(addr, size, PKVM_NOPAGE);
> > -	}
> > -
> > -	return ret;
> > +	if (ret)
> > +		return ret;
> > +	/*
> > +	 * After stage2 maintenance has happened, but before the page
> > +	 * owner has changed.
> > +	 */
> > +	pkvm_sme_dvmsync_fw_call();
> > +	__host_update_page_state(addr, size, PKVM_NOPAGE);
> > +	return pkvm_iommu_host_stage2_idmap(addr, addr + size, 0);
> 
> On error here the host stage-2 annotation needs to be reverted. Or just
> WARN_ON() here. It also probably better to do it before the page-state has
> changed, even if we hold the host stage-2 lock.
> 

I saw that all the callers will WARN on failure, that's why I did
not handle the failure. I can move it earlier.

> >  }
> >  
> >  int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> > @@ -618,8 +618,10 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> >  			return -EPERM;
> >  
> >  		ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
> > -		if (!ret)
> > -			__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
> > +		if (ret)
> > +			break;
> > +		__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
> > +		ret = pkvm_iommu_host_stage2_idmap(addr, addr + size, PKVM_HOST_MEM_PROT);
> >  		break;
> >  	case PKVM_ID_HYP:
> >  		ret = host_stage2_set_owner_metadata_locked(addr, size,
> > @@ -1022,6 +1024,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
> >  				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
> >  				       &vcpu->vcpu.arch.pkvm_memcache, 0));
> >  	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
> > +	WARN_ON(pkvm_iommu_host_stage2_idmap(phys, phys + PAGE_SIZE, PKVM_HOST_MEM_PROT));
> 
> Ha ok I understand your remark yesterday. I thought you'd put
> pkvm_iommu_host_stage2_idmap() into host_stage2_idmap_locked()... but then it
> means it tries to map on very host abort. 

Yes, actually this version is less efficient than v6, as now on VM
teardown we re-map all the VM pages including the shared ones which
are already in the IOMMU. It's is not terrible but the but the
io-pgtable detects that and return -EEXIST which I added new code
in this version to ignore.

> 
> (same though as host_stage2_set_owner_metadata_locked(), I would first update
> the iommu and then update the page-state)

Will do.

Thanks,
Mostafa

> 
