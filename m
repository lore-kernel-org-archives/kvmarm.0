Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0104744E664
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 13:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785937339; cv=none; b=kvEe0s7n1BoTZX7c3tfnTpYCIGiUsigXi8WTDI9TLkwsytVNiqkzOnE3PkWvUHVSZo1i5jdiSb72ogWgrOTZjqD/b2wbKbbxWsViYhKg0c1X2uov0js26wAlZ1w3cmFC+2KY9y6ISw8VfcBcaBNHh+ocoQGFNuwUw0gWy+kF8O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785937339; c=relaxed/simple;
	bh=7kUBW9e/onM1wKjYT9kKKmLLDlUPg1Zv1oWBBE9EUS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NONoy494TWWboGJN4N2VxYsD+lq0iBSCDJ6X789freSP8HHIU8GYDyVbAbrSo3XAEowXKQNi7EOmB1BX9fiMWzZWJ7PtkcXROYlEb3JQ+UmkW4v7y3dI7oVJa8EkdJCMOMDMO6AGt6j686UafCrJvsekQlMf4IyE6BJxgLFgYsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aws9DgOV; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aws9DgOV"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-69fec8b4638so11669a12.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Aug 2026 06:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785937336; x=1786542136; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pHYWzmu6ZuPAY5Z9zsBk2vZkLf/NrY20M76Txnt8CKc=;
        b=aws9DgOV84iz7f+c4G0fPm4yLdRfOfEOutxmHdd+NxzfMnMYC6Us1+GIqf4IdY7hhH
         miKe8ZLnVEQYknCq09lz/Sb/gbE8NnRSf/Z6KRdkkOQf4MwSjgt+13Iui5WzhcT9ZCJY
         TQ1CXG12JHuJxQNgted/xSzWxAHd8CPsgQXw5W7jC1cCx4T1W0t+i7UK1T0eRRYUz01b
         T9jkBeI0VrPm7zR5ZD+fZyp0m8VES8WWWi/CVbGpgrO64TRsFXJvPtQJnsHRgSCXqbAe
         yfy31gmXIKdQpIz484UEV51gePUc47R53tc930/iN58p+KFgF/ZSo/w67NVaibLH5i9l
         M9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785937336; x=1786542136;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pHYWzmu6ZuPAY5Z9zsBk2vZkLf/NrY20M76Txnt8CKc=;
        b=OengHG0cORD6iySLtXYyr9aGQlMq5hRFSefOvy1NLoIEry2qYdpIe4HnXowgEt1HBc
         P3t8kEN6Uia2e32cWMQidLCEeC/XStowxpKgCuUFlEYgMRZV2PJPxsX0LxCOAI1CTEPZ
         jI4E51g6VkRZNMh2iK1X+yroro8Lf6iiIE1Cp88dHovQ+j8McIkekX/dXfA7cEzLIpNj
         FZjnOaWjyc+lRgsa81dOpKjbHKZ5t6kYPnfH6FvueSMa9ZVuocRhki31tEJqa1/KKL0T
         hf9UGwAS04uLxm+iVQDOV0YEh71ac4acyAnAdlaa53VozxbNyIgImiV5QefKi/C4gVht
         be9A==
X-Forwarded-Encrypted: i=1; AHgh+RqmllA/mHJUi2kdb0wtz9NSWRuobygIVEvWyhsAjKcErn2jtDrJ2jTEugwkr+XMaldv+2Ps6cU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwX8R6xGpZnEb1mQltXBxqJ6Gn1pECJD7Wyp3yvUSPJZeCGR/ZN
	xtbhJDhkSpmtzqFKv56Sull0I1KfceM922+RECe7JSgkb5Hw+TtvV+cXgzpY9gFCnA==
X-Gm-Gg: AR+sD13pvBm2dCd6AOfRANclQXJgSIgzmXNlIWBwJUtJ5vscY50DKVUyczMQefdg8Uy
	cka4fEsbeHgavRnUSrc4BQs0vjapzXnxfq3SP8UIugO3dk8M2NJIsGTUMr4pSudiAe1l9SREFDU
	/PZHnFBlanEFHBIHXVQwFTDuMrtR6b3Fl2Fy3wjn4HkHScO3p6nzGou4YuBuT4h+I8s1EX/i8cg
	zRKokjheLTT1YuooQ7x8ENm27ypxKJlvzKtAacsKGxPm8cAmjfORQjOibF6K6dNh/OYZs5LvBdB
	wCgBCUnI68B14iQ2nkCZnU8e8b8obidqq+wvQAehBFfxMprbQ6IbLktqdhwAOZNJjzhLT3jnInu
	Jh+s1cGT6LmX2wq7Xqm4i5T2UzpJjkEjFPaJz41mevfS8s6nDWXzY4cZ7AdQ/L4tJRXFEYbcsGt
	dI+pgutooScCUSaxrgi/LbTdaZpIgEhMXnras3n791CkZFD2F6qL7HeqaK82qmLEphuFIwsPuGH
	NCB/U0e6Eif8FC/T/PLmFIZn2Q/OA==
X-Received: by 2002:aa7:dbc1:0:b0:69f:d9cd:ec41 with SMTP id 4fb4d7f45d1cf-6a14fc57373mr57486a12.6.1785937335722;
        Wed, 05 Aug 2026 06:42:15 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c20560bab69sm8654166b.37.2026.08.05.06.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 06:42:14 -0700 (PDT)
