Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507EA399004
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 14:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785941831; cv=none; b=OLBEFlUwqfoDYIIgtAhpDryg9LvhW13k1ewMsW3l8wwT6jhAwP8gW5t80W3oQNXTsNPMyOYGCRku0u+DyFTHl5kP1/EGrpjbed4qMGmCPfeLSY427VCmR7LLwLpeRwgkZFqd9W7sxBQu1NBcCi1trKwvxgRzw49He2uDxAJQuB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785941831; c=relaxed/simple;
	bh=cqzy97cVVOO/aObREG1arsE54P9gBkOM8bNx5Yj95qM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bd7t+sjxvDMcGENKLhAtLPGBek2M2SBlH31zm1BEt/2l5TWjtuZTm0vOzVjdAD6r/qgUBeqppFmxNgeHhWaRxmLvaRKC+ZU8EUwWOoCc5er3J0ZgXohNhq8oYCrJ119cpuyHiv+NojnHxl5zx1cBuiUiNjBqgdMWF4yP+mGUbgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W4XugZY7; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W4XugZY7"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4994d67d260so51075e9.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Aug 2026 07:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785941827; x=1786546627; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NNzat26Y19ZrKtjltXLxT2fvXKCHP/AoQJ9WhsEOxAU=;
        b=W4XugZY7ORabZ44qD28glMro2pRaMRyMHkTlUjyNNtJK52MnzWMXLRvgONPwJ0GB1g
         zOcrMxqO38d4g+zMnycYPSUNq5LmJrvFgG9YZ0ZlCppHyxcfpxKYfYQn1gS6AzCbhxb/
         jDp4Ej7NPUMXHZ6vXb/GfNF9eEeezz8zm/xnYWFLQLo4HrE0ZzijBIgdyOp1WYRRbd/E
         OOp0JSEjicyxCPc5fpFlV6ewngLFgLNMnrWhXBqiK1TXvvmWGUmKa6JZI4Bx72Kk+4ZB
         mc4fHkQ3NZusDieP07x04/LGQgZYzum7pVM3jHIE/YXtuSUn6w9gBYka31RnFSVHsnUm
         y3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785941827; x=1786546627;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NNzat26Y19ZrKtjltXLxT2fvXKCHP/AoQJ9WhsEOxAU=;
        b=YAklBI7I3UtHPaFwoVjzElU7sGCa4aIRX0jhUgTGPiAISVlPSu5RRqgADiK1l5DLfe
         UXDOC6ix5IFnJvoKoI5RxyAh7mjIj1sTgySigmaQKKp2YjWgWSrbK0HSRMGgETBvlVLa
         IyNKeVta8zp/Amh9vqsN6cxn+05Bzgnxhq1P18LMWCH6KJJSbRjH9w8SWtm/vCw2JCK8
         vbtIsnEFVbDideog4AUTFLWm/581h3LpWLsznyA/E/1ZitBcQDk8GCOYWJw0Msg3YAdq
         aEcn/IQMTkSMTpDRTJkJoZGxAjZMYpqIeFVeLJMowmPs9oLeF/wXPtgjzq1h/YHyUv/v
         6Akg==
X-Forwarded-Encrypted: i=1; AHgh+Rpd98mHa533wHw8Pub/c4dsvkWa9K+J+N1g30v6Lg1XXj6OE3pxd1ZjpGigjPaIgAS2gDx2o3Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoRqy+wSHpGHJA0eSRrjAWwwtuYwyJtsZPhxxFGfTrGIrOBQzr
	B9q20ispD8WcgfFn1rWC/THwZYh74EFTwzyvbu18ij/Lp9rTbk3NK9p/gxd6O/KmKw==
X-Gm-Gg: AR+sD12HxJiuYjY8oyjSnrv7jYbe8wR4Qu1hT7H9LElrSQzTCZU6AMDCPFyAPxNVPk/
	bI/kKCRmXrdLdnAXm9+TT5+RZyc4Bo+r3+wfylxG094lpoQpG34FRSVwa+AzFZuMKuXND40jsgV
	2ig4q/wwSvH1q8994nht3R25F/AogisS6US6wB924ygrGaQ+NsBjLfIVv8i9kavToT+Dl2ctAi8
	1TzPDqWOck5Bkns0MBHPuQj3+3wY8+vlxvFB3ch0p65WKroAzYKmWRXTXPoZbdEphgASlOeN1Xx
	tIa2NTwbvSHK1LGj9SUIQYRpib8ydBSyH8CmBmBBkFmFbbEA8Nb8LI2BJloyE/n+vAp/JN7Op7E
	//Q1X2CRH11Bt03PFIIUdOnxCMQhH7EZjJ6zsQw2n7WyRTor4wNvwmEf8brW5jD/OeHroExklHD
	8Xxp3FQjsIvZC3ow6ByfXceHjeu5MyVFpPuoILXD3Um16NTCD40rXH92xW9UDldf74zrrza0sgK
	n9IwtIZrtcIaloICLAXVmKvEhLANfs+
X-Received: by 2002:a05:600c:6554:b0:493:ae5f:d29f with SMTP id 5b1f17b1804b1-4994f0fb66dmr834065e9.3.1785941827064;
        Wed, 05 Aug 2026 07:57:07 -0700 (PDT)
