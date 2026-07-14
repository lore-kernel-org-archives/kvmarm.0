Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FDB42EEC9
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 08:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784018853; cv=none; b=p8urPv5l5LtFtz0ocuD5ZBNdIv+tjJ12oDkkioA6UqTMOBJD7OHgbdSEVpA7DXY2Qst5jVPAlxnky9iysObgeYXxMiekku2OcwQwB6onRTDeaBTOIbmJuw08J1fCFPqF7e90KElialGRGTammqBy3Cdc2kFJIOfCcIKwwsBZEvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784018853; c=relaxed/simple;
	bh=BQvQA28/hQsJiQl1Rts5gtoQqHvUkzf0m5MoHJQ0PZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p4O0VBbWVuZ8JECK2Z3+7UX0ga++gbC+f/PfHNy1MYaUVcvsyZrnSdO7TcP8FRRYrPy1EMU515/XvSG3mrxkOMZH4+Rv01ZxG2ki+Z7XYBxgLf0Glf+pr5M4guOh07+mhjunKunnD+n6Y8go+lQfvBgE7CY+3QafXCFZ+ZMAaDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hd5Rm33Y; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hd5Rm33Y"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493f25d47dcso5084605e9.1
        for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 01:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784018850; x=1784623650; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m879ws2jFhHLOh/9WRuezyCL3r8TAQ3JpjmFZyFa7tw=;
        b=hd5Rm33Yv/OoXMIz/o08qShV9xqmP/1f3NkCVkzCMJsCJULVzcUyHzmzrw3o7MJyGA
         YDGoBfe874ClXjYIfTX1zOEaj60LBJsPNYOvk77b3VXideJoXA6DVTMcMJXsN6gjCxiJ
         Eim6i16IInrGwywEBmF7OLpVUgesryCYRB9EkecHK6JQHhsUAPSmO4sRBjmnB1zRVH/q
         dY46erIV3jufKnyiVFUDpVQPMoueIu1RCw1t91RPeXZXFhRnKDCPQgunSGGelCCupOAh
         YWD3bkp9s+F3U7PGxT5m8uQTkQuLRkIoOe5PjSveqZaEfQKR0tlEIfHcAMuIqJGrERiY
         L6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784018850; x=1784623650;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m879ws2jFhHLOh/9WRuezyCL3r8TAQ3JpjmFZyFa7tw=;
        b=Ie9TcpjIq0FSNVgbNx8Vi+QDbkvXprX6EMyGVqPOZs4A2gbrrPbRVt/nVi3foYbU75
         66ks0S6ExnzRX/ghbob1yH29E8Ug1LjFM0Ldrvg0hOMESBBoZIxuXmvhg+LpXxOQ2+Y2
         HWmcvUIFlCF0A5pN/oGRIgyGwNwepDu/thXaXeWqi6ds5V2k3hn9p7Kks8UdRwumFM62
         Is8et+0kkMiuL1d3RohE8ZRLAHlDaO/T5vIcgeQcm0uE+TcAGxf0JVVhmPqRcFnr8qBT
         nLQ4g0DS5bbE1p2Q9t8js0AzQFSWJYUuHeT9i00CfdJHCHJwblBWRIJprv0ppW4fbW2s
         wUtA==
X-Forwarded-Encrypted: i=1; AHgh+Rp/Q6e+Yz4YF3hEbWXwzQx31Ucs30V3Si7C4bhY2OBOBrhFdMQ3pZ+ESLer/9fe5/cZgczZrj8=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywx7HPeMzJzT30Sx2lsMB+Kyw2Wvd2NLikWliPXGPPH6I7yu9ud
	z8uhy5G4jTks7h7+YHupnzsH9tBUHzAOX+Xu6jhPKJ+ysaPdreQT7UVFKb3XegJowQ==
X-Gm-Gg: AfdE7ckCrbJKJ0yTV0KAo6pgIau6fs9kTnprKvh1S8M4dKSFRSJXKx1p/yy9AcS0hqF
	b4km6iQh506v5svLtOheQn5kGwUcUDFilUNSosY39XDgJG6B2qeAs/XonYEX1JMtrgPNxKrBjP0
	3FkX+JU1jTdf74kcQdtVMY18PKXam8AKHAUF1MZsWh5PMiyD3pWP8B6SeXO6AQVcrQRaK/zdSZX
	60AbOaTxBqfHQ5T3lGCrPd8Ew3mAvd0vpfrFnEtHlKlUK7daxWGeAL+rtET6QGPwLWuB8I5kwy1
	Ul97iLe2jVnDTyzelrJdZZTOhZBBeZ0c3syPsXQM7V5sseq+e+Pu25bV5wt0iVQW/Yd9QwNhTVW
	04Gun8ry1KMGYyrKNK7DlyLtdAEqzWUyjz5oXCttK7yzMAwDwA1V/31s9V9K7ne40oL3X1HObh8
	C6hdpdIYFnDglDoQZmcFFrpJW0cSrolobL36UezDtRbLItHsAxKPs=
