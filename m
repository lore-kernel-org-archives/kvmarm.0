Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6EA0747F
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 02:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741834429; cv=none; b=GPMcVlQAlnSpJQZQVIg+taOuxVzIy5f76kh2R2V5ycc8mGb+P7zF3+JwoC3adHsJbaKrmeWyXo4xZf1Xz4t25CyipnvcYbT6mSoUNfEVL4g1QzxHxqfZUMUR02bVfu+I3UD1h6kIILijXZBMiZpEDwCOE19zqa8t/bmD4ZxFwaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741834429; c=relaxed/simple;
	bh=6H80aIBSlmZGrKvH09HNDaYGSvdFFUW1gK8w+oS3Rok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dx9otYmTpkvLYC9j3tq+eXZBx2XpWTGgS+rSAUN9VtA0MJj/EqdfqrsHtuLn9OFiTsFnmALBfhI95FXWDVedNFNJSGtz2syVqcK8z5xAD9arfNaonEbZohAZkgYHdc6ADfn7+I1QbJ71NnkLOsqS5tQkWI2/ZZ8GNeFxtZEy6lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D24515A1;
	Wed, 12 Mar 2025 19:53:56 -0700 (PDT)
Received: from [10.162.40.25] (a077893.blr.arm.com [10.162.40.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A03433F5A1;
	Wed, 12 Mar 2025 19:53:41 -0700 (PDT)
Message-ID: <34b8242b-529b-4ad5-ac17-e1200965ae1d@arm.com>
Date: Thu, 13 Mar 2025 08:23:38 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Drop sort_memblock_regions()
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 qperret@google.com, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, shan.gavin@gmail.com
References: <20250311043718.91004-1-gshan@redhat.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250311043718.91004-1-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/11/25 10:07, Gavin Shan wrote:
> Drop sort_memblock_regions() and avoid sorting the copied memory
> regions to be ascending order on their base addresses, because the
> source memory regions should have been sorted correctly when they
> are added by memblock_add() or its variants.
> 
> This is generally reverting commit a14307f5310c ("KVM: arm64: Sort
> the hypervisor memblocks"). No functional changes intended.

Just wondering what prompted this change ?

> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/pkvm.c | 19 -------------------
>  1 file changed, 19 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 930b677eb9b0..d9c9174f89a1 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -10,7 +10,6 @@
>  #include <asm/kvm_mmu.h>
>  #include <linux/memblock.h>
>  #include <linux/mutex.h>
> -#include <linux/sort.h>
>  
>  #include <asm/kvm_pkvm.h>
>  
> @@ -24,23 +23,6 @@ static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
>  phys_addr_t hyp_mem_base;
>  phys_addr_t hyp_mem_size;
>  
> -static int cmp_hyp_memblock(const void *p1, const void *p2)
> -{
> -	const struct memblock_region *r1 = p1;
> -	const struct memblock_region *r2 = p2;
> -
> -	return r1->base < r2->base ? -1 : (r1->base > r2->base);
> -}
> -
> -static void __init sort_memblock_regions(void)
> -{
> -	sort(hyp_memory,
> -	     *hyp_memblock_nr_ptr,
> -	     sizeof(struct memblock_region),
> -	     cmp_hyp_memblock,
> -	     NULL);
> -}
> -
>  static int __init register_memblock_regions(void)
>  {
>  	struct memblock_region *reg;
> @@ -52,7 +34,6 @@ static int __init register_memblock_regions(void)
>  		hyp_memory[*hyp_memblock_nr_ptr] = *reg;
>  		(*hyp_memblock_nr_ptr)++;
>  	}
> -	sort_memblock_regions();
>  
>  	return 0;
>  }
