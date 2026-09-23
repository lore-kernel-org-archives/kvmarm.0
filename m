Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E19844238B;
	Wed, 23 Sep 2026 09:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790156568; cv=none; b=MeHPTLbcALXmz329A6N9kJLHiVX7yrj7IzjcvUmDgU1bTmGqwCgiUP/15KvmNNZg45RRLNcW8acL82TH0VnV33v2HRE7xp9E1QCSlmKl3VP9RTSdZ04oXTlAomkbO0mPoTAiX9IhbkwsWN5TWS0JP79GjsPFVcRqrwZT3owz59g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790156568; c=relaxed/simple;
	bh=ovmViFUKy6MLk0NrlYXc5n5zxje+qUS5YdjUVeCmo3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BtyJqt7EwnthM40c0qEIyYgEMzmZOAYgCAR2NMLFhOT+3i8lEY9T6/aPL/wlCnKBjQJpZIlFWbpXbxjkDJ2ApWAMJ6rESAfgNsVZNj4NV0+Opg/2AdxlzjfXwr/OivdxR9DOSvtPJUXqFwvFqGdWzXglEKeuAdx0TJNqlbTVomk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EqrxHpMU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EqrxHpMU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17E0A1516;
	Wed, 23 Sep 2026 02:42:42 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 890353F86F;
	Wed, 23 Sep 2026 02:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790156565; bh=ovmViFUKy6MLk0NrlYXc5n5zxje+qUS5YdjUVeCmo3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EqrxHpMU3y3q09p7ZwC3F7pnYhUAukhhWF6HkPPmq/150OiZcTwdjrlGOeBN8pNBQ
	 ViYlHj7XxBiCoU3LYoeEyZ1FOUfVcJxbQ/TAUCtCU/Xb1Gv0B6KDlzCogBgLoCrn9N
	 2KeYP3En8k33E1CffATf2xeYK+Rk4KTPNkAHQoT0=
Date: Wed, 23 Sep 2026 10:42:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
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
Message-ID: <arOfD6syXOgQhZYA@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aik3w344o.fsf@kernel.org>

On Wed, Sep 23, 2026 at 11:23:27AM +0530, Aneesh Kumar K.V wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Mon, Sep 21, 2026 at 08:18:36PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> +int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
> >> +		size_t requested, struct cc_shared_pages *mem)
> >> +{
> >> +	struct cc_shared_layout layout;
> >> +	struct page *page;
> >> +	unsigned int order;
> >> +	bool zero = gfp & __GFP_ZERO;
> >> +	int ret;
> >> +
> >> +	if (!mem)
> >> +		return -EINVAL;
> >> +
> >> +	ret = cc_shared_calc_layout(requested, &layout);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	order = get_order(layout.shared_size);
> >> +	if (order > MAX_PAGE_ORDER)
> >> +		return -EINVAL;
> >> +
> >> +	/*
> >> +	 * State transitions require a linear-map address and may modify memory.
> >> +	 * Allocate from low memory and defer requested zeroing until afterwards.
> >> +	 */
> >> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
> >> +	if (nid == NUMA_NO_NODE)
> >> +		page = alloc_pages(gfp, order);
> >> +	else
> >> +		page = alloc_pages_node(nid, gfp, order);
> >> +	if (!page)
> >> +		return -ENOMEM;
> >> +
> >> +	ret = cc_make_shared(page_address(page), layout.shared_size);
> >> +	if (ret) {
> >> +		if (!cc_make_private(page_address(page), layout.shared_size))
> >> +			__free_pages(page, order);
> >> +		else
> >> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
> >> +					    layout.shared_size);
> >> +		return ret;
> >> +	}
> >> +
> >> +	if (zero)
> >> +		memset(page_address(page), 0, layout.shared_size);
> >
> > Does the memset() post sharing logic work for pKVM as well? If nothing
> > clears it, we have a small window where guest data is leaked to the
> > host.
> >
> > Is there a case where we *do not* need the memory cleared? If not, maybe
> > we can move the logic in the arch set_memory_decrypted().
> >
> 
> I don't think every architecture or platform can unconditionally zero
> memory in set_memory_decrypted(). Some callers may need to share valid
> contents with the host.

Is there any? That would be a bad assumptions in the caller. Most
set_memory_* backends don't preserve the content as they change the
encryption key. So properly written code shouldn't rely on this unless
it knows specifically it's only running on pKVM for example. The only
use-case I see to avoid explicit zeroing is when the caller doesn't care
about the page initialisation and wants to save some cycles. The
encryption key change would take care of the security aspect.

> Also, if zeroing is added only to the CCA implementation, the allocator
> must retain __GFP_ZERO for platforms such as pKVM. This would cause the
> memory to be zeroed twice on CCA.

What I meant is that we change the set_memory_decrypted() contract to
always zero, assuming that all callers need to zero the pages anyway. If
we do have cases where zeroing is not needed, we could make it explicit
via a flag.

> How about extending cc_make_shared() with a flag indicating that the
> memory must be zeroed, and passing that requirement down to the
> architecture-specific implementation? The implementation could then zero
> the memory at the appropriate point: before sharing for pKVM and after
> the destructive transition for CCA.

On pKVM, we want set_memory_decrypted() to zero the buffer
before the host can access it (I guess currently relying on __GFP_ZERO
allocations). Since no cryptographic encryption takes place, there's not
much point in memset'ing again after the operation as the content was
already zeroed.

I don't think cc_make_shared() has the right information on how to
safely and efficiently do the zeroing. That's only known to the
set_memory_* backend. So you'd have to propagate the flag down.

-- 
Catalin