Date: Wed, 5 Aug 2026 13:42:10 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, keirf@google.com
Subject: Re: [PATCH v7 02/24] KVM: arm64: Donate MMIO to the hypervisor
Message-ID: <anM9sk_gXTt5F1Ie@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-3-smostafa@google.com>
 <anMwxy9gEEt_Wu6M@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <anMwxy9gEEt_Wu6M@google.com>

On Wed, Aug 05, 2026 at 12:47:03PM +0000, Sebastian Ene wrote:
> On Wed, Jul 15, 2026 at 11:58:43AM +0000, Mostafa Saleh wrote:
> > Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
> > drivers can protect and access the MMIO of IOMMUs.
> > 
> > As donating MMIO is very rare, and we don’t need to encode the full
> > state, it’s reasonable to have a separate function to do this.
> > It will init the host s2 page table with an invalid leaf with the owner ID
> > to prevent the host from mapping the page on faults.
> > 
> > Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
> > stage-2 PTEs, as this can be triggered from recycle logic under memory
> > pressure. There is no code relying on this, as all ownership changes is
> > done via kvm_pgtable_stage2_set_owner()
> > 
> > For the error path in IOMMU drivers, add a function to donate MMIO
> > back from hyp to host. However, that leaks the hypervisor virtual
> > address range which should be acceptable as this is quite rare and
> > it matches the behaviour of fix_map/block.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  7 ++
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 91 ++++++++++++++++++-
> >  arch/arm64/kvm/hyp/pgtable.c                  | 11 +--
> >  3 files changed, 102 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 29935c7da1de..51b0eb3844a9 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -36,6 +36,13 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
> >  int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
> >  int __pkvm_host_unshare_hyp(u64 pfn);
> >  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
> > +/*
> > + * Donate MMIO range to the hypervisor, it will be mapped in the hypervisor's
> > + * private range and unmapped from the host stage-2.
> > + */
> > +int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned long *haddr);
> > +/* Remaps MMIO range in the host, typically used in error path. */
> > +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size);
> >  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
> >  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
> >  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 4e329e39a695..d803b3dd4cb4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -378,7 +378,11 @@ static int host_stage2_unmap_dev_all(void)
> >  	u64 addr = 0;
> >  	int i, ret;
> >  
> > -	/* Unmap all non-memory regions to recycle the pages */
> > +	/*
> > +	 * Unmap all non-memory regions to recycle the pages.
> > +	 * That relies on kvm_pgtable_stage2_unmap() not clearing
> > +	 * counted PTEs which include hypervisor MMIO.
> > +	 */
> >  	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
> >  		reg = &hyp_memory[i];
> >  		ret = kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
> > @@ -1119,6 +1123,91 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
> >  	return ret;
> >  }
> >  
> > +int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned long *haddr)
> > +{
> > +	kvm_pte_t pte;
> > +	u64 offset;
> > +	int ret;
> > +
> > +	/* Only before de-privilege. */
> > +	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> > +		return -EPERM;
> > +
> > +	if (!PAGE_ALIGNED(addr | size) ||
> > +	    !pfn_range_is_valid(hyp_phys_to_pfn(addr), size >> PAGE_SHIFT))
> > +		return -EINVAL;
> > +
> > +	ret = __pkvm_create_private_mapping(addr, size, PAGE_HYP_DEVICE, haddr);
> 
> > +	if (ret)
> > +		return ret;
> > +
> > +	host_lock_component();
> > +	for (offset = 0; offset < size; offset += PAGE_SIZE) {
> > +		if (addr_is_memory(addr + offset)) {
> > +			ret = -EINVAL;
> > +			goto unlock;
> 
> If this fails we are left with the mapping inside the hyp because the unlock
> doesn't destroy the private mapping. Is this intended ?
> 

Yes, there is no way to remove a private mapping at the moment, all
the callers to __pkvm_create_private_mapping() will leak it on failure.

> > +		}
> > +		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
> > +		if (ret)
> > +			goto unlock;
> > +		if (pte && !kvm_pte_valid(pte)) {
> > +			ret = -EPERM;
> > +			goto unlock;
> > +		}
> > +	}
> > +	/*
> > +	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
> > +	 * - host aborts: host_stage2_adjust_range() would fail for invalid non zero PTEs.
> > +	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would call
> > +	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid ptes (counted).
> > +	 * - other MMIO donation: Would fail as we check that the PTE is valid or empty.
> > +	 */
> > +	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> > +			      addr, size, &host_s2_pool,
> > +			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
> > +			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
> > +unlock:
> > +	host_unlock_component();
> > +	return ret;
> > +}
> > +
> > +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size)
> 
> This function seems to only update the host stage-2 annotation but it
> doesn't destroy the hyp mapping.

Yes, as mentioned above there is no way to destroy it, and this was
not desgined for frequent use. Typicaly, __pkvm_host_donate_hyp_mmio()
is called at boot per area/device. And __pkvm_hyp_donate_host_mmio()
is only used for failures.

> 
> I was looking to make use of this patch in an upcoming posting for the
> v2 ITS hardening but in my case I don't need the private VA range
> creation.

I believe if you need to map MMIO, private range is the right way to
do it as the linear map was mainly designed around system memory.

Thanks,
Mostafa