X-Received: by 2002:a05:600c:4f8a:b0:493:f7c8:eae2 with SMTP id 5b1f17b1804b1-493f87e6e9cmr127818785e9.15.1784018849325;
        Tue, 14 Jul 2026 01:47:29 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495086ca93esm59158715e9.0.2026.07.14.01.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 01:47:28 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:47:24 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 08/25] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <alX3nHLykNc_nng5@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
 <alTnAy7jvjUamwUA@google.com>
 <alTvf7iiOWn4PKE8@google.com>
 <alUA7zsJO1FGnss-@google.com>
 <alUJa5cbjjqZ8n72@google.com>
 <alUMVU7DYcrvgAYi@google.com>
 <alUsLFBQ5qKFOgwQ@google.com>
 <alXwXRGqECTUZ3ou@google.com>
 <alXzcrnxWADIEL2H@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alXzcrnxWADIEL2H@google.com>

On Tue, Jul 14, 2026 at 08:29:38AM +0000, Mostafa Saleh wrote:
> On Tue, Jul 14, 2026 at 09:16:29AM +0100, Vincent Donnefort wrote:
> > On Mon, Jul 13, 2026 at 06:19:24PM +0000, Mostafa Saleh wrote:
> > > 
> > > That would walk the table twice, first time with a massive map, then
> > > to unmap the pages that was just mapped, issuing TLB invalidations
> > > for all of those, also as the IOMMU page table code never frees tables
> > > that means we would immediately exahust the IOMMU pool.
> > 
> > Well the massive map is pretty quick we would mostly just allocate the PGD? And
> > then it would be just for the subsequent unmaps to split the blocks. So nothing
> > to be freed really and no risk to exhaust the pool. But if you put the calls to
> > the host_stage2_* functions that's pretty transparent.
> 
> Not for the IOMMU, everything is mapped with a leaf mapping, because

Ha Ok my bad, I didn't get that!

> the pgtable code does not support splitting blocks, this is something
> I plan to add support for in a follow up series after this one is
> merged along side other optimizations.
> 
> > 
> > Just to make sure I am clear. Here's what it could look like:
> > 
> > in iommu.c:
> > 
> > int kvm_iommu_stage2_idmap_init(struct kvm_s2_mmu *host_mmu)
> > {
> > 	u64 addr = 0;
> > 
> > 	for (i = 0; i < hyp_memblock_nr; i++) { 
> > 		kvm_iommu_stage2_idmap(addr, reg->start, IOMMU_MMIO);
> > 
> > 		addr = reg->start + reg->size;
> > 		kvm_iommu_stage2_idmap(reg->start, addr, IOMMU_READ | IOMMU_WRITE);
> > 	}
> > 
> > 	kvm_iommu_stage2_idmap(addr, kvm_phys_size(host_mmu), IOMMU_MMIO);
> > }
> > 
> > in mem_protect.c:
> > 
> > int kvm_host_prepare_stage2(void *pgt_pool_base)
> > {
> > 	...
> > 
> > 	return kvm_iommu_stage2_idmap_init(mmu);
> > 
> > 	/* 
> > 	 * From here, all the changes to the host stage-2 will be reported to
> > 	 * the iommu driver
> > 	 */
> > }
> > 
> > On the pro side: no custom walker and we really couple the iommu idmap to the
> > host stage-2 map.
> > 
> > On the con side: As you've pointed out, we'd need indeed the iommu to be ready
> > early enough.
> > 
> > If you want to stick to the snapshot function, could we have the walker to
> > first walk the hyp_memblock? the .arg could just pass if we are walking a MMIO
> > region? That would avoid that find_mem_range_from() and I believe would
> > massively simplify the snapshot walker.
> > 
> 
> I see, let me try that.
> 
> 
> Unrelated to this, but while looking into option#2 I see that
> __pkvm_guest_share_host() does not call either of the
> host_stage2_set_owner* so that requires another explicit
> pkvm_iommu_host_stage2_idmap() call.

It does! it calls __host_set_page_state_range() which calls
host_stage2_idmap_locked().

FTR, I don't really like __host_set_page_state_range(). And we removed it
recently from our Android tree. Because there's just a special case in
__host_set_page_state_range() to cover guest_share_host. So we can easily
replace all the callers with __host_update_page_state() and and call the
idmap explicitely in __pkvm_guest_share_host().

> 
> I still plan to use option#2 in v7.
> 
> Thanks,
> Mostafa
> 
