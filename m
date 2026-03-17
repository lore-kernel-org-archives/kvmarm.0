Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83B533CE88
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773769856; cv=none; b=QQKgoCcpftqVTtkw9/MiurKtObo79eoA+OuRpnewWMeHCAd6TYv3d9bKXdlmN3MbEQegG1R9QRnyOwB8YRqKn+TXHx1vrAgSG9y6R1qBin+0MzySgWNrzzGsrzyL4B5m6oPOzhAV621SRgRJh1LtgBqtkJGgbDTQGW4MA12EPds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773769856; c=relaxed/simple;
	bh=yiyoMaFHy9lzPuRoFxSqRk4KEu9ZNcoxBKMkiH5Ib3M=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NL2dCnekeNkKowqT2Led5VWrY8qj28SfGNOmxS459INpoCHCBal6mPT+xn+d7wApuXB/IRDYs786xAmku0OzTF+QROuo0P/VYBi0XTFv3nQC/vu9y6ZGRXf7YX2IYKDAyVFHzWhxZ4rFlViA+cWCD7aAXFXvBxk7kokkkqXcawM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fZzxb2PjmzJ4687;
	Wed, 18 Mar 2026 01:49:55 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id BDBBA4056A;
	Wed, 18 Mar 2026 01:50:51 +0800 (CST)
Received: from localhost (10.48.149.62) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 17 Mar
 2026 17:50:50 +0000
Date: Tue, 17 Mar 2026 17:50:47 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Fuad Tabba <tabba@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, "KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64"
	<linux-arm-kernel@lists.infradead.org>, KERNEL VIRTUAL MACHINE FOR ARM64
 KVM/arm64 <kvmarm@lists.linux.dev>, "open list"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] KVM: arm64: Use guard(mutex) in mmu.c
Message-ID: <20260317175047.00000b6e@huawei.com>
In-Reply-To: <20260316-tabba-el2_guard-v1-6-456875a2c6db@google.com>
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
	<20260316-tabba-el2_guard-v1-6-456875a2c6db@google.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Mon, 16 Mar 2026 17:35:27 +0000
Fuad Tabba <tabba@google.com> wrote:

> Migrate manual mutex_lock() and mutex_unlock() calls managing
> kvm_hyp_pgd_mutex and hyp_shared_pfns_lock to use the
> guard(mutex) macro.
> 
> This eliminates manual unlock calls on return paths and simplifies
> error handling by replacing unlock goto labels with direct returns.
> Centralized cleanup goto paths are preserved with manual unlocks
> removed.
> 
> Change-Id: Ib0f33a474eb84f19da4de0858c77751bbe55dfbb
> Signed-off-by: Fuad Tabba <tabba@google.com>

> @@ -652,22 +632,20 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
>  	unsigned long base;
>  	int ret = 0;
>  
> -	mutex_lock(&kvm_hyp_pgd_mutex);
> -
> -	/*
> -	 * This assumes that we have enough space below the idmap
> -	 * page to allocate our VAs. If not, the check in
> -	 * __hyp_alloc_private_va_range() will kick. A potential
> -	 * alternative would be to detect that overflow and switch
> -	 * to an allocation above the idmap.
> -	 *
> -	 * The allocated size is always a multiple of PAGE_SIZE.
> -	 */
> -	size = PAGE_ALIGN(size);
> -	base = io_map_base - size;
> -	ret = __hyp_alloc_private_va_range(base);
> -
> -	mutex_unlock(&kvm_hyp_pgd_mutex);
> +	scoped_guard(mutex, &kvm_hyp_pgd_mutex) {
> +		/*
> +		 * This assumes that we have enough space below the idmap
> +		 * page to allocate our VAs. If not, the check in
> +		 * __hyp_alloc_private_va_range() will kick. A potential
> +		 * alternative would be to detect that overflow and switch
> +		 * to an allocation above the idmap.
> +		 *
> +		 * The allocated size is always a multiple of PAGE_SIZE.
> +		 */
> +		size = PAGE_ALIGN(size);
> +		base = io_map_base - size;
> +		ret = __hyp_alloc_private_va_range(base);
Minor one and matter of taste, but I'd do
		if (ret)
			return ret;
	}
	*hwaddr = base;

	return 0;

> +	}
>  
>  	if (!ret)
>  		*haddr = base;
> @@ -711,17 +689,16 @@ int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr)
>  	size_t size;
>  	int ret;
>  
> -	mutex_lock(&kvm_hyp_pgd_mutex);
> -	/*
> -	 * Efficient stack verification using the NVHE_STACK_SHIFT bit implies
> -	 * an alignment of our allocation on the order of the size.
> -	 */
> -	size = NVHE_STACK_SIZE * 2;
> -	base = ALIGN_DOWN(io_map_base - size, size);
> +	scoped_guard(mutex, &kvm_hyp_pgd_mutex) {
> +		/*
> +		 * Efficient stack verification using the NVHE_STACK_SHIFT bit implies
> +		 * an alignment of our allocation on the order of the size.
> +		 */
> +		size = NVHE_STACK_SIZE * 2;
> +		base = ALIGN_DOWN(io_map_base - size, size);
>  
> -	ret = __hyp_alloc_private_va_range(base);
> -
> -	mutex_unlock(&kvm_hyp_pgd_mutex);
> +		ret = __hyp_alloc_private_va_range(base);
> +	}
>  
>  	if (ret) {
>  		kvm_err("Cannot allocate hyp stack guard page\n");
Maybe move this under the guard just to keep the error check nearer the code
in question.

Thanks,

Jonathan

> 

