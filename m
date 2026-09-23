Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE7E490C13;
	Wed, 23 Sep 2026 10:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790159759; cv=none; b=BqeWHNn94dw7ykkt7hvYD1ARd4Yrs+P4PCIPrGT2FcwbBdtDIw7Cs9DEHDXATxNF8aauqfC/aQg76PjQbIdFOSnTTE/sJY7ntSBuG80u73J50VPl7P2SChExwj8ppmbMTUyNw4Oyyz5rH93jeBKVj5b8yVA8wHZx9EsMdjYWSkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790159759; c=relaxed/simple;
	bh=v9G6lJSh6OMVo7mppK0Hk+jifrbC6I47Gu6icD1n1fw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JVv84HalbKwGgZVjfRYbzgxWQAXm3DfNK91xejnNxq7rOKC6kBG8c6d5mOO4nbozntKQGYMNvXXx8S4Dvqx1tKsVMQoc5/F7VUoJ/xU4PaevSsVyq7K2PAla3BIa+9aiH9kePv822G9zD5DwHDaPmJyLKOsUdQVrqhuQ7+ICTp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ewmaVXkx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ewmaVXkx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 451161570;
	Wed, 23 Sep 2026 03:35:47 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B5ABC3F86C;
	Wed, 23 Sep 2026 03:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790159750; bh=v9G6lJSh6OMVo7mppK0Hk+jifrbC6I47Gu6icD1n1fw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ewmaVXkxLy98D6T0jp9a151FmO0Op77gHcimtZp1SgvTUTUKuJQ5luNggprLpjZMg
	 JZOuDeYoO+3y/I6Omc7mGGCSkjuReFAYGypqx14TBycfBylH51cJ9b2S2q0oi4rNBO
	 xrDH/ShQcUVeiWgWolvO3OpJNpP1DHa8nrUOGvJA=
Date: Wed, 23 Sep 2026 11:35:45 +0100
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
Subject: Re: [RFC PATCH v7 06/13] dma-contiguous: Accept an explicit minimum
 alignment
Message-ID: <arOrgRfi1k12clT7@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-7-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921144847.501151-7-aneesh.kumar@kernel.org>

On Mon, Sep 21, 2026 at 08:18:40PM +0530, Aneesh Kumar K.V (Arm) wrote:
> @@ -125,7 +126,8 @@ static inline int dma_contiguous_reserve_area(phys_addr_t size,
>  	return -ENOSYS;
>  }
>  static inline struct page *dma_alloc_from_contiguous(struct device *dev,
> -		size_t count, unsigned int order, bool no_warn)
> +		size_t count, unsigned int order, unsigned int required_order,
> +		bool no_warn)
>  {
>  	return NULL;
>  }
> @@ -136,7 +138,7 @@ static inline bool dma_release_from_contiguous(struct device *dev,
>  }
>  /* Use fallback alloc() and free() when CONFIG_DMA_CMA=n */
>  static inline struct page *dma_alloc_contiguous(struct device *dev, size_t size,
> -		gfp_t gfp)
> +		gfp_t gfp, unsigned int align_order)

Can we not just bake the alignment further down in these functions
rather than getting the callers to pass the {required,align}_order?

-- 
Catalin
