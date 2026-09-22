Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EBBD5678EC;
	Tue, 22 Sep 2026 16:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790094372; cv=none; b=U93aPJx46RjoI//Rudj7i7rNJbsXq08XRNYKqTFvyHf+O0PyVyeaWdyitladpEkHOkTKj2q8MiIGujJA2NQV5HYhwGOBqdtKuTc9PKm0vQeE+vJHFJFGlK9D9PzJq9okZZH9kxtQltwl/o5KkIlwu4n6+rLqymYeEB+CnKdxDCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790094372; c=relaxed/simple;
	bh=ayic+nVzRT7jF2h19D33qb2NxY0nfyFpS1c2IauCEkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtvoCghwzwLfdukLQx0rv2f3QpVmBL5TmduFl+//n+A6pmYmxw4v9swJgQmBVvyBqnYJWLzgnuYT7wincQJ/y+ueQRNx5Ly+haKtLzsMFq7zOhTvHGIMJZ50Asbbo+2ApmBFKf6Twsne2ePQuM6askMzrBSJeOcwo1gSeKpCaaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vLKpHlXy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vLKpHlXy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 177FF1576;
	Tue, 22 Sep 2026 09:26:00 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06CF23F632;
	Tue, 22 Sep 2026 09:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790094363; bh=ayic+nVzRT7jF2h19D33qb2NxY0nfyFpS1c2IauCEkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vLKpHlXy9TeAxplzn8LuOxnhs+NZZT08I8jSb7+j1I6L64gZFqCGnchXfZ3Dqibh8
	 eQMv80pCWNlnv73z0GmxiYSywlJm2UuyVrhWN9MyheshF5MMnKprwZkReiNsEO3hTc
	 KddnGGEGanHe0MFeVvE3aGvk5G7QNuyyTWu9q8xw=
Date: Tue, 22 Sep 2026 17:25:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <arKsFofudnTYpXj1@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921144847.501151-3-aneesh.kumar@kernel.org>

On Mon, Sep 21, 2026 at 08:18:36PM +0530, Aneesh Kumar K.V (Arm) wrote:
> +int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
> +		size_t requested, struct cc_shared_pages *mem)
> +{
> +	struct cc_shared_layout layout;
> +	struct page *page;
> +	unsigned int order;
> +	bool zero = gfp & __GFP_ZERO;
> +	int ret;
> +
> +	if (!mem)
> +		return -EINVAL;
> +
> +	ret = cc_shared_calc_layout(requested, &layout);
> +	if (ret)
> +		return ret;
> +
> +	order = get_order(layout.shared_size);
> +	if (order > MAX_PAGE_ORDER)
> +		return -EINVAL;
> +
> +	/*
> +	 * State transitions require a linear-map address and may modify memory.
> +	 * Allocate from low memory and defer requested zeroing until afterwards.
> +	 */
> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
> +	if (nid == NUMA_NO_NODE)
> +		page = alloc_pages(gfp, order);
> +	else
> +		page = alloc_pages_node(nid, gfp, order);
> +	if (!page)
> +		return -ENOMEM;
> +
> +	ret = cc_make_shared(page_address(page), layout.shared_size);
> +	if (ret) {
> +		if (!cc_make_private(page_address(page), layout.shared_size))
> +			__free_pages(page, order);
> +		else
> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
> +					    layout.shared_size);
> +		return ret;
> +	}
> +
> +	if (zero)
> +		memset(page_address(page), 0, layout.shared_size);

Does the memset() post sharing logic work for pKVM as well? If nothing
clears it, we have a small window where guest data is leaked to the
host.

Is there a case where we *do not* need the memory cleared? If not, maybe
we can move the logic in the arch set_memory_decrypted().

-- 
Catalin
