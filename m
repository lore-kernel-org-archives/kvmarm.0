Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB513DDDB1;
	Wed, 23 Sep 2026 05:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142819; cv=none; b=qM4mq2H6qTZ9sSpxeFyW9kuU9Mo50wx4MULtBvP4vRVXiwdHKLA2ykYxwI14qrLRp4VKHDbNxbyNT4U7soC2uOWA/GEUHFfdSwjpI1UQMSffBy9nqg1+Idv1KdMh6pSkjQyZW4P3f364pNX8QrBBf+2FPxAsusFDERo6Rt5dfmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142819; c=relaxed/simple;
	bh=SizAW2/qNUHUEFI/k5gafiEU85XtrtxInmg/6FaOLvo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SBcAhpK9Ha+1K1L0eYtbT85bBaZkQL31rdmM5d1PQHJnjiQwVfSPvzGWhQyA6mdc0mtHIq8QM6/YH+2L6jMGOvgL6jhPV5HApNI8clIXI2e36qE4zmJVpnMioQUH5VVbYaPQcYTMngDh0+6q4cg4lOyfGsWU9H1dLNvhWtsIyyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfiMSTdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfiMSTdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B328E1F000FF;
	Wed, 23 Sep 2026 05:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790142817;
	bh=NLg7eC5tmmPMhZrdk3Y2A4+KtVVGLpx4Z4IOl6QmxuU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dfiMSTdwFtu0GCkhWemNFDgm+eZPZTNwX9NfJANQl2p7VUL12gPuLOT5GFrp9s1/W
	 gYHsfaLK7hikvujYiuXBUn8tMKa90RN/oaYf2S0NAbKARN3nHId0g1n9dBJrUeJeqm
	 1Q44Iafx85llSabeXDEcOdxXWocXCUP5y+CfG+SLeH3LQKK2DCfDxkDMtcFBDaOqJv
	 3HMHpRbUUmlsMii5otr4W/LYqrG4eJChKhKMXRP42VluhoUFMzhKQPjXcnsbxGFGAB
	 eSZq2hnozQ8Ha+TQTKHYQZsH+7U8XaqMquyRiYdYscnEhoNd02LZ7qoYGMlm0AwCPg
	 wXpHkFmSzOfPQ==
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
In-Reply-To: <arKsFofudnTYpXj1@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
Date: Wed, 23 Sep 2026 11:23:27 +0530
Message-ID: <yq5aik3w344o.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Mon, Sep 21, 2026 at 08:18:36PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> +int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
>> +		size_t requested, struct cc_shared_pages *mem)
>> +{
>> +	struct cc_shared_layout layout;
>> +	struct page *page;
>> +	unsigned int order;
>> +	bool zero = gfp & __GFP_ZERO;
>> +	int ret;
>> +
>> +	if (!mem)
>> +		return -EINVAL;
>> +
>> +	ret = cc_shared_calc_layout(requested, &layout);
>> +	if (ret)
>> +		return ret;
>> +
>> +	order = get_order(layout.shared_size);
>> +	if (order > MAX_PAGE_ORDER)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * State transitions require a linear-map address and may modify memory.
>> +	 * Allocate from low memory and defer requested zeroing until afterwards.
>> +	 */
>> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
>> +	if (nid == NUMA_NO_NODE)
>> +		page = alloc_pages(gfp, order);
>> +	else
>> +		page = alloc_pages_node(nid, gfp, order);
>> +	if (!page)
>> +		return -ENOMEM;
>> +
>> +	ret = cc_make_shared(page_address(page), layout.shared_size);
>> +	if (ret) {
>> +		if (!cc_make_private(page_address(page), layout.shared_size))
>> +			__free_pages(page, order);
>> +		else
>> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
>> +					    layout.shared_size);
>> +		return ret;
>> +	}
>> +
>> +	if (zero)
>> +		memset(page_address(page), 0, layout.shared_size);
>
> Does the memset() post sharing logic work for pKVM as well? If nothing
> clears it, we have a small window where guest data is leaked to the
> host.
>
> Is there a case where we *do not* need the memory cleared? If not, maybe
> we can move the logic in the arch set_memory_decrypted().
>

I don't think every architecture or platform can unconditionally zero
memory in set_memory_decrypted(). Some callers may need to share valid
contents with the host.

Also, if zeroing is added only to the CCA implementation, the allocator
must retain __GFP_ZERO for platforms such as pKVM. This would cause the
memory to be zeroed twice on CCA.

How about extending cc_make_shared() with a flag indicating that the
memory must be zeroed, and passing that requirement down to the
architecture-specific implementation? The implementation could then zero
the memory at the appropriate point: before sharing for pKVM and after
the destructive transition for CCA.

The allocator could derive this flag from __GFP_ZERO, remove __GFP_ZERO
before calling alloc_pages(), and let the sharing operation perform the
requested zeroing with the correct ordering.

-aneesh
