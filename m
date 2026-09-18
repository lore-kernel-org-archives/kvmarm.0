Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41F215B21A;
	Fri, 18 Sep 2026 14:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789740988; cv=none; b=Fnc7TpeMAmX/nowmHhjud5zyaz6TYNlVkCSSQUz4xptzMYADzl0qaJFwuIIL61nG9SpsSZE2S2kbGsLunmmkZ9mDAc7k+RGp84U2GTyA3Z2u8cs9TMI9jUJS26q+EIfPplJ3vXyuhRsUNfOkaxnW2WGJ/OpeSyvhs8goJNcAddI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789740988; c=relaxed/simple;
	bh=YqrCUZ8I8X0j3hoH420Py4EkqpAdfkVvBg2xqWOej2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uhBe0nZY8equX+XH/TaZzQ7mM0OQk8tws+hKX3Ry+vrhxH1XNFPfLDwBPf53MBoWgJ+FdVOBzrUMVLNHnxF/27u8gOj8ZT6fNOdjFWGo8TRbpAifHkN7swN9jdKLi2mHq/4oFxLCVYPdSoWRQrb+/IZls1vXHywXEZvz02Gry7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FWU9O+Gw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FWU9O+Gw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB9761C00;
	Fri, 18 Sep 2026 07:16:22 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 65BA43F86C;
	Fri, 18 Sep 2026 07:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789740986; bh=YqrCUZ8I8X0j3hoH420Py4EkqpAdfkVvBg2xqWOej2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FWU9O+GwOITgZTuxF750EuQlx6vzKzmlnFP69ErXUkCFrjt3Z6vDWsBmGYWKcQs/H
	 Q/dSP51xK3EEDoSKaO1VGr9wUiu9nMwmEDt9EzLrDBYZRKzOiZ5KKcpd4WcgJ2C7+I
	 y9Gg2hEfTEY8s1kVGK/+6Uf2nGbYt25MII5AT5fw=
Date: Fri, 18 Sep 2026 15:16:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Jason Gunthorpe <jgg@ziepe.ca>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6 4/9] dma-direct: Align CoCo shared DMA allocations to
 the shared granule size
Message-ID: <aq1HtSvwDHouhgZl@arm.com>
References: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
 <20260904103452.1197239-5-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904103452.1197239-5-aneesh.kumar@kernel.org>

On Fri, Sep 04, 2026 at 04:04:47PM +0530, Aneesh Kumar K.V (Arm) wrote:
> @@ -419,6 +420,14 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp,
>  #ifdef CONFIG_DMA_NUMA_CMA
>  	int nid = dev_to_node(dev);
>  #endif
> +	/*
> +	 * CoCo shared allocations require CMA alignment large enough for the
> +	 * architecture's shared-buffer granule.
> +	 */
> +	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED) {
> +		if (get_order(mem_cc_shared_granule_size()) > CONFIG_CMA_ALIGNMENT)
> +			return NULL;
> +	}

[...]

> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
> index 00f422a1e896..fc4a834aaa14 100644
> --- a/kernel/dma/pool.c
> +++ b/kernel/dma/pool.c
> @@ -91,7 +91,9 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
>  	void *addr;
>  	int ret = -ENOMEM;
>  	pgprot_t prot __maybe_unused;
> +	unsigned int min_encrypt_order = get_order(mem_cc_shared_granule_size());
>  
> +	pool_size = mem_cc_align_to_shared_granule(pool_size);
>  	/* Cannot allocate larger than MAX_PAGE_ORDER */
>  	order = min(get_order(pool_size), MAX_PAGE_ORDER);
>  
> @@ -102,7 +104,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
>  							 order, false);
>  		if (!page)
>  			page = alloc_pages(gfp | __GFP_NOWARN, order);
> -	} while (!page && order-- > 0);
> +	} while (!page && order-- > min_encrypt_order);

I can see dma_alloc_from_contiguous() called by atomic_pool_expand()
clamps the alignment to CONFIG_CMA_ALIGNMENT and this one has a minimum
value of 2. Allocation will silently succeed. Not sure of the best fix,
maybe do a check here before calling the dma alloc function or just
return NULL as in dma_alloc_contiguous().

-- 
Catalin
