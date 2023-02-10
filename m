Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A34B8483
	for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 19:21:25 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id o15so2732489wrc.9
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 11:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Tz1WhSiDyiHb7swgsfraxGg6wWStHRX2Amb3b1VcmU=;
        b=WKCPMt8G4P6kglvBEYuR6Y8VGe4vLKREbo46B1FzP36qdC9o/gXh5YU6gEW7L3708X
         lrxXAzEPB1j3pGDdzQh1aduk3Z9ZrGueXQk2asJVFXfbphcdAajT2cuL8SDpesGlCuT5
         zP27G5KvohxP/B+J2p8XFakN/0ZUkhWnnBrHWiIoZRCeISeKJDx0vx5qCieGs4EnxLMv
         DR+bECwo2Frc9+Tg0Sq3Y8jMTdALTUIhprnoG8OmKK9vaJW9Bl1ofg1Vnea3kae6KK3A
         RYJiA29h4m4QGtT3sklUElmYPdchtrnZQvS2mzkuO+xv8NS8SwBva8yxv2T57qImR1fr
         WyNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Tz1WhSiDyiHb7swgsfraxGg6wWStHRX2Amb3b1VcmU=;
        b=JQsxUv+9sK2O+H4iIVaRAAxdvob/WxrUHkQHoJcJ01RBfwXpDuFPEAhC7B2APTNgSj
         xK1rpjAtLrCWswQH5zSt54E+q4GP0OobiZzpNt0qduMbdBXef3+hFQMQMPjQtwpeNcx4
         ep1FttewPeR612WScOIS5qC2jv0eKZ6d/aWhsc7BCSRnvyRlYnTI6q//VHH04NBvG7eS
         JBz1xCzaFNVotMkjuypw12+tXmCtuE9OnEuDVOFPnQY5fcWWeHrtoVtHtPKrKmyJY22B
         RogomNx5k8leDNywPYKM+EwGBkzOpwCBRch6w0MEP3VbXallhO7E5eG1dxjleqsF95M4
         oA7g==
X-Gm-Message-State: AO0yUKVU5cH1L1/zGowTKpQux+/BudE7UDyHzYMJQMpexTpN9UKBVD1b
	MizN13ORXORmIfDqv+w9UmnSJQ==
X-Google-Smtp-Source: AK7set81Xt2KccZQRdMWDTRiY2Gd0tbVvECaL276b9b5J5FRXHU0WwGuCEaGmrLLiiQcY/fFP5oI7g==
X-Received: by 2002:adf:f212:0:b0:2c3:dbe0:58ea with SMTP id p18-20020adff212000000b002c3dbe058eamr16025908wro.47.1676056883588;
        Fri, 10 Feb 2023 11:21:23 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id y1-20020a5d6201000000b002c3ea5ebc73sm4253499wru.101.2023.02.10.11.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:21:23 -0800 (PST)
Date: Fri, 10 Feb 2023 19:21:14 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 15/45] KVM: arm64: pkvm: Add
 __pkvm_host_share/unshare_dma()
Message-ID: <Y+aZKmXJAVwpPbF0@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-16-jean-philippe@linaro.org>
 <Y+JJ5HJpKGy3P04V@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+JJ5HJpKGy3P04V@google.com>

On Tue, Feb 07, 2023 at 12:53:56PM +0000, Mostafa Saleh wrote:
> > +static int __host_check_page_dma_shared(phys_addr_t phys_addr)
> > +{
> > +	int ret;
> > +	u64 hyp_addr;
> > +
> > +	/*
> > +	 * The page is already refcounted. Make sure it's owned by the host, and
> > +	 * not part of the hyp pool.
> > +	 */
> > +	ret = __host_check_page_state_range(phys_addr, PAGE_SIZE,
> > +					    PKVM_PAGE_SHARED_OWNED);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Refcounted and owned by host, means it's either mapped in the
> > +	 * SMMU, or it's some VM/VCPU state shared with the hypervisor.
> > +	 * The host has no reason to use a page for both.
> > +	 */
> > +	hyp_addr = (u64)hyp_phys_to_virt(phys_addr);
> > +	return __hyp_check_page_state_range(hyp_addr, PAGE_SIZE, PKVM_NOPAGE);
> 
> This works for hyp-host sharing, I am worried about scalability of this.
> For example FFA(still on the list) adds a new entity that can share data
> with host, and we would need an extra check for it.
> https://lore.kernel.org/kvmarm/20221116170335.2341003-1-qperret@google.com/

Right, although it looks like the ff-a support doesn't need a refcount at
the moment so passing such a page to iommu_map() would fail at
check_share() (but I may be wrong, I'll need another look). Even if it did
use a refcount, I think it may be fine to share it between different
entities: the refcount ensures that every sharing is undone before the
page can be donated to another entity, and a separate tracking ensures
that the host undoes the right thing (the io-pgtable mappings for pages
shared with the IOMMU, and the secure world for ff-a)

Regardless I agree that this doesn't scale, it gets too complex and I'd
prefer if tracking the page state was less subtle. I'll try to find
something more generic.

> 
> One way I can think about this, is to use the SW bits in SMMU page table to
> represent ownership, for example for PKVM_ID_IOMMU
> do_share:
> -completer: set SW bits in the SMMU page table to
> PKVM_PAGE_SHARED_BORROWED

I'm not sure I understand, would we add this in order to share a page that
is already mapped in the SMMU with another entity (e.g. ff-a)?  Doing it
this way would be difficult because there may be a lot of different SMMU
page tables mapping the page.

The fact that a page is mapped in the SMMU page table already indicates
that it's borrowed from the host so the SW bits seem redundant.

> 
> do_unshare:
> -completer: set SW bit back to PKVM_PAGE_OWNED(I think this is good
> enough for host ownership)
> 
> In __pkvm_host_share_dma_page
> If page refcount > 1, it succeeds if only the page was borrowed in the
> SMMU page table and shared in the host page table.

We could also move more information into the vmemmap, because struct
hyp_page still has some space for page state. It has six free bits at the
moment, which is enough for both owner ID and share state, and maybe we
could steal a couple more from the refcount and order fields if necessary.

With that the iommu_map() and unmap() path could also be made a lot more
scalable because they wouldn't need to take any page table locks when
updating page state, a cmpxchg may be sufficient.

Thanks,
Jean
