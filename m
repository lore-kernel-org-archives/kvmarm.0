Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABD53C8C71;
	Sun, 20 Sep 2026 07:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789889089; cv=none; b=m7CHEST2hQHyMzvq6K2R12IBuku5ipiyAbCLzd5xMo5M/ttiFNk7r5PfpSmQFNwtlcS/pfEMvaaOSDLAj5HF01cRYpJ5HKUt263Bj/JyRCS15UbGSpCVInSjYwunxcAHtzl7aFBkXusloBmonzc4u4oUCDH2FS+GNd4YIVKIc7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789889089; c=relaxed/simple;
	bh=FPVGdonagIacHcL/d/dZ+5gGqIpfFwUk3LIT+aCs9BI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JIrMf8Nfl8QqEhdHKJ+pNZotD0a+VElaHhX0fpf9VkAt2qqCzxTIPi/Kn2npjSBCyPJt01PjlWCYRPsQIGwgaskATdDk959V6pzdDiP60nnQbMdPVkJbKE5CXfj7uwFESDpFLodpl/pqyb0SfW3NaVydpvUIV4MsASsScAhvlGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7lGpA8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7lGpA8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395D11F000FF;
	Sun, 20 Sep 2026 07:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789889087;
	bh=JykXcVLQ+SODnQl6eDwSo0pjarUst5H1xKMW2Gg1dG0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=H7lGpA8oxCwUoMdVQLZKlRanbrT2e3x3tiI2Lv/9D2mNfO7SsqLrfSgi9mj5cwr4l
	 p/4S240ofW0LQ/NXHEvBfaWJi8OayARjZWNnird0Y+O2aaUwfXpcQWE5mO42NMEVTe
	 yo6Y+i71T0oRF/zB7055vZvPJ3YFrVP1wXaCHGKiREh3L3Q9S80Jn8MvJplBWtkvWt
	 pEWj19lkvepnBXtCbeLK6jiB5c9mMO2VJaFTTc18K22kHyz5VVz+S2uP0IbcxE5lUd
	 gK6IbamepYGVCW0X/R6kr1+rM/esDudpV4pxveg4hCltq1t23VXK3R+K0+ibmPWLTz
	 XeoqLo1F/STZg==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	"T.J. Mercier" <tjmercier@google.com>
Subject: Re: [PATCH v6 7/9] dma-buf: system_heap: Enforce shared-granule
 alignment for cc-shared buffers
In-Reply-To: <20260919213531.GI11599@ziepe.ca>
References: <aq1V3oeDdvXobt8J@arm.com>
 <97c30fce-9bda-4c61-b1b9-10297b89c8d9@amd.com>
 <20260918153642.GD11599@ziepe.ca> <yq5atsnl47c6.fsf@kernel.org>
 <20260919213531.GI11599@ziepe.ca>
Date: Sun, 20 Sep 2026 12:54:38 +0530
Message-ID: <yq5a8q4ws7ux.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Sat, Sep 19, 2026 at 08:27:29PM +0530, Aneesh Kumar K.V wrote:
>  
>> +static struct page *system_heap_alloc_order(unsigned int order, gfp_t flags,
>> +					    bool cc_shared)
>> +{
>> +	struct cc_shared_pages mem;
>> +
>> +	if (!cc_shared)
>> +		return alloc_pages(flags, order);
>> +
>> +	/* The shared granule can raise the actual allocation order. */
>> +	flags |= __GFP_COMP;
>> +	if (alloc_cc_shared_pages(flags, PAGE_SIZE << order, &mem))
>> +		return NULL;
>
> Oh yeah that's surprisingly easy because of how this loop works with
> order
>
> Makes sense to me
>
>> int alloc_cc_shared_pages_node(int nid, gfp_t gfp, size_t requested,
>> 			       struct cc_shared_pages *mem)
>
> This argument order is a little weird from mm norms?
>

That is similar to

static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
						   unsigned int order)

-aneesh
