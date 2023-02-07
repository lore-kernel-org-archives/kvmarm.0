Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8F22101
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 10:39:53 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id g6so5099064wrv.1
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 02:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ezuf8zIGtjTbwprIBH3RkeiO7eWB8R8vQxUpLhGnoGw=;
        b=xUgt49eDesXWBFfzjD7n4TFdFOPbhMqmAkmaDcQH1O33LN7B2lcB7F1wc4hYi3wmv1
         r2hEgVKt/oPCqgxpok1UG2a0ILNWdzHuypas15hOUaPavVxoc6ea7c757XOj7HTgh72S
         SmzjrczVxPKuzed5ze9dxd6V65pu9+h88/y/cb558ytu5qjDB3sp8PWJ3f0xJ9ha5PoJ
         vRED/uIoGf3O3sYnGYRWy0aXnDYNOfJzjQKTK/Tj9AwqXAfmokk6dcuWJeJGFgpneV/y
         gxrskFJsHWVoQwdjj0VD0pYzcmP+cVivQO5tZnPknSFZbcsDxbpR9drG7X5LP2UPL2K/
         3h3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ezuf8zIGtjTbwprIBH3RkeiO7eWB8R8vQxUpLhGnoGw=;
        b=ubM0/DEhhPe8W6zWOTYsJHkO2Kw5N4DIZc3j6GjwCRmev3S42fWNq/JFdlYKdueZsQ
         7yl3fCIx2AJPHRJJNeY5Ev/fPMkxkRWQqU7jqN1trxcGVvIyTWll1NRBbEZvi5ZtRj+s
         fv52ErActQ4xTywlPF3URxP5VqSCGspSPzkalhtk42XoFNMy7hnT1uSX/nM3rzHa9Jr4
         RFNUWAv1WAS89OW/gQRU0tiewbNQ4f0lXL06MEw2xlxVevaq2gTizLD8i8LsrBBhxix9
         SGvbzvreRI059lNPsu6d8w4yMsfgPB0SchgO4qmvJPJH8SxqBeZsikshq6bakZryzfTu
         qXFA==
X-Gm-Message-State: AO0yUKVlXKqiZf/IO/MkIzJuQUEsNdJuHwDNYCFcc4jxioLT6bFvK1Ze
	BPY7MNuPf/uA+Ae2AumvkPW94Q==
X-Google-Smtp-Source: AK7set8URL8FZwsSiW+sDnFANc5QHMcYb6CW6VXqlAe361UtKx/EnW5TcnLZYj/p4W5+PO6ACStkBw==
X-Received: by 2002:adf:f712:0:b0:2bf:b281:1bbb with SMTP id r18-20020adff712000000b002bfb2811bbbmr2244453wrp.36.1675766391394;
        Tue, 07 Feb 2023 02:39:51 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id l5-20020adfe585000000b002c3e3ee7d1asm6290379wrm.79.2023.02.07.02.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 02:39:51 -0800 (PST)
Date: Tue, 7 Feb 2023 10:39:46 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: "tina.zhang" <tina.zhang@intel.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, smostafa@google.com, dbrazdil@google.com,
	ryan.roberts@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 15/45] KVM: arm64: pkvm: Add
 __pkvm_host_share/unshare_dma()
Message-ID: <Y+Iqcm3Do00Jj6vb@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-16-jean-philippe@linaro.org>
 <dec54922-37cf-89df-477e-eed1e9461db3@intel.com>
 <Y+Du0fZetGVdPVW2@myrica>
 <c06440b2-1ce6-b2c2-59b7-6ccdfd8b5ab4@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c06440b2-1ce6-b2c2-59b7-6ccdfd8b5ab4@intel.com>

On Tue, Feb 07, 2023 at 10:37:51AM +0800, tina.zhang wrote:
> Hi Jean,
> 
> On 2/6/23 20:13, Jean-Philippe Brucker wrote:
> > Hi Tina,
> > 
> > On Sat, Feb 04, 2023 at 08:51:38PM +0800, tina.zhang wrote:
> > > > +int __pkvm_host_share_dma(phys_addr_t phys_addr, size_t size, bool is_ram)
> > > > +{
> > > > +	int i;
> > > > +	int ret;
> > > > +	size_t nr_pages = size >> PAGE_SHIFT;
> > > > +
> > > > +	if (WARN_ON(!PAGE_ALIGNED(phys_addr | size)))
> > > > +		return -EINVAL;
> > > > +
> > > > +	host_lock_component();
> > > > +	hyp_lock_component();
> > > > +
> > > > +	for (i = 0; i < nr_pages; i++) {
> > > > +		ret = __pkvm_host_share_dma_page(phys_addr + i * PAGE_SIZE,
> > > > +						 is_ram);
> > > Hi Jean,
> > > 
> > > I'm not familiar with ARM arch. Just out of curiosity. If pKVM-ARM populates
> > > the host stage-2 page table lazily, would there be a case that device driver
> > > in host triggers DMA with pages which have not been mapped to the host
> > > stage-2 page table yet? How do we handle this situation?
> > 
> > It's possible that the host asks the hypervisor to map on the IOMMU side
> > a page that is not yet mapped on the CPU side. In general before calling
> > map_pages() the host zero-initializes the page, triggering a page fault
> > which creates the mapping, so this case is rare. But if it happens,
> > __pkvm_host_share_dma() will create the CPU stage-2 mapping:
> > 
> >   __pkvm_host_share_dma()
> >    do_share()
> >     host_initiate_share()
> >      host_stage2_idmap_locked()
> > 
> > which creates a valid identity mapping, along with the ownership
> > information PVKM_PAGE_SHARED_OWNED. That ownership info is really all we
> > need here, to prevent future donations to guests or hyp. Since the SMMU
> > side uses separate stage-2 page tables, we don't actually need to create a
> > valid mapping on the CPU side yet, that's just how pKVM's mem_protect
> > currently works. But I don't think it hurts to create the mapping right
> > away instead of waiting for the CPU page fault, because the host will
> > likely access the page soon to read what the device wrote there.
> Right. I was thinking if stage-2 lazy mapping method is being adopted,
> whether there would be a case that the check_share() couldn't pass, as the
> pte might not be valid at that time. After checking the logic, I see we
> check kvm_pte_valid(pte) as well as the value of pte. So I guess the
> check_share() can return successfully even w/o having triggered host CPU
> page fault.

Yes, during check_share(), host_get_page_state() allows disabled PTE
unless the PTE already contains ownership information (in particular, if
the page has been donated to a guest or to the hypervisor, the PTE is
invalid and contains the non-zero owner ID.)

Thanks,
Jean