Received: from google.com (63.235.189.35.bc.googleusercontent.com. [35.189.235.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d74sm9786235f8f.17.2026.08.05.07.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 07:57:06 -0700 (PDT)
Date: Wed, 5 Aug 2026 14:57:02 +0000
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
Message-ID: <anNPPrjGd2Z2dSwc@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-3-smostafa@google.com>
 <anMwxy9gEEt_Wu6M@google.com>
 <anM9sk_gXTt5F1Ie@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <anM9sk_gXTt5F1Ie@google.com>

On Wed, Aug 05, 2026 at 01:42:10PM +0000, Mostafa Saleh wrote:
> On Wed, Aug 05, 2026 at 12:47:03PM +0000, Sebastian Ene wrote:
> > On Wed, Jul 15, 2026 at 11:58:43AM +0000, Mostafa Saleh wrote:
> > > Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
> > > drivers can protect and access the MMIO of IOMMUs.
> > > 
> > > As donating MMIO is very rare, and we don’t need to encode the full
> > > state, it’s reasonable to have a separate function to do this.
> > > It will init the host s2 page table with an invalid leaf with the owner ID
> > > to prevent the host from mapping the page on faults.
> > > 
> > > Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
> > > stage-2 PTEs, as this can be triggered from recycle logic under memory
> > > pressure. There is no code relying on this, as all ownership changes is
> > > done via kvm_pgtable_stage2_set_owner()
> > > 
> > > For the error path in IOMMU drivers, add a function to donate MMIO
> > > back from hyp to host. However, that leaks the hypervisor virtual
> > > address range which should be acceptable as this is quite rare and
> > > it matches the behaviour of fix_map/block.
> > > 
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  7 ++
> > >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 91 ++++++++++++++++++-
> > >  arch/arm64/kvm/hyp/pgtable.c                  | 11 +--
> > >  3 files changed, 102 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > index 29935c7da1de..51b0eb3844a9 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > @@ -36,6 +36,13 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
> > >  int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
> > >  int __pkvm_host_unshare_hyp(u64 pfn);
> > >  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
> > > +/*
> > > + * Donate MMIO range to the hypervisor, it will be mapped in the hypervisor's
> > > + * private range and unmapped from the host stage-2.
> > > + */
> > > +int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned long *haddr);
> > > +/* Remaps MMIO range in the host, typically used in error path. */
> > > +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size);
> > >  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
> > >  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
> > >  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > index 4e329e39a695..d803b3dd4cb4 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > @@ -378,7 +378,11 @@ static int host_stage2_unmap_dev_all(void)
> > >  	u64 addr = 0;
> > >  	int i, ret;
> > >  
> > > -	/* Unmap all non-memory regions to recycle the pages */
> > > +	/*
> > > +	 * Unmap all non-memory regions to recycle the pages.
> > > +	 * That relies on kvm_pgtable_stage2_unmap() not clearing
> > > +	 * counted PTEs which include hypervisor MMIO.
> > > +	 */
> > >  	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
> > >  		reg = &hyp_memory[i];
> > >  		ret = kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
> > > @@ -1119,6 +1123,91 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
> > >  	return ret;
> > >  }
> > >  
> > > +int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned long *haddr)
> > > +{
> > > +	kvm_pte_t pte;
> > > +	u64 offset;
> > > +	int ret;
> > > +
> > > +	/* Only before de-privilege. */
> > > +	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> > > +		return -EPERM;
> > > +
> > > +	if (!PAGE_ALIGNED(addr | size) ||
> > > +	    !pfn_range_is_valid(hyp_phys_to_pfn(addr), size >> PAGE_SHIFT))
> > > +		return -EINVAL;
> > > +
> > > +	ret = __pkvm_create_private_mapping(addr, size, PAGE_HYP_DEVICE, haddr);
> > 
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	host_lock_component();
> > > +	for (offset = 0; offset < size; offset += PAGE_SIZE) {
> > > +		if (addr_is_memory(addr + offset)) {
> > > +			ret = -EINVAL;
> > > +			goto unlock;
> > 
> > If this fails we are left with the mapping inside the hyp because the unlock
> > doesn't destroy the private mapping. Is this intended ?
> > 
> 
> Yes, there is no way to remove a private mapping at the moment, all
> the callers to __pkvm_create_private_mapping() will leak it on failure.
> 
> > > +		}
> > > +		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
> > > +		if (ret)
> > > +			goto unlock;
> > > +		if (pte && !kvm_pte_valid(pte)) {
> > > +			ret = -EPERM;
> > > +			goto unlock;
> > > +		}
> > > +	}
> > > +	/*
> > > +	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
> > > +	 * - host aborts: host_stage2_adjust_range() would fail for invalid non zero PTEs.
> > > +	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would call
> > > +	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid ptes (counted).
> > > +	 * - other MMIO donation: Would fail as we check that the PTE is valid or empty.
> > > +	 */
> > > +	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> > > +			      addr, size, &host_s2_pool,
> > > +			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
> > > +			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
> > > +unlock:
> > > +	host_unlock_component();
> > > +	return ret;
> > > +}
> > > +
> > > +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size)
> > 
> > This function seems to only update the host stage-2 annotation but it
> > doesn't destroy the hyp mapping.
> 
> Yes, as mentioned above there is no way to destroy it, and this was
> not desgined for frequent use. Typicaly, __pkvm_host_donate_hyp_mmio()
> is called at boot per area/device. And __pkvm_hyp_donate_host_mmio()
> is only used for failures.
> 

Yes, I saw that you only allow the call during the init pKVM calls, however it seems a bit fragile.

> > 
> > I was looking to make use of this patch in an upcoming posting for the
> > v2 ITS hardening but in my case I don't need the private VA range
> > creation.
> 
> I believe if you need to map MMIO, private range is the right way to
> do it as the linear map was mainly designed around system memory.

Is there a reason behind not having MMIO as part of the linear
map in the hypervisor ? I would like to avoid holding the hva around and
just do a simple addition to resolve the hyp_va.

> 
> Thanks,
> Mostafa
>

Thanks,
Sebastian
