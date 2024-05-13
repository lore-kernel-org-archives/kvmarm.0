Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514EE1CD15;
	Mon, 13 May 2024 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715619379; cv=none; b=hlysFIS6YOKZyEzZkBXUlCRhp5KkNbL4PR0neMfbSnt3cJ8IEtwK4sMKxKBsB+4JmPOI5jSxCJSkucjqPQoZQMnhImpEp73/cwysvLPTc6SPVsxTg1g08WLE50J7qhVh/17Fk4pKpXdbLrtn7otT15Li55w4DYyKxMYg4/a5tE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715619379; c=relaxed/simple;
	bh=R1yt8VY85saTQsFLGCPH5N9UB7wO5F3GKqnZyj/mioc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dG6ebOgTG0ObmAZdOgcZyiYED6cWwK9pozKa7Tc02eAypEo2772QxdOuZfYY99bMfkXLTJjK4kAG8Xb6ITG697RCPtwVzr3vonA79fq0EWHeyxqpuV85CeX+R+ZzA+irCxdVorGGMjPguUEXO/jn4pymAKuFOZjkmDNYGFn6g0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05AEC113CC;
	Mon, 13 May 2024 16:56:15 +0000 (UTC)
Date: Mon, 13 May 2024 17:56:13 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 08/14] arm64: Enforce bounce buffers for realm DMA
Message-ID: <ZkJGLV5FfEPmdoG-@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-9-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084213.1733764-9-steven.price@arm.com>

On Fri, Apr 12, 2024 at 09:42:07AM +0100, Steven Price wrote:
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 786fd6ce5f17..01a2e3ce6921 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -370,7 +370,9 @@ void __init bootmem_init(void)
>   */
>  void __init mem_init(void)
>  {
> -	bool swiotlb = max_pfn > PFN_DOWN(arm64_dma_phys_limit);
> +	bool swiotlb = (max_pfn > PFN_DOWN(arm64_dma_phys_limit));

This series tends to add unnecessary brackets.

> +
> +	swiotlb |= is_realm_world();

I first thought we wouldn't need this, just passing 'true' further down
but I guess you want to avoid reducing the bounce buffer size when it's
only needed for kmalloc() bouncing.

>  
>  	if (IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) && !swiotlb) {
>  		/*
> @@ -383,7 +385,12 @@ void __init mem_init(void)
>  		swiotlb = true;
>  	}
>  
> -	swiotlb_init(swiotlb, SWIOTLB_VERBOSE);
> +	if (is_realm_world()) {
> +		swiotlb_init(swiotlb, SWIOTLB_VERBOSE | SWIOTLB_FORCE);
> +		swiotlb_update_mem_attributes();
> +	} else {
> +		swiotlb_init(swiotlb, SWIOTLB_VERBOSE);
> +	}

Just do this higher up and avoid calling is_realm_world() twice:

	unsigned int flags = SWIOTLB_VERBOSE;

	...

	if (is_realm_world()) {
		swiotlb = true;
		flags |= SWIOTLB_FORCE;
	}

	...

	swiotlb_init(swiotlb, flags);

-- 
Catalin
