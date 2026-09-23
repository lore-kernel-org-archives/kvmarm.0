Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0E04DE715;
	Wed, 23 Sep 2026 11:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164216; cv=none; b=GCZRMDDigDgZJkNRlo10F9ex5JPK2GiKa9pHBAHmXA+AUu1D0f0nMsPuZEQt7zWPeSmsksPL4gi9UWKDuZLcVQyhTftDZ1PUxiuk440jrmtoW2Gfm8e5JMtfzukQfpsKbvy1AAkly9vdS/TCK1QCIszjL1/8q3V3D7qYkpVx7Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164216; c=relaxed/simple;
	bh=HrzUtRQyb6wNrO13ZaUTR/tjUSAHl4//cFA2Xmw57ks=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bZ+jrQnPopwrQzOZduuLvJx2gK6HNe1W+3mvvZKrsQ3Nc0klUpyaSr6QIz2VG7+Qo6348N4QvgNjpvuufOkUYzv0G8hK8vSZd4HbwHPVaZIr5Qprm7AYCQ4oGs5/Cy9jvfnMQUmOSa+r7lK8fHCfBYtjFL2IIkAEt7CY8ycPU3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3QZjKt2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3QZjKt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D332E1F000FF;
	Wed, 23 Sep 2026 11:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790164201;
	bh=jI0vAlJKhDmiOEB6Q23h3G6CLXMXdX46480mhO3rjOk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=j3QZjKt2RDG++7vwN6aJe3RA7jXlLMR25KRKluo6b+e2fpyRs/pTz6vg3MeMVgz3Y
	 H/uFrc3+3pyN38Avf0YeUAxm/S/O+UYkxoG1yg2hevAJ7xtnMPU4ruJWSG/bl4vDRu
	 a2+E5u83/YxSpGaDgPepX4M+KVq5eQWV3LxaqaNvqgJ0xF/Xh37LMhSBpaanlugiGi
	 a6+IqmVFl9eTuZSg2ZqPukR9Tb5u+HfSSew9/Q5ZdNFqsJuWTV56233K9JINsg6JB4
	 SaDj00V23Bhf5UDAvsQeyU1kxlfysMR0sLQ47c99jCokiOgVXxgydYh+6zjRxefc3x
	 m/QmnRG8vSOaA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 06/13] dma-contiguous: Accept an explicit minimum
 alignment
In-Reply-To: <arOrgRfi1k12clT7@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-7-aneesh.kumar@kernel.org>
 <arOrgRfi1k12clT7@arm.com>
Date: Wed, 23 Sep 2026 17:19:52 +0530
Message-ID: <yq5a33v02nmn.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Mon, Sep 21, 2026 at 08:18:40PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> @@ -125,7 +126,8 @@ static inline int dma_contiguous_reserve_area(phys_addr_t size,
>>  	return -ENOSYS;
>>  }
>>  static inline struct page *dma_alloc_from_contiguous(struct device *dev,
>> -		size_t count, unsigned int order, bool no_warn)
>> +		size_t count, unsigned int order, unsigned int required_order,
>> +		bool no_warn)
>>  {
>>  	return NULL;
>>  }
>> @@ -136,7 +138,7 @@ static inline bool dma_release_from_contiguous(struct device *dev,
>>  }
>>  /* Use fallback alloc() and free() when CONFIG_DMA_CMA=n */
>>  static inline struct page *dma_alloc_contiguous(struct device *dev, size_t size,
>> -		gfp_t gfp)
>> +		gfp_t gfp, unsigned int align_order)
>
> Can we not just bake the alignment further down in these functions
> rather than getting the callers to pass the {required,align}_order?
>

But, we need this to be conditional on CoCo shared allocations. We could
derive that from attrs and pass attrs instead of align_order, i.e.
something like:


 struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
-		unsigned int align, unsigned int required_align, bool no_warn)
+		unsigned int align, unsigned long attrs, bool no_warn)
 {
-	if (required_align > CONFIG_CMA_ALIGNMENT)
+	if (!dma_contiguous_resolve_alignment(attrs, &align))
 		return NULL;
-	align = min(max(align, required_align), CONFIG_CMA_ALIGNMENT);
 
 	return cma_alloc(dev_get_cma_area(dev), count, align, no_warn);
 }


with

+static bool dma_contiguous_resolve_alignment(unsigned long attrs,
+					     unsigned int *align)
+{
+	unsigned int required_align = 0;
+
+	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED)
+		required_align = get_order(cc_shared_granule_size());
+	if (required_align > CONFIG_CMA_ALIGNMENT)
+		return false;
+
+	*align = min(max(*align, required_align), CONFIG_CMA_ALIGNMENT);
+	return true;
+}
+

-aneesh
