Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65DE1C695;
	Wed, 23 Sep 2026 08:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152283; cv=none; b=mmvoUaD+W8DBkHSTKIFmMCzLcnHvy1aoO0/aavdEU6HONEKFB4IBIE56d3RfI0CidWd3mZMRMxwTYA9E1GuqDghKglwx4Z6Z9dhQA0VCq9UlpvSobkr7IFzq1kac6geJINBD7RkjAZQGyui5yY49l+26yKsJf+RB4Tx15SYJeck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152283; c=relaxed/simple;
	bh=paNO5eY1DEgK8W03rG7sbOrBlMZLVg8sLc5gM/Q+wQQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EdzOMN9n7DHG/EbxEX47/MWsGC+a6HOtaEegg/Lj+7XJ03H/GSYzmGUsNMYYcVEU2n4fqluH3tYhV70+7IDwM8O8ZfWmH/irM+mrqF/F7b65PKp4rBUJ0X7P9biJ77pWMFm+QmEzpyyZpR7v2xBJ/r8NIPsmdvyhdW2vXPsyTZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTkYlM77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTkYlM77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62941F000FF;
	Wed, 23 Sep 2026 08:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790152278;
	bh=XxmbCQ7HTgeDaajizNY6/YBNTKC18nSpZXzsHrNVM84=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=OTkYlM77Ug42qVxwfxT90vI8uqJaGZuINeDuY7JZQ7999GuMgboyvG3xtQK4xUOl6
	 zd/wjFpIioagBtMBTbIRO4+LWzQDIAK3I7vBM0rpdAp3+D48idK6/rLGv/wp810wau
	 kBIp+Yuzbff5wJbTofP8TTmKYmwVjL0T+CpHEPlOh1dCtBCBbY6Li6SfZcSRBy1ZqV
	 6HKD6TB9iq8dr86QgVxPCe/DU6JyTmmONL36429SSJxW5oOsL1SHztUpZ/FQDboYkM
	 lciZ4ZYh3Nxzy1apRUyFKvXJd6RsZiuZRR7Ov/HZwLWG+HsGzKjqSxB30w84hYznIo
	 wOWxilA16da9A==
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
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
In-Reply-To: <yq5aik3w344o.fsf@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com> <yq5aik3w344o.fsf@kernel.org>
Date: Wed, 23 Sep 2026 14:01:08 +0530
Message-ID: <yq5afqz02wtv.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Aneesh Kumar K.V <aneesh.kumar@kernel.org> writes:

> Catalin Marinas <catalin.marinas@arm.com> writes:
>
>> On Mon, Sep 21, 2026 at 08:18:36PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>> +int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
>>> +		size_t requested, struct cc_shared_pages *mem)
>>> +{
>>> +	struct cc_shared_layout layout;
>>> +	struct page *page;
>>> +	unsigned int order;
>>> +	bool zero = gfp & __GFP_ZERO;
>>> +	int ret;
>>> +
>>> +	if (!mem)
>>> +		return -EINVAL;
>>> +
>>> +	ret = cc_shared_calc_layout(requested, &layout);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	order = get_order(layout.shared_size);
>>> +	if (order > MAX_PAGE_ORDER)
>>> +		return -EINVAL;
>>> +
>>> +	/*
>>> +	 * State transitions require a linear-map address and may modify memory.
>>> +	 * Allocate from low memory and defer requested zeroing until afterwards.
>>> +	 */
>>> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
>>> +	if (nid == NUMA_NO_NODE)
>>> +		page = alloc_pages(gfp, order);
>>> +	else
>>> +		page = alloc_pages_node(nid, gfp, order);
>>> +	if (!page)
>>> +		return -ENOMEM;
>>> +
>>> +	ret = cc_make_shared(page_address(page), layout.shared_size);
>>> +	if (ret) {
>>> +		if (!cc_make_private(page_address(page), layout.shared_size))
>>> +			__free_pages(page, order);
>>> +		else
>>> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
>>> +					    layout.shared_size);
>>> +		return ret;
>>> +	}
>>> +
>>> +	if (zero)
>>> +		memset(page_address(page), 0, layout.shared_size);
>>
>> Does the memset() post sharing logic work for pKVM as well? If nothing
>> clears it, we have a small window where guest data is leaked to the
>> host.
>>
>> Is there a case where we *do not* need the memory cleared? If not, maybe
>> we can move the logic in the arch set_memory_decrypted().
>>
>
> I don't think every architecture or platform can unconditionally zero
> memory in set_memory_decrypted(). Some callers may need to share valid
> contents with the host.
>
> Also, if zeroing is added only to the CCA implementation, the allocator
> must retain __GFP_ZERO for platforms such as pKVM. This would cause the
> memory to be zeroed twice on CCA.
>
> How about extending cc_make_shared() with a flag indicating that the
> memory must be zeroed, and passing that requirement down to the
> architecture-specific implementation? The implementation could then zero
> the memory at the appropriate point: before sharing for pKVM and after
> the destructive transition for CCA.
>
> The allocator could derive this flag from __GFP_ZERO, remove __GFP_ZERO
> before calling alloc_pages(), and let the sharing operation perform the
> requested zeroing with the correct ordering.
>

I was pointed to this email thread:

https://lore.kernel.org/all/c25502d3-35c6-4281-a9ec-856f789fb1b4@arm.com

This makes a stronger case for having a CoCo shared memory allocator
that captures all these restrictions. It also means that
alloc_cc_shared_pages_node() needs:

	if (WARN_ON_ONCE(!gfpflags_allow_blocking(gfp)))
		return -EINVAL;

	might_sleep();

I guess this also requires the VPE L1 tables to be preallocated from a sleepable context.

-aneesh


