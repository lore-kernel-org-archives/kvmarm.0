Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F729566C69;
	Tue, 22 Sep 2026 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790095154; cv=none; b=BmpRjTu+AyS49xAJq01GLmjwluEQLJCmeQPWkClFtEqKer+0Yf7+G/OrZhYwb0Oec0RXEasd6Jag0DhxmerMFWg0FIL+D9DOMpbqx2WgAfaQinrBXB5p3NxGYTot7oBpjwsuI1KohofiMz2QTQVHlS1hHryplq4quhhz6scQatw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790095154; c=relaxed/simple;
	bh=YQf4ZF9UrIZkju53+FMc2/Zw5dM/iafRxTRYEbJms0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAQQtT5412Q3j1pmcQKXGwNT91trNbgjHtIbmrCXCQgyRJdCSObPxRZ3514zHXmbQ5BnvimaXCxCDcQs+DSqauPB++FdMl3KE2kKZYChXDpPqqJT1Qy+v7utxDPnL654nDWMVbD0bbRL9uEv+pbor/uqdjLM7pMV9Rroru/Fa9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AYzw/dZB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AYzw/dZB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C0461576;
	Tue, 22 Sep 2026 09:39:06 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3D7A3F632;
	Tue, 22 Sep 2026 09:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790095150; bh=YQf4ZF9UrIZkju53+FMc2/Zw5dM/iafRxTRYEbJms0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AYzw/dZBDBEYe9/IfefTSuDA9ATgbB7Dnmm7bUOXpXYL7xrhaOG6WNWM89zKFywgX
	 Hca5ai3qk4fYLZscOfPi0Qh5fdm128r5ziOOA5TBgZtWFVOg+iJJUHDyzqYjkftVAr
	 3sHOOYEiFcjjnuFpaEP+biIIhTBY6lijgPOKAanM=
Date: Tue, 22 Sep 2026 17:39:04 +0100
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
Subject: Re: [RFC PATCH v7 12/13] dma-buf: system_heap: Allocate shared
 buffers using CoCo shared memory allocator
Message-ID: <arKvKME-_wNeW7ea@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-13-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921144847.501151-13-aneesh.kumar@kernel.org>

On Mon, Sep 21, 2026 at 08:18:46PM +0530, Aneesh Kumar K.V (Arm) wrote:
> @@ -405,6 +396,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>  {
>  	struct system_heap_buffer *buffer;
>  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> +	struct cc_shared_layout layout;
>  	unsigned long size_remaining = len;
>  	unsigned long sg_remaining = len;
>  	unsigned int max_order = orders[0];
> @@ -417,6 +409,14 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>  	struct page *page, *tmp_page;
>  	int i, ret = -ENOMEM;
>  
> +	if (cc_shared) {
> +		ret = cc_shared_calc_layout(len, &layout);

You should not override 'ret' here, it was set to -ENOMEM for a reason.
cc_shared_calc_layout() succeeds resetting 'ret' and some further down
allocation failure, goto free will return ERR_PTR(0).

-- 
Catalin
